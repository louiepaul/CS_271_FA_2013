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

getString	  MACRO

mWriteStr prompt

call readVal



ENDM



;MACRO from Lecture 26
mWriteStr	  MACRO	buffer
    push	  edx
    mov	  edx, OFFSET buffer
    call	  WriteString
    pop	  edx
ENDM

;MACRO from Lecture 26
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
outString	BYTE		MAXSIZE DUP(?)		; User's string capitalized
prompt1	BYTE		"Enter a string: ",0
sLength	DWORD	0
total	DWORD	0
ecxReg    DWORD     ?
curInt	DWORD     0
tenUpper	DWORD	1
eaxReg	DWORD     ?
placer    DWORD     ?

result  DWORD   ?
;temp        BYTE        21 DUP(0)
answer  DWORD   ?

progTitle		 BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
progrIntro	 BYTE	"Written by: ",0 
progrName		 BYTE	"Ian Paul",0
spacer		 BYTE	" ",0

instruct		 BYTE	"Please provide 10 unsigned decimal integers.", 0dh, 0ah,
					"Each number needs to be small enough to fit inside a 32 bit register.",0dh, 0ah,
					"After you have finished inputting the raw numbers I will display a list ",0dh, 0ah,
				     "of the integers, their sum, and their average value.",0

prompt		 BYTE    "Please enter an unsigned number: ",0

numberArray	 DWORD	ARRAY_MAX DUP(?)	;Only 10 spots for the user numbers

squareArray	DWORD	MAXSIZE DUP(?)

userString	 BYTE	ARRAY_MAX DUP(?)

a			DWORD		?		;
b			DWORD		?		;
sum			DWORD		?		;

temp			 DWORD		 ?

count		 DWORD   0
userNumber	 DWORD   ?
;sLength		 DWORD   10

averageNum	 DWORD   ?


errorMsg		 BYTE    "ERROR: You did not enter an unsigned number or your number was too big!",0
tryAgain		 BYTE    "Please try again: ",0

outro1		 BYTE    "You entered the following numbers: ",0
outro2		 BYTE    "The sum of these numbers is: ",0
outro3		 BYTE    "The average is: ",0

goodBye		 BYTE    "Thanks for playing!",0

saveForLater	 DWORD   ?
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
mWriteStr   instruct
call	   Crlf
call	   Crlf

;prompt user. this might be combined with get user data

mov ecx, superLooper


totalLoop:

getString

;need to call fillArray from demo5LP

call	fillArray	



call summer


mov ecx, superLooper
dec superLooper

loop totalLoop

;mov edx, saveForLater
;mov numberArray, edx

call aver


mWriteStr outro1


call Crlf


	push	OFFSET squareArray
	push	arrayCount
	call	showRevList		;Print the array in reverse order
	
	call Crlf

mWriteStr outro2

mov eax, sum
call WriteDec

call Crlf

mWriteStr outro3

mov eax, averageNum
call WriteDec

call Crlf


;need to write the proper strings
;also need to call showRevList from demo5LP

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)
; ***************************************************************
; Procedure to display array in reverse order.
; receives: address of array and value of count on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: count is initialized, 1 <= count <= 100
;                and the first count elements of array initialized
; registers changed: eax, ebx, edx, esi
; ***************************************************************
showRevList	PROC
	push	ebp
	mov	ebp,esp
	mov	edx,[ebp+8]		;count in edx
	mov	esi,[ebp+12]		;address of array in esi
	inc	edx				;scale edx for [count-1 down to 0]

more:

	mov	al,32
	call	WriteChar
	call	WriteChar
	mov	eax,[esi+edx*4]	;start with last element
	call	WriteDec			;display n-squared

	inc	edx
	cmp	edx,10
	jl	more
	
	pop	ebp
	ret	8
showRevList	ENDP

; ***************************************************************
; Procedure to put count squares into the array.
; receives: address of array and value of count on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: count is initialized, 1 <= count <= 100
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray	PROC
	push	ebp
	mov	ebp,esp
	
	;mov	ecx,[ebp+8]		;count in ecx
	;mov ecx, arrayCount
	;mov	edi,[ebp+12]		;address of array in edi
	mov edi, OFFSET squareArray
	mov	ebx,0
again:
	
	mov  eax, total
		
    	mov  ecx, arrayPlace
	mov	[edi +ecx*4],eax
	;add	edi,4
	inc  arrayPlace

	;mov  eax, total

	;mov	[edi],eax
	;add	edi,4
	inc	ebx
	;loop	again
	
	pop	ebp
	ret	8
fillArray	ENDP



summer PROC

mov eax, total
mov ebx, sum
add eax, ebx
mov sum, eax
mov eax, 0
mov total, eax

    ret
summer ENDP

aver PROC

mov	eax, sum					; moves total to eax 
cdq							
mov	ebx, 10
div	ebx 

mov	averageNum, eax					; puts average into edx




    ret
aver ENDP


readVal PROC
push        ebp
mov     ebp,esp

; Get user input:
jmp runner

	notNum:
	;mWriteStr prompt
	mWriteStr errorMSG
	call Crlf
	mWriteStr tryAgain

runner:
	mov	edx,OFFSET inString
	mov	ecx,MAXSIZE
	call ReadString
	mov saveForLater, edx
	call	CrLf
	
; Set up the loop counter, put the string addresses in the source 
; and index registers, and clear the direction flag:
	mov	sLength,eax
	mov	ecx,eax
	mov  placer, eax
	dec  placer
	mov	esi,OFFSET inString

	cld

; Check each character to determine if it is a lower-case letter.
; If yes, change it to a capital letter.  Store all characters in
; the converted string:
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
	sub	al,48
	mov  [edi], al
  

	mov  ecxReg, ecx
	
	mov  eax, 1
	mov  tenUpper, eax

	mov  ecx, placer
	cmp  ecx, 0
	je   noMul

	multiplier:


	mov  eax, tenUpper
	mov  ebx, 10
	mul  ebx
	mov  tenUpper, eax
	loop multiplier
	dec  placer

	noMul:

	mov  ecx, ecxReg

	mov  eax, tenUpper
	mov  ebx, curInt
	
	mul  ebx

	;mov edi, OFFSET total	;only need offset for al register

	

	add total, eax

	;stosb
	loop	counter
	
;need to call fillArray from demo5LP
    
	

	;call	fillArray	

	

	pop ebp
    ret 
readVal ENDP




END main