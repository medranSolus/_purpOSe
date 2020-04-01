; File: crti.asm
; Author: Marek Machliński
; Brief: GCC standard library funtion headers for initialization and finalization.
;
; Copyright (c) 2020
;
[BITS 32]

SECTION .init
GLOBAL _init:FUNCTION
; GCC initialization function
_init:
    push ebp
    mov ebp, esp
    ; GCC insert crtbegin.o .init section here

SECTION .fini
GLOBAL _fini:FUNCTION
; GCC finalization function
_fini:
    push ebp
    mov ebp, esp
    ; GCC insert crtbegin.o .fini section here