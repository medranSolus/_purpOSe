[BITS 32]

SECTION .text
GLOBAL read8:FUNCTION (read8.end - read8)
; Get 8 bit data from port
; IN: Port number [16b]
; OUT: Data [8b]
; USES: DX
read8:
    mov dx, [esp + 4]
    in al, dx
    ret
.end: