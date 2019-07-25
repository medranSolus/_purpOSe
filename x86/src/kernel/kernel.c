#include "terminal/VGA.h"
#include "terminal/terminal.h"
#include "terminal/output.h"

static inline enum VideoType getBiosVideoType() { return (enum VideoType)(*((uint16_t*)0x410) & 0x30); }

void kernel()
{
    const char * welcome = "Kernel 0.0.1 alpha started\n_purpOSe is fully running ";
	char * mode = NULL;
	switch (getBiosVideoType())
	{
		case VideoType_Monochrome:
		{
			mode = "in monochrome mode.\nA:\\>";
			break;
		}
		case VideoType_Colour:
		{
			mode = "in colour mode.\nA:\\>";
			break;
		}
		case VideoType_None:
		{
			mode = "without screen.\nA:\\>";
			break;
		}
		default:
		{
			mode = "in unknown mode.\nA:\\>";
			break;
		}
	}
	initTerminal();
	print(welcome);
	print(mode);
	return;
}