[BITS 32]

SECTION .text
GLOBAL _1_debugException:FUNCTION (_1_debugException.end - _1_debugException)
_1_debugException:
    hlt
    iret
.end:
