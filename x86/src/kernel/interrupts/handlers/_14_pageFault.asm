[BITS 32]

SECTION .text
GLOBAL _14_pageFault:FUNCTION (_14_pageFault.end - _14_pageFault)
_14_pageFault:
    iret
.end:
