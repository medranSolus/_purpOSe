/**
 * @file utils.h
 * @author Marek Machliński
 * @brief Header with utility functions.
 * @version 0.0.1_a
 * @date 01.04.2020
 * 
 * @copyright Copyright (c) 2020
 * 
 */
#ifndef __UTILS_H__
#define __UTILS_H__
#include <stdint.h>

#if defined(__cplusplus)
extern "C" {
#endif

#define MAX_PROCESSORS 1

/**
 * @brief Number of processors on current machine.
 * 
 */
extern uint32_t PROCESSOR_COUNT;

/**
 * @brief Panic function, when everything else failed...
 * 
 */
void panic(const char* msg) __attribute__ ((noreturn));
/**
 * @brief Exclude current processor from further execution.
 * 
 */
extern void _disable_processor();

#if defined(__cplusplus)
} // extern "C"
#endif

#endif // __UTILS_H__