SECTION .text
GLOBAL read8:FUNCTION (read8.end - read8)
; Get 8 bit data from port
; IN: port number [16b]
; OUT: data [8b]
read8:
    mov dx, [esp + 8]
    in al, dx
    ret
.end: