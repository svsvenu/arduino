	.include "m328pdef.inc"

	.equ	numB 	= 20		; number of bytes in array

	.def	tmp	= r16		   ; define temp register
	.def	loopCt	= r17		; define loop count register

	.dseg
	.org	SRAM_START
sArr:	.BYTE	numB			; allocate bytes in SRAM for array
mArr:   .BYTE   numB

	.cseg

.org 0xAA
main:
  sbi 0x04, 5       ; PORTB5 output
loop:               ; main loop begin
  sbi 0x05, 5       ; PORTB5 high
  call delay_1000ms ; delay 1s
  cbi 0x05, 5       ; 5 PORTB5 low
  call delay_1000ms ; delay 1s
  rjmp  loop        ; main loop

delay_1000ms:       ; subroutine for 1s delay
                    ; initialize counters
  ldi r18, 0xFF     ; 255
  ldi r24, 0xD3     ; 211
  ldi r25, 0x30     ; 48
inner_loop:
  subi  r18, 0x01   ; 1
  sbci  r24, 0x00   ; 0
  sbci  r25, 0x00   ; 0
  	ldi	r16,'a'				; load char 'a' into r16

  
  putc:	lds	r17,UCSR0A			; load UCSR0A into r17
	sbrs	r17,UDRE0			; wait for empty transmit buffer
	rjmp	putc				; repeat loop

	sts	UDR0,r16			; transmit character

  
  brne  inner_loop
  ret
    .dseg
    .org 0x135
nArr:   .BYTE   numB
