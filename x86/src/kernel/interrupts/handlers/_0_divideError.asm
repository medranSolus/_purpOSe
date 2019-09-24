[BITS 32]

SECTION .text
EXTERN panic
GLOBAL _0_divideError:FUNCTION (_0_divideError.end - _0_divideError)
_0_divideError:
    push error
    call panic
    iret
.end:

SECTION .data
error: DB 0xA, "Chuju, dzielisz przez zero!", 0xA, "Kernel panic i tyle w temacie.", 0xA, 0