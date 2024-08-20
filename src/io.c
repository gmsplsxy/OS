#include "io.h"
#include "uart.h"

#include <stdarg.h>
#include <stdbool.h>

char* itoa(int n)
{
	static char buf[16];
	int i = 16;
	bool is_neg = (n < 0);
	buf[--i] = '\0';

	if(is_neg)
		n *= -1;

	if(n == 0)
		buf[--i] = 0x30;

	while(n != 0) {
		buf[--i] = (n % 10) + 0x30;
		n /= 10;
	}

	if(is_neg)
		buf[--i] = '-';

	return &buf[i];
}

int printf(const char* fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	
	for(int i = 0; fmt[i] != '\0'; i++) {
		if(fmt[i] == '%') {
			switch(fmt[++i]) {
				case 'd':
					uart_puts(itoa(va_arg(args, int)));
					break;
				case 's':
					uart_puts(va_arg(args, char*));
					break;
				case 'c':
					uart_putc((char)va_arg(args, int));
					break;
			}
		}
		else {
			uart_putc(fmt[i]);
		}
	}

	va_end(args);
}
