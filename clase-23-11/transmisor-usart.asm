 ;#include "m328Pdef.inc"
 #include "m88PAdef.inc"

.def	temp0	=	r16
.def	temp1	=	r17
.def	data	=	r18

　
　
RCALL	USART_INIT

MAIN:

LDI	data,0x3F

RCALL	USART_TRANSMIT

　
/*LOOP:
	LDI	temp0,0xFF
	OUT	DDRB,temp0
	OUT	PORTB,temp0
	RJMP LOOP*/

RJMP	MAIN

　
　
USART_INIT:
   ; Set baud rate to UBRR0
   LDI		temp0,0x00
   STS		UBRR0H, temp0
   LDI		temp0,119
   STS		UBRR0L, temp0
   ; Enable receiver and transmitter
   LDI		temp0, (1<<RXEN0)|(1<<TXEN0)
   STS		UCSR0B,temp0
   ; Set frame format: 8data, 2stop bit
   LDI    temp0, (1<<USBS0)|(3<<UCSZ00)
   STS    UCSR0C,temp0
   RET

USART_TRANSMIT:
; El buffer de transmisión solo puede ser escrito cuando el flag UDRE0 (in UCSR0A) esta en estado alto.
LDS		temp0, UCSR0A
SBRS	temp0, UDRE0
RJMP	USART_TRANSMIT
; El dato se coloca en UDR0 y es cargado en el Transmit Shift Register cuando este esté vacio. Luego es transmitido en serie al pin TxD0.
STS		UDR0,data
RET

　
