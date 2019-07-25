;%include "segmentDescriptor.asm"
SECTION .text
GLOBAL _initSegments:FUNCTION (_initSegments.end - _initSegments)

_initSegments:
    sub esp, 8
    mov WORD [esp - 8], 6
    mov DWORD [esp - 6], GDT
    lgdt [esp - 8]
    add esp, 8
    ret
.end:

SECTION .GDT
GDT: TIMES 6 DQ 0