SECTION .text
EXTERN printChar
GLOBAL print:FUNCTION (print.end - print)
; Display string that ends with NULL character
; IN: address of string to display [32b]
; OUT: Void
print:
    pushfd
    push esi
    mov esi, [esp + 12]
    .loop:
        mov al, [esi]
        test al, al
        jz short .quit
        push eax
        call printChar
        pop eax
        inc esi
        jmp short .loop
    .quit:
    pop esi
    popfd
    ret
.end: