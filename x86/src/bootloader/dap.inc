; File: dap.inc
; Author: Marek Machliński
; Brief: Layout of Disk Address Packet structure. 2 byte aligment required.
;        For support check INT 0x13 AH=0x41 BX=0x55AA.
;
; Copyright (c) 2020
;
%ifndef __DAP_INC__
%define __DAP_INC__

STRUC DAP 
    .dap_size:       RESB 1
    .reserved:       RESB 1 ; Must be 0
    .sectors_count:  RESB 2 ; Max 127 on some BIOSes
    .buffer_offset:  RESB 2
    .buffer_smgt:    RESB 2
    .start_lba_low:  RESB 4
    .start_lba_high: RESB 4 ; Upper 16 bit of 48 bit LBA value
    .SIZE:           RESB 0
ENDSTRUC

%endif ; __DAP_INC__