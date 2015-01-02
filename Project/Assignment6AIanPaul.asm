TITLE Program Assignment 6A			(Assignment6A.asm)

; Program Description: The program introduces itself, uses prompts, and calculates
;				    Through using procedures and macros, a user is prompted to give
;				    10 unsigned decimal integers (range of 0 to 2,147,483,647, the max
;				    32 bit unsigned int). Then it takes all of them, displays them, then 
;				    displays their average. Then exits.
; Author: Ian Paul
; Date Created: 12/5/2013
; Last Modification Date:

INCLUDE Irvine32.inc

; (insert symbol definitions here)

LO = 0
ARRAY_MAX = 10
MAXSIZE	= 100

; (insert MACROs builds here)


;getString macro writes the prompt and then calls readVal procedure
getString	  MACRO

mWriteStr prompt

call readVal

ENDM

;displayString macro displays the list of ints given by the user
displayString MACRO

	push	OFFSET numbersArray	  ;pushes the address of the array with the numbers
	push	arrayCount		  ;pushes the count of the array
	call	showList			  ;procedure to print the numbers in the array
	call Crlf

ENDM

;displaySum macro displays the sum
displaySum MACRO

mov eax, sum
call WriteDec

ENDM

displayAve MACRO

mov eax, averageNum
call WriteDec

ENDM

;MACRO from Lecture 26 
;mWriteStr macro takes a string and prints it
mWriteStr	  MACRO	buffer
    push	  edx
    mov	  edx, OFFSET buffer
    call	  WriteString
    pop	  edx
ENDM

;MACRO from Lecture 26
;mReadStr macro reads a string a stores it to a predetermined variable
mReadStr	  MACRO	varName
    push	  ecx
    push	  edx
    mov	  edx,	OFFSET varName
    mov	  ecx,	(SIZEOF varName)-1
    call	  ReadString
    pop	  edx
    pop	  ecx
ENDM

.data

; (insert variables here)

inString	BYTE		MAXSIZE DUP(?)		; User's string

sLength	DWORD	0
total	DWORD	0
ecxReg    DWORD     ?
curInt	DWORD     0
tenUpper	DWORD	1
eaxReg	DWORD     ?
placer    DWORD     ?

progTitle		 BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
progrIntro	 BYTE	"Written by: ",0 
progrName		 BYTE	"Ian Paul",0

instruct		 BYTE	"Please provide 10 unsigned decimal integers.", 0dh, 0ah,
					"Each number needs to be small enough to fit inside a 32 bit register.",0dh, 0ah,
					"After you have finished inputting the raw numbers I will display a list ",0dh, 0ah,
				     "of the integers, their sum, and their average value.",0

prompt		 BYTE    "Please enter an unsigned number: ",0

numbersArray	DWORD	MAXSIZE DUP(?)
sum			DWORD	   ?		
temp			DWORD	   ?
averageNum	DWORD	   ?

errorMsg		 BYTE    "ERROR: You did not enter an unsigned number or your number was too big!",0
tryAgain		 BYTE    "Please try again: ",0

outro1		 BYTE    "You entered the following numbers: ",0
outro2		 BYTE    "The sum of these numbers is: ",0
outro3		 BYTE    "The average is: ",0

goodBye		 BYTE    "Thanks for playing!",0

saveForLater	 DWORD    ?
tempStr		 DWORD	?

loopCount		 DWORD   11
fillCount		 DWORD   0
totalCount	 DWORD   3
superLooper	 DWORD   10
arrayCount	 DWORD   -1
arrayPlace	 DWORD   0


.code
main PROC

; (insert executable instructions here)

;introduce program

mWriteStr	  progTitle
call	   Crlf

;diplay programmer name

mWriteStr	  progrIntro
mWriteStr	  progrName 
call	   Crlf 
call	   Crlf 
call	   Crlf 

;display program instructions
mWriteStr   instruct
call	   Crlf
call	   Crlf

;prompt user to give 10 ints

    totalLoop:

	   getString		    ;macro that writes prompt and then gets the string and turns it to an int

	   call	fillArray	    ;procedure to put the ints into an array to be displayed later

	   call summer	    ;procedure to sum the ints given


    mov ecx, superLooper    ;puts 10 into ecx for the loop
    dec superLooper		   ;decriments variable used for loop counter

loop totalLoop		    ;loops to get all 10 ints from user

    call aver			    ;procedure to get the average of all the numbers


;display "you entered the following numbers"
mWriteStr outro1

call Crlf


;display all the numbers given
	
	displayString


;display "the sum of these numbers is: "
mWriteStr outro2


;display sum

    displaySum

call Crlf


;display "the average is: "

mWriteStr outro3


;display average

    displayAve

call Crlf


;"display "thanks for playing!"
mWriteStr goodBye

call Crlf


	exit		; exit to operating system
main ENDP

; (insert additional procedures here)


; ***************************************************************
; Procedure to display array in order.
; receives: address of array and value of count on system stack
; returns: prints out the value in the array
; preconditions: count is initialized, 1 <= count <= 100
;                and the first count elements of array initialized
; registers changed: eax, ebx, edx, esi
; ***************************************************************
showList	PROC
	push	ebp
	mov	ebp,esp
	mov	edx,[ebp+8]		;count in edx
	mov	esi,[ebp+12]		;address of array in esi
	inc	edx				;scale edx for [count-1 up to 10]

more:

	mov	al,32			;puts a ' ' into al for spacing
	call	WriteChar
	call	WriteChar
	mov	eax,[esi+edx*4]	;start with first element
	call	WriteDec			;display ints

	inc	edx
	cmp	edx,10
	jl	more
	
	pop	ebp
	ret	8
showList	ENDP

; ***************************************************************
; Procedure to put user ints into the array.
; returns: puts the current user int into the array
; preconditions: count is initialized, 1 <= count <= 100
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray	PROC
	push	ebp
	mov	ebp,esp
	
	mov edi, OFFSET numbersArray  ;puts @numbersArray into edi
	mov	ebx,0
again:
	
	mov  eax, total			 ;int value of user string
    	mov  ecx, arrayPlace		 ;variable to place ints into array properly
	mov	[edi +ecx*4],eax
	inc  arrayPlace
	inc	ebx
	
	pop	ebp
	ret	8
fillArray	ENDP


; ***************************************************************
; Procedure to sum the ints given by the user
; returns: updates sum 
; preconditions: total and sum must have values
; registers changed: eax, ebx
; **************************************************************
summer PROC

mov eax, total
mov ebx, sum
add eax, ebx
mov sum, eax
mov eax, 0		;zeros out total variable for use later
mov total, eax

    ret
summer ENDP


; ***************************************************************
; Procedure to get the averages of all the ints
; returns: updates sum 
; preconditions: total and sum must have values
; registers changed: eax, ebx
; **************************************************************
aver PROC

mov	eax, sum					 ;moves sum to eax 
cdq							
mov	ebx, ARRAY_MAX
div	ebx						 ;computes the average

mov	averageNum, eax			 ;puts computation into averageNum

    ret
aver ENDP


; ***************************************************************
; Procedure that gets a string from the user, checks each char
; given, if they are numbers, converts them to their int equivolent,
; determins the decimal value of that char (now int), multiplies it
; by the appropriate factor of 10, adds that to a running total 
; until all chars have been converted. If any chars are not a number
; then the user is prompted to enter an actual number. 
; returns: The int value of the user string
; preconditions: user has entered a string
; registers changed: eax, ebx, ecx, edx, esi, esp, ebp
; NOTE: This procedure was put together using material from 
; lectures and demos, and also some pretty creative fixes made
; by me.
; ***************************************************************
readVal PROC
push        ebp
mov     ebp,esp

; Get user input:
jmp runner					 ;jumps past error handeling

	notNum:					 ;jump spot if a char is ever not a number
	   mWriteStr errorMSG
	   call Crlf
	   mWriteStr tryAgain

runner:						 ;gets the user's string
	mov	edx,OFFSET inString
	mov	ecx,MAXSIZE

	call ReadString
	mov saveForLater, edx
	call	CrLf
	
	;sets up loop counter and puts address of user string into edi
	mov	sLength,eax
	cmp	eax, ARRAY_MAX
	jge  notNum			  ;checks to make sure the string can fit
	mov	ecx,eax
	mov  placer, eax
	dec  placer
	mov	esi,OFFSET inString

	cld					  ;clears direction flag

;checks each char and makes sure it is a number
counter:
	lodsb

	mov  eaxReg, eax
	mov  eax, 0
	mov  curInt, eax
	mov  edi, OFFSET curInt



	mov  eax, eaxReg
	
	cmp	al,48	; '0' is character 48
	jb	notNum
	cmp	al,57	; '9' is character 57
	ja	notNum
	sub	al,48	;subtracts value of al to make it the actual int value
	mov  [edi], al	;moves value into total (variable)
  

	mov  ecxReg, ecx  ;saves ecx for the outer loop
	
	mov  eax, 1	    ;puts 1 in tenUpper
	mov  tenUpper, eax

	mov  ecx, placer   ;placer determins what decimal place value each char is
	cmp  ecx, 0
	je   noMul

	multiplier:		   ;small loop to create a value of 10, 100, 1000, etc. to multiply the char by
	
	mov  eax, tenUpper
	mov  ebx, 10
	mul  ebx
	mov  tenUpper, eax
	loop multiplier
	dec  placer

	noMul:

	mov  ecx, ecxReg		  ;saves ecx register for outer loop

	mov  eax, tenUpper		  
	mov  ebx, curInt
	
	mul  ebx				  ;multiplies current char (now int) by whatever place value it is

	add total, eax			  ;adds calculation to the variable "total"

	loop	counter
	
	pop ebp
    ret 
readVal ENDP




END main