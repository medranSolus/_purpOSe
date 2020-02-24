[BITS 32]
%include "sysVars.inc"
EXTERN GDT.TSS0

SECTION .text
GLOBAL _loadAllTSS:FUNCTION (_loadAllTSS.end - _loadAllTSS)
; Load TSS pointers to GDT descriptors
; IN: Void
; OUT: Void
; USES: EAX, ECX
_loadAllTSS:
    pushfd
    push esi
    push edi
    mov esi, TSS0
    mov edi, GDT.TSS0
    mov ecx, [PROCESSOR_COUNT]
    .loadTSS:
        mov eax, esi
        mov [edi + 2], ax
        shr eax, 16
        mov [edi + 4], al
        mov [edi + 7], ah
        add esi, TSS_SIZE
        add edi, 8
        loop .loadTSS
    pop edi
    pop esi
    popfd
    ret
.end:

SECTION .TSS
TSS_SIZE EQU 104
TSS0:
    .link:   DW 0x0, 0x0
    .ESP0:   DD 0x0
    .SS0:    DW 0x0, 0x0
    .ESP1:   DD 0x0
    .SS1:    DW 0x0, 0x0
    .ESP2:   DD 0x0
    .SS2:    DW 0x0, 0x0
    .CR3:    DD 0x0
    .EIP:    DD 0x0
    .EFLAGS: DD 0x0
    .EAX:    DD 0x0
    .ECX:    DD 0x0
    .EDX:    DD 0x0
    .EBX:    DD 0x0
    .ESP:    DD 0x0
    .EBP:    DD 0x0
    .ESI:    DD 0x0
    .EDI:    DD 0x0
    .ES:     DW 0x0, 0x0
    .CS:     DW 0x0, 0x0
    .SS:     DW 0x0, 0x0
    .DS:     DW 0x0, 0x0
    .FS:     DW 0x0, 0x0
    .GS:     DW 0x0, 0x0
    .LDT:    DW 0x0, 0x0
    .debugT: DW 0x0
    .IOaddr: DW 0x0