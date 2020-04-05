; File: nmi.asm
; Author: Marek Machliński
; Brief: Functions to disable and enable NMI.
;
; Copyright (c) 2020
;
%ifndef __NMI_ASM__
%define __NMI_ASM__
[BITS 16]

; IN: Void
; OUT: Void
; USES: AL
_enable_nmi:
    in al, 0x70
    and al, 0x7F
    out 0x70, al
    ret

; IN: Void
; OUT: Void
; USES: AL
_disable_nmi:
    in al, 0x70
    or al, 0x80
    out 0x70, al
    ret

%endif ; __NMI_ASM__