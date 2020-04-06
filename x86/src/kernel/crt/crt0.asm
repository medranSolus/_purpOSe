[BITS 32]

SECTION .text
EXTERN _init
EXTERN _init_memory
EXTERN _init_idt
EXTERN _disable_processor
EXTERN print
EXTERN kernel
GLOBAL _start:FUNCTION (_start.end - _start)

_start:
    cli
    mov esp, stack_top
    call _init
    call _init_memory
    call _init_idt
    sti
    call kernel
    call _disable_processor
.end:

SECTION .data
KEND: DB 0xA, "No i koniec", 0xA, 0x0

SECTION .bss
ALIGN 16
stack_bottom:
RESB 8192
stack_top: 