#ifndef __TERMINAL_H__
#define __TERMINAL_H__
#include "vga.h"
#include <stdint.h>

typedef enum HexSize
{
    HexSize_fixed = 0,
    HexSize_8bit = 1,
    HexSize_16bit = 2,
    HexSize_32bit = 4,
    HexSize_64bit = 8
} HexSize;

void init_terminal();
/**
 * @brief Combines sign and background colors into VGA specific color
 */
uint8_t get_vga_color(TerminalColor sign, TerminalColor background);
/**
 * @brief Combines sign and it's color for entry in VGA table
 */
uint16_t get_vga_entry(unsigned char sign, uint8_t vga_color);
void set_color(uint8_t vga_color);
void print_hex(uint64_t number, HexSize display_size);

#endif // __TERMINAL_H__