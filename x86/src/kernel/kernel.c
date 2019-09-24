#include "VGA.h"
#include "terminal.h"
#include "output.h"

static inline enum VideoType getBiosVideoType() { return (enum VideoType)(*((uint16_t*)0x410) & 0x30); }

extern int __KERNEL_END;

void kernel()
{
    const char * welcome = "Kernel 0.0.1 alpha started\n_purpOSe is fully running ";
	const char * prompt = "\nA:\\>";
	const char * kend = "\nKernel end = ";
	char * mode = NULL;
	switch (getBiosVideoType())
	{
		case VideoType_Monochrome:
		{
			mode = "in monochrome mode.";
			break;
		}
		case VideoType_Colour:
		{
			mode = "in colour mode.";
			break;
		}
		case VideoType_None:
		{
			mode = "without screen.";
			break;
		}
		default:
		{
			mode = "in unknown mode.";
			break;
		}
	}
	initTerminal();
	print(welcome);
	print(mode);
	print(kend);
	printHex(&__KERNEL_END, HexSize_Fixed);
	print(prompt);
	return;
}