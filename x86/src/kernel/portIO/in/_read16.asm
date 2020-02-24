[BITS 32]

SECTION .text
GLOBAL _read16:FUNCTION (_read16.end - _read16)
; Get 16 bit data from port
; IN: Port number [16b]
; OUT: Data [16b]
; USES: DX
_read16:
    mov dx, [esp + 4]
    in ax, dx
    ret
.end: