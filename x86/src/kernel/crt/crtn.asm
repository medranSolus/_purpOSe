; File: crtn.asm
; Author: Marek Machliński
; Brief: GCC standard library funtion bottoms for initialization and finalization.
;
; Copyright (c) 2020
;
[BITS 32]

SECTION .init
    ; GCC insert crtend.o .init section here
    pop ebp
    ret

SECTION .fini
    ; GCC insert crtend.o .fini section here
    pop ebp
    ret