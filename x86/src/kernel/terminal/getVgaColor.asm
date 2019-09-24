[BITS 32]

SECTION .text
GLOBAL getVgaColor:FUNCTION (getVgaColor.end - getVgaColor)
; Combines sign and background colors into VGA specific color
; IN: Sign color [TerminalColor], Background color [TerminalColor]
; OUT: VGA color [8b]
getVgaColor:
    pushfd
    mov ah, [esp + 12]
    shl ah, 4
    mov al, [esp + 8]
    and al, 0xF
    add al, ah
    popfd
    ret
.end: