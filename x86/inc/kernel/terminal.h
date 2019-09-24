#ifndef __TERMINAL_H__
#define __TERMINAL_H__
#include "VGA.h"
#include <stdint.h>

typedef enum HexSize
{
    HexSize_Fixed = 0,
    HexSize_8bit = 1,
    HexSize_16bit = 2,
    HexSize_32bit = 4,
    HexSize_64bit = 8
} HexSize;

extern uint8_t getVgaColor(enum TerminalColor sign, enum TerminalColor background);
extern uint16_t getVgaEntry(unsigned char sign, uint8_t vgaColor);
void initTerminal();
void setColor(uint8_t vgaColor);
void printHex(uint64_t number, HexSize displaySize);

#endif // __TERMINAL_H__