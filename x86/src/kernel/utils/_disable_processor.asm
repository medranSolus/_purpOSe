[BITS 32]

SECTION .text
EXTERN __KERNEL_END
GLOBAL _disable_processor:FUNCTION (_disable_processor.end - _disable_processor)
; Disable current processor for further usage in system
; IN: Void
; OUT: Void
_disable_processor:
    cli
    hlt
    jmp _disable_processor
.end: