#ifndef __UTILS_H__
#define __UTILS_H__
#include <stdint.h>

#define MAX_PROCESSORS 1

extern uint32_t PROCESSOR_COUNT;

void panic(const char * msg) __attribute__ ((noreturn));
extern void _disable_processor();

#endif // __UTILS_H__