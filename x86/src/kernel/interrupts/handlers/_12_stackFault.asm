[BITS 32]

SECTION .text
GLOBAL _12_stackFault:FUNCTION (_12_stackFault.end - _12_stackFault)
_12_stackFault:
    iret
.end:
