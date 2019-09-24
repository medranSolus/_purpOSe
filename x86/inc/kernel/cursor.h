#ifndef __CURSOR_H__
#define __CURSOR_H__
#include <stdint.h>

extern uint16_t getCursorPosition();
extern void setCursor(uint16_t x, uint16_t y);
extern void setCursorFixed(uint16_t lengthFromBegining);

#endif // __CURSOR_H__