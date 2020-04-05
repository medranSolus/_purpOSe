; File: zero_mem.asm
; Author: Marek Machliński
; Brief: Zero memory in protected mode.
;
; Copyright (c) 2020
;
%ifndef __ZERO_MEM_ASM__
%define __ZERO_MEM_ASM__
%include "protected_mode.inc"
[BITS 16]

; IN: EDI = Memory address, ECX = Size in bytes
; OUT: Void
; USES: EAX, BL
_zero_mem:
    enter_32bit
    xor bl, bl
    shr ecx, 1
    rcl bl, 1
    shr ecx, 1
    rcl bl, 1
    xor eax, eax
    rep stosd
    test bl, 1
    je short .no_word_remainder
    stosw
    .no_word_remainder:
    test bl, 2
    je short .no_byte_remainder
    stosb
    .no_byte_remainder:
    leave_32bit
    ret

%endif ; __ZERO_MEM_ASM__