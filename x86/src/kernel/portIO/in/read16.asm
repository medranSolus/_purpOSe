SECTION .text
GLOBAL read16:FUNCTION (read16.end - read16)
; Get 16 bit data from port
; IN: port number [16b]
; OUT: data [16b]
read16:
    mov dx, [esp + 8]
    in ax, dx
    ret
.end: