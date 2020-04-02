; File: strlen_wide.asm
; Author: Marek Machliński
; Brief: Get length of wide (2 byte) null terminated string.
;
; Copyright (c) 2020
;
%ifndef __STRLEN_WIDE_ASM__
%define __STRLEN_WIDE_ASM__
[BITS 16]

; IN: DS:SI = Wide string
; OUT: CX = Length of string
; USES: AX
_strlen_wide:
    push si
    xor cx, cx
    .loop:
        lodsw
        cmp ax, 0
        je short .quit
        inc cx
        jmp short .loop
    .quit:
    pop si
    ret

%endif ; __STRLEN_WIDE_ASM__