#include "utils.h"
#include "output.h"

void panic(const char * msg)
{
    print(msg);
    asm("hlt");
}