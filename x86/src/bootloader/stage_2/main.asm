; File: main.asm
; Author: Marek Machliński
; Brief: Main BIOS bootloader file.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x0000]

%include "fat/structures.inc"

BOOTLOADER_SGMT EQU 0x1000
KERNEL_SGMT     EQU 0x2000

header: ; 0x4D4F43C3
    ret
    DB "COM"

; IN: DL = Drive number
_main:
    call _enable_a20
    mov bx, fat_header(sys_dir_cluster)
    cmp al, 1
    je short .a20_enabled
    mov si, msg_no_a20
    jmp _error
    .a20_enabled:
    mov ax, KERNEL_SGMT
    mov es, ax
    mov ax, BOOTLOADER_SGMT
    mov ds, ax
    mov fs, ax
    mov gs, ax

    mov si, msg_hello
    jmp _error
    
    mov bp, file_kernel
    .find_kernel_file:
        call _find_subdir_entry
        xor di, di
        adc di, 0
        call _load_entry_buffer_disk
        cmp di, 0
        jne short .find_kernel_file


; Load entry inside directory into disk buffer.
; IN: SI = DAP address, DL = Drive number, BX = Entry cluster
; OUT: BX = Entry next cluster
; USES: EAX(_load_entry), CX(_load_entry)
_load_entry_buffer_disk:
    push 0
    push KERNEL_SGMT
    call _load_entry
    ret

; Find specified entry in subdirectory inside disk buffer.
; IN: DS:BP = Entry name, DH = Entry attributes (0 for skip), BX = Directory next cluster entry
; OUT: ES:DI = Entry, BX = Entry cluster, Carry set if not found
; USES: CX, DI
_find_subdir_entry:
    pusha
    xor ax, ax
    mov ds, ax
    mov cx, fat_header(dir_entry_count)
    popa
    xor di, di
    jmp short _find_entry

%include "fat/find_entry.asm"
%include "fat/load_entry.asm"
%include "enable_a20.asm"

msg_no_a20: DB "Cannot enable A20 line!", 0
msg_hello:  DB "Bootloader file in memory.", 0x0D, 0x0A, 0

file_kernel: DW 'p', 'o', 'k', 'e', 'r', 'n', 'e', 'l', '.', 'e', 'l', 'f', 0