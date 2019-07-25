#ifndef _VGA_H
#define _VGA_H
#include <stddef.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

enum VideoType 
{ 
    VideoType_None = 0x00, 
    VideoType_Colour = 0x20, 
    VideoType_Monochrome = 0x30 
};

enum TerminalColor 
{
	TColor_Black = 0,
	TColor_Blue = 1,
	TColor_Green = 2,
	TColor_Cyan = 3,
	TColor_Red = 4,
	TColor_Magenta = 5,
	TColor_Brown = 6,
	TColor_LightGrey = 7,
	TColor_DarkGrey = 8,
	TColor_LightBlue = 9,
	TColor_LightGreen = 10,
	TColor_LightCyan = 11,
	TColor_LightRed = 12,
	TColor_LightMagenta = 13,
	TColor_LightBrown = 14,
	TColor_White = 15,
};

#endif