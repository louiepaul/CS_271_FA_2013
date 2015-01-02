TITLE Program Template			(template.asm)

; Program Description: This program prompts a user for numbers (less than 100) and computes the average once the user inputs a negative number
; Author: Emma Paul 
; Date Created: November 1, 2013 
; Last Modification Date:

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data
;constants
UPPERLIMIT = 100 ; highest integer user input can be 
LOWERLIMIT = 0  ; lowest integer user input can be

; (insert variables here)

;intro variables 
accum_title	BYTE	"Welcome to the Integer Accumulator", 0
myName		BYTE	"Programmed by Emma Paul", 0
getName		BYTE	"What's your name?", 0
hello		BYTE	"Hello, ", 0
prompt1		BYTE	"Please enter integers less than or equal to 100. ", 0dh, 0ah,
					"When you would like to see the results, please enter a negative number.", 0
prompt2		BYTE	"Enter number: ", 0
userName	BYTE	33 DUP(0)	;string to be entered by user
numEntered	BYTE	"You entered ", 0
numWord		BYTE	" numbers", 0
errorMess	BYTE	"That number is too high.", 0
sumMess		BYTE	". The sum of your numbers is ", 0
aveMess		BYTE	". The rounded average is ", 0
byeMess		BYTE	"Thank you for playing Integer Acummulator! It's been a pleasure to meet you, ", 0
count		DWORD	0	  ;count needs to start at 0
average		DWORD	?
runTotal		DWORD     ?

.code
main PROC
; (insert executable instructions here)

;intro 
mov		edx, OFFSET accum_title
call	writestring 
call	Crlf 
call	Crlf
mov	edx, OFFSET	myname 
call	writestring 
call	Crlf
call	Crlf


;get user name 
mov		edx, OFFSET getName		; move name prompt into edx 
call	writestring				; ask 
call	crlf
call	Crlf					; return 
mov		edx, OFFSET userName 
mov		ecx, 50					; set ECX to the maximum number of characters the user can enter
call	ReadString				; reads name into edx 
mov		edx, OFFSET hello
call	crlf
call	writeString 
mov		edx, OFFSET username 
call	writestring
call	crlf 
call	Crlf


;prompt user for numbers 
mov		edx, OFFSET prompt1
call	writestring
call	crlf
mov		ebx, 0


userNumbers:
	mov		edx, OFFSET prompt2
	call	writeString
	call	crlf
	call	readInt 
	cmp		eax, UPPERLIMIT				; compare n to 100 
	jg		errorReport				; if n >= 100, go to error message 
	cmp		eax, LOWERLIMIT				; compare n to 0
	jl		endLoop						; if n is negative number
	add		ebx, eax					; if n is within 0-100 add it to ebx 
	mov		runTotal,ebx	   			    ; Stores edx temporarily
	inc		count
	jmp		userNumbers					; start over 
	

endLoop:								; once user enters a negative number, print results 
mov		edx, OFFSET numEntered
call	writestring
mov		eax, count					; needs to be eax and no offset
call	writeDec
mov		edx, OFFSET numWord
call	writestring 
mov		edx, OFFSET	sumMess
call	writeString
mov		eax, runTotal						; prints total needs to be eax
call	writeDec

mov		eax, ebx						; moves total to eax 
cdq										; double to quad word (to deal with overflow for division operation)
mov		ebx, count
div		ebx 
mov		edx, OFFSEt aveMess
call	writeString
mov		edx, eax					; puts average edx
call	writeDec					; prints average  
call	crlf
mov		edx, OFFSET Byemess
call	writeString
mov		edx, OFFSET username
call	writestring
call	crlf

jmp exitProgram


errorReport:
	mov	edx, OFFSET	errorMess
	call crlf
	call writeString
	call crlf 
	mov edx, OFFSET prompt1
	call writeString
	call crlf
	jmp userNumbers						; jump back to getting user number after error message 

exitProgram:

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main