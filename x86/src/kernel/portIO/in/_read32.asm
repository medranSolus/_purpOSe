[BITS 32]

SECTION .text
GLOBAL _read32:FUNCTION (_read32.end - _read32)
; Get 32 bit data from port
; IN: Port number [16b]
; OUT: Data [32b]
; USES: DX
_read32:
    mov dx, [esp + 4]
    in eax, dx
    ret
.end: