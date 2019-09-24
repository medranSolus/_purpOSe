[BITS 32]

SECTION .text
GLOBAL _8_doubleFault:FUNCTION (_8_doubleFault.end - _8_doubleFault)
_8_doubleFault:
    iret
.end:
