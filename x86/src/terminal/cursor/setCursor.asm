SECTION .data
EXTERN maxColumn

SECTION .text
EXTERN setCursorFixed
GLOBAL setCursor:FUNCTION (setCursor.end - setCursor)
; Sets cursor at the specified position in notation (x,y) [column,line]
; IN: x [16b], y [16b]
; OUT: Void
setCursor:
    pushfd
	mov bx, [esp + 12]
	mov eax, [maxColumn]
	mul bx
	add eax, [esp + 8]
	push eax
    call setCursorFixed
	pop eax
	popfd
	ret
.end: