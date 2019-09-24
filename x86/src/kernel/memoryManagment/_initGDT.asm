[BITS 32]

SECTION .text
EXTERN disableProcessor
GLOBAL _initGDT:FUNCTION (_initGDT.end - _initGDT)
; Load GDT into GDTR
; IN: Void
; OUT: Void
; USES: EAX
_initGDT:
    sub esp, 8
    mov WORD [esp], GDT.SIZE
    mov DWORD [esp + 2], GDT
    lgdt [esp]
    jmp 0x08:.flushCS
    .flushCS:
    mov ax, 16
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    add esp, 8
    ret
.end:

SECTION .GDT
GLOBAL GDT.TSS0
ALIGN 8
GDT:                ; Max number of TSS: 64 (64 logical cores)
    .null: DQ 0x0
    .kernelCode:
        DW 0xFFFF   ; limit1
        DW 0x0      ; base1
        DB 0x0      ; base2
        DB SGMT_CODE | SGMT_EXECUTE_READ | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT    ; type_flags1
        DB 0xF | SGMT_32BIT_SEGMENT | SGMT_4K_BYTE_LIMIT                            ; limit2_flags2
        DB 0x0      ; base3
    .kernelData:
        DW 0xFFFF   ; limit1
        DW 0x0      ; base1
        DB 0x0      ; base2
        DB SGMT_READ_WRITE | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT  ; type_flags1
        DB 0xF | SGMT_32BIT_SEGMENT | SGMT_4K_BYTE_LIMIT            ; limit2_flags2
        DB 0x0      ; base3
    .userCode:
        DW 0xFFFF   ; limit1
        DW 0x0      ; base1
        DB 0x0      ; base2
        DB SGMT_CODE | SGMT_EXECUTE_READ | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT | SGMT_USER    ; type_flags1
        DB 0xF | SGMT_32BIT_SEGMENT | SGMT_4K_BYTE_LIMIT                                        ; limit2_flags2
        DB 0x0      ; base3
    .userData:
        DW 0xFFFF   ; limit1
        DW 0x0      ; base1
        DB 0x0      ; base2
        DB SGMT_READ_WRITE | SGMT_CODE_DATA_SEGMENT | SGMT_PRESENT | SGMT_USER  ; type_flags1
        DB 0xF | SGMT_32BIT_SEGMENT | SGMT_4K_BYTE_LIMIT                        ; limit2_flags2
        DB 0x0      ; base3
    .TSS0:
        DW 103  ; limit1
        DW 0x0  ; base1
        DB 0x0  ; base2
        DB SGMT_TSS | SGMT_PRESENT  ; type_flags1
        DB 0x0  ; limit2_flags2
        DB 0x0  ; base3
    .SIZE EQU (6 << 3) - 1

;------- SEGMENT TYPES --------
;   ------ All Segments -------
    SGMT_ACCESSED     EQU 0001b
;   ------ Data Segments ------
    SGMT_DATA         EQU 0
    SGMT_READ_ONLY    EQU 0
    SGMT_READ_WRITE   EQU 0010b
    SGMT_EXPAND_DOWN  EQU 0100b
;   ------ Code Segments ------
    SGMT_CODE         EQU 1000b
    SGMT_EXECUTE_ONLY EQU 0
    SGMT_EXECUTE_READ EQU 0010b
    SGMT_CONFORMING   EQU 0100b
;   ------ Task Segments ------
    SGMT_TSS          EQU 1001b
    SGMT_BUSY         EQU 0010b

;------------- SEGMENT FLAGS -------------
;   --------------- Group 12 -------------
    SGMT_CODE_DATA_SEGMENT  EQU 0001b << 4
    SGMT_SYSTEM_SEGMENT     EQU 0
    SGMT_USER               EQU 0110b << 4
    SGMT_KERNEL             EQU 0
    SGMT_PRESENT            EQU 1000b << 4
    SGMT_NOT_PRESENT        EQU 0
;   --------------- Group 20 -------------
    SGMT_64BIT_SEGMENT      EQU 0010b << 4
    SGMT_16BIT_SEGMENT      EQU 0
    SGMT_32BIT_SEGMENT      EQU 0100b << 4
    SGMT_BYTE_LIMIT         EQU 0
    SGMT_4K_BYTE_LIMIT      EQU 1000b << 4