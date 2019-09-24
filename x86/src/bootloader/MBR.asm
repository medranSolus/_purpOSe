[BITS 16]
[ORG 0x0600]

relocate:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x01B8  ; Stack just before partition table
    mov cx, 0x0100  ; Size of MBR in WORD's
    mov si, 0x7C00  ; Bootsector address
    mov di, 0x0600  ; New address
    rep movsw
    jmp 0:loadVBR

loadVBR:
    sti
    mov si, msgStart
    call print
    mov si, partition1
    mov cx, 4
    .checkBootable:
        cmp BYTE [si], 0x80
        jz short .bootFound
        inc BYTE [msgBootFrom.number]
        add si, ENTRY_SIZE
        loop .checkBootable
    mov si, msgNoBootPartition
    jmp error
    .bootFound:
    push si
    mov si, msgBootFrom
    call print
    pop si
    mov cx, 3
    mov dh, [si + 2]
    xor bx, bx
    mov es, bx
    mov bx, 0x7C00
    .readDisk:
        push cx
        mov ax, 0x0201
        mov ch, [si + 1]
        mov cl, [si + 3]
        int 0x13
        pop cx
        jnc short .VBRloaded
        mov ah, 0
        int 0x13
        loop .readDisk
    mov si, msgDiskError
    jmp error
    .VBRloaded:
    push si
    mov si, msgVBRloaded
    call print
    pop si
    jmp 0:0x7C00

; Print string on screen
; IN: SI = pointer to string
; OUT: Void
print:
    mov ah, 0x0e
    .loop:
        lodsb
        test al, al
        jz short .quit
        int 0x10
        jmp short .loop
    .quit:
    ret

; Handle unrecoverable boot error
; IN: SI = Pointer to error message
; OUT: Void
error:
    call print
    .hang:
        cli
        hlt
        jmp short .hang

msgStart:               DB "Hard Disk MBR loaded.", 0x0D, 0x0A, 0
msgBootFrom:            DB "Booting from partition "
    .number:            DB "1...", 0x0D, 0x0A, 0
msgVBRloaded:           DB "Boot completed.", 0
msgNoBootPartition:     DB "No bootable partition!", 0
msgDiskError:           DB "Error reading disk for selected VBR!", 0

TIMES 440 - ($ - $$) DB 0       ; padding

signature:      DD 0x00000000
reserved:       DW 0x0000

partition1:
    .status:        DB 0x80     ; 0x80 bootable
    .startCylinder: DB 0x00
    .startHead:     DB 0x00
    .startSector:   DB 0x02
    .type:          DB 0x00
    .lastCylinder:  DB 0xFF
    .lastHead:      DB 0xFF
    .lastSector:    DB 0xFF
    .startLBA:      DD 0x00000001
    .lastLBA:       DD 0xFFFFFFFF

ENTRY_SIZE EQU $ - partition1

partition2:
    .status:        DB 0x00
    .startCylinder: DB 0x00
    .startHead:     DB 0x00
    .startSector:   DB 0x00
    .type:          DB 0x00
    .lastCylinder:  DB 0x00
    .lastHead:      DB 0x00
    .lastSector:    DB 0x00
    .startLBA:      DD 0x00000000
    .lastLBA:       DD 0x00000000

partition3:
    .status:        DB 0x00
    .startCylinder: DB 0x00
    .startHead:     DB 0x00
    .startSector:   DB 0x00
    .type:          DB 0x00
    .lastCylinder:  DB 0x00
    .lastHead:      DB 0x00
    .lastSector:    DB 0x00
    .startLBA:      DD 0x00000000
    .lastLBA:       DD 0x00000000

partition4:
    .status:        DB 0x00
    .startCylinder: DB 0x00
    .startHead:     DB 0x00
    .startSector:   DB 0x00
    .type:          DB 0x00
    .lastCylinder:  DB 0x00
    .lastHead:      DB 0x00
    .lastSector:    DB 0x00
    .startLBA:      DD 0x00000000
    .lastLBA:       DD 0x00000000

DW 0xAA55 ; Magic boot number