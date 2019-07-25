SECTION .text
GLOBAL write16:FUNCTION (write16.end - write16)
; Write 16 bit data to port
; IN: port number [16b], data to write [16b]
; OUT: Void
write16:
    mov dx, [esp + 12]
    mov ax, [esp + 16]
    out dx, ax
    ret
.end: