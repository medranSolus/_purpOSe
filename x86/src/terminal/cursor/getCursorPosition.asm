SECTION .text
GLOBAL getCursorPosition:FUNCTION (getCursorPosition.end - getCursorPosition)
; Get cursor position from begining of the screen
; IN: Void
; OUT: Cursor postion [32b]
getCursorPosition:
    pushfd
    mov eax, 0
    mov dx, 0x3d4
    mov al, 0x0f
    out dx, al
    mov dx, 0x3d5
    in al, dx
    movzx ecx, al
    mov dx, 0x3d4
    mov al, 0x0e
    out dx, al
    mov dx, 0x3d5
    in al, dx
    shl ax, 8
    or eax, ecx
    popfd
    ret
.end: