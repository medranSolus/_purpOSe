SECTION .data
EXTERN outputBuffer, currentColor

SECTION .text
EXTERN setCursorFixed, getCursorPosition
GLOBAL printChar:FUNCTION (printChar.end - printChar)
; Display single character on screen and move cursor
; IN: character to display [8b]
; OUT: Void
printChar:
    pushfd
    call getCursorPosition
    and eax, 0xffff
    mov cl, [esp + 8]
    cmp cl, 10
    je short .newLine
    cmp cl, 8
    je short .backspace
    mov edx, 0xb8000
    shl eax, 1
    mov [eax + edx], cl
    mov cl, [currentColor]
    mov [eax + edx + 1], cl
    shr eax, 1
    inc eax
    jmp short .quit
    .backspace:
        dec eax
        shl eax, 1
        mov [eax + edx], BYTE ' '
        mov cl, [currentColor]
        mov [eax + edx + 1], cl
        shr eax, 1
        jmp short .quit
    .newLine:
        mov ecx, eax
        mov dl, 80
        div dl
        movzx eax, ah
        sub ecx, eax
        mov eax, ecx
        add eax, 80
    .quit:
    push eax
    call setCursorFixed
    pop eax
    popfd
    ret
.end: