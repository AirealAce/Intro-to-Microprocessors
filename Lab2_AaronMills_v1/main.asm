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
;Memory allocation of Arrays must be done before the RESET and Stop WDT
ARY1 	.set 0x0200 ;Memory allocation ARY1		.set basically declares an array
ARY1S 	.set 0x0210 ;Memory allocation ARYS		by assigning memory locations to it.
ARY2 	.set 0x0220 ;Memory allocation ARY2
ARY2S 	.set 0x0230 ;Memory allocation AR2S

 	clr R4 ;clearing all register being use is a good
 	clr R5 ;programming practice
 	clr R6

SORT1
	mov.w	#ARY1, R4 	;initialize R4 as a pointer to array1			<-R4 takes the value of the constant in ARY1
 	mov.w	#ARY1S, R6 	;initialize R6 as a pointer to array1 sorted
 	call	#ArraySetup1;then call subroutine ArraySetup1				<-Refer to/use that label
 	call	#COPY		;Copy elements from ARY1 to ARY1S space			<-Refer to/use COPY label
 	call	#SORT		;Sort elements in ARAY1							<-Rever to/Use SORT label

SORT2 ;<-^Repeat everything but for ARY2
	mov.w	#ARY2, R4	;initialize R4 as a pointer to array2
 	mov.w	#ARY2S, R6	;initialize R4 as a pointer to array2 sorted
 	call	#ArraySetup2;then call subroutine ArraySetup2
 	call	#COPY		;Copy elements from ARY2 to ARY2S space
 	call	#SORT 		;Sort elements in ARAY2

Mainloop jmp Mainloop;Infinite Loop

ArraySetup1
	mov.b #10,	0(R4)	;Array element initialization Subroutine
 	mov.b #33,	1(R4)	;First start with the number of elements
 	mov.b #-91, 2(R4)	;and then fill in the 10 elements.
 	mov.b #-75, 3(R4)	;<-index mode (3 units after @R4)
	mov.b #82, 4(R4)	;<-index mode (4 units after @R4)
	mov.b #11, 5(R4)	;<-index mode (5 units after @R4)
	mov.b #-28, 6(R4)	;<-index mode (6 units after @R4)
	mov.b #-99, 7(R4)	;<-index mode (7 units after @R4)
 	mov.b #31, 8(R4)	;<-index mode (8 units after @R4)
 	mov.b #-92, 9(R4)	;<-index mode (9 units after @R4)
 	mov.b #80, 10(R4)	;<-index mode (10 units after @R4)

	ret

ArraySetup2	;<-^Same thing for ARY2
	mov.b #10,	0(R4)	;Similar to ArraySetup1 subroutine
 	mov.b #21,	1(R4)	;
 	mov.b #22, 2(R4)	;
 	mov.b #20, 3(R4)	;<-index mode (3 units after @R4)
	mov.b #-49, 4(R4)	;<-index mode (4 units after @R4)
	mov.b #-80, 5(R4)	;<-index mode (5 units after @R4)
	mov.b #32, 6(R4)	;<-index mode (6 units after @R4)
	mov.b #62, 7(R4)	;<-index mode (7 units after @R4)
 	mov.b #60, 8(R4)	;<-index mode (8 units after @R4)
 	mov.b #61, 9(R4)	;<-index mode (9 units after @R4)
 	mov.b #-82, 10(R4)	;<-index mode (10 units after @R4)
 	ret

COPY	;Copy original Array to allocated Array-
 	mov.b 0(R4),R10		;Save the array size somewhere
 	inc.w	R10			;Counter: accounts for "ARY size" element
	mov.w 	R4, R5		;R5 points to ARY, so R4 is unaltered
	mov.w R6, R11		;Store pointer value for later use...

CLoop	;Begin loop for copying
		mov.b  @R5+, 0(R11) ;Begin copying, prepare next copy src
		inc.w	R11			;Prepare next copy dst
		dec	R10				;Count down the counter
 		jnz 	CLoop		;Dont exit 'til no more elements to copy
 	ret ;Sorted space

SORT ;Subroutine SORT sorts array
	mov.w	R6, R11		;Point back to begining of ARY
	inc.w	R11			;Point to first element of ARYIS
	mov.w	R11, R12	;Copy of that pointer for later use
	mov.b 0(R4), R10	;Reset counter
	dec		R10			;Counter: there r 1 less arrangements then there r elements

ReScan
	mov.w	R12,	R11		;Store pointer somewhere so that R6 is left unaltered
	mov.b	R10, R9		;Additional counter for later usage

Compare ;Compare each element
		mov.b @R11+, R7			;Move element to R7
		mov.b @R11, R8			;Move next element to R8
		cmp.b	R8, R7			;Compare values
		jl	LeaveAlone			;Lleave the order alone
								;Otherwise, Switch the larger value with the smaller value for ordering

Arrange	;Arrange each element
	mov.b	R7, 0(R11)			;Switch R7 w R8's place in the ARY so larger value is after smaller
	mov.b	R8, -1(R11)			;Switch R8 w R7's place in ARY^

LeaveAlone
	dec		R9					;
	jnz		Compare				;
								;otherwise
	dec R10						;
	jnz		ReScan				;
	ret ;lowest to highest value
;----- Your Sorting lab ends here -------------------------------------------
;-------------------------------------------------------------------------------
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
            
