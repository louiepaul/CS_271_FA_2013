TITLE Program Program2			(Program2.asm)

; Program Description: This program introduces itself and the programer,
; then asks the user for their name. Then asks the user to input a value
; to be used in how many iterations of the Fibonaci Sequence are to 
; be displayed. 
; Author:Ian Paul
; Date Created:10/16/2013
; Last Modification Date: 10/20/2013
; Notes: I worked with Emma Paul on this

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

UPPERLIMIT = 46;
LOWERLIMIT = 0;

userName	  BYTE	33 DUP(0)	  ;string to be entered by user
userNum	  DWORD	?
intro_1	  BYTE	"Fibonacci Numbers!",0
intro_2	  BYTE	"Programmed by Ian Paul", 0
prompt_1	  BYTE	"What's your name? ", 0
hello_1	  BYTE	"Hello, ",0
instruct_1  BYTE	"Enter the number of Fibonacci terms to be displayed, then press ENTER",0
instruct_2  BYTE	"Give the number as an integer in the range [1 .. 46].",0
prompt_2	  BYTE	"How many Fibonacci terms do you want?",0
error_1	  BYTE	"Out of range. Enter a number in [1 .. 46]",0
n	   	  DWORD	?
goodBye_1	  BYTE	"Results certified by Ian Paul",0
goodBye_2	  BYTE	"Good bye, ",0

ip_Test	  BYTE	"Good Job, Bro! Your Jumps Worked!",0	;String used as test

temp		  DWORD	?   ;temp variable to hold numbers
count	  DWORD	1   ;for the loop counter

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


; Prompt User to Enter their name. Save it in userName

    mov	  edx, OFFSET prompt_1
    call	  WriteString
    mov	  edx, OFFSET userName
    mov	  ecx, 56				 ;just limiting the user name to size 56
    call	  ReadString
    call	  Crlf


; Say hello to the user using their name

    mov	  edx, OFFSET hello_1
    call	  WriteString
    mov	  edx, OFFSET userName
    call	  WriteString
    call	  Crlf
    call	  Crlf


; Print "Enter the number of Fibonacci terms to be displayed"

    mov	  edx, OFFSET instruct_1
    call	  WriteString
    call	  Crlf


; Print "Give the number as an integer in the range [1 .. 46]."

    mov	  edx, OFFSET instruct_2
    call	  WriteString
    call	  Crlf


; Empty Line for spacing

    call	  Crlf


;Prompt user "How many Fibonacci terms do you want? " 

userInput:					 ;use as a block to go back if the user input is too low or too high
    call	  Crlf
    mov	  edx, OFFSET prompt_2
    call	  WriteString
    call	  Crlf

; Get user input

    mov	  edx, OFFSET userNum
    mov	  ecx, UPPERLIMIT				 ;just limits user input size
    call	  ReadInt


; Need some sort of Out of Range Check (Out of range. Enter a number in [1 .. 46])

    cmp	  eax, LOWERLIMIT		 ; compairs user input to 1
    jl	  outOfRange			 ; if user input < 1, jumps to outOfRange block, otherwise moves to next line
    cmp	  eax, UPPERLIMIT		 ; compairs user input to UPPERLIMIT
    jg	  outOfRange			 ; if user input > 46, jumpts to outOfRange block, otherwise moves to next line
    jmp	  printFib			 ; forces a jump to printFib block. If the code makes it to here, that means userNum is within range
    

outOfRange:					 ; block to re prompt the user to enter a correct input
    mov	  edx, OFFSET error_1
    call	  WriteString
    call	  Crlf
    jmp	  userInput			; jumps back to userInput block to get a new user input for userNum


; Print out iterations based on user input (LOOP)

printFib:						; printFib block starts the Fibinacci Sequence
    call	  Crlf
    mov	  ebx, 1 
    mov	  edx, 0 
    mov	  ecx, eax			; makes ecx (which will be the loop counter) the userNum (which is in eax)
    
    fibLoop:					; fibLoop is the loop that makes the sequence work over and over again
	   mov	 eax, ebx 
	   add	 eax, edx 
	   mov	 ebx, edx 
	   mov	 edx, eax 
	   call	 WriteDec 
	   mov	 temp,edx	   		; Stores edx temporarily
	   mov	 eax, count
	   cdq
	   div	 Fiver
	   mov	 remainder, edx
	   cmp	 remainder, 0
	   jne	 Taber
	   je	 NewLiner

    NewLiner:
	   call	 Crlf
	   jmp	 LoopEnd

    Taber:
	   mov	 al, TAB
	   call	 WriteChar
	   cmp	 count, 36
	   jge	 LoopEnd
	   call	 WriteChar

    LoopEnd:
	   mov	 edx, temp
	   inc	 count
	   loop	 fibLoop


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