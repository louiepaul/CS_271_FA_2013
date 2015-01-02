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



prompt		 BYTE    "Please enter an unsigned number: ",0

numberArray	 DWORD	ARRAY_MAX DUP(?)	;Only 10 spots for the user numbers

userString	 BYTE	ARRAY_MAX DUP(?)

tempStr		 DWORD	?

temp			 DWORD		 ?

saveForLater	 DWORD   ?

count		DWORD	10

answer  DWORD   ?

errorMsg		 BYTE    "ERROR: You did not enter an unsigned number or your number was too big!",0

sLength		 DWORD   2

spacer		 BYTE	" ",0

.code
main PROC

; (insert executable instructions here)



push OFFSET answer
push OFFSET tempStr
call convertBot
call Crlf

mov eax, answer
call WriteDec
call Crlf

mWriteStr saveForLater ; this comes from convertBot. it holds the origonal string. use this to fill an array later
;still can't figure out error checking



	exit		; exit to operating system
main ENDP

convertBot PROC
push        ebp
mov     ebp,esp

again:
mWriteStr prompt
mReadStr	tempStr
mov     ecx, eax        ;loop for each char in string
mov	   eax, [tempStr]
mov	   saveForLater,eax

mov     esi,[ebp+8]    ;point at char in string

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
    mov     ebx,[ebp+8]
    mov     [ebx],eax
    mov     ebx,[ebp+12]
    mov     [ebx],eax       
    mWriteStr   errorMSG
    call	   Crlf
    jmp	  again
moveOn:
    

    pop     ebp
    ret     12

convertBot ENDP



fillArray	PROC
	push	ebp
	mov	ebp,esp
	mov	ecx,[ebp+8]		;count in ecx
	mov	edi,[ebp+12]		;address of array in edi
	
	mov	ebx,0
;again:
	;mov	edx, OFFSET prompt
	;call	WriteString		;prompt user
	;call	ReadInt			;get user's number
	
	;mov	eax,ebx			;calculate squares and store in consecutive array elements
	;mul	ebx
	mov  eax, [ebp+16]
	mov	[edi],eax
	;add	edi,4
	;inc	ebx
	;loop	again
	
	pop	ebp
	ret	8
fillArray	ENDP


showList	PROC
	push	ebp
	mov	ebp,esp
	mov	ecx,[ebp+8]		;count in ecx
	mov	esi,[ebp+12]		;address of array in esi
	mov	edx, 0


more:
	mov	eax,[esi+edx*4]			;display n
	call WriteDec
	
	;mWriteStr prompt
	
	;mov	temp, eax
	;mWriteStr temp
     ;mWriteStr spacer
	inc	edx
	loop	more
	
	pop	ebp
	ret	8
showList	ENDP

END main
