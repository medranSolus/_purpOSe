; File: main.asm
; Author: Marek Machliński
; Brief: Main BIOS bootloader file.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x0000]

BOOTLOADER_SGMT  EQU 0x1000

header: ; 0x4D4F43C3
    ret
    DB "COM"

; IN: DL = Drive number
_main:
    call _enable_a20
    cmp al, 1
    je short .a20_enabled
    mov si, msg_no_a20
    jmp short _error
    .a20_enabled:
    mov ax, BOOTLOADER_SGMT
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov si, msg_hello
    jmp short _error

%include "read_disk.asm"
%include "enable_a20.asm"

msg_no_a20: DB "Cannot enable A20 line!", 0
msg_hello:  DB "Bootloader file in memory.", 0x0D, 0x0A, 0