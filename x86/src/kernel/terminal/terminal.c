#include "terminal.h"
#include "output.h"
#include "libc/string.h"

uint16_t maxColumn = VGA_WIDTH;
uint16_t maxRow = VGA_HEIGHT + 25;
uint16_t beginRow = 0;
uint16_t currentRow = 0;
uint16_t currentColumn = 0;
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

void printHex(uint64_t number, HexSize displaySize)
{
	print("0x");
	int8_t i = (displaySize << 3) - 4;
	if (!displaySize)
	{
		i = 60;
		while (i > 4 && !(number >> (i - 4)))
			i -= 8;
	}
	for (char tmp; i >= 0; i -= 4)
	{
		tmp = (char)((number >> i) & 0xF);
		if (tmp < 10)
			printChar(tmp | 0x30);
		else
			printChar(tmp + 0x37);
	}
}
