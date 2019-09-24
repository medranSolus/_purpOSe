[BITS 32]

SECTION .text
GLOBAL _10_invalidTSS:FUNCTION (_10_invalidTSS.end - _10_invalidTSS)
_10_invalidTSS:
    iret
.end:
