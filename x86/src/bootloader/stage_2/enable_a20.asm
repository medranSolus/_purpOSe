; File: enable_a20.asm
; Author: Marek Machliński
; Brief: Enable A20 line to access upper memory.
;
; Copyright (c) 2020
;
%ifndef __ENABLE_A20_ASM__
%define __ENABLE_A20_ASM__
%include "check_a20.asm"
[BITS 16]
RETRIES_COUNT  EQU 10
SPIN_LOOP_TIME EQU 0xFF

; IN: Void
; OUT: AL = 1 if enabled otherwise 0
; USES: AX, CX, SI, DI, DS, ES
_enable_a20:
    call _check_a20
    je short .enabled
    .bios_method:
        mov ax, 0x2403
        int 0x15
        jc short .keyboard_controller
        cmp ah, 0
        jnz short .keyboard_controller ; Not supported
        mov ax, 0x2401
        int 0x15
        call _check_a20
        je short .enabled
    .keyboard_controller:
        cli
        call .keyboard_a20_wait
        mov al, 0xAD
        out 0x64, al
        call .keyboard_a20_wait
        mov al, 0xD0
        out 0x64, al
        .keyboard_wait:
            in al, 0x64
            test al, 1
            jz short .keyboard_wait
        in al, 0x60
        push ax
        call .keyboard_a20_wait
        mov al, 0xD1
        out 0x64, al
        call .keyboard_a20_wait
        pop ax
        or al, 2
        out 0x60, al 
        call .keyboard_a20_wait
        mov al, 0xAE
        out 0x64, al
        call .keyboard_a20_wait
        sti
        mov cx, RETRIES_COUNT
        .keyboard_try:
            call _check_a20
            je short .enabled
            push cx
            mov cx, SPIN_LOOP_TIME
            loop $
            loop .keyboard_try
    .fast_a20:
        in al, 0x92
        test al, 2
        jnz short .last_try
        or al, 2
        and al, 0xFE
        out 0x92, al
        mov cx, RETRIES_COUNT
        .fast_a20_try:
            call _check_a20
            je short .enabled
            push cx
            mov cx, SPIN_LOOP_TIME
            loop $
            loop .fast_a20_try
    .last_try:
        in al, 0xEE ; Sometimes when port 0xEE is enabled, reading from it causes enabling A20
        call _check_a20
        je short .enabled
    xor al, al
    jmp short .quit
    .enabled:
    mov al, 1
    .quit:
    ret

.keyboard_a20_wait:
    in al, 0x64
    test al, 2
    jnz short .keyboard_a20_wait
    ret

%endif ; __ENABLE_A20_ASM__