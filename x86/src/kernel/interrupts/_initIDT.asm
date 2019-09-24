[BITS 32]

SECTION .text
%include "./x86/src/kernel/interrupts/intHandlers.s"
GLOBAL _initIDT:FUNCTION (_initIDT.end - _initIDT)
; Initialize IDT
; IN: Void
; OUT: Void
; USES: EAX, ECX
_initIDT:
    pushfd
    push _0_divideError
    push _1_debugException
    push _2_nmi
    push _3_breakpoint
    push _4_overflow
    push _5_boundRange
    push _6_invalidOpcode
    push _7_noFPU
    push _8_doubleFault
    push _9_coprocSegmentOverrun
    push _10_invalidTSS
    push _11_segmentNotPresent
    push _12_stackFault
    push _13_generalProtection
    push _14_pageFault
    push _16_fpuError
    push _17_aligmentCheck
    push _18_machineCheck
    push _19_simdException
    push _20_virtualizationException
    mov ecx, 20
    .fillUpper:
        pop eax
        mov [IDT + ecx * 8], ax
        shr eax, 16
        mov [IDT + ecx * 8 + 6], ax
        dec ecx
        cmp cl, 15
        jnz .fillUpper
    dec ecx
    .fillLower:
        pop eax
        mov [IDT + ecx * 8], ax
        shr eax, 16
        mov [IDT + ecx * 8 + 6], ax
        dec ecx
        cmp cl, 0xFF
        jnz .fillLower
    sub esp, 8
    mov WORD [esp], IDT.SIZE
    mov DWORD [esp + 2], IDT
    lidt [esp]
    add esp, 8
    popfd
    ret
.end:

SECTION .IDT
INT_GATE  EQU 10001110b   ; IF cleared
TRAP_GATE EQU 10001111b   ; IF unchanged

ALIGN 8
IDT:                            ;       |  NAME |  TYPE | ERROR
    .divideError:               ;   0   |  #DE  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .debugException:            ;   1   |  #DB  |Flt/Trp|   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB TRAP_GATE     ; type
        DW 0x0          ; offset2
    .nmi:                       ;   2   | ----- |  Int  |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .breakpoint:                ;   3   |  #BP  |  Trap |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB TRAP_GATE     ; type
        DW 0x0          ; offset2
    .overflow:                  ;   4   |  #OF  |  Trap |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .boundRange:                ;   5   |  #BR  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .invalidOpcode:             ;   6   |  #UD  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .noFPU:                     ;   7   |  #NM  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .doubleFault:               ;   8   |  #DF  | Abort |  Zero
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .coprocSegmentOverrun:      ;   9   |       | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .invalidTSS:                ;   10  |  #TS  | Fault |   Yes
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .segmentNotPresent:         ;   11  |  #NP  | Fault |   Yes
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .stackFault:                ;   12  |  #SS  | Fault |   Yes
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .generalProtection:         ;   13  |  #GP  | Fault |   Yes
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .pageFault:                 ;   14  |  #PF  | Fault |   Yes
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .reserved15:                ;   15  | ----- |       |   No
        DQ 0x00000F0000080000
    .fpuError:                  ;   16  |  #MF  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .aligmentCheck:             ;   17  |  #AC  | Fault |  Zero
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .machineCheck:              ;   18  |  #MC  | Abort |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .simdException:             ;   19  |  #XM  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .virtualizationException:   ;   20  |  #VE  | Fault |   No
        DW 0x0          ; offset1
        DW 0x8          ; segment selector
        DB 0x0          ; 0 and reserved
        DB INT_GATE     ; type
        DW 0x0          ; offset2
    .reserved21_31:             ; ----- | ----- | ----- | -----
    .SIZE EQU (21 << 3) - 1
