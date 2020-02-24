[BITS 32]

MODULES_ALIGN EQU 1 << 0
MEMORY_INFO EQU 1 << 1
FLAGS EQU MODULES_ALIGN | MEMORY_INFO
MAGIC_NUMBER EQU 0x1BADB002
CHECKSUM EQU -(MAGIC_NUMBER + FLAGS)

SECTION .multiboot
ALIGN 4
DD MAGIC_NUMBER
DD FLAGS
DD CHECKSUM

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