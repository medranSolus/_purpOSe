/**
 * @file stdio.h
 * @author Marek Machliński
 * @brief 
 * @version 0.0.1
 * @date 2019-07-22
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
 * @brief           Print formatted data to stdout.
 * 
 * @param format:   Formating C string to be written to stdout.
 * @param ...:      Additional params to be inserted into formating string.
 * @return int:     Number of char written or -1 on error (sets ferror).
 */
extern int printf(const char * format, ...);

#if defined(__cplusplus)
} /* extern "C" */
#endif

#endif // __STDIO_H__