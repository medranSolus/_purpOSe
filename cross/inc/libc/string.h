/**
 * @file string.h
 * @author Marek Machliński
 * @brief Standard library header.
 * @version 0.0.1_a
 * @date 22.07.2019
 * 
 * @copyright Copyright (c) 2019
 * 
 */
#ifndef __STRING_H__
#define __STRING_H__
#include <stddef.h>
#include <stdint.h>

#if defined(__cplusplus)
extern "C" {
#endif

/**
 * @brief Get length of a string without null char.
 * 
 * @param str: Pointer to null-terminated C string.
 * @return size_t: Length of a null-terminated string.
 */
extern size_t strlen(const char* str);

#if defined(__cplusplus)
} // extern "C"
#endif

#endif // __STRING_H__