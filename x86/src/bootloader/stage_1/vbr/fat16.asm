; File: fat16.asm
; Author: Marek Machliński
; Brief: VBR for FAT16 loading bootloader into memory.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x0530]

; Bootloader path: Purpose\Boot\bootpos.COM
_start:
    cld
    jmp short _relocate

%include "fat_structures.inc"
%include "mbr_entry.inc"
%include "dap.inc"

; Constants
BUFFER_DISK_SIZE EQU 0xF400 ; 122 x 512 sectors
BOOTLOADER_SGMT  EQU 0x1000
STACK_SGMT       EQU 0x7FE0
STACK_TOP        EQU 0x0200

; Memory variables
partition_entry EQU 0x0500
dap_address     EQU 0x0510
lba_data        EQU 0x0520
lba_fat         EQU 0x0524
loaded_fat      EQU 0x0528 ; 1B
buffer_vbr_rest EQU 0x0730
buffer_fat      EQU 0x0930
buffer_disk     EQU 0x0A30

BPB: ; BIOS Parameter Block
    .description:            DB "_purpOSe" ; 8!!!
    .bytes_per_sector:       DW 512 ; 512, 1024, 2048 or 4096 but for 99,99% it's 512
    .sectors_per_cluster:    DB 1   ; 1, 2, 4, 8, 16 or 32 (128 not supported) NOTE: later for 512 * x -> bytes_per_sector >> 10 * sectors_per_cluster
    .reserved_sectors_count: DW 1   ; Minimum 1 for vbr
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
    .volume_label:           DB "Pos Volume " ; 11!!!
    .file_system_id:         DB "FAT16   " ; 8!!! (Never trust it)
    .SIZE EQU $ - BPB ; = 59

%define bpb_var(reg, var) [reg + BPB.%+var - BPB]

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
        mov cx, 8
        mov di, partition_entry
        rep movsw
    .vbr:
        mov ds, ax
        mov cx, 0x0100  ; Size of VBR in WORD's
        mov si, 0x7C00  ; Bootsector address
        mov di, $$      ; New address
        rep movsw
    mov si, BPB
    mov bpb_var(si, drive_number), dl
    sti
    jmp 0:_locate_bootloader

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
        mov [lba_fat], ebx
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
        mov si, dap_address
        mov [si + DAP.sectors_count], dx
        mov [si + DAP.start_lba_low], ebx
        mov WORD [si + DAP.dap_size], DAP.SIZE
        mov DWORD [si + DAP.start_lba_high], 0
        mov DWORD [si + DAP.buffer_offset], buffer_disk
        add ebx, edx
        mov [lba_data], ebx
        mov dl, [BPB.drive_number]
        call _read_disk
    .load_rest_of_vbr:
        mov DWORD [si + DAP.sectors_count], (buffer_vbr_rest << 16) | 1
        mov eax, [partition_entry + MbrEntry.start_lba]
        inc eax
        mov DWORD [si + DAP.start_lba_low], eax
        call _read_disk
    .load_sys_dir:
        mov bp, dir_system
        mov dh, DIR_ATTRIB.SUB_DIR
        mov bx, 0xFFFF
        call _find_entry
        movzx eax, bh
        call _load_fat
        call _load_entry_buffer_disk
    .load_boot_dir:
        mov bp, dir_boot
        .check_sys_dir_cluster:
            call _find_entry
            xor di, di
            adc di, 0
            call _load_entry_buffer_disk
            cmp di, 0
            jne short .check_sys_dir_cluster
    .find_bootloader:
        mov bp, file_boot
        xor dh, dh
        .check_boot_dir_cluster:
            call _find_entry
            jnc _load_bootloader
            call _load_entry_buffer_disk
            jmp short .check_boot_dir_cluster

; Finds entry inside directory in buffer_disk
; IN: DS:BP = Entry name, DH = Entry attributes (0 for skip), BX = Directory next cluster entry
; OUT: ES:DI = Entry, BX = Entry cluster, Carry set if not found
; USES: CX, DI
_find_entry:
    mov cx, [BPB.root_dir_entries_count]
    mov di, buffer_disk
    .check_entries:
        cmp dh, 0
        je short .name_compare
        test dh, [di + FatEntry.attrib]
        jz short .skip_entry
        .name_compare:
            push si
            push di
            push cx
            mov si, bp
            mov cx, 11
            repe cmpsb
            pop cx
            pop di
            pop si
        je short .found
        .skip_entry:
        add di, FatEntry.SIZE
        loop .check_entries
    cmp bx, 0xFFFF
    jne short .not_found
    mov si, msg_no_entry
    call _print
    mov si, bp
    jmp short _error
    .not_found:
    stc
    jmp short .quit
    .found:
    mov bx, WORD [di + FatEntry.start_cluster]
    clc
    .quit:
    ret

; Load selected entry into buffer
; IN: DS:SI = DAP address, DL = Drive number, BX = Entry cluster, SS:SP+2 = Buffer segment, SS:SP+4 = Buffer address
; OUT: BX = Entry next cluster
; USES: EAX(_load_fat), ECX
_load_entry:
    cmp bh, [loaded_fat]
    je short .current_fat
    movzx eax, bh
    call _load_fat
    .current_fat:
    movzx eax, bl
    shl bx, 1
    mov bx, [buffer_fat + bx]
    movzx cx, BYTE [BPB.sectors_per_cluster]
    mov [si + DAP.sectors_count], cx
    dec al
    dec al
    mul cl
    add eax, [lba_data]
    mov [si + DAP.start_lba_low], eax
    pop ax
    pop cx
    shl ecx, 16
    pop cx
    mov [si + DAP.buffer_offset], ecx
    push ax
    call _read_disk
    ret

; Read data from disk
; IN: DS:SI = DAP address, DL = Drive number
; OUT: Void
; USES: AH
_read_disk:
    mov ah, 0x42
    int 0x13
    jnc short .quit
    mov si, msg_disk_error
    jmp short _error
    .quit:
    ret

; Handle unrecoverable boot error
; IN: DS:SI = String to display
; OUT: No-return
; USES: AX
_error:
    call _print
    .hang:
        cli
        hlt
        jmp short .hang

%include "print.asm"

; Messages
msg_no_bios_ext: DB "No Disk Extensions!", 0
msg_disk_error:  DB "Disk error!", 0

TIMES 510 - ($ - $$) DB 0

DW 0xAA55

; IN: ES:DI = Bootloader entry, BX = Bootloader cluster
_load_bootloader:
    movzx ecx, BYTE [BPB.sectors_per_cluster]
    shl ecx, 9
    dec ecx
    mov eax, [di + FatEntry.file_size]
    test eax, ecx
    jz short .file_size_even
    add eax, ecx
    not ecx
    and eax, ecx
    .file_size_even:
    cmp eax, 0x10000
    jbe short .smaller_than_64K
    mov si, msg_loader_too_big
    jmp short _error
    .smaller_than_64K:
    shr ax, 9
    push ax
    xor ax, ax
    .read_entries:
        push ax
        push ax
        push BOOTLOADER_SGMT
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
    mov ax, BOOTLOADER_SGMT
    mov ds, ax
    cmp DWORD [ds:0], 0x4D4F43C3 ; Bootloader magic number
    je short .correct_header
    xor ax, ax
    mov ds, ax
    mov si, msg_unknown_format
    jmp _error
    .correct_header:
    jmp BOOTLOADER_SGMT:0x4

; Load entry inside directory into buffer_disk
; IN: DS:SI = DAP address, DL = Drive number, BX = Entry cluster
; OUT: BX = Entry next cluster
; USES: EAX(_load_entry), CX(_load_entry)
_load_entry_buffer_disk:
    push buffer_disk
    push 0
    call _load_entry
    ret

; Load selected FAT sector
; IN: DS:SI = DAP address, DL = Drive number, EAX = FAT sector number
; OUT: Void
; USES: EAX
_load_fat:
    mov DWORD [si + DAP.sectors_count], (buffer_fat << 16) | 1
    mov [loaded_fat], al
    add eax, [lba_fat]
    mov [si + DAP.start_lba_low], eax
    call _read_disk
    ret

; Messages
msg_no_entry:       DB "Entry not found: ", 0
msg_loader_too_big: DB "Bootloader size exceeded 64KB!",0
msg_entry_corrupt:  DB "Bootloader entry corrupted!", 0
msg_unknown_format: DB "Unknown bootloader file header!", 0
msg_hello:          DB "Bootloader file in memory.", 0x0D, 0x0A, 0

; Location of bootloader
dir_system: DB "PURPOSE    ", 0
dir_boot:   DB "BOOT       ", 0
file_boot:  DB "BOOTPOS COM", 0

TIMES 0x400 - ($ - $$) DB 0xDD