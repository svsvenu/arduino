;************************************
; serial.asm
;************************************

.nolist
.include "./m328Pdef.inc"
.list


.cseg

;
; Set up the Interrupt Vector at 0x0000
;
; We only use 1 interrupt in this program, the RESET
; interrupt.
;

.org 0x0000
	jmp reset		; PC = 0x0000	RESET


;======================
; initialization

.org 0x0034
reset: 
	clr	r1			; set the SREG to 0
	out	SREG, r1

	ldi	r28, LOW(RAMEND)	; init the stack pointer to point to RAMEND
	ldi	r29, HIGH(RAMEND)
	out	SPL, r28
	out	SPH, r29

	rcall	USART_Init		; initialize the serial communications
	sei				; enable global interrupts
	rjmp	main

;=======================
; Initialize the USART
;
USART_Init:
	; these values are for 9600 Baud with a 16MHz clock
	ldi	r16, 103
	clr	r17

	; Set baud rate
	sts	UBRR0H, r17
	sts	UBRR0L, r16

    ; Enable receiver and transmitter
	ldi	r16, (1<<RXEN0)|(1<<TXEN0)
	sts	UCSR0A, r16

	; Enable receiver and transmitter
	ldi	r16, (1<<RXEN0)|(1<<TXEN0)
	sts	UCSR0B, r16

	; Set frame format: Async, no parity, 8 data bits, 1 stop bit
	ldi	r16, 0b00001110
	sts	UCSR0C, r16
	ret

;=======================
; send a byte over the serial wire
; byte to send is in r19

USART_Transmit:
	; wait for empty transmit buffer
	lds	r16, UCSR0A
	sbrs	r16, UDRE0
	rjmp	USART_Transmit

	; Put data (r19) into buffer, sends the data
	sts	UDR0, r17
	ret
    
USART_Receive:
	lds	r16,UCSR0A			; load UCSR0A into r16
	sbrs	r16,RXC0			; wait for empty transmit buffer
	rjmp	USART_Receive				; repeat loop

	lds	r17, UDR0		; get received character
    rcall	USART_Transmit


	ret

 
delay: 
    ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1

;======================
; Main body of program:

main:
    
loop:
	rcall	USART_Receive		; send the character in r19 to the USART

	rcall delay 
	rjmp	loop			; else go back and to reset the value in r19
