; File: print_wide.asm
; Author: Marek Machliński
; Brief: Print wide (2 byte) string onto screen in real mode.
;
; Copyright (c) 2020
;
%ifndef __PRINT_WIDE_ASM__
%define __PRINT_WIDE_ASM__
[BITS 16]

; IN: DS:SI = String to display
; OUT: Void
; USES: AX
_print_wide:
        lodsw
        test ax, ax
        jz short .quit
        mov ah, 0x0E
        int 0x10
        jmp short _print_wide
    .quit:
    ret

%endif ; __PRINT_WIDE_ASM__