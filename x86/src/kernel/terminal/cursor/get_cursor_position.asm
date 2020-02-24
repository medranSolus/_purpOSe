[BITS 32]

SECTION .text
GLOBAL get_cursor_position:FUNCTION (get_cursor_position.end - get_cursor_position)
; Get cursor position from begining of the screen
; IN: Void
; OUT: Cursor postion [16b]
; USES: CL, DX
get_cursor_position:
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