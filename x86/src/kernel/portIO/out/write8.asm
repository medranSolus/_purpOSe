SECTION .text
GLOBAL write8:FUNCTION (write8.end - write8)
; Write 8 bit data to port
; IN: port number [16b], data to write [8b]
; OUT: Void
write8:
    mov dx, [esp + 12]
    mov al, [esp + 16]
    out dx, al
    ret
.end: