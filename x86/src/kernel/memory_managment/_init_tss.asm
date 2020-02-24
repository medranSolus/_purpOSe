[BITS 32]

SECTION .text
GLOBAL _init_tss:FUNCTION (_init_tss.end - _init_tss)
; Load TSS for current processor
; IN: DX = Current processor number (MUST BE LOWER THAN PROCESSOR_COUNT AND MAX_PROCESSORS!!!)
; OUT: Void
; USES:
_init_tss:
    pushfd
    shl dx, 3
    add dx, 0x28
    ltr dx
    popfd
    ret
.end: