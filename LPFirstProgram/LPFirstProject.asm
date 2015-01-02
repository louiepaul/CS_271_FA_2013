TITLE Program LPFirstProject			(LPFirstProject.asm)

; Program Description: 
; Author: Ian Paul
; Date Created: 10/14/13
; Last Modification Date:

INCLUDE Irvine32.inc

DOG_FACTOR = 7

; (insert symbol definitions here)

.data

userName	  BYTE	33 DUP(0)	  ;string to be entered by user
userAge	  DWORD	?		  ;integer to be entered by user
intro_1	  BYTE	"Hi, my name is Lassie, and I'm here to tell you your age in dog years!",0
prompt_1	  BYTE	"What's your name? ", 0
intro_2	  BYTE	"Nice to meet you!", 0
prompt_2	  BYTE	"How old are you? ",0
dogAge	  DWORD	?
result_1	  BYTE	"Wow ... that's ", 0
result_2	  BYTE	" in dog years !", 0
goodBye	  BYTE	"Good-bye, ", 0


.code
main PROC

 ; Introduce prgrammer
    mov	  edx, OFFSET intro_1
    call	  WriteString
    call	  CrLf
 ; Get user name
    mov	  edx, OFFSET prompt_1
    call	  WriteString
    mov	  edx, OFFSET userName
    mov	  ecx, 56
    call	  ReadString
 ; Get user age
    mov	  edx, OFFSET prompt_2
    call	  WriteString
    call	  ReadInt
    mov	  userAge, eax

 ; Calculate user "dog years"
    mov	  eax, UserAge
    mov	  ebx, DOG_FACTOR
    mul	  ebx
    mov	  dogAge, eax

 ; Report result
    mov	  edx, OFFSET result_1
    call	  WriteString
    mov	  eax, dogAge
    call	  WriteDec
    mov	  edx, OFFSET result_2
    call	  WriteString
    call	  CrLf

 ; Say "Good-bye"
    mov	  edx, OFFSET goodbye
    call	  WriteString
    mov	  edx, OFFSET userName
    call	  WriteString
    call	  Crlf


	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main