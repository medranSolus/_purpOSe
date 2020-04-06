; File: protected_mode.inc
; Author: Marek Machliński
; Brief: Macros for entering and leaving protected mode.
;
; Copyright (c) 2020
;
%ifndef __PROTECTED_MODE_INC__
%define __PROTECTED_MODE_INC__

; USES: EAX, DS, ES
%macro ENTER_32BIT 0
    cli
    call _disable_nmi
    mov eax, cr0
    or al, 1
    mov cr0, eax
    jmp DWORD 0x08:%%protected_mode
    [BITS 32]
    %%protected_mode:
    mov eax, 0x10
    mov ds, eax
    mov es, eax
%endmacro

; USES: EAX, DS, ES
%macro LEAVE_32BIT 0
    mov eax, 0x20
    mov ds, eax
    mov es, eax
    DB 0xEA               ; Far jump, NASM produces wrong
    DD %%protected_mode16 ; code when used like:
    DW 0x0018             ; jmp 0x18:%%protected_mode16
    [BITS 16]
    %%protected_mode16:
    mov eax, cr0
    and eax, 0x7FFFFFFE
    mov cr0, eax
    jmp BOOTLOADER_SGMT:%%real_mode
    %%real_mode:
    mov eax, BOOTLOADER_SGMT
    mov ds, ax
    mov eax, KERNEL_SGMT
    mov es, ax
    call _enable_nmi
    sti
%endmacro

%endif ; __PROTECTED_MODE_INC__