[BITS 32]

SECTION .text
GLOBAL _write16:FUNCTION (_write16.end - _write16)
; Write 16 bit data to port
; IN: Port number [16b], Data to write [16b]
; OUT: Void
; USES: AX, DX
_write16:
    mov dx, [esp + 4]
    mov ax, [esp + 8]
    out dx, ax
    ret
.end: