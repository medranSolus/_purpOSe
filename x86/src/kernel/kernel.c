#include "vga.h"
#include "terminal.h"
#include "output.h"

static inline VideoType get_bios_video_type() { return (VideoType)(*((uint16_t*)0x410) & 0x30); }

extern int __KERNEL_END;

void kernel()
{
    const char * welcome = "Kernel 0.0.1 alpha started\n_purpOSe is fully running ";
	const char * prompt = "\nA:\\>";
	const char * kend = "\nKernel end = ";
	char * mode = NULL;
	switch (get_bios_video_type())
	{
		case VideoType_monochrome:
		{
			mode = "in monochrome mode.";
			break;
		}
		case VideoType_color:
		{
			mode = "in color mode.";
			break;
		}
		case VideoType_none:
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
	init_terminal();
	print(welcome);
	print(mode);
	print(kend);
	print_hex((uint32_t)&__KERNEL_END, HexSize_fixed);
	print(prompt);
	return;
}