[BITS 32]

SECTION .text
GLOBAL read32:FUNCTION (read32.end - read32)
; Get 32 bit data from port
; IN: Port number [16b]
; OUT: Data [32b]
; USES: DX
read32:
    mov dx, [esp + 4]
    in eax, dx
    ret
.end: