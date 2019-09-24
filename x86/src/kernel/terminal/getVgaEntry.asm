[BITS 32]

SECTION .text
GLOBAL getVgaEntry:FUNCTION (getVgaEntry.end - getVgaEntry)
; Combines sign and it's color for entry in VGA table
; IN: Sign [8b], VGA color [8b]
; OUT: VGA sign with color [16b]
getVgaEntry:
    mov ah, [esp + 8]
    mov al, [esp + 4]
    ret
.end: