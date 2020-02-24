#ifndef __CURSOR_H__
#define __CURSOR_H__
#include <stdint.h>

extern uint16_t get_cursor_position();
extern void set_cursor(uint16_t x, uint16_t y);
extern void set_cursor_fixed(uint16_t offset);

#endif // __CURSOR_H__