[BITS 32]

SECTION .text
GLOBAL write32:FUNCTION (write32.end - write32)
; Write 32 bit data to port
; IN: Port number [16b], Data to write [32b]
; OUT: Void
; USES: EAX, DX
write32:
    mov dx, [esp + 4]
    mov eax, [esp + 8]
    out dx, eax
    ret
.end: