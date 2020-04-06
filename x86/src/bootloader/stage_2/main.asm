; File: main.asm
; Author: Marek Machliński
; Brief: Main BIOS bootloader file.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x10000]

%include "elf.inc"
%include "protected_mode.inc"
%include "fat/structures.inc"
%define FAT_HEADER(var) [fs:fat_header_addr + FatHeader.%+var]
%define ELF_PROGRAM_ENTRY(var) DWORD [es:di + Elf32ProgramEntry.%+var]

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
    movzx ax, BYTE FAT_HEADER(sectors_per_cluster)
    shl ax, 9
    mov [bytes_per_cluster], ax
    call _setup_gdt
    mov si, msg_kernel_loading
    call _print
    mov si, dap_addr
    .find_kernel:
        mov bx, FAT_HEADER(sys_dir_cluster)
        call _load_entry_kernel_buffer
        mov bp, file_kernel
        xor dh, dh
        .search_kernel_entry:
            mov cx, FAT_HEADER(dir_entry_count)
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
            cmp DWORD ELF_PROGRAM_ENTRY(segment_type), ELF_SEGMENT.LOAD
            jne short .skip_segment
            mov eax, ELF_PROGRAM_ENTRY(file_offset)
            mov [si], eax
            add si, 4
            mov eax, ELF_PROGRAM_ENTRY(virtual_addr)
            mov [si], eax
            add si, 4
            mov eax, ELF_PROGRAM_ENTRY(segment_file_size)
            mov [si], eax
            add si, 4
            mov eax, ELF_PROGRAM_ENTRY(segment_mem_size)
            mov [si], eax
            add si, 4
            cmp si, SGMT_INFO_END
            je short .zero_kernel_memory
            .skip_segment:
            add di, Elf32ProgramEntry.SIZE
            loop .loop_segments
    .zero_kernel_memory:
        mov ecx, [text_sgmt.mem_size]
        mov eax, [text_sgmt.file_size]
        mov edi, [text_sgmt.virtual_addr]
        call _zero_kernel_mem
        mov ecx, [data_sgmt.mem_size]
        mov eax, [data_sgmt.file_size]
        mov edi, [data_sgmt.virtual_addr]
        call _zero_kernel_mem
    .copy_kernel:
        mov si, text_sgmt.file_offset
        mov di, data_sgmt.file_offset   
        call _copy_segment
        mov si, data_sgmt.file_offset  
        mov di, text_sgmt.file_offset 
        call _copy_segment
    .call_kernel:
        ENTER_32BIT
        mov fs, eax
        mov gs, eax
        mov ss, eax
        jmp [kernel_entry]

%include "fat/load_entry.asm"
%include "fat/find_entry.asm"

; Copy main segment into kernel memory.
; IN: DS:SI = Main segment, DS:DI = Second segment
; OUT: Void
; USES: EAX, BX(_adjust_offsets), ECX, ESI, EDI
_copy_segment:
        call _adjust_offsets
        mov ecx, [si + 8] ; File size
        push di
        mov edi, [si + 4] ; Destination address
        mov eax, [si]     ; File offset
        add eax, ecx      ; File end
        sub eax, 0x10000  ; Buffer overflow
        jbe short .sgm_in_buffer
        sub ecx, eax      ; Bytes to copy
        add [si + 4], ecx ; Adjust next destination address
        sub [si + 8], ecx ; Decrement remaining file size
        push si
        mov esi, [si]
        call _copy_mem
        pop si
        pop di
        mov DWORD [si], 0x10000 ; Advance file offset to end of buffer
        jmp short _copy_segment
    .sgm_in_buffer:
    mov esi, [si]
    call _copy_mem
    pop di
    ret

; Adjust segment offsets and load next buffers.
; IN: DS:SI = Main offset, DS:DI = Second offset
; OUT: Void
; USES: EAX(_load_buffer), BX, ECX(_load_buffer)
_adjust_offsets:
    mov bx, [kernel_next_cluster]
    .loop:
        cmp DWORD [si], 0x10000
        jb short .done
        cmp bx, 0xFFFF
        jne short .load_next
        mov si, msg_kernel_corrupted
        jmp _error
        .load_next:
        push di
        call _load_buffer
        pop di
        sub DWORD [si], 0x10000
        sub DWORD [ds:di], 0x10000
        jmp short .loop
    .done:
    ret

; Zero kernel memory region if won't be overwriten by file content.
; IN: ECX = Memory block size, EAX = File block size, EDI = Start address
; OUT: Void
; USES: EAX(_zero_mem), ECX, EDI
_zero_kernel_mem:
    cmp ecx, eax
    jbe short .skip
    sub ecx, eax
    add edi, eax
    call _zero_mem
    .skip:
    ret

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

%include "enable_a20.asm"
%include "setup_gdt.asm"
%include "nmi.asm"
%include "zero_mem.asm"
%include "copy_mem.asm"

file_kernel: DW 'p', 'o', 's', 'k', 'e', 'r', 'n', 'e', 'l', '.', 'e', 'l', 'f', 0

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

; Messages
msg_no_a20:           DB "Cannot enable A20 line!", 0
msg_not_elf_file:     DB "Kernel is not in ELF format!", 0
msg_wrong_bin_format: DB "Wrong kernel binary format! Required 32 bit little endian.", 0
msg_wrong_header_ver: DB "ELF header in unknown verion!", 0
msg_wrong_file_type:  DB "Loaded file is not executable!", 0
msg_wrong_arch:       DB "Kernel is not in x86 arch format!", 0
msg_wrong_segments:   DB "ELF file have only 1 segment!", 0
msg_kernel_corrupted: DB "Kernel file corrupted!", 0
msg_kernel_loading:   DB "Loading _purpOSe...", 0x0D, 0x0A, 0