[ORG 0x7c00]
[BITS 16]

jmp short $
mov al, 1
mov cl, 2       ;starting sector (first sector is bootsector, then data/kernel/etc.)
mov bx, 0
mov es, bx
mov bx, 0x7e00  ;where to load (512 bytes after this sector in RAM)
call readDisk
jmp secondSector

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

; Read data from disk ()
; IN: AL = sectors count, CL = starting sector, ES:BX = data buffer, 
;     DL = 0x00/0x80 (0x00 if booting from USB/SSD/CD/flash/floppy, 0x80 if booting from HDD. Can be 0x00 if it's real hardware)
; OUT: AH = return code, AL = sectors read count, CF = 1 if error
readDisk:   ;
    mov ah, 0x02    ;function name
    mov ch, 0       ;starting cylinder
    mov dh, 0       ;starting head
    mov dl, 0x80    ;drive type    
    int 13h
    jc short .error
    ret
    .error:
        mov si, messageDiskError
        call print
        jmp short $

messageWelcome: DB "Booting _purpOSe...", 0x0a, 0x0d, 0
messageDiskError: DB "Hardware error reading from disk.", 0x0a, 0x0d, 0
TIMES 510-($-$$) DB 0   ;padding
DW 0xAA55

secondSector:
mov si, messageWelcome
call print
jmp short $
TIMES 512 DB 0