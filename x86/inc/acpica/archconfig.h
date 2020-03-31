/**
 * @file archconfig.h
 * @author Marek Machliński
 * @brief ACPICA configuration header for x86 architecture.
 * @version 0.0.1_a
 * @date 31-03-2020
 * 
 * @copyright Copyright (c) 2020
 * 
 */
#ifndef __ARCHCONFIG_H__
#define __ARCHCONFIG_H__

#include <stdint.h>

#define CONFIG_ACPI_DEBUGGER
#define ACPI_MACHINE_WIDTH 32
#define COMPILER_DEPENDENT_UINT64 uint64_t
#define COMPILER_DEPENDENT_INT64 int64_t

typedef uint8_t                         BOOLEAN;
typedef uint8_t                         UINT8;
typedef int8_t                          INT8;
typedef uint16_t                        UINT16;
typedef int16_t                         INT16;
typedef uint32_t                        UINT32;
typedef int32_t                         INT32;
typedef COMPILER_DEPENDENT_UINT64       UINT64;
typedef COMPILER_DEPENDENT_INT64        INT64;

#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
    __asm__("divl %4" \
            : "=d"(r32), "=a"(q32) \
            : "d"(n_hi), "a"(n_lo), "q"(d32) \
            : "cc");

#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
    __asm__("shrl $1, %%edx \t\n" \
            "rcrl $1, %%eax" \
            : "=d"(n_hi), "=a"(n_lo) \
            : "d"(n_hi), "a"(n_lo) \
            : "cc");
            
#endif // __ARCHCONFIG_H__