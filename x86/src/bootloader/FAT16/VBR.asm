[BITS 16]
[ORG 0x0800]

; Boot loader path: Purpose\Boot\bootpos.bin

; Stack overwrites MBR code, top just begore disk signature and VBR variables
STACK_SGMT  EQU 0x0050
STACK_SIZE  EQU 0x02B4   ; Must be even
LOAD_SGMT   EQU 0x20A0
LOAD_BUFFER EQU 0x0000

; Memory variables:
cylinderCount       EQU 0x07B4
partionEntryOffset  EQU 0x07B6

_init:
    cld
    jmp short _relocateVBR

BPB: ; BIOS Parameter Block
    .description:           DB "_purpOSe" ; 8!!!
    .bytePerSector:         DW 512
    .sectorsPerCluster:     DB 1
    .reservedSectorsCount:  DW 1
    .FATcount:              DB 2
    .rootDirEntries:        DB 16 ; 32 bytes per entry
    .sectorsTotal:          DW 0  ; If zero: number of sectors in volume lower
    .mediaDescriptor:       DB 0xF0
    .sectorsPerFAT:         DW 2
    .sectorsPerCylinder:    DW 1 ; Must be initialized first (starting value always invalid)
    .headsCount:            DW 1 ; Must be initialized first (starting value always invalid)
    .hiddenSectorsCount:    DD 0 ; Ignored
    .sectorsTotal2:         DD 0
    .driveNumber:           DB 0x80 ; Must be initialized first (starting value always invalid)
    .reserved:              DB 0x00 ; Windows NT flags \_____ Current FAT sector in memory
    .signature:             DB 0x29 ;                  /
    .volumeID:              DD 0x00 ; Can be ignored, but used to track volumes
    .volumeLabel:           DB "Pos Volume " ; 11!!!
    .fileSystemID:          DB "FAT16   " ; 8!!!
    .SIZE EQU $ - BPB ; = 59

_relocateVBR:
    mov bx, ds
    mov fs, bx  ; MBR segment (should be 0)
    xor bp, bp
    mov ds, bp
    mov es, bp
    mov gs, bp
    mov sp, STACK_SGMT
    mov ss, sp
    mov sp, STACK_SIZE 
    mov [partionEntryOffset], si
    mov cx, 0x0100  ; Size of VBR in WORD's
    mov si, 0x7C00  ; Bootsector address
    mov di, 0x0800  ; New address
    rep movsw
    jmp 0:_locateLoader

_locateLoader:
    mov di, si
    mov [BPB.driveNumber], dl
    .getDiskGeometry:
        mov ah, 8
        int 0x13
        shr dx, 8
        inc dh
        mov [BPB.headsCount], dx
        mov [cylinderCount], ch
        mov ch, cl
        shr ch, 6
        mov [cylinderCount + 1], ch
        and cx, 0x3F
        mov [BPB.sectorsPerCylinder], cx
    .getRootDirCHS:
        movzx bp, BYTE [BPB.rootDirEntries]
        test bp, 0x0F
        jz .rootDirSectorsGood
        add bp, 0x10
        .rootDirSectorsGood:
        shr bp, 4                   ; Root dir sectors
        mov bx, LOAD_BUFFER         ; Buffer
        mov dh, [fs:di + 2]         ; Start head
        mov dl, [BPB.driveNumber]   ; Driver
        mov ch, [fs:di + 1]         ; Start cylinder
        mov cl, [fs:di + 3]         ; Start sector
        mov ax, [BPB.sectorsPerFAT]
        mul BYTE [BPB.FATcount]
        inc ax
        add ax, [fs:di + 3]         ; Root dir start sector
    .getBootDir:
    
    cli
    jmp short $

; Compare filenames
; IN: SI = Name pattern, BX = Name to check
; OUT: FLAGS set according to result
nameCompare:
    xchg di, bx
    push cx
    mov cx, 11
    repe cmpsb
    pop cx
    xchg di, bx
    ret

; Read data from disk
; IN: CH = Starting cylinder, DH = Starting head, AX = Starting sector,
;     DL = Drive number, ES:BX = Data buffer, FS:di = Active partition
; OUT: AX = Read sector in CHS format
readDisk:
    cmp ax, [BPB.sectorsPerCylinder]
    jbe .sectorsInRange
    sub ax, [BPB.sectorsPerCylinder]
    inc ch
    jmp readDisk
    .sectorsInRange:
        push ax
        mov cl, al
        .checkCylinderSize:
        cmp ch, [cylinderCount]
        jb .checkVolumeRange
        sub ch, [cylinderCount]
        inc dh
        jmp .checkCylinderSize
    .checkVolumeRange:
        push 5              ; Max disk read try count
        cmp dh, [fs:di + 6]
        jb .diskOffsetInRange
        jg .invalidSector
        cmp ch, [fs:di + 5]
        jb .diskOffsetInRange
        jg .invalidSector
        cmp cl, [fs:di + 7]
        jb .diskOffsetInRange
    .invalidSector:
        mov si, msgInvalidSector
        jmp error
    .diskOffsetInRange:
        mov ax, 0x0201
        int 13h
        jnc short .readSuccess
        pop ax
        dec ax
        push ax
        jnz .diskOffsetInRange
        mov si, msgDiskError
        jmp error
    .readSuccess:
    pop ax
    pop ax
    ret

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

msgDiskError:       DB "RDerr", 0
msgInvalidSector:   DB "Wrong sctr", 0

dirSystem: DB "Purpose    "
dirBoot:   DB "Boot       "
fileBoot:  DB "bootpos bin"

TIMES 510 - ($ - $$) DB 0

DW 0xAA55