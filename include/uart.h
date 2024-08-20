#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>

// Memory-Mapped I/O output
void mmio_write(uint32_t reg, uint32_t data);
// Memory-Mapped I/O input
uint32_t mmio_read(uint32_t reg);
// The MMIO area base address, depends on board type
void mmio_init(int raspi);

void uart_init(int raspi);
void uart_putc(unsigned char c);
unsigned char uart_getc();
void uart_puts(const char* str);

#endif //__UART_H__
