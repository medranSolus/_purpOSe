[BITS 32]

SECTION .data
EXTERN max_column

SECTION .text
EXTERN set_cursor_fixed
GLOBAL set_cursor:FUNCTION (set_cursor.end - set_cursor)
; Sets cursor at the specified position in notation (x,y) [column,line]
; IN: x [16b], y [16b]
; OUT: Void
; USES: EAX, ECX
set_cursor:
    pushfd
	mov cx, [esp + 12]
	mov ax, [max_column]
	mul cx
	add ax, [esp + 8]
	push eax
    call set_cursor_fixed
	pop eax
	popfd
	ret
.end: