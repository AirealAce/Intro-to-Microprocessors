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
LAB3
		mov.w #5, R4 ;Load "a" into R4
CLEAR
		clr R5 	;clear the entire register
 		clr R6 	;clear the entire register
 		clr R7	;clear the entire register

XCALC
		clr 	R10 	;R10=j=0, the initial index variable
 		clr		R14		;Summation accumulator
		tst		R4		;Check if a is negative
		jn	ABSL		;Find abosolute value
		mov.w R4, R9	;We're using R9 from now on
		jmp SUMM		;Otherwise, compute  summation

ABSL	;Find |a|
		mov.w	R4, R15		;"R4 maintains a"
		mov.w	#0xFFFF, R9	;Prepare to not
		sub.w	R15, R9 	;Not (R15)
		inc.w	R9			;Add 1 to get |a|

SUMM	;Adds term to summation
 		mov.w R10, R11 		;Leave j (index) untouched during computations
		call	#FACT		;Find the Factorial
		add.w	R12, R12	;This is 2(j!)
MARK	add.w	R12, R14	;Add summation term into the summation. Should be 308 when done
RWEDONE	;Checks if summation is complete
		inc.w	R10		;Initial index +1
		cmp.w	R10, R9		;Is j = |a|? Is summation done? |a| >= j?
		jge		SUMM		;If not, continue
		mov.w	R14, R5		;R5 = X = Summation
		call		#FCALC	;Now we can solve for F

ML	jmp		ML	;F & X have been computed, infiniteloop.

FACT	;Find factorial of j
		 cmp.w	#0, R11	;Check if R11 (j) is 0
		 jnz 	PREP	;Otherwise compute R11! (j!)
		 mov.w	#1, R12	; 0! = 1
DONE	 ret			;FACT has been found
PREP	;FACT not found, needa compute it
		mov.w	R11, R12	;R11 = j, R12 will be j!
		mov.w	R11, R13	;Prepare multiplicant/ier
CHECK	;Checks if next item of FACT is 1 or 0 so computation ends.
		dec.w	R13			;^ (Definition of ! )
		cmp.w	#2, R13		;Check if >=1 so factorial ends
		jge		COMPUTEIT	;If not >=1, then computation commences
		jmp		DONE		;If >=1,then factorial has been found
COMPUTEIT	;Computes an item of the factorial
		mov.w	R13, R5		;Prepare multiplier
		mov.w	R12, R6		;Prepare multiplcand
		call #MULT			;Multiply
		mov.w R6, R12		;Result is/part of factorial
		jmp		CHECK		;Check next multiplier

FCALC	;Calculate F
		mov.w	#4, R6 	;Prepair multiplicand
	 	call #MULT 		;Multiply 4*X
 		mov.w R6, R7	;R7 is now 4x	(4D0)
 		add.w  	#40, R7	;4X + 40
 		rrc.w	R7		;Divide by 2
 		ret				;Done


; your lab3 code is here between double dashed lines
; below is the

MULT
			push.w	R5;
			push.w	R7;
			push.w 	R8;
			mov.w	#16, R8		;16 bit multiplication, so we loop 8 times
			clr.w	R7			;additive accumulator should start with zero
;			and.w	#0x00FF, R5	;clear upper 8 bits of mltiplier
;			and.w 	#0x00FF, R6	;clear upper 8 bits of multipliant

nextbit
			rrc.w	R5			;shift multiplier bits one at a time to the carry
			jnc		twice		;if no carry skip the add
addmore		add.w	R6, R7		;add a copy of the multiplicand to the accumulator
twice		add.w	R6, R6		;multiplicand times 2, (shifted 1 bit left)
			dec.w 	R8			;dec loop counter
			jnz		nextbit		;jump to check next bit of the multiplier
			mov.w 	R7, R6		;save the result in R6

			pop.w	R8;
			pop.w	R7;
			pop.w 	R5;

MULTend		ret

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
            
