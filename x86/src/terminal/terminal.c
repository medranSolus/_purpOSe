#include "terminal.h"
#include "output.h"
#include "libc/string.h"

size_t maxColumn = VGA_WIDTH;
size_t maxRow = VGA_HEIGHT + 25;
size_t beginRow = 0;
size_t currentRow = 0;
size_t currentColumn = 0;
uint8_t currentColor = 7;
uint16_t *terminalBuffer = NULL;
uint16_t *outputBuffer = (uint16_t *)0xB8000;

void initTerminal()
{
	currentRow = 0;
	currentColumn = 0;
	currentColor = getVgaColor(TColor_LightGrey, TColor_Black);
	outputBuffer = (uint16_t *)0xB8000;
	clearTerminal();
}

void setColor(uint8_t vgaColor)
{
	currentColor = vgaColor;
}
