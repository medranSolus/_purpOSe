OUTPUT_FORMAT(elf32-i386)
ENTRY(_start)
SECTIONS
{
    . = 0x100000;
    .multiboot :
    {
        *(.multiboot)
    }
    .init :
    {
        *(.init)
    }
    .text :
    { 
        *(.text)
    }
    .rodata :
    { 
        *(.rodata)
    }
    .data :
    { 
        *(.data)
    }
    .bss :
    { 
        *(.bss)
    }
    .fini :
    {
        *(.fini)
    }
}