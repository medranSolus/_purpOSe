[BITS 32]

SECTION .text
GLOBAL _write8:FUNCTION (_write8.end - _write8)
; Write 8 bit data to port
; IN: Port number [16b], Data to write [8b]
; OUT: Void
; USES: AL, DX
_write8:
    mov dx, [esp + 4]
    mov al, [esp + 8]
    out dx, al
    ret
.end: