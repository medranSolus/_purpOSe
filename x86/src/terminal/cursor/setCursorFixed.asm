SECTION .text
GLOBAL setCursorFixed:FUNCTION (setCursorFixed.end - setCursorFixed)
; Sets cursor at the specified position from begining of the screen
; IN: position from begining [32b]
; OUT: Void
setCursorFixed:
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