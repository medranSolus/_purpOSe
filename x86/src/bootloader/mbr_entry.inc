; File: mbr_entry.inc
; Author: Marek Machliński
; Brief: Description of entry in MBR partition table.
;
; Copyright (c) 2020
;
%ifndef __MBR_ENTRY_INC__
%define __MBR_ENTRY_INC__

STRUC MbrEntry
    .status:         RESB 1
    .start_cylinder: RESB 1
    .start_head:     RESB 1
    .start_sector:   RESB 1
    .type:           RESB 1
    .last_cylinder:  RESB 1
    .last_head:      RESB 1
    .last_sector:    RESB 1
    .start_lba:      RESB 4
    .last_lba:       RESB 4
ENDSTRUC

%endif ; __MBR_ENTRY_INC__