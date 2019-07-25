/**
 * @file string.h
 * @author Marek Machliński
 * @brief 
 * @version 0.0.1
 * @date 2019-07-22
 * 
 * @copyright Copyright (c) 2019
 * 
 */
#ifndef _STRING_H
#define _STRING_H
#include <stddef.h>

#if defined(__cplusplus)
extern "C" {
#endif

/**
 * @brief           Get length of a string without null char.
 * 
 * @param str       Pointer to null-terminated C string.
 * @return size_t   Length of a null-terminated string.
 */
extern size_t strlen(const char* str);

#if defined(__cplusplus)
} /* extern "C" */
#endif

#endif