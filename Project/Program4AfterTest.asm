TITLE Program Program4			(Program4.asm)

; Program Description: This program introduces itself and the programer.
; Then asks the user to input a value
; to be used in how many prime numbers are to 
; be displayed. 
; Author:Ian Paul
; Date Created:11/06/2013
; Last Modification Date: 11/09/2013


INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

UPPERLIMIT = 200;
LOWERLIMIT = 0;

userName	  BYTE	33 DUP(0)	  ;string to be entered by user
userNum	  DWORD	?
intro_1	  BYTE	"Prime Numbers!",0
intro_2	  BYTE	"Programmed by Ian Paul", 0

prompt1	  BYTE	"Enter the number of prime numbers you would like to see. ", 0dh, 0ah,
				"I'll accept orders for up to 200 primes.", 0


instruct_1  BYTE	"Enter the number of primes to display [1-200], then press ENTER:",0

error_1	  BYTE	"Out of range. Try again.",0
n	   	  DWORD	1
divider	  DWORD	1
goodBye_1	  BYTE	"Results certified by Ian Paul",0
goodBye_2	  BYTE	"Good bye, ",0

ip_Test	  BYTE	"Good Job, Bro! Your Jumps Worked!",0	;String used as test

temp		  DWORD	?   ;temp variable to hold numbers
count	  DWORD	?   ;for the loop counter

Fiver	  DWORD	5   ;helper variable for correct tab and line placement
remainder	  DWORD	?   ;remainder variable

.code
main PROC

; Display Program Name

    mov	  edx, OFFSET intro_1
    call	  WriteString
    call	  CrLf


; Display Programer Name

    mov	  edx, OFFSET intro_2
    call	  WriteString
    call	  CrLf


; Empty Line for spacing

    call	  Crlf


; Display prompt1

    mov	  edx, OFFSET prompt1
    call	  WriteString
    call	  Crlf


; Display instuct_1

    mov	  edx, OFFSET instruct_1
    call	  WriteString
    call	  Crlf


; Empty Line for spacing

    call	  Crlf

; Get user input

userInput:
    mov	  edx, OFFSET userNum
    mov	  ecx, UPPERLIMIT				 ;just limits user input size
    call	  ReadInt
    mov	  userNum, eax


; Need some sort of Out of Range Check (Out of range. Enter a number in [1 .. 46])

    cmp	  eax, LOWERLIMIT		 ; compairs user input to 1
    jle	  outOfRange			 ; if user input < 1, jumps to outOfRange block, otherwise moves to next line
    cmp	  eax, UPPERLIMIT		 ; compairs user input to UPPERLIMIT
    jg	  outOfRange			 ; if user input > 46, jumpts to outOfRange block, otherwise moves to next line
    mov	  ecx, userNum			 ; makes ecx (which will be the loop counter) 
    mov	  count, ecx			 ; count and user number are now the same
    jmp	  printPrime			 ; forces a jump to prime block. If the code makes it to here, that means userNum is within range
    

outOfRange:					 ; block to re prompt the user to enter a correct input
    mov	  edx, OFFSET error_1
    call	  WriteString
    call	  Crlf
    mov	  edx, OFFSET instruct_1
    call	  WriteString
    call	  Crlf
    jmp	  userInput			; jumps back to userInput block to get a new user input for userNum


; Print out iterations based on user input (LOOP)
    call	  Crlf

ladderTop:  ; This is to jump from the middle of the printPrime Segment to allow for a longer jump



printPrime:						; printPrime block starts the Prime Sequence

	
	primeMaker:
	inc n
	mov eax, n ; n will be a variable that starts at 1
	cmp eax, 2 ; n is checked against all the single digit primes
	je formater	; if n is a single digit prime, it jumps down to the formater section
	cmp eax, 3
	je formater
	cmp eax, 5
	je formater
	cmp eax, 7
	je formater	

				; n is now devided by the single digit primes and the remainder is checked
	mov eax, n
	cdq
	mov ebx, 2
	div ebx
	cmp edx, 0	; if the raminder is 0, then that means n can be devided, and is not a prime
	je primeMaker	; so the program jumps to the top and n is increased and everything is done again

	mov eax, n
	cdq
	mov ebx, 3
	div ebx
	cmp edx, 0
	je primeMaker

	jmp snake		; this is to allow for longer jumps. Snakes and Ladders

	ladderMid:	; i like to think of this like a portal or rip in the space time continuum. 

	jmp ladderTop	; this jumps to the top

	snake:

     mov eax, n	; the tests are continued
	cdq
	mov ebx, 5
	div ebx
	cmp edx, 0
	je primeMaker

	mov eax, n
	cdq
	mov ebx, 7
	div ebx
	cmp edx, 0
	je primeMaker

	formater:			   ; This part now formats how the primes are printed

	   mov	 eax, count
	   cdq
	   div	 Fiver
	   mov	 remainder, edx
	   cmp	 remainder, 0	  
	   jne	 Taber		  ; forces a tab to printed after each prime up to 5 primes
	   je	 NewLiner		  ; if there are 5 primes, then no new tabs are printed and just a new line is inserted

    NewLiner:
	   call	 Crlf		  ; a new line is printed
	   jmp	 primeJump

    Taber:				  ; prints a tab
	   mov	 al, TAB
	   call	 WriteChar
	   ;call	 WriteChar

	
	primeJump:			  ; This section actually prints the primes
mov eax, n

call writeDec			   ; prints the prime
;call Crlf

dec count				   ; decrimints prime so that the right number of primes is created
mov eax, count
cmp eax, 0			   ; compares count to zero
je  afterLoop			   ; once count is zero, jumps the program out of the loop

jmp ladderMid			   ; if count is not zero, jumps the program half way up to allow another jump

;loop printPrime

afterLoop:			   ; jump spot for after loop
   
   


; Print out "Results certified by Ian Paul"

    call	  Crlf
    call	  Crlf
    mov	  edx, OFFSET goodbye_1
    call	  WriteString
    call	  Crlf


; Print out "Good bye, (User Name)"

    call	  Crlf
    mov	  edx, OFFSET goodbye_2
    call	  WriteString
    mov	  edx, OFFSET userName
    call	  WriteString
    call	  Crlf


	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main