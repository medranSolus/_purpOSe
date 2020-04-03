; File: fat16.asm
; Author: Marek Machliński
; Brief: VBR for FAT16 loading bootloader into memory.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x0730]

; Bootloader path: Purpose\Boot\bootpos.COM
_start:
    cld
    jmp short _relocate

%include "mbr_entry.inc"
%include "fat/structures.inc"

; Constants
DISK_BUFFER_SGMT EQU 0x1000
STACK_SGMT       EQU 0x00B3
STACK_TOP        EQU 0xF4D0

buffer_vbr_rest  EQU 0x0930

BPB: ; BIOS Parameter Block
    .description:            DB "_purpOSe" ; 8!!!
    .bytes_per_sector:       DW 512 ; 512, 1024, 2048 or 4096 (but for 99,99% it's 512) NOTE: Max sectors_per_cluster for bytes_per_sector below
    .sectors_per_cluster:    DB 1   ; 128,       32,     16, 8, 4, 2, 1 NOTE: later for 512 * x -> bytes_per_sector >> 10 * sectors_per_cluster
    .reserved_sectors_count: DW 2   ; Minimum 1 for vbr
    .fat_count:              DB 2
    .root_dir_entries_count: DW 512 ; 32 bytes per entry NOTE: Max 0x7A0 entries
    .sectors_count:          DW 0   ; If zero: number of sectors in volume lower
    .media_descriptor:       DB 0xF0
    .sectors_per_fat:        DW 2
    .sectors_per_cylinder:   DW 1   ; Must be initialized first (starting value always invalid)
    .heads_count:            DW 1   ; Must be initialized first (starting value always invalid)
    .hidden_sectors_count:   DD 0   ; Ignored
    .sectors_count_long:     DD 0
    .drive_number:           DB 0x80 ; Must be initialized first (starting value always invalid)
    .reserved:               DB 0x00 ; Windows NT flags \_____ Current FAT sector in memory
    .signature:              DB 0x29 ;                  /
    .volume_id:              DD 0x00 ; Can be ignored, but used to track volumes
    .volume_label:           DB "PurpOSe    " ; 11!!!
    .file_system_id:         DB "FAT16   " ; 8!!! (Never trust it)
    .SIZE EQU $ - BPB ; = 59

%define bpb_var(reg, var) [reg + BPB.%+var - BPB]

; IN: DS:SI = Active partition address, DL = Drive number
_relocate:
    cli
    xor ax, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, STACK_SGMT
    mov ss, sp
    mov sp, STACK_TOP
    .partition_entry:
        mov cx, 4
        mov di, partition_entry
        rep movsd
    .vbr:
        mov ds, ax
        mov cx, 0x0080  ; Size of VBR in DWORD's
        mov si, 0x7C00  ; Bootsector address
        mov di, $$      ; New address
        rep movsd
    mov si, BPB
    mov bpb_var(si, drive_number), dl
    sti
    mov ax, DISK_BUFFER_SGMT
    mov es, ax
    jmp 0:_locate_bootloader

; IN: DS:SI = Active partition address, DL = Drive number
_locate_bootloader:
    .check_bios_ext:
        mov ah, 0x41
        mov bx, 0x55AA
        int 0x13
        jnc short .load_root_dir
        mov si, msg_no_bios_ext
        jmp _error
    .load_root_dir:
        mov cx, bpb_var(si, bytes_per_sector)
        shr cx, 10
        cmp cl, 0
        jz short .no_decrement
        dec cl
        .no_decrement:
        movzx ebx, WORD bpb_var(si, reserved_sectors_count)
        shl ebx, cl
        add ebx, [partition_entry + MbrEntry.start_lba]
        mov fat_header(lba_fat), ebx
        movzx ax, BYTE bpb_var(si, fat_count)
        shl ax, cl
        mul WORD bpb_var(si, sectors_per_fat)
        shl edx, 16
        mov dx, ax
        add ebx, edx
        movzx edx, WORD bpb_var(si, root_dir_entries_count)
        test dl, 0x0F
        jz short .root_dir_entries_even
        and dl, 0xF0
        add dx, 0x10
        .root_dir_entries_even:
        shr dx, 4
        shl edx, cl
        shl BYTE bpb_var(si, sectors_per_cluster), cl
        movzx cx, BYTE bpb_var(si, sectors_per_cluster)
        mov fat_header(sectors_per_cluster), cl
        shl cx, 4
        mov fat_header(dir_entry_count), cx
        mov si, dap_address
        mov [si + DAP.sectors_count], dx
        mov [si + DAP.start_lba_low], ebx
        mov WORD [si + DAP.dap_size], DAP.SIZE
        mov DWORD [si + DAP.start_lba_high], 0
        mov DWORD [si + DAP.buffer_offset], DISK_BUFFER_SGMT << 16
        add ebx, edx
        mov fat_header(lba_data), ebx
        mov dl, [BPB.drive_number]
        call _read_disk
    .load_rest_of_vbr:
        mov DWORD [si + DAP.sectors_count], (buffer_vbr_rest << 16) | 1
        mov WORD [si + DAP.buffer_sgmt], 0
        mov eax, [partition_entry + MbrEntry.start_lba]
        inc eax
        mov DWORD [si + DAP.start_lba_low], eax
        call _read_disk
    .load_sys_dir:
        mov bp, dir_system
        mov dh, DIR_ATTRIB.SUB_DIR
        mov bx, 0xFFFF
        mov cx, [BPB.root_dir_entries_count]
        xor di, di
        call _find_entry
        mov fat_header(sys_dir_cluster), bx
        movzx eax, bh
        call _load_fat
        call _load_entry_buffer_disk
    .load_boot_dir:
        mov bp, dir_boot
        .check_sys_dir_cluster:
            call _find_subdir_entry
            xor di, di
            adc di, 0
            call _load_entry_buffer_disk
            cmp di, 0
            jne short .check_sys_dir_cluster
    .find_bootloader:
        mov bp, file_boot
        xor dh, dh
        .check_boot_dir_cluster:
            call _find_subdir_entry
            jnc _load_bootloader
            call _load_entry_buffer_disk
            jmp short .check_boot_dir_cluster

%include "read_disk.asm"

; Messages
msg_no_bios_ext:    DB "No Disk Extensions!", 0
msg_loader_too_big: DB "Bootloader size exceed 64KB!",0
msg_entry_corrupt:  DB "Bootloader entry corrupted!", 0
msg_unknown_format: DB "Unknown bootloader header!", 0

TIMES 510 - ($ - $$) DB 0

DW 0xAA55

; IN: ES:DI = Bootloader entry, BX = Bootloader cluster
_load_bootloader:
    movzx ecx, BYTE [BPB.sectors_per_cluster]
    shl ecx, 9
    dec ecx
    mov eax, [es:di + FatEntry.file_size]
    test eax, ecx
    jz short .file_size_even
    add eax, ecx
    not ecx
    and eax, ecx
    .file_size_even:
    cmp eax, 0x10000
    jbe short .smaller_than_64K
    mov si, msg_loader_too_big
    jmp _error
    .smaller_than_64K:
    shr ax, 9
    push ax
    xor ax, ax
    .read_entries:
        push ax
        push ax
        push DISK_BUFFER_SGMT
        call _load_entry
        pop ax
        add ax, [si + DAP.sectors_count]
        cmp bx, 0xFFFF
        je short .loader_in_memory
        cmp ax, 0
        jne short .read_entries
        mov si, msg_loader_too_big
        jmp _error
    .loader_in_memory:
    pop cx
    cmp cx, ax
    je short .loaded_correctly
    mov si, msg_entry_corrupt
    jmp _error
    .loaded_correctly:
    mov ax, DISK_BUFFER_SGMT
    mov ds, ax
    cmp DWORD [ds:0], 0x4D4F43C3 ; Bootloader magic number
    je short .correct_header
    xor ax, ax
    mov ds, ax
    mov si, msg_unknown_format
    jmp _error
    .correct_header:
    jmp DISK_BUFFER_SGMT:0x4

; Find specified entry in subdirectory inside disk buffer.
; IN: DS:BP = Entry name, DH = Entry attributes (0 for skip), BX = Directory next cluster entry
; OUT: ES:DI = Entry, BX = Entry cluster, Carry set if not found
; USES: CX, DI
_find_subdir_entry:
    mov cx, fat_header(dir_entry_count)
    xor di, di
    jmp short _find_entry

; Load entry inside directory into disk buffer.
; IN: DS:SI = DAP address, DL = Drive number, BX = Entry cluster
; OUT: BX = Entry next cluster
; USES: EAX(_load_entry), CX(_load_entry)
_load_entry_buffer_disk:
    push 0
    push DISK_BUFFER_SGMT
    call _load_entry
    ret

%include "fat/find_entry.asm"
%include "fat/load_fat.asm"
%include "fat/load_entry.asm"

; Location of bootloader
dir_system: DW 'P', 'u', 'r', 'p', 'o', 's', 'e', 0
dir_boot:   DW 'B', 'o', 'o', 't', 0
file_boot:  DW 'b', 'o', 'o', 't', 'p', 'o', 's', '.', 'C', 'O', 'M', 0

TIMES 0x400 - ($ - $$) DB 0x90