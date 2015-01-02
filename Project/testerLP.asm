TITLE DemoString     (demo6.asm)

INCLUDE Irvine32.inc

.data
str1	   BYTE	 "Introduction",0

.code
main PROC

mov	   esi, OFFSET str1
add	   esi, 5
mov	   ecx, 4

more1:
    lodsb
	   call	 WriteChar
	   loop	 more1

	   mov	 ecx, 4
	   std
more2:
    lodsb
    call	  WriteChar
    loop	  more2



main ENDP

END main
