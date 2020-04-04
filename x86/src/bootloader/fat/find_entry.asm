; File: find_entry.asm
; Author: Marek Machliński
; Brief: Find specified entry inside disk buffer.
;
; Copyright (c) 2020
;
%ifndef __FIND_ENTRY_ASM__
%define __FIND_ENTRY_ASM__
%include "fat/lfn_compare.asm"
%include "print.asm"
%include "print_wide.asm"
[BITS 16]

; IN: DS:BP = Entry name, ES:DI = Disk buffer, DH = Entry attributes (0 for skip),
;     BX = Directory next cluster entry, CX = Entries count
; OUT: ES:DI = Entry, BX = Entry cluster, Carry set if not found
; USES: CX, DI
_find_entry:
    .check_entries:
        cmp dh, 0
        je short .name_compare
        test dh, [es:di + FatEntry.attrib]
        jz short .skip_entry
        .name_compare:
        call _lfn_compare
        je short .found
        .skip_entry:
        add di, FatEntry.SIZE
        loop .check_entries
    cmp bx, 0xFFFF
    jne short .not_found
    .no_more_dir_clusters:
        mov si, msg_no_entry
        call _print
        mov si, bp
        call _print_wide
        mov si, bp
        inc si
        jmp _error
    .not_found:
    stc
    jmp short .quit
    .found:
    mov bx, WORD [es:di + FatEntry.start_cluster]
    clc
    .quit:
    ret

msg_no_entry: DB "Entry not found: ", 0

%endif ; __FIND_ENTRY_ASM__