[BITS 32]

SECTION .text
GLOBAL _read8:FUNCTION (_read8.end - _read8)
; Get 8 bit data from port
; IN: Port number [16b]
; OUT: Data [8b]
; USES: DX
_read8:
    mov dx, [esp + 4]
    in al, dx
    ret
.end: