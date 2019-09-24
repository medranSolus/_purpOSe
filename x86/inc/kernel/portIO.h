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
 * 
 * @param port  Port number
 * @param data  Byte data
 */
extern void write8(uint16_t port, uint8_t data);
/**
 * @brief       Write 2 bytes to port
 * 
 * @param port  Port number
 * @param data  2 byte data
 */
extern void write16(uint16_t port, uint16_t data);
/**
 * @brief       Write 4 bytes to port
 * 
 * @param port  Port number
 * @param data  4 byte data
 */
extern void write32(uint16_t port, uint32_t data);

/**
 * @brief           Read byte from port
 * 
 * @param port      Port number
 * @return uint8_t  Byte data from port
 */
extern uint8_t read8(uint16_t port);
/**
 * @brief           Read 2 bytes from port
 * 
 * @param port      Port number
 * @return uint8_t  2 bytes data from port
 */
extern uint16_t read16(uint16_t port);
/**
 * @brief           Read 4 bytes from port
 * 
 * @param port      Port number
 * @return uint8_t  4 bytes data from port
 */
extern uint32_t read32(uint16_t port);

#endif // __PORTIO_H__