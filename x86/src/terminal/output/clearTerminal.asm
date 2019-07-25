SECTION .data
EXTERN outputBuffer, currentColor

SECTION .text
EXTERN setCursorFixed
GLOBAL clearTerminal:FUNCTION (clearTerminal.end - clearTerminal)
; Clears screen and move cursor at beginig position
; IN: Void
; OUT: Void
clearTerminal:
    pushfd
    push edi
    push 0
    call setCursorFixed
    pop edi
    mov eax, [outputBuffer]
    mov cl, [currentColor]
    .loop:
        cmp edi, 2000
        jae short .quit
        mov [eax + edi], BYTE ' '
        mov [eax + edi + 1], cl
        add edi, 2
        jmp short .loop
    .quit:
    pop edi
    popfd
    ret
.end: