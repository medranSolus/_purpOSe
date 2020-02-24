#include "terminal.h"
#include "output.h"
#include "libc/string.h"

uint16_t max_column = VGA_WIDTH;
uint16_t max_row = VGA_HEIGHT + 25;
uint16_t current_column = 0;
uint16_t current_row = 0;
uint8_t current_color = 7;
uint16_t* terminal_buffer = NULL;
uint16_t* output_buffer = (uint16_t *)0xB8000;

void init_terminal()
{
	current_row = 0;
	current_column = 0;
	current_color = get_vga_color(TerminalColor_light_grey, TerminalColor_black);
	output_buffer = (uint16_t *)0xB8000;
	clear_terminal();
}

uint8_t get_vga_color(TerminalColor sign, TerminalColor background)
{
	return (background << 4) | sign;
}

uint16_t get_vga_entry(unsigned char sign, uint8_t vga_color)
{
	return (vga_color << 8) | sign;
}

void set_color(uint8_t vga_color)
{
	current_color = vga_color;
}

void print_hex(uint64_t number, HexSize display_size)
{
	print("0x");
	int8_t i = (display_size << 3) - 4;
	if (!display_size)
	{
		i = 60;
		while (i > 4 && !(number >> (i - 4)))
			i -= 8;
	}
	for (char tmp; i >= 0; i -= 4)
	{
		tmp = (char)((number >> i) & 0xF);
		if (tmp < 10)
			print_char(tmp | 0x30);
		else
			print_char(tmp + 0x37);
	}
}
