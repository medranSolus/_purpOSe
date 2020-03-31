/**
 * @file cursor.h
 * @author Marek Machliński
 * @brief Header containig cursor modification methods.
 * @version 0.0.1_a
 * @date 31-03-2020
 * 
 * @copyright Copyright (c) 2020
 * 
 */
#ifndef __CURSOR_H__
#define __CURSOR_H__
#include <stdint.h>

#if defined(__cplusplus)
extern "C" {
#endif

/**
 * @brief Get the cursor position relative
 *        to begining of the screen.
 * 
 * @return uint16_t: Cursor offset.
 */
extern uint16_t get_cursor_position();
/**
 * @brief Set cursor position.
 * 
 * @param x: Column.
 * @param y: Row.
 */
extern void set_cursor(uint16_t x, uint16_t y);
/**
 * @brief Set the cursor position based on offset
 *        from the begining of the screen.
 * 
 * @param offset: Offset relative to screen start.
 */
extern void set_cursor_fixed(uint16_t offset);

#if defined(__cplusplus)
} // extern "C"
#endif

#endif // __CURSOR_H__