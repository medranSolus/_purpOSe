#ifndef _TERMINAL_H
#define _TERMINAL_H
#include "VGA.h"
#include <stdint.h>

extern uint8_t getVgaColor(enum TerminalColor sign, enum TerminalColor background);
extern uint16_t getVgaEntry(unsigned char sign, uint8_t vgaColor);
void initTerminal();
void setColor(uint8_t vgaColor);

#endif