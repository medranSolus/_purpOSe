[BITS 32]

SECTION .data
EXTERN outputBuffer, currentColor

SECTION .text
EXTERN setCursorFixed, getCursorPosition
GLOBAL printChar:FUNCTION (printChar.end - printChar)
; Display single character on screen and move cursor
; IN: Character to display [8b]
; OUT: Void
; USES: EAX, ECX, EDX
printChar:
    pushfd
    call getCursorPosition
    and eax, 0xffff
    mov cl, [esp + 8]
    cmp cl, 10
    je short .newLine
    cmp cl, 8
    je short .backspace
    mov edx, [outputBuffer]
    shl ax, 1
    mov [eax + edx], cl
    mov cl, [currentColor]
    mov [eax + edx + 1], cl
    shr ax, 1
    inc ax
    jmp short .quit
    .backspace:
        dec ax
        shl ax, 1
        mov [eax + edx], BYTE ' '
        mov cl, [currentColor]
        mov [eax + edx + 1], cl
        shr ax, 1
        jmp short .quit
    .newLine:
        mov cx, ax
        mov dl, 80
        div dl
        movzx ax, ah
        sub cx, ax
        mov ax, cx
        add ax, 80
    .quit:
    push eax
    call setCursorFixed
    pop eax
    popfd
    ret
.end: