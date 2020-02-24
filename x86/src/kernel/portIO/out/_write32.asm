[BITS 32]

SECTION .text
GLOBAL _write32:FUNCTION (_write32.end - _write32)
; Write 32 bit data to port
; IN: Port number [16b], Data to write [32b]
; OUT: Void
; USES: EAX, DX
_write32:
    mov dx, [esp + 4]
    mov eax, [esp + 8]
    out dx, eax
    ret
.end: