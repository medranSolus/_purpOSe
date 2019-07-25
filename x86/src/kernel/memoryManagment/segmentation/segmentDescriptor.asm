; Structure to hold segment descriptors for GDT and LGDT
STRUC SegmentDescriptor
    .limit1: RESW 1
    .base1: RESW 1
    .base2: RESB 1
    .flags1: RESB 1
    .limit2_flags2: RESB 1
    .base3: RESB 1
ENDSTRUC