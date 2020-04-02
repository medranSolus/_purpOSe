; File: check_a20.asm
; Author: Marek Machliński
; Brief: Check if line A20 is active by wraparound in high memory.
;
; Copyright (c) 2020
;
%ifndef __CHECK_A20_ASM__
%define __CHECK_A20_ASM__
[BITS 16]

; IN: Void
; OUT: Equality flag set (ZF = 1)
; USES: AX, SI, DI, DS, ES
_check_a20:
    xor ax, ax
    mov ds, ax
    mov si, 0x0520
    not ax
    mov es, ax
    mov di, 0x0530
    mov BYTE [ds:si], 0xAA
    mov al, [es:di]
    mov BYTE [es:di], 0x55
    cmp BYTE [ds:si], 0xAA
    mov [es:di], al
    ret

%endif ; __CHECK_A20_ASM__