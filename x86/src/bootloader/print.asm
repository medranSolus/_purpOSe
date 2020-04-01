; File: print.asm
; Author: Marek Machliński
; Brief: Print string onto screen in real mode.
;
; Copyright (c) 2020
;
%ifndef __PRINT_ASM__
%define __PRINT_ASM__
[BITS 16]

; IN: DS:SI = String to display
; OUT: Void
; USES: AX
_print:
    mov ah, 0x0E
    .loop:
        lodsb
        test al, al
        jz short .quit
        int 0x10
        jmp short .loop
    .quit:
    ret

%endif ; __PRINT_ASM__