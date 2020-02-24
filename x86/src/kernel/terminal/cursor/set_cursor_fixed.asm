[BITS 32]

SECTION .text
GLOBAL set_cursor_fixed:FUNCTION (set_cursor_fixed.end - set_cursor_fixed)
; Sets cursor at the specified position from begining of the screen
; IN: Position from begining [16b]
; OUT: Void
; USES: AX, DX
set_cursor_fixed:
	pushfd
	mov al, 0x0f
	mov dx, 0x3d4
	out dx, al 
	mov ax, [esp + 8]
	mov dx, 0x3d5
	out dx, al 
	mov al, 0xe
	mov dx, 0x3d4
	out dx, al
	mov ax, [esp + 8]
	shr ax, 8
	mov dx, 0x3d5
	out dx, al
    popfd
	ret
.end: