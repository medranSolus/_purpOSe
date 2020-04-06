; File: copy_mem.asm
; Author: Marek Machliński
; Brief: Copy memory in protected mode.
;
; Copyright (c) 2020
;
%ifndef __COPY_MEM_ASM__
%define __COPY_MEM_ASM__
%include "protected_mode.inc"
[BITS 16]

; IN: ESI = Source inside kernel buffer, EDI = Destination, ECX = Size in bytes
; OUT: Void
; USES: EAX, BL
_copy_mem:
    ENTER_32BIT
    add esi, KERNEL_SGMT << 4
    xor bl, bl
    shr ecx, 1
    rcl bl, 1
    shr ecx, 1
    rcl bl, 1
    rep movsd
    test bl, 1
    je short .no_word_remainder
    movsw
    .no_word_remainder:
    test bl, 2
    je short .no_byte_remainder
    movsb
    .no_byte_remainder:
    LEAVE_32BIT
    ret

%endif ; __COPY_MEM_ASM__