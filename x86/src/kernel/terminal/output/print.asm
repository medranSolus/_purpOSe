[BITS 32]

SECTION .text
EXTERN print_char
GLOBAL print:FUNCTION (print.end - print)
; Display string that ends with NULL character
; IN: Address of string to display [32b]
; OUT: Void
; USES: EAX
print:
    pushfd
    push esi
    mov esi, [esp + 12]
    .loop:
        mov al, [esi]
        test al, al
        jz short .quit
        push eax
        call print_char
        pop eax
        inc esi
        jmp short .loop
    .quit:
    pop esi
    popfd
    ret
.end: