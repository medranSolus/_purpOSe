; File: error.asm
; Author: Marek Machliński
; Brief: Handle unrecoverable boot error.
;
; Copyright (c) 2020
;
%ifndef __ERROR_ASM__
%define __ERROR_ASM__
%include "print.asm"
[BITS 16]

; IN: DS:SI = String to display
; OUT: Noreturn
; USES: AX
_error:
    call _print
    .hang:
        cli
        hlt
        jmp short .hang

%endif ; __ERROR_ASM__