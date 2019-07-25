SECTION .text
GLOBAL write32:FUNCTION (write32.end - write32)
; Write 32 bit data to port
; IN: port number [16b], data to write [32b]
; OUT: Void
write32:
    mov dx, [esp + 12]
    mov eax, [esp + 16]
    out dx, eax
    ret
.end: