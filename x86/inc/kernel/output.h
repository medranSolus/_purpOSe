/**
 * @file output.h
 * @author Marek Machliński
 * @brief Basic ways to output data on screen.
 * @version 0.0.1_a
 * @date 31-03-2020
 * 
 * @copyright Copyright (c) 2020
 * 
 */
#ifndef __OUTPUT_H__
#define __OUTPUT_H__

#if defined(__cplusplus)
extern "C" {
#endif

/**
 * @brief Clear terminal screen.
 * 
 */
extern void clear_terminal();
/**
 * @brief Print null terminated string on screen.
 * 
 * @param string: Pointer to string. 
 */
extern void print(const char* string);
/**
 * @brief Print single character on screen.
 * 
 * @param c: ASCII code.
 */
extern void print_char(char c);

#if defined(__cplusplus)
} // extern "C"
#endif

#endif // __OUTPUT_H__