[BITS 32]

SECTION .text
GLOBAL _initTSS:FUNCTION (_initTSS.end - _initTSS)
; Load TSS for current processor
; IN: DX = Current processor number (MUST BE LOWER THAN PROCESSOR_COUNT AND MAX_PROCESSORS!!!)
; OUT: Void
; USES:
_initTSS:
    pushfd
    shl dx, 3
    add dx, 0x28
    ltr dx
    popfd
    ret
.end: