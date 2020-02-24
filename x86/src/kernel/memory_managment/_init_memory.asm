[BITS 32]

SECTION .text
EXTERN _init_gdt
EXTERN _load_all_tss
EXTERN _init_tss
GLOBAL _init_memory:FUNCTION (_init_memory.end - _init_memory)
; Initialize memory managment structures
; IN: DX = Current processor number (MUST BE LOWER THAN CURRENT PROCESSORS COUNT AND MAX_PROCESSORS!!!)
; OUT: Void
; USES:
_init_memory:
    call _init_gdt
    call _load_all_tss
    call _init_tss
    ret
.end: