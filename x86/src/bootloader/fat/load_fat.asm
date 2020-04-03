; File: load_fat.asm
; Author: Marek Machliński
; Brief: Load selected FAT sector into buffer.
;
; Copyright (c) 2020
;
%ifndef __LOAD_FAT_ASM__
%define __LOAD_FAT_ASM__
%include "fat/structures.inc"
%include "dap.inc"
%include "read_disk.asm"
[BITS 16]

; IN: DS:SI = DAP address, DL = Drive number, EAX = FAT sector number
; OUT: Void
; USES: EAX
_load_fat:
    mov DWORD [si + DAP.sectors_count], (fat_buffer << 16) | 1
    mov WORD [si + DAP.buffer_sgmt], 0
    mov fat_header(loaded_fat), al
    add eax, fat_header(lba_fat)
    mov [si + DAP.start_lba_low], eax
    call _read_disk
    ret

%endif ; __LOAD_FAT_ASM__