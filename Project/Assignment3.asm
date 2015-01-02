TITLE Program Assignment 3			(Assignment3.asm)

; Program Description: This program prompts a user
; takes numbers from a user until a negative is given, 
; adds them up, tells them how many numbers they used, and gives
; an average before saying goodbye and exiting. 
;
; Author:	  Ian Paul
; Date Created: 11/01/2013
; Last Modification Date: 11/03/2013

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; Constants
UPPERLIMIT = 100	; user input cannot be greater
LOWERLIMIT = 0		; user input cannot be lower


; (insert variables here)

; Variables
programTitle		BYTE	"ACCUMULATOR", 0
programerName		BYTE	"Programmed by Ian Paul", 0
getUserName		BYTE	"Please enter your name: ", 0
hello			BYTE	"Hello ", 0
greeting			BYTE ", nice to meet you!",0

prompt1			BYTE	"Please enter integers less than or equal to 100. ", 0dh, 0ah,
					"To see the sum and average of your numbers, enter a negative number.", 0

prompt2			BYTE	"Enter a number: ", 0

userName			BYTE	33 DUP(0)	;string to be entered by user
numberEntered		BYTE	"You entered ", 0
numbers			BYTE	" numbers", 0

sumMessage		BYTE	"The sum of your numbers is ", 0
averageMessage		BYTE	"The rounded average is ", 0

goodBye			BYTE	"Thank you for using ACCUMULATOR!", 0dh, 0ah,
					"Peace be with you, ", 0

toHigh			BYTE	"That number is too high. Must be between 0-100", 0

count			DWORD	0	  ;count needs to start at 0
average			DWORD	?
runTotal			DWORD     ?

.code
main PROC

; (insert executable instructions here)

; Display Program Title and Programer's Name

mov	edx, OFFSET programTitle
call	writestring 
call	Crlf 
call	Crlf
mov	edx, OFFSET	programerName
call	writestring 
call	Crlf
call	Crlf


; Get the user's name and greet the user

mov	edx, OFFSET getUserName		
call	writestring				
call	crlf
call	Crlf					
mov	edx, OFFSET userName 
mov	ecx, 50				; set ECX to the maximum number of characters the user can enter
call	ReadString			; reads name into edx 
mov	edx, OFFSET hello
call	crlf
call	writeString 
mov	edx, OFFSET userName 
call	writestring
mov	edx, OFFSET greeting 
call	writestring
call	crlf 
call	Crlf


; Display instructions for the user

mov	edx, OFFSET prompt1
call	writestring
call	crlf
mov	ebx, 0


; Repeatedly prompt the user to enter a number (0-100)
; Count and accumulate the valid user number until a negative is entered

userNumbers: ;loop
	mov	edx, OFFSET prompt2
	call	writeString
	call	readInt 
	cmp	eax, UPPERLIMIT	; Compare n to 100 
	jg	errorReport		; Jump if n >= 100, go to error message 
	cmp	eax, LOWERLIMIT	; compare n to 0
	jl	endCalc			; Jump if n is negative number
	add	ebx, eax			; If n is within 0-100 add it to ebx 
	mov	runTotal, ebx	     ; Stores edx temporarily
	inc	count			; Keeps a running total of how many usable numbers entered
	jmp	userNumbers		; Starts the loop over 


; Calculate the rounded integer average of non-negative numbers

; Display

;   The number of non-negatives entered

endCalc:						
mov	edx, OFFSET numberEntered
call	writestring
mov	eax, count				; needs to be eax and no offset
call	writeDec
mov	edx, OFFSET numbers
call	writestring 
call	Crlf

;   The sum of the non-negative numbers entered


mov	edx, OFFSET sumMessage
call	writeString
mov	eax, runTotal				; prints total needs to be eax
call	writeDec
call	Crlf

;   The average rounded to the nearest integer


mov	eax, ebx					; moves total to eax 
cdq							
mov	ebx, count
div	ebx 
mov	edx, OFFSET averageMessage
call	writeString
mov	edx, eax					; puts average into edx
call	writeDec					; prints average  
call	crlf
call	Crlf

;   A parting message with the user's name

mov	edx, OFFSET goodBye
call	writeString
mov	edx, OFFSET username
call	writestring
call	crlf

jmp exitProgram


;   Error message if too high

errorReport:
	mov	edx, OFFSET toHigh
	call crlf
	call writeString
	call crlf 
	jmp userNumbers

exitProgram:

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main