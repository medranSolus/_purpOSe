/**
 * @file portIO.h
 * @author Marek Machliński (marekin450@spoko.pl)
 * @brief 
 * @version 0.0.1
 * @date 2019-07-22
 * 
 * @copyright Copyright (c) 2019
 * 
 */
#ifndef __PORTIO_H__
#define __PORTIO_H__
#include <stdint.h>

/**
 * @brief       Write byte to port
 */
extern void _write8(uint16_t port, uint8_t data);
/**
 * @brief       Write 2 bytes to port
 */
extern void _write16(uint16_t port, uint16_t data);
/**
 * @brief       Write 4 bytes to port
 */
extern void _write32(uint16_t port, uint32_t data);

/**
 * @brief           Read byte from port
 */
extern uint8_t _read8(uint16_t port);
/**
 * @brief           Read 2 bytes from port
 */
extern uint16_t _read16(uint16_t port);
/**
 * @brief           Read 4 bytes from port
 */
extern uint32_t _read32(uint16_t port);

#endif // __PORTIO_H__