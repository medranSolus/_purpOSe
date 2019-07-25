SECTION .text
GLOBAL getVgaColor:FUNCTION (getVgaColor.end - getVgaColor)
; Combines sign and background colors into VGA specific color
; IN: sign color [TerminalColor], background color [TerminalColor]
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