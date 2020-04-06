OUTPUT_FORMAT(elf32-i386)
ENTRY(_start)
SECTIONS
{
    . = 0x100000;
    .text ALIGN (0x1000) :
    {
        *(.init)
        *(.text)
        *(.fini)
        *(.rodata)
    }
    .data ALIGN (0x1000) :
    {
        *(.IDT)
        *(.GDT)
        *(.sysVars)
        *(.data)
    }
    .bss ALIGN (0x1000) :
    {
        *(.bss)
    }
    __KERNEL_END = .;
}