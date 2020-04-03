; File: read_disk.asm
; Author: Marek Machliński
; Brief: Read data from disk.
;
; Copyright (c) 2020
;
%ifndef __READ_DISK_ASM__
%define __READ_DISK_ASM__
%include "error.asm"
[BITS 16]

; IN: DS:SI = DAP address, DL = Drive number
; OUT: Void
; USES: AH
_read_disk:
    mov ah, 0x42
    int 0x13
    jnc short .quit
    mov si, msg_disk_error
    jmp short _error
    .quit:
    ret

msg_disk_error: DB "Disk error!", 0

%endif ; __READ_DISK_ASM__