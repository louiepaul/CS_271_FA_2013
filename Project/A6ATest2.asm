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

; (insert MACROs builds here)

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

counterLP	  DWORD	10

result  DWORD   ?
temp        BYTE        21 DUP(0)
answer  DWORD   ?
answerSize DWORD 10

;result  DWORD   ?
;temp        BYTE        21 DUP(0)
;answer  DWORD   ?

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

userString	 BYTE	ARRAY_MAX DUP(?)

a			DWORD		?		;
b			DWORD		?		;
sum			DWORD		0		;

;temp			 DWORD		 ?

count		 DWORD   0
userNumber	 DWORD   ?
sLength		 DWORD   10

averageNum	 DWORD   ?

inString	BYTE		ARRAY_MAX DUP(?)		; User's string
outString	BYTE		ARRAY_MAX DUP(?)		; User's string capitalized

errorMsg		 BYTE    "ERROR: You did not enter an unsigned number or your number was too big!",0
tryAgain		 BYTE    "Please try again: ",0

outro1		 BYTE    "You entered the following numbers: ",0
outro2		 BYTE    "The sum of these numbers is: ",0
outro3		 BYTE    "The average is: ",0

goodBye		 BYTE    "Thanks for playing!",0


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

;prompt user

mWriteStr	  instruct
call	   Crlf 
call	   Crlf 

;get user data. be sure to error check

;mov ecx, counterLP

looper:
;push numberArray	;ebp+20
push OFFSET temp        ;ebp+16
push OFFSET answer      ;ebp+12
push answerSize     ;ebp+8
;push numberArray	;ebp+8
call    getData
loop looper


;demo5
;push	OFFSET numberArray
;push	sLength
;call	fillArray			;Put that many squares into the array

;call	   ReadVal

;display "you entered the following numbers: "

mWriteStr outro1
call Crlf

;display numbers entered

    ;mWriteStr answer
	push	OFFSET answer
	push	sLength
	call	showList		;Print the array in reverse order

;mWriteStr	  userString
call Crlf

;display "the sum of these numbers is: "

mWriteStr outro2

;display sum

mov	   eax,sum
call	   WriteInt
call Crlf

;display "the average is: "

mWriteStr outro3

;display average

call Crlf
call Crlf

;display "Thanks for playing!"




	exit		; exit to operating system
main ENDP

; (insert additional procedures here)


;*************************************************
; prompts / gets the user�s answer.
; receives: the OFFSET of answer and temp and value of answerSize
; returns: none
; preconditions: none
; registers changed:  eax, ebx, ecx, edx, ebp, esi, esp
;*************************************************
getData PROC
push        ebp
mov     ebp,esp

again:
mWriteStr   prompt
mov     edx, [ebp+16]       ;move OFFSET of temp to receive string of integers
mov     ecx, 12
call        ReadString
cmp     eax, 10
jg      invalidInput

mov     ecx, eax        ;loop for each char in string
mov     esi,[ebp+16]    ;point at char in string

;pushad
loopString:             ;loop looks at each char in string
    mov     ebx,[ebp+12]
    mov     eax,[ebx]   ;move address of answer into eax
    mov     ebx,10d     
    mul     ebx         ;multiply answer by 10
    mov     ebx,[ebp+12]    ;move address of answer into ebx
    mov     [ebx],eax       ;add product to answer
    mov     al,[esi]        ;move value of char into al register
    inc     esi         ;point to next char
    sub     al,48d      ;subtract 48 from ASCII value of char to get integer  

    cmp     al,0            ;error checking to ensure values are digits 0-9
    jl      invalidInput
    cmp     al,9
    jg      invalidInput

    mov     ebx,[ebp+12]    ;move address of answer into ebx
    ;mov     [ebx],al        ;add int to value in answer
    add     [ebx],al        ;add int to value in answer

    loop        loopString  
;popad
jmp     moveOn
invalidInput:               ;reset registers and variables to 0
    mov     al,0
    mov     eax,0
    mov     ebx,[ebp+12]
    mov     [ebx],eax
    mov     ebx,[ebp+16]
    mov     [ebx],eax       
    mWriteStr   errorMSG
    call	   Crlf
    jmp	  again
moveOn:

   ; mov ebx, [ebp+20]
    ;mov [ebx],al

    mov eax, [ebx]
    mov ebx, [ebp+20]
    mov [ebx],eax

    mov ecx, counterLP
    dec counterLP
    pop     ebp
    ret     12
getData ENDP

;demp5
; ***************************************************************
; Procedure to display array in reverse order.
; receives: address of array and value of count on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: count is initialized, 1 <= count <= 100
;                and the first count elements of array initialized
; registers changed: eax, ebx, edx, esi
; ***************************************************************
showList	PROC
	push	ebp
	mov	ebp,esp
	mov	ecx,[ebp+8]		;count in ecx
	mov	esi,[ebp+12]		;address of array in esi
	mov	edx, 0


more:
	mov	eax,[esi+edx*4]			;display n
	;add	eax, 48
	mov	a, eax
	mWriteStr a
     mWriteStr spacer
	inc	edx
	loop	more
	
	pop	ebp
	ret	8
showList	ENDP


END main