#ifndef __VGA_H__
#define __VGA_H__
#include <stddef.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

typedef enum VideoType
{ 
    VideoType_none = 0x00, 
    VideoType_color = 0x20, 
    VideoType_monochrome = 0x30 
} VideoType;

typedef enum TerminalColor
{
	TerminalColor_black = 0,
	TerminalColor_blue = 1,
	TerminalColor_green = 2,
	TerminalColor_cyan = 3,
	TerminalColor_red = 4,
	TerminalColor_magenta = 5,
	TerminalColor_brown = 6,
	TerminalColor_light_grey = 7,
	TerminalColor_dark_grey = 8,
	TerminalColor_light_blue = 9,
	TerminalColor_light_green = 10,
	TerminalColor_light_cyan = 11,
	TerminalColor_light_red = 12,
	TerminalColor_light_magenta = 13,
	TerminalColor_light_brown = 14,
	TerminalColor_white = 15,
} TerminalColor;

#endif // __VGA_H__