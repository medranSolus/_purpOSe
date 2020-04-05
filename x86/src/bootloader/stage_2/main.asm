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
%define elf_program_entry(var) [es:di + Elf32ProgramEntry.%+var]

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
    movzx ax, BYTE fat_header(sectors_per_cluster)
    shl ax, 9
    mov [bytes_per_cluster], ax
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
    call _load_buffer
    .check_elf_header:
        cmp DWORD [es:Elf32Header.magic_number], ELF_MAGIC_NUMBER
        je short .corret_magic
        mov si, msg_not_elf_file
        jmp _error
        .corret_magic:
            cmp WORD [es:Elf32Header.bit_format], (ELF_ENDIAN.LITTLE << 8) | ELF_BIT_FORMAT.BIT_32
            je short .correct_binary
            mov si, msg_wrong_bin_format
            jmp _error
        .correct_binary:
            cmp BYTE [es:Elf32Header.header_version], 1
            je short .correct_header
            mov si, msg_wrong_header_ver
            jmp _error
        .correct_header:
            cmp WORD [es:Elf32Header.file_type], ELF_FILE_TYPE.EXECUTABLE
            je short .correct_file_type
            mov si, msg_wrong_file_type
            jmp _error
        .correct_file_type:
            cmp WORD [es:Elf32Header.arch_type], ELF_ARCH.X86
            je short .load_segment_info
            mov si, msg_wrong_arch
            jmp _error
    .load_segment_info:
        mov cx, [es:Elf32Header.program_header_entries]
        cmp cx, 2
        jae short .correct_sgmt_count
        mov si, msg_wrong_segments
        jmp _error
        .correct_sgmt_count:
        mov eax, [es:Elf32Header.program_entry]
        mov [kernel_entry], eax
        mov si, text_sgmt
        mov di, [es:Elf32Header.program_header_table]
        .loop_segments:
            cmp DWORD elf_program_entry(segment_type), ELF_SEGMENT.LOAD
            jne short .skip_segment
            mov eax, DWORD elf_program_entry(file_offset)
            mov [si], eax
            add si, 4
            mov eax, DWORD elf_program_entry(virtual_addr)
            mov [si], eax
            add si, 4
            mov eax, DWORD elf_program_entry(segment_file_size)
            mov [si], eax
            add si, 4
            mov eax, DWORD elf_program_entry(segment_mem_size)
            mov [si], eax
            add si, 4
            cmp si, SGMT_INFO_END
            je short .segments_loaded
            .skip_segment:
            add di, Elf32ProgramEntry.SIZE
            loop .loop_segments
    .segments_loaded:
    mov edi, [text_sgmt.virtual_addr]
    mov ecx, [text_sgmt.mem_size]
    call _zero_mem
    mov edi, [data_sgmt.virtual_addr]
    mov ecx, [data_sgmt.mem_size]
    call _zero_mem
    mov si, msg_kernel_found
    jmp _error

; Fill kernel buffer with next entries.
; IN: BX = Starting cluster
; OUT: BX = Next cluster to load
; USES: EAX(_load_entry), ECX, DI
_load_buffer:
    xor di, di
    .load_loop:
        push di
        push KERNEL_SGMT
        call _load_entry
        add di, [bytes_per_cluster]
        cmp bx, 0xFFFF
        je short .file_end
        cmp di, 0
        jne short .load_loop ; Buffer still have more space
    .file_end:
    mov [kernel_next_cluster], bx
    ret

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
msg_no_a20:           DB "Cannot enable A20 line!", 0
msg_not_elf_file:     DB "Kernel is not in ELF format!", 0
msg_wrong_bin_format: DB "Wrong kernel binary format! Required 32 bit little endian.", 0
msg_wrong_header_ver: DB "ELF header in unknown verion!", 0
msg_wrong_file_type:  DB "Loaded file is not executable!", 0
msg_wrong_arch:       DB "Kernel is not in x86 arch format!", 0
msg_wrong_segments:   DB "ELF file have only 1 segment!", 0
msg_kernel_found:     DB "Kernel found.", 0x0D, 0x0A, 0

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
SGMT_INFO_END EQU $
kernel_entry: DD 0
bytes_per_cluster: DW 0
kernel_next_cluster: DW 0

file_kernel: DW 'p', 'o', 's', 'k', 'e', 'r', 'n', 'e', 'l', '.', 'e', 'l', 'f', 0