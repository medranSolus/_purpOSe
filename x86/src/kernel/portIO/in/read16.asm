[BITS 32]

SECTION .text
GLOBAL read16:FUNCTION (read16.end - read16)
; Get 16 bit data from port
; IN: Port number [16b]
; OUT: Data [16b]
; USES: DX
read16:
    mov dx, [esp + 4]
    in ax, dx
    ret
.end: