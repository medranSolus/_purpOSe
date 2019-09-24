[BITS 32]

SECTION .text
GLOBAL write16:FUNCTION (write16.end - write16)
; Write 16 bit data to port
; IN: Port number [16b], Data to write [16b]
; OUT: Void
; USES: AX, DX
write16:
    mov dx, [esp + 4]
    mov ax, [esp + 8]
    out dx, ax
    ret
.end: