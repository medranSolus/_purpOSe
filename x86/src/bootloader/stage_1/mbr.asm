; File: mbr.asm
; Author: Marek Machliński
; Brief: Basic MBR with single partition.
;
; Copyright (c) 2020
;
[BITS 16]
[ORG 0x7A00]

BOOT_SECTOR EQU 0x7C00

_relocate:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ax, stack_top
    shr ax, 4
    mov ss, ax
    mov sp, STACK_SIZE  ; Stack just before partition table
    mov cx, 0x0080      ; Size of MBR in DWORD's
    mov si, BOOT_SECTOR ; Bootsector address
    mov di, $$          ; New address
    rep movsd
    jmp 0:_load_vbr

%include "print.asm"

_load_vbr:
    sti
    mov si, partition1
    mov cx, 4
    .check_bootable:
        cmp BYTE [si], 0x80
        jz short .boot_found
        inc BYTE [msg_boot_from.number]
        add si, ENTRY_SIZE
        loop .check_bootable
    mov si, msg_no_boot_partition
    jmp short _error
    .boot_found:
    push si
    mov si, msg_boot_from
    call _print
    pop si
    mov cx, 3
    mov dh, [si + 2]
    xor bx, bx
    mov es, bx
    mov bx, 0x7C00
    .read_disk:
        push cx
        mov ax, 0x0201
        mov ch, [si + 1]
        mov cl, [si + 3]
        int 0x13
        pop cx
        jnc short .vbr_loaded
        mov ah, 0
        int 0x13
        loop .read_disk
    mov si, msg_disk_error
    jmp short _error
    .vbr_loaded:
    jmp 0:BOOT_SECTOR

; Handle unrecoverable boot error
; IN: SI = Pointer to error message
; OUT: Void
_error:
    call _print
    .hang:
        cli
        hlt
        jmp short .hang

msg_boot_from:          DB "Booting from partition "
    .number:            DB "1...", 0x0D, 0x0A, 0
msg_no_boot_partition:  DB "No bootable partition!", 0
msg_disk_error:         DB "Error reading disk for selected VBR!", 0

ALIGN 16
stack_top:
    TIMES 440 - ($ - $$) DB 0  ; Stack
STACK_SIZE EQU $ - stack_top

signature:  DD 0x00000000
reserved:   DW 0x0000

partition1:
    .status:         DB 0x80    ; 0x80 bootable
    .start_cylinder: DB 0x00
    .start_head:     DB 0x00
    .start_sector:   DB 0x02
    .type:           DB 0x00
    .last_cylinder:  DB 0xFF
    .last_head:      DB 0xFF
    .last_sector:    DB 0xFF
    .start_lba:      DD 0x00000001
    .last_lba:       DD 0xFFFFFFFF

ENTRY_SIZE EQU $ - partition1

partition2:
    .status:         DB 0x00
    .start_cylinder: DB 0x00
    .start_head:     DB 0x00
    .start_sector:   DB 0x00
    .type:           DB 0x00
    .last_cylinder:  DB 0x00
    .last_head:      DB 0x00
    .last_sector:    DB 0x00
    .start_lba:      DD 0x00000000
    .last_lba:       DD 0x00000000

partition3:
    .status:         DB 0x00
    .start_cylinder: DB 0x00
    .start_head:     DB 0x00
    .start_sector:   DB 0x00
    .type:           DB 0x00
    .last_cylinder:  DB 0x00
    .last_head:      DB 0x00
    .last_sector:    DB 0x00
    .start_lba:      DD 0x00000000
    .last_lba:       DD 0x00000000

partition4:
    .status:         DB 0x00
    .start_cylinder: DB 0x00
    .start_head:     DB 0x00
    .start_sector:   DB 0x00
    .type:           DB 0x00
    .last_cylinder:  DB 0x00
    .last_head:      DB 0x00
    .last_sector:    DB 0x00
    .start_lba:      DD 0x00000000
    .last_lba:       DD 0x00000000

DW 0xAA55 ; Magic boot number