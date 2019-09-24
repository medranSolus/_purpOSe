[BITS 32]

SECTION .text
EXTERN _initGDT
EXTERN _loadAllTSS
EXTERN _initTSS
GLOBAL _initMemory:FUNCTION (_initMemory.end - _initMemory)
; Initialize memory managment structures
; IN: DX = Current processor number (MUST BE LOWER THAN CURRENT PROCESSORS COUNT AND MAX_PROCESSORS!!!)
; OUT: Void
; USES:
_initMemory:
    call _initGDT
    call _loadAllTSS
    call _initTSS
    ret
.end: