; ============================================================
; CIS-11 Project B: Test Score Calculator
; Team: Avengers Assemble
; Members: David Zaragoza, Javier Martinez, Francisco Colorado
; Advisor: Kasey Nguyen, PhD
;
; Expected test output (scores: 52, 87, 96, 79, 61):
;   Min: 52  Grade: F
;   Max: 96  Grade: A
;   Avg: 75  Grade: C
;
; Strategy: each section owns its local data immediately after
; its code so all PC-relative offsets stay within +-256 words.
; ============================================================

        .ORIG   x3000

; ============================================================
; MAIN
; ============================================================
        LD      R6, MAIN_STACK_INIT	; Initialize welcome message

        LEA     R0, MAIN_MSG_WELCOME	; Load welcome message
        TRAP    x22			; Display welcome message

        LEA     R1, MAIN_SCORES		; R1 points to start of scores array	
        AND     R2, R2, #0		; Clear input counter
        ADD     R2, R2, #5		; Set counter to 5 

INPUT_LOOP
        LEA     R0, MAIN_MSG_ENTER	; Load score prompt text
        TRAP    x22			; Display prompt

        LD      R0, MAIN_PROMPT_IDX	; Load current score number
        LD      R3, MAIN_ASCII_ZERO
        ADD     R0, R0, R3		; Convert score number to ASCII
        TRAP    x21			; Display score number

        LEA     R0, MAIN_MSG_COLON	; Load colon seperator
        TRAP    x22			; Display ": "

        JSR     READ_NUMBER		; Read and convert user input to integer
	
	JSR 	VALIDATE_SCORE		; Check if score exceeds 100
	ADD	R3, R3, #0		; Update condition codes from validation result
	BRp	INVALID_INPUT		; Re-prompt user if score is invalid input

        STR     R0, R1, #0		; Store score in array
        ADD     R1, R1, #1		; Move to next array element
        ADD     R2, R2, #-1		; Decrement score counter

        LD      R0, MAIN_PROMPT_IDX	; Load current score number
        ADD     R0, R0, #1		; Increment score number
        ST      R0, MAIN_PROMPT_IDX	; Save updated score number

        LEA     R0, MAIN_MSG_NL		; Load newline character
        TRAP    x22			; Move to next line
	ADD	R2, R2, #0		; Update condition code using remaining count
        BRp     INPUT_LOOP		; Continue loop until 5 scores are entered

        JSR     FIND_MIN_MAX		; Determine min and max scores
        JSR     CALC_AVERAGE		; Compute score average
	
        ; Print Min
        LEA     R0, MAIN_MSG_MIN	; Load "Min: " message
        TRAP    x22			; Display min label
        ADD     R0, R3, #0		; Copy min score into R0 for printing
        ADD     R6, R6, #-1		
        STR     R3, R6, #0		; Save min score
        ADD     R6, R6, #-1
        STR     R4, R6, #0		; Save max score
        ADD     R6, R6, #-1
        STR     R5, R6, #0		; Save average score
        JSR     PRINT_NUMBER		; Display min score
        LDR     R5, R6, #0		; Restore average score
        ADD     R6, R6, #1
        LDR     R4, R6, #0		; Restore max score
        ADD     R6, R6, #1
        LDR     R3, R6, #0		; Restore min score
        ADD     R6, R6, #1
        LEA     R0, MAIN_MSG_GRADE	; Load "Grade: " label
        TRAP    x22			; Display grade label
        ADD     R0, R3, #0		; Pass min score to GET_GRADE
        ADD     R6, R6, #-1		; Save scores 
        STR     R3, R6, #0		
        ADD     R6, R6, #-1
        STR     R4, R6, #0		
        ADD     R6, R6, #-1
        STR     R5, R6, #0		
        JSR     GET_GRADE		; Convert score to letter grade
        LDR     R5, R6, #0		; Restore scores
        ADD     R6, R6, #1
        LDR     R4, R6, #0		
        ADD     R6, R6, #1
        LDR     R3, R6, #0		
        ADD     R6, R6, #1
        TRAP    x21			; Print letter grade returned by GET_GRADE
        LEA     R0, MAIN_MSG_NL		; Load newline
        TRAP    x22			; Move to next line

        ; Print Max
        LEA     R0, MAIN_MSG_MAX	; Load "Max: " message
        TRAP    x22			; Display max label
        ADD     R0, R4, #0		; Copy max score into R0 for printing
        ADD     R6, R6, #-1		; Save scores
        STR     R3, R6, #0		
        ADD     R6, R6, #-1
        STR     R4, R6, #0		
        ADD     R6, R6, #-1
        STR     R5, R6, #0		
        JSR     PRINT_NUMBER		; Display max score
        LDR     R5, R6, #0		; Restore scores
        ADD     R6, R6, #1
        LDR     R4, R6, #0		
        ADD     R6, R6, #1
        LDR     R3, R6, #0		
        ADD     R6, R6, #1
        LEA     R0, MAIN_MSG_GRADE	; Load "Grade: " label
        TRAP    x22			; Display grade label
        ADD     R0, R4, #0		; Pass max score to GET_GRADE
        ADD     R6, R6, #-1		; Save scores
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0
        ADD     R6, R6, #-1
        STR     R5, R6, #0
        JSR     GET_GRADE		; Convert score to letter grade
        LDR     R5, R6, #0		; Restore scores
        ADD     R6, R6, #1
        LDR     R4, R6, #0
        ADD     R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        TRAP    x21			; Print letter grade returned by GET_GRADE
        LEA     R0, MAIN_MSG_NL		; Load newline
        TRAP    x22			; Move to next line

        ; Print Avg
        LEA     R0, MAIN_MSG_AVG	; Load "Avg: " message
        TRAP    x22			; Display avg label
        ADD     R0, R5, #0		; Copy avg score into R0 for printing
        ADD     R6, R6, #-1		; Save scores
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0
        ADD     R6, R6, #-1
        STR     R5, R6, #0
        JSR     PRINT_NUMBER		; Display avg score
        LDR     R5, R6, #0		; Restore scores
        ADD     R6, R6, #1
        LDR     R4, R6, #0
        ADD     R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LEA     R0, MAIN_MSG_GRADE	; Load "Grade: " label
        TRAP    x22			; display grade label
        ADD     R0, R5, #0		; Pass avg score to GET_GRADE
        ADD     R6, R6, #-1		; Save scores
        STR     R3, R6, #0
        ADD     R6, R6, #-1
        STR     R4, R6, #0
        ADD     R6, R6, #-1
        STR     R5, R6, #0
        JSR     GET_GRADE		; Convert score to letter grade
        LDR     R5, R6, #0		; Restore scores
        ADD     R6, R6, #1
        LDR     R4, R6, #0
        ADD     R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        TRAP    x21			; Print letter grade returned by GET_GRADE
        LEA     R0, MAIN_MSG_NL		; Load newline
        TRAP    x22			; Move to next line

        TRAP    x25			; HALT


INVALID_INPUT
	LEA	R0, INVALID_MSG		; Load message notifying user of invalid input
	TRAP	x22			; Display error message
	BRnzp 	INPUT_LOOP		; Reloop back to ask for the score again

; --- Main local data ---
MAIN_SCORES         .BLKW   5
MAIN_PROMPT_IDX     .FILL   x0001
MAIN_STACK_INIT     .FILL   xFE00
MAIN_ASCII_ZERO     .FILL   x0030
MAIN_MSG_WELCOME    .STRINGZ "=== Test Score Calculator ===\n"
MAIN_MSG_ENTER      .STRINGZ "Enter score "
MAIN_MSG_COLON      .STRINGZ ": "
MAIN_MSG_NL         .STRINGZ "\n"
MAIN_MSG_MIN        .STRINGZ "Min: "
MAIN_MSG_MAX        .STRINGZ "Max: "
MAIN_MSG_AVG        .STRINGZ "Avg: "
MAIN_MSG_GRADE      .STRINGZ "  Grade: "
INVALID_MSG	.STRINGZ "Invalid Score. Please enter a value from 0 to 100.\n"

; ============================================================
; Subroutine: READ_NUMBER
;   Reads multi-digit decimal integer. Returns value in R0.
;   Saves/restores: R1, R2, R3, R7
;
;   Example:
;	Input: "89"
;	Output: 89 returned in R0
; ============================================================
READ_NUMBER
        ADD     R6, R6, #-1		; Save registers to stack
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0

        AND     R1, R1, #0		; Initialize accumulated number to 0

RN_LOOP
        TRAP    x23			; Read character from input
        TRAP    x21			; Display this character back to console

        LD      R3, RN_NEG_CR		
        ADD     R3, R0, R3		; Check if input character is ENTER (CR)
        BRz     RN_DONE			; Finish if ENTER pressed

        LD      R3, RN_NEG_LF
        ADD     R3, R0, R3		; Check for line feed character
        BRz     RN_DONE

        LD      R3, RN_NEG_ZERO
        ADD     R2, R0, R3		; Convert ASCII digit to integer value

        ADD     R3, R1, R1		; Multiply current number by 10 using repeated addition
        ADD     R3, R3, R3
        ADD     R3, R3, R3
        ADD     R3, R3, R1
        ADD     R3, R3, R1
        ADD     R1, R3, R2		; number = (number * 10) + new digit

        BRnzp   RN_LOOP			; Process next input character

RN_DONE
        ADD     R0, R1, #0		; Return completed integer in R0

        LDR     R3, R6, #0		; Restore saved registers and return
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

RN_NEG_CR       .FILL   xFFF3
RN_NEG_LF       .FILL   xFFF6
RN_NEG_ZERO     .FILL   xFFD0

; ============================================================
; Subroutine: VALIDATE_SCORE
;   Subracts 100 from current score input.
;   Returns: R3 = A positive or negative value
;   If the value is positive then the score was greater than 100
;   Which makes it invalid
; ============================================================
VALIDATE_SCORE
	LD	R3, VS_NEG_100		; Load -100 
	ADD	R3, R0, R3		; Subtract 100 from current score
	RET				; Return that value

VS_NEG_100	.FILL	xFF9C

; ============================================================
; Subroutine: FIND_MIN_MAX
;   Returns: R3 = min, R4 = max
;   Saves/restores: R0, R1, R2, R5, R7
; ============================================================
FIND_MIN_MAX
        ADD     R6, R6, #-1		; Save registers to stack
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R5, R6, #0

        LEA     R1, MAIN_SCORES		; Point to start of scores array
        LDR     R3, R1, #0		; Initialize min to first score
        LDR     R4, R1, #0		; Initizlize max to first score
        ADD     R1, R1, #1		; Move to second score
        AND     R2, R2, #0		; Clear loop counter
        ADD     R2, R2, #4		; Set score counter to 4 scores remaining to process

MM_LOOP
        LDR     R0, R1, #0		; Load current score

        NOT     R5, R3			
        ADD     R5, R5, #1		; Compute -min
        ADD     R5, R0, R5		; Current score - min
        BRzp    MM_NOT_MIN		; Skip update if score >= current min
        ADD     R3, R0, #0		; Otherwise, update min score
MM_NOT_MIN

        NOT     R5, R4			
        ADD     R5, R5, #1		; Compute -max
        ADD     R5, R0, R5		; Current score - max
        BRnz    MM_NOT_MAX		; Skip update if score <= current max
        ADD     R4, R0, #0		; Otherwise, update max score
MM_NOT_MAX

        ADD     R1, R1, #1		; Advance to next score
        ADD     R2, R2, #-1		; Decrement score counter
        BRp     MM_LOOP			; Reloop until all scores are processed 

        LDR     R5, R6, #0		; Restore saved registers and return
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

; ============================================================
; Subroutine: CALC_AVERAGE
;   Returns: R5 = average
;   Saves/restores: R0, R1, R2, R3, R7
; ============================================================
CALC_AVERAGE
        ADD     R6, R6, #-1		; Save registers to stack
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R0, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0

        LEA     R1, MAIN_SCORES		; Point to start of scores array 
        AND     R0, R0, #0		; Initialize sum to 0
        AND     R2, R2, #0		; Clear loop counter
        ADD     R2, R2, #5		; Set score counter to 5 scores remaining to process

CA_SUM_LOOP
        LDR     R3, R1, #0		; Load current score
        ADD     R0, R0, R3		; Add score to total sum
        ADD     R1, R1, #1		; Move to next score
        ADD     R2, R2, #-1		; Decrement score counter
        BRp     CA_SUM_LOOP		; Continue until all scores are summed

        AND     R5, R5, #0		; Initialize average to 0
        LD      R3, CA_NEG_FIVE		; Load -5 for repeated subtraction

CA_DIV_LOOP
        ADD     R0, R0, R3		; Subtract 5 from current sum
        BRn     CA_DIV_DONE		; Stop when sum becomes negative
        ADD     R5, R5, #1		; Increment quotient (average)
        BRnzp   CA_DIV_LOOP		; Contine dividing by 5

CA_DIV_DONE
        LDR     R3, R6, #0		; Restore registers and return
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R0, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

CA_NEG_FIVE     .FILL   xFFFB

; ============================================================
; Subroutine: GET_GRADE
;   Input:  R0 = score
;   Output: R0 = ASCII letter grade
;   Saves/restores: R1, R7
; ============================================================
GET_GRADE
        ADD     R6, R6, #-1		; Save registers to stack
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0

        ST      R0, GG_SCRATCH		; Save original score for repeated comparisons

GG_TEST_A
        LD      R1, GG_NEG_90
        ADD     R1, R0, R1		; score - 90
        BRn     GG_TEST_B		; If score < 90, test for B
        LD      R0, GG_ASCII_A		; Otherwise, assign letter grade A
        BRnzp   GG_DONE			; Grade found, skip remaining tests

GG_TEST_B
        LD      R0, GG_SCRATCH		; Restore original score
        LD      R1, GG_NEG_80	
        ADD     R1, R0, R1		; score - 80
        BRn     GG_TEST_C		; If score < 80, test for C
        LD      R0, GG_ASCII_B		; Otherwise, assign letter grade B
        BRnzp   GG_DONE			; Grade found, skip remaining tests

GG_TEST_C
        LD      R0, GG_SCRATCH		; Restore original score
        LD      R1, GG_NEG_70		
        ADD     R1, R0, R1		; score - 70 
        BRn     GG_TEST_D		; If score < 70, test for D
        LD      R0, GG_ASCII_C		; Otherwise, assign letter grade C
        BRnzp   GG_DONE			; Grade found, skip remaining tests

GG_TEST_D
        LD      R0, GG_SCRATCH		; Restore original score
        LD      R1, GG_NEG_60		
        ADD     R1, R0, R1		; Score - 60
        BRn     GG_FAIL			; If score < 60, then grade is F
        LD      R0, GG_ASCII_D		; Otherwise, assign letter grade D
        BRnzp   GG_DONE			; Grade found, skip remaining tests

GG_FAIL
        LD      R0, GG_ASCII_F		; Assign letter grade F

GG_DONE
        LDR     R1, R6, #0		; Restore registers and return
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

GG_SCRATCH      .FILL   x0000
GG_NEG_60       .FILL   xFFC4
GG_NEG_70       .FILL   xFFBA
GG_NEG_80       .FILL   xFFB0
GG_NEG_90       .FILL   xFFA6
GG_ASCII_A      .FILL   x0041
GG_ASCII_B      .FILL   x0042
GG_ASCII_C      .FILL   x0043
GG_ASCII_D      .FILL   x0044
GG_ASCII_F      .FILL   x0046

; ============================================================
; Subroutine: PRINT_NUMBER
;   Input:  R0 = integer (0-100)
;   Saves/restores: R0, R1, R2, R3, R4, R7
; ============================================================
PRINT_NUMBER
        ADD     R6, R6, #-1		; Save registers to stack
        STR     R7, R6, #0
        ADD     R6, R6, #-1
        STR     R1, R6, #0
        ADD     R6, R6, #-1
        STR     R2, R6, #0
        ADD     R6, R6, #-1
        STR     R3, R6, #0
	ADD 	R6, R6, #-1
	STR	R4, R6, #0
	

        AND     R1, R1, #0		; Intialize tens digit counter
        LD      R3, PN_NEG_TEN		; Load -10 for repeated subtraction

PN_TENS_LOOP
        ADD     R2, R0, R3		; test subtracting 10 from current value
        BRn     PN_TENS_DONE		; Stop when subtraction would go negative
        ADD     R0, R2, #0		; Update remaining value
        ADD     R1, R1, #1		; Increment tens digit count
        BRnzp   PN_TENS_LOOP		; Continue subtracting tens

PN_TENS_DONE
	ADD 	R4, R0, #0		; Save ones digit before printing
        ADD     R2, R1, R3		; Check if tens count equals ten
        BRn     PN_PRINT_TENS		; Skip special handling unless value is 100
        LD      R2, PN_ASCII_ONE
	ADD	R0, R2, #0
        TRAP    x21			; Print leading '1' for value 100
	LD 	R0, PN_ASCII_ZERO
	TRAP	x21			; Print middle '0' for value 100
        ADD     R1, R1, #-10		; Remove hundreds digit from tens count
		
PN_PRINT_TENS
        ADD     R2, R1, #0		; Check whether tens digit exists
        BRz     PN_SKIP_TENS		; Skip if tens digit is zero
        LD      R3, PN_ASCII_ZERO
        ADD     R2, R1, R3		; Convert tens digit to ASCII
	ADD 	R0, R2, #0
        TRAP    x21			; Print tens digit

PN_SKIP_TENS
        LD      R3, PN_ASCII_ZERO	; Load ASCII offset
        ADD	R0, R4, R3		; Convert ones digit to ASCII
        TRAP    x21			; Print ones digit
	
	LDR 	R4, R6, #0		; Restore registers and return
	ADD	R6, R6, #1
        LDR     R3, R6, #0
        ADD     R6, R6, #1
        LDR     R2, R6, #0
        ADD     R6, R6, #1
        LDR     R1, R6, #0
        ADD     R6, R6, #1
        LDR     R7, R6, #0
        ADD     R6, R6, #1
        RET

PN_NEG_TEN      .FILL   xFFF6
PN_ASCII_ZERO   .FILL   x0030
PN_ASCII_ONE    .FILL   x0031

        .END    x3000