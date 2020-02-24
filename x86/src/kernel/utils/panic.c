#include "utils.h"
#include "output.h"

__attribute__((noreturn))
void panic(const char * msg)
{
    print(msg);
    asm("hlt");
}