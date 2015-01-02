TITLE Midterm Examination Code (main.asm)

INCLUDE Irvine32.inc

.data
greeting BYTE "Please provide an integer between 2 and 100:",0dh,0ah,0
warning BYTE "The input you provided was not a valid integer between 2 and 100.",0dh,0ah,0
headerPart1 BYTE "Prime factorization of ",0
headerPart2 BYTE ":",0dh,0ah,0
primeNums BYTE 2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97
newLine BYTE 0dh,0ah,0
case1 BYTE " ",0
case2 BYTE " * " ,0
num BYTE ?

.code

main PROC
MOV eax,0
MOV ebx,0
MOV ecx,0
MOV edx,0
CALL Clrscr

promptUser:
CALL ReadDec ; Get an unsigned decimal integer from the user and place it into EAX
MOV num, al
MOV ebx, OFFSET primeNums ; Load the address of the prime number array

topOfLoop:
CMP num, 1
JE finished ; Jump out of the loop if num == 1
MOV ah, 0
MOV al, num
DIV BYTE PTR[ebx] ; Divide AX by the number that ebx is pointing to
; The quotient is now stored in AL and the remainder is in AH
MOV cl, BYTE PTR[ebx]
CMP AH, 0
JNE remNotZero
MOV num, AL
CMP num, 1
JNE qNot1
MOV eax, 0
MOV al, cl
CALL WriteDec
MOV edx, OFFSET case1
CALL WriteString
JMP primePrinted
qNot1:
MOV eax, 0
MOV al, cl
CALL writeDec
MOV edx, OFFSET case2
CALL WriteString

primePrinted:
JMP topOfLoop

remNotZero:
; Point to the next prime number and repeat the loop
ADD ebx,TYPE BYTE; Increment the pointer
JMP topOfLoop

finished:
MOV edx, OFFSET newLine
CALL WriteString
EXIT
main ENDP
END main