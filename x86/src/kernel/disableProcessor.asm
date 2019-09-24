[BITS 32]

SECTION .text
EXTERN __KERNEL_END
GLOBAL disableProcessor:FUNCTION (disableProcessor.end - disableProcessor)
; Disable current processor for further usage in system
; IN: Void
; OUT: Void
disableProcessor:
    cli
    hlt
    jmp disableProcessor
.end: