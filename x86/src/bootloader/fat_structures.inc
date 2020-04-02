; File: fat_structures.inc
; Author: Marek Machliński
; Brief: FAT structures necessary to decode filesystem data.
;
; Copyright (c) 2020
;
%ifndef __FAT_STRUCTURES_INC__
%define __FAT_STRUCTURES_INC__

; Directory entry.
STRUC FatEntry
    .filename:      RESB 8
    .extension:     RESB 3
    .attrib:        RESB 1
    .reserved:      RESB 10
    .time:          RESB 2
    .date:          RESB 2
    .start_cluster: RESB 2
    .file_size:     RESB 4
    .SIZE:          RESB 0
ENDSTRUC

; Long File Name entry (each character is 2 byte long).
STRUC LfnEntry
    .index:    RESB 1
    .string1:  RESB 10 ; 5 chars
    .attrib:   RESB 1
    .reserved: RESB 1
    .checksum: RESB 1
    .string2:  RESB 12 ; 6 chars
    .zero:     RESB 2
    .string3:  RESB 4  ; 2 chars
    .SIZE:     RESB 0
ENDSTRUC

; Directory entry attributes.
DIR_ATTRIB:
    .READ_ONLY    EQU 0000_0001b
    .HIDDEN_FILE  EQU 0000_0010b
    .SYSTEM_FILE  EQU 0000_0100b
    .VOLUME_LABEL EQU 0000_1000b
    .SUB_DIR      EQU 0001_0000b
    .ARCHIVE      EQU 0010_0000b
    .LFN          EQU 0000_1111b

%endif ; __FAT_STRUCTURES_INC__