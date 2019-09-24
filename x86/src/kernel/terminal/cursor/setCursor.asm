[BITS 32]

SECTION .data
EXTERN maxColumn

SECTION .text
EXTERN setCursorFixed
GLOBAL setCursor:FUNCTION (setCursor.end - setCursor)
; Sets cursor at the specified position in notation (x,y) [column,line]
; IN: x [16b], y [16b]
; OUT: Void
; USES: EAX, ECX
setCursor:
    pushfd
	mov cx, [esp + 12]
	mov ax, [maxColumn]
	mul cx
	add ax, [esp + 8]
	push eax
    call setCursorFixed
	pop eax
	popfd
	ret
.end: