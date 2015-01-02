TITLE DemoString     (demo6.asm)

; Author: Paulson
; CS271	in-class demo        9/15/2012
; Description:  This program asks the user to enter a string,
;               and then displays the string in all caps.
;               Finally, the string is displayed backwards.

INCLUDE Irvine32.inc
MAXSIZE	= 100
.data
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

.code
main PROC
; Get user input:
	notNum:
	mov	edx,OFFSET prompt1
	call	WriteString
	mov	edx,OFFSET inString
	mov	ecx,MAXSIZE
	call	ReadString
	call	WriteString
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

	mov edi, OFFSET total	

	add  [edi], eax

	;stosb
	loop	counter
	


	mov eax, total
	call WriteDec
     call Crlf

	
	exit			;exit to operating system
main ENDP

END main
