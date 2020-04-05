; File: setup_gdt.asm
; Author: Marek Machliński
; Brief: Setup minimal GDT.
;
; Copyright (c) 2020
;
%ifndef __SETUP_GDT_ASM__
%define __SETUP_GDT_ASM__
[BITS 16]

; IN: Void
; OUT: Void
; USES: BP
_setup_gdt:
    mov bp, sp
    sub bp, 8
    mov WORD [ss:bp], GDT.SIZE
    mov DWORD [ss:bp + 2], GDT
    cli
    lgdt [ss:bp]
    sti
    ret

ALIGN 8
GDT:
    .null: DQ 0x0
    .code32:
        DW 0xFFFF ; limit1
        DW 0x00   ; base1
        DB 0x00   ; base2
        DB SGMT_CODE | SGMT_EXECUTE_READ | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT ; type_flags1
        DB 0x0F | SGMT_32BIT_SEGMENT | SGMT_4K_BYTE_LIMIT                        ; limit2_flags2
        DB 0x00   ; base3
    .data32:
        DW 0xFFFF ; limit1
        DW 0x00   ; base1
        DB 0x00   ; base2
        DB SGMT_READ_WRITE | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT ; type_flags1
        DB 0x0F | SGMT_32BIT_SEGMENT | SGMT_4K_BYTE_LIMIT          ; limit2_flags2
        DB 0x00   ; base3
    .code16:
        DW 0xFFFF ; limit1
        DW 0x00   ; base1
        DB 0x00   ; base2
        DB SGMT_CODE | SGMT_EXECUTE_READ | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT ; type_flags1
        DB 0x0F   ; limit2_flags2
        DB 0x00   ; base3
    .data16:
        DW 0xFFFF ; limit1
        DW 0x00   ; base1
        DB 0x00   ; base2
        DB SGMT_READ_WRITE | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT ; type_flags1
        DB 0x0F   ; limit2_flags2
        DB 0x00   ; base3
    .SIZE EQU ($ - GDT) - 1


;------- SEGMENT TYPES --------
;   ------ Data Segments ------
    SGMT_READ_WRITE   EQU 0010b
;   ------ Code Segments ------
    SGMT_CODE         EQU 1000b
    SGMT_EXECUTE_READ EQU 0010b

;------------ SEGMENT FLAGS -------------
;   -------------- Group 12 -------------
    SGMT_CODE_DATA_SEGMENT EQU 0001b << 4
    SGMT_PRESENT           EQU 1000b << 4
;   -------------- Group 20 -------------
    SGMT_32BIT_SEGMENT     EQU 0100b << 4
    SGMT_4K_BYTE_LIMIT     EQU 1000b << 4

%endif ; __SETUP_GDT_ASM__