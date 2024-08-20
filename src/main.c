#include <stddef.h>
#include <stdint.h>
#include "uart.h"
#include "io.h"
#include "utils.h"
#include "interrupt.h"
#include "irq.h"
#include "timer.h"

void kernel_main(uint64_t dtb_ptr32, uint64_t x1, uint64_t x2, uint64_t x3)
{
	// initialize UART for Raspi2
	uart_init(3);
	printf("Hel%co, %s World!\n", 'l', "kernel");
	printf("Current EL:%d\n", get_el());

	irq_vector_init();
	timer_init();
	enable_interrupt_controller();
	enable_irq();

	while (1)
		uart_putc(uart_getc());
}
