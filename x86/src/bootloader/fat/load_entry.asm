; File: load_entry.asm
; Author: Marek Machliński
; Brief: Load selected entry into buffer.
;
; Copyright (c) 2020
;
%ifndef __LOAD_ENTRY_ASM__
%define __LOAD_ENTRY_ASM__
%include "fat/load_fat.asm"
[BITS 16]

; __stdcall (No stack cleanup)
; IN: FS:SI = DAP address, DL = Drive number, BX = Entry cluster,
;     SS:SP+2 = Buffer segment, SS:SP+4 = Buffer address
; OUT: BX = Entry next cluster
; USES: EAX, ECX
_load_entry:
    cmp bh, fat_header(loaded_fat)
    je short .current_fat
    movzx eax, bh
    call _load_fat
    .current_fat:
    movzx eax, bl
    shl bx, 1
    mov bx, [fs:fat_buffer + bx]
    movzx cx, BYTE fat_header(sectors_per_cluster)
    mov [fs:si + DAP.sectors_count], cx
    dec al
    dec al
    mul cl
    add eax, fat_header(lba_data)
    mov [fs:si + DAP.start_lba_low], eax
    pop ax
    pop cx
    shl ecx, 16
    pop cx
    mov [fs:si + DAP.buffer_offset], ecx
    push ax
    call _read_disk
    ret

%endif ; __LOAD_ENTRY_ASM__