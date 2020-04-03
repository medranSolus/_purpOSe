; File: lfn_compare.asm
; Author: Marek Machliński
; Brief: Compare Long File Name with unicode string.
;
; Copyright (c) 2020
;
%ifndef __LFN_COMPARE_ASM__
%define __LFN_COMPARE_ASM__
%include "fat/structures.inc"
[BITS 16]

; IN: DS:BP = Name pattern in unicode, ES:DI = Entry
; OUT: Equality flag set (ZF = 1) if found
; USES: Void
_lfn_compare:
    pusha
    mov si, bp
    xor ax, ax
    .find_loop:
        sub di, LfnEntry.SIZE - 1
        cmp BYTE [es:di + LfnEntry.attrib - 1], DIR_ATTRIB.LFN
        jne short .not_found
        test BYTE [es:di + LfnEntry.index - 1], 0x40
        jz short .not_last
        inc ah
        .not_last:
        mov cx, 5
        call .check_part
        add di, 3
        mov cx, 6
        call .check_part
        add di, 2
        mov cx, 2
        call .check_part
        cmp ah, 0
        je short .check_next
        cmp WORD [ds:si], 0
        je short .string_end
        jmp short .not_found
        .check_next:
        sub di, LfnEntry.SIZE
        jmp short .find_loop
    .not_found:
    inc al
    .string_end:
    cmp al, 0
    popa
    ret

.check_part:
    pop bx
    .check_loop:
        cmp WORD [ds:si], 0
        jne short .not_string_end
        cmp WORD [es:di], 0
        jne short .not_found
        jmp short .string_end
        .not_string_end:
        cmpsw
        jne short .not_found
        loop .check_loop
    push bx
    ret

%endif ; __LFN_COMPARE_ASM__