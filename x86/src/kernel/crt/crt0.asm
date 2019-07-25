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
EXTERN kernel
GLOBAL _start:FUNCTION (_start.end - _start)

_start:
    mov esp, stack_top
    call _init
    call kernel
    cli
    .hang:
        hlt
        jmp .hang
.end:

SECTION .bss
ALIGN 16
stack_bottom:
RESB 8192
stack_top: 