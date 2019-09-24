[BITS 32]

SECTION .init
    ; GCC insert crtend.o .init section here
    pop ebp
    ret

SECTION .fini
    ; GCC insert crtend.o .fini section here
    pop ebp
    ret