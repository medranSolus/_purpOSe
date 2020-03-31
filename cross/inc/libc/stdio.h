/**
 * @file stdio.h
 * @author Marek Machliński
 * @brief Standard library header.
 * @version 0.0.1_a
 * @date 22-07-2019
 * 
 * @copyright Copyright (c) 2019
 * 
 */
#ifndef __STDIO_H__
#define __STDIO_H__

#if defined(__cplusplus)
extern "C" {
#endif

/**
 * @brief Print formatted data to stdout.
 * 
 * @param format: Formating C string to be written to stdout.
 * @param ...: Additional params to be inserted into formating string.
 * @return int: Number of char written or -1 on error (sets ferror).
 */
extern int printf(const char* format, ...);

#if defined(__cplusplus)
} // extern "C"
#endif

#endif // __STDIO_H__