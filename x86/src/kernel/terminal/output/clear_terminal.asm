[BITS 32]

SECTION .data
EXTERN output_buffer, current_color

SECTION .text
EXTERN set_cursor_fixed
GLOBAL clear_terminal:FUNCTION (clear_terminal.end - clear_terminal)
; Clears screen and move cursor at beginig position
; IN: Void
; OUT: Void
; USES: EAX, CL
clear_terminal:
    pushfd
    push edi
    push 0
    call set_cursor_fixed
    pop edi
    mov eax, [output_buffer]
    mov cl, [current_color]
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