SECTION .text
GLOBAL read32:FUNCTION (read32.end - read32)
; Get 32 bit data from port
; IN: port number [16b]
; OUT: data [32b]
read32:
    mov dx, [esp + 8]
    in eax, dx
    ret
.end: