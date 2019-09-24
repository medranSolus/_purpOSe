[BITS 32]

SECTION .text
GLOBAL getCursorPosition:FUNCTION (getCursorPosition.end - getCursorPosition)
; Get cursor position from begining of the screen
; IN: Void
; OUT: Cursor postion [16b]
; USES: CL, DX
getCursorPosition:
    pushfd
    xor ax, ax
    mov dx, 0x3d4
    mov al, 0x0f
    out dx, al
    mov dx, 0x3d5
    in al, dx
    mov cl, al
    mov dx, 0x3d4
    mov al, 0x0e
    out dx, al
    mov dx, 0x3d5
    in al, dx
    shl ax, 8
    or al, cl
    popfd
    ret
.end: