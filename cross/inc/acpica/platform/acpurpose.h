/**
 * @file acpurpose.h
 * @author Marek Machliński
 * @brief OS specific defines, etc. for _purpOSe.
 * @version 0.0.1_a
 * @date 01.04.2020
 * 
 * @copyright Copyright (c) 2020
 * 
 */
#ifndef __ACPURPOSE_H__
#define __ACPURPOSE_H__

#include "archconfig.h"


/* Common (in-kernel/user-space) ACPICA configuration */
#define ACPI_CACHE_T                ACPI_MEMORY_LIST
#define ACPI_USE_LOCAL_CACHE
#define ACPI_USE_DO_WHILE_0
#define ACPI_IGNORE_PACKAGE_RESOLUTION_ERRORS

#define ACPI_USE_SYSTEM_INTTYPES
#define ACPI_USE_GPE_POLLING

/* Kernel specific ACPICA configuration */

#ifdef CONFIG_ACPI_REDUCED_HARDWARE_ONLY
#define ACPI_REDUCED_HARDWARE 1
#endif

#ifdef CONFIG_ACPI_DEBUGGER
#define ACPI_DEBUGGER
#endif

#ifdef CONFIG_ACPI_DEBUG
#define ACPI_MUTEX_DEBUG
#endif

/* Host-dependent types and defines for in-kernel ACPICA */

#define ACPI_MACHINE_WIDTH          32
#define ACPI_CPU_FLAGS              unsigned long
#define ACPI_MUTEX_TYPE             UINT8

#define ACPI_STRUCT_INIT(field, value)  .field = value

#endif // __ACPURPOSE_H__