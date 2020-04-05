; File: main.asm
; Author: Marek Machliński
; Brief: Main BIOS bootloader file.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x10000]

%include "elf.inc"
%include "fat/structures.inc"
%define fat_header(var) [fs:fat_header_addr + FatHeader.%+var]
%define elf_header(var) [elf_header_addr + Elf32Header.%+var]

BOOTLOADER_SGMT EQU 0x1000
KERNEL_SGMT     EQU 0x2000

header: ; 0x4D4F43C3
    ret
    DB "COM"

; IN: DL = Drive number
_main:
    call _enable_a20
    cmp al, 1
    je short .a20_enabled
    mov si, msg_no_a20
    jmp _error
    .a20_enabled:
    mov ax, KERNEL_SGMT
    mov es, ax
    mov eax, BOOTLOADER_SGMT
    mov ds, ax
    call _setup_gdt
    .find_kernel:
        mov bx, fat_header(sys_dir_cluster)
        call _load_entry_kernel_buffer
        mov bp, file_kernel
        xor dh, dh
        .search_kernel_entry:
            mov cx, fat_header(dir_entry_count)
            xor di, di
            call _find_entry
            jnc short .kernel_found
            call _load_entry_kernel_buffer
            jmp short .search_kernel_entry
    .kernel_found:
    mov [kernel_first_cluster], bx
    movzx eax, BYTE fat_header(sectors_per_cluster)
    shl eax, 9
    mov [bytes_per_cluster], eax
    mov eax, [es:di + FatEntry.file_size]
    mov [kernel_remaining_size], eax
    mov si, msg_kernel_found
    jmp _error

; Load entry inside directory into kernel buffer.
; IN: FS:SI = DAP address, DL = Drive number, BX = Entry cluster
; OUT: BX = Entry next cluster
; USES: EAX(_load_entry), ECX(_load_entry)
_load_entry_kernel_buffer:
    push 0
    push KERNEL_SGMT
    call _load_entry
    ret

%include "fat/find_entry.asm"
%include "fat/load_entry.asm"
%include "enable_a20.asm"
%include "setup_gdt.asm"
%include "zero_mem.asm"

; Messages
msg_no_a20:       DB "Cannot enable A20 line!", 0
msg_kernel_found: DB "Kernel found.", 0x0D, 0x0A, 0

; Variables
text_sgmt:
    .file_offset:  DD 0
    .virtual_addr: DD 0
    .file_size:    DD 0
    .mem_size:     DD 0
data_sgmt:
    .file_offset:  DD 0
    .virtual_addr: DD 0
    .file_size:    DD 0
    .mem_size:     DD 0
kernel_entry: DD 0

bytes_per_cluster: DD 0
kernel_remaining_size: DD 0
kernel_first_cluster: DW 0xFFFF
kernel_next_cluster: DW 0

file_kernel: DW 'p', 'o', 's', 'k', 'e', 'r', 'n', 'e', 'l', '.', 'e', 'l', 'f', 0