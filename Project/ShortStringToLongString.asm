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

loopCount DWORD      2
strCounter   DWORD	 0


.code
main PROC

mov ecx, loopCount
looper:

call stringer
inc strCounter

mov ecx, loopCount
dec loopCount
loop looper



	
	exit			;exit to operating system
main ENDP

stringer PROC

; Get user input:
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
	mov	esi,OFFSET inString
	mov  eax, strCounter
	mov	edi,	OFFSET outString 
	cld

; Check each character to determine if it is a lower-case letter.
; If yes, change it to a capital letter.  Store all characters in
; the converted string:
    mov   edi, [edi + ebx*4]
  
counter:
	lodsb

	stosb
	loop	counter

	mov al, 0
	stosb
	
; Display the converted string:
	mov	edx,OFFSET outString
	call	WriteString
	call	CrLf
	


ret

stringer ENDP



END main
