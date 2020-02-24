[BITS 32]

SECTION .data
EXTERN output_buffer, current_color

SECTION .text
EXTERN set_cursor_fixed, get_cursor_position
GLOBAL print_char:FUNCTION (print_char.end - print_char)
; Display single character on screen and move cursor
; IN: Character to display [8b]
; OUT: Void
; USES: EAX, ECX, EDX
print_char:
    pushfd
    call get_cursor_position
    and eax, 0xffff
    mov cl, [esp + 8]
    cmp cl, 10
    je short .newLine
    cmp cl, 8
    je short .backspace
    mov edx, [output_buffer]
    shl ax, 1
    mov [eax + edx], cl
    mov cl, [current_color]
    mov [eax + edx + 1], cl
    shr ax, 1
    inc ax
    jmp short .quit
    .backspace:
        dec ax
        shl ax, 1
        mov [eax + edx], BYTE ' '
        mov cl, [current_color]
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
    call set_cursor_fixed
    pop eax
    popfd
    ret
.end: