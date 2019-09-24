#include "sysUtils.h"
#include "kernel/output.h"

__attribute__((noreturn))
void panic(const char * msg)
{
    print(msg);
    asm("hlt");
}