; File: elf.inc
; Author: Marek Machliński
; Brief: ELF structures description.
;
; Copyright (c) 2020
;
%ifndef __ELF_INC__
%define __ELF_INC__

; ELF32 file header.
STRUC Elf32Header
    .magic_number:              RESB 4
    .bit_format:                RESB 1
    .endianness:                RESB 1
    .header_version:            RESB 1 ; Should be 1
    .abi:                       RESB 1 ; 0 for System V
    .padding:                   RESB 8
    .file_type:                 RESB 2
    .arch_type:                 RESB 2
    .elf_version:               RESB 4
    .program_entry:             RESB 4
    .program_header_table:      RESB 4 ; 0 if none
    .section_header_table:      RESB 4 ; 0 if none
    .flags:                     RESB 4
    .header_size:               RESB 2
    .program_header_entry_size: RESB 2
    .program_header_entries:    RESB 2
    .section_header_entry_size: RESB 2
    .section_header_entries:    RESB 2
    .section_names_index:       RESB 2
    .SIZE:                      RESB 0
ENDSTRUC

; ELF constants.
ELF_BIT_FORMAT:
    .BIT_32 EQU 1
    .BIT_64 EQU 2

ELF_ENDIAN:
    .LITTLE EQU 1
    .BIG    EQU 2

ELF_FILE_TYPE:
    .RELOCATABLE EQU 1
    .EXECUTABLE  EQU 2
    .SHARED      EQU 3
    .CORE        EQU 4

ELF_ARCH:
    .NO_SPECYFIC EQU 0x00
    .SPARC       EQU 0x02
    .X86         EQU 0x03
    .MIPS        EQU 0x08
    .POWER_PC    EQU 0x14
    .ARM         EQU 0x28
    .SUPER_H     EQU 0x2A
    .IA_64       EQU 0x32
    .X64         EQU 0x3E
    .A_ARCH_64   EQU 0xB7

ELF_MAGIC_NUMBER EQU 0x464C457F

; ELF32 program header entry.
STRUC Elf32ProgramEntry
    .segment_type:      RESB 4
    .file_offset:       RESB 4
    .virtual_addr:      RESB 4
    .undefined:         RESB 4
    .segment_file_size: RESB 4
    .segment_mem_size:  RESB 4
    .flags:             RESB 4
    .aligment:          RESB 4 ; Must be power of 2
    .SIZE: RESB 0
ENDSTRUC

ELF_SEGMENT:
    .NULL    EQU 0 ; Ignore entry
    .LOAD    EQU 1 ; Clear mem_size bytes at virtual_addr to 0, then copy file_size bytes from file_offset to virtual_addr
    .DYNAMIC EQU 2 ; Dynamic linking required
    .INTERP  EQU 3 ; Contains a file path to an executable to use as an interpreter for the following segment
    .NOTE    EQU 4 ; Arch/env specyfic info

ELF_SEGMENT_FLAGS:
    .EXEC  EQU 1
    .WRITE EQU 2
    .READ  EQU 4

%endif ; __ELF_INC__