

;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
Setup
			clr.w	R4			;clear all registers
			clr.w	R5			;^
			clr.w	R6			;^
			clr.w	R7			;^
			clr.w	R10			;^

			mov.w	#04, R4		;setup register value
			mov.w	#03, R5		;^
			mov.w	#10, R6		;^
			mov.w	#15, R10	;^

Addition
			add.w	R4, R7		;Add the content of registers
			add.w	R5, R7		;^
			add.w	R6, R7		;^

Subtraction
			sub.w	R10, R7 	;subtract content of R10 from R7

Store
			mov.w	R4, 	&0x0200;Store the content of all register used
			mov.w	R5, 	&0x0202;into memory including resuts in the
			mov.w	R6, 	&0x0204;order R4, R5, R6, R10, R7
			mov.w	R10,	&0x0206;^
			mov.w	R7,		&0x0208;^

Mainloop	jmp				Mainloop		;infinite loop



;-------------------------------------------------------------------------------

                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
