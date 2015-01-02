TITLE Program Assignment5			(Assignment5.asm)

; Program Description: Prompts ueser for a number between 10 and 200
				  ;Then displays whatever number the user enterd of unsorted random numbers
				  ;their median, and then displays them in a sorted list
; Author: Ian Paul
; Date Created: 11/20/2013
; Last Modification Date:11/24/2013

INCLUDE Irvine32.inc

; (insert symbol definitions here)

;unchangable constants
MIN		= 10
MAX		= 200
LO		= 100
HI		= 999 

.data

; (insert variables here)

sortTitle		BYTE	"Sorting Random Integers", 0 ;name of the program displayed at the start
myName		BYTE	"Programmed by Ian Paul", 0  ;name of programmer

;prompt to let the user know how the program works
runPrompt		BYTE	"This program generates random numbers in the range [100...999],", 0dh, 0ah, 
				"displays the original list, sortst the list, and calculates the", 0dh, 0ah,
				"median value. Finally, it displays the list sorted in descending order. ", 0 

numPrompt		BYTE	"How many numbers should be generated? [10...200]:  ", 0 ;prompt to ask how many numbers to be printed
errPrompt		BYTE	"Invalid Input", 0								  ;respons if user number is out of range
dspLst		BYTE	"The unsorted random numbers: ", 0	  				  ;display title of all the randoms generated
mdian		BYTE	"The median is: ", 0							  ;display title of the median
srtLst		BYTE	"The sorted list: ", 0							  ;display title of the sorted list of randoms

numArray		DWORD	200 DUP(?)	; max size for array is 200. The capacity will be determined later by the user 
userNumber	DWORD	?			; will be capacity, num of elements in array 
medianIDX	  	DWORD	?			; variable for index value of median 
medVAL		DWORD	?			; variable for value of median 

count		DWORD	-1			
count1		DWORD	-1

tempVal		DWORD	0			; temp value to hold request 
lineDiv		DWORD	10			; used to print 10 numbers per line 
remain1		DWORD	?			; variable to hold remainder for testing 
remain2		DWORD	?			; used for median 


.code
main PROC



; (insert executable instructions here)

call	RANDOMIZE					; assigment notes say to call at beginning of main, Randomize Procedure in Irvine Library 

 ;pushes for intro  
	push	OFFSET	sortTitle		
	push	OFFSET	myName		
	push	OFFSET	runPrompt		
	call	introduction			

 ;pushes for get data 
	push	OFFSET numPrompt		 
	push	OFFSET errPrompt		
	push	OFFSET userNumber		
	call	getData				

;pushes for fill array 
	push	OFFSET	numArray		
	push	userNumber			
	call	fillArray				

;pushes for display list 	
	push	OFFSET	numArray		
	push	userNumber			
	push	OFFSET	dspLst		
	call	displayList			

;pushes for sortList		
	push	OFFSET numArray		
	push tempVal				
	push	count1				
	push	userNumber			
	call	sortList				

;pushes for display sorted list 
	push	OFFSET	numArray		
	push	userNumber			
	push	OFFSET	srtLst		
	call	displaysortList

;pushes for display median 
	push	OFFSET	numArray		
	push	userNumber			
	push	OFFSET mdian			
	push remain2				
	push medianIdx				
	call	displayMedian			



	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

; ************************************************************************************ ;
; Procedure to introduce the program										  ;
; Implementation note: accesses introduction variables by pushing them onto the stack  ;
; receives: variables: sortTitle, myName, and runPrompt to introduce the program	  ;
; calls: writestring and crlf												  ;
; registers changed: edx													  ;
; ************************************************************************************ ;
introduction PROC 
	push	ebp					 
	mov		ebp, esp			
	mov		edx, [ebp+16]		
	call	writeString 
	call	crlf
	call	crlf 
	mov		edx, [ebp+12]		
	call	writeString 
	call	crlf 
	call	crlf
	mov		edx, [ebp+8]		
	call	writeString 
	call	crlf 
	call	crlf
	pop		ebp				
	ret		12
introduction ENDP

; *********************************************************************************************** ;
; Procedure to get a number [10...200]												   ;
; Implementation note:	   This procedures access its parameters by seeting up a "stack frame"   ;
;					   and referencing parameters relative to the top of the system stack    ;
; receives: variables: numPrompt, errPrompt											   ;
;		  user data: user request for a number [10....200]                                      ;
; calls:	writeString, readInt                                                                    ;
; returns:  error message if invalid input, or stores valid number                                ;
; preconditions: MINNUM < MAXNUM in order to work                                                 ;
; registers changed: eax, edx, ebx                                                                ;
; *********************************************************************************************** ;
getData PROC 
	push	ebp						
	mov		ebp, esp				
promptLoop: 
	mov		edx, [ebp+16]			 
	call		Writestring			
	call		readInt				 
	cmp		eax, MIN				
	jl		invalidInput			
	cmp		eax, MAX				
	jg		invalidInput			
	mov		ebx, [ebp+8]			
	mov		[ebx], eax			  
	jmp		endloops				

invalidInput: 
	call	crlf
	mov		edx, [ebp+12]			 
	call	writeString 
	call	crlf
	call	crlf
	jmp		promptLoop

endLoops: 
	pop		ebp					
	ret		12					
getData ENDP

; ****************************************************************** ;
; Procedure to fill numArray with random numbers				    ;
; receives: address of array and value of request on system stack    ;
; returns: array with random numbers starting @numArray              ;
; registers changed: eax, ebx, ecx, edi                              ;
; ****************************************************************** ;
fillArray PROC 
	push	ebp						
	mov		ebp, esp				 
	mov		ecx, [ebp+8]			 
	mov		edi, [ebp + 12]		 
again: 
	mov		eax, HI					
	sub		eax, LO				
	inc		eax 
	call	RandomRange				 
	add		eax, LO				
	mov		[edi], eax			 
	add		edi, 4				 
	loop	again
	
	pop ebp						 
	ret 8
fillArray ENDP

; *************************************************************** ;
; Procedure to display the list of unsorted, random numbers.      ;
; receives: address of array and user request on system stack     ;
; returns: list                                                   ;
; preconditions: list is not empty                                ;
; registers changed: eax, ebx, ecx, edi                           ;
; *************************************************************** ;
displayList PROC 
	push	 ebp					 
	mov	 ebp, esp				
	mov	 esi, [ebp+16]			 
	mov	 ecx, [ebp+12]
	mov	 edx, [ebp+8]			 
	call	writestring 
	call crlf
	mov	 eax, 1
	mov	 count, eax			 

moreloop: 
	mov		eax, [esi]		
	call	writeDec 
	mov		eax, count		
	cdq
	div		lineDiv			
	mov		remain1, edx		
	cmp		remain1, 0
	jne		tabloop
	je		newline
	
newLine: 
	call crlf
	jmp  endLoop

tabloop: 
	mov		al, TAB			 
	call	writeChar

endLoop:
	inc		count			 
	add		esi, 4			 
	loop	moreLoop

endMoreLoop: 	
	pop		ebp
	ret		12
disPlayList ENDP
; *************************************************************** ;
; Procedure to sort the array of number in descending order       ;
; receives: address of array and value of count on system stack   ;
; returns: array is sorted after procedure                        ;
; preconditions: array is not empty                               ;
; registers changed: eax, ebx, edi, esi                           ;
; *************************************************************** ;

sortList PROC
	push ebp
	mov ebp, esp
	mov esi, [ebp+16]			 
	mov ebx, [ebp+12]			
	mov eax, [ebp+8]								
	dec eax					
	mov [ebp+12], eax			

outerLoop:
    inc esi
    mov edi, [ebp+16]			
    mov eax, [ebp+8]			
    cmp esi, eax				 
    je endLoop					

innerLoop:
	mov ebx, [ebp+12]			 
	inc edi					   
	cmp edi, ebx				
	je outerLoop				

compare:
	mov eax, [numArray + edi * 4]		    
	mov ebx, [numArray + edi * 4 + 4]	   
	cmp ebx, eax					    
	jle innerLoop					    

swap:
	mov [numArray + edi * 4], ebx		     
	mov [numArray + edi * 4 + 4], eax	    
	jmp innerLoop

endLoop:
	pop ebp
	ret 16
sortList ENDP


; *************************************************************** ;
; Procedure to display the list of sorted, random numbers.        ;
; receives: address of array and user request on system stack     ;
; returns: prints sorted list                                     ;
; preconditions: array is not empty                               ;
; registers changed: eax, ebx, ecx, edi, esi                      ;
; *************************************************************** ;
displaySortList PROC 
	push ebp					
	mov	ebp, esp				 
	mov	esi, [ebp+16]			
	mov  ecx, [ebp+12]
	mov  edx, [ebp+8]			
	call crlf
	call writestring 
	call crlf
	mov	eax, 1
	mov	count, eax			 

moreloop: 
	mov		eax, [esi]		
	call	writeDec 
	mov		eax, count		
	cdq
	div		lineDiv			
	mov		remain1, edx		
	cmp		remain1, 0
	jne		tabloop
	je		newline
	

newLine: 
	call crlf
	jmp  endLoop

tabloop: 
	mov		al, TAB			
	call	writeChar

endLoop:
	inc		count			
	add		esi, 4			
	loop	moreLoop

endMoreLoop: 	
	pop		ebp
	ret		12
disPlaySortList ENDP
								
; ***************************************************************
; Procedure to display the value of the median index (calculates in necessary)
; receives: address of array, user request
; returns: prints median value 
; preconditions: 
; registers changed: eax, ebx, edx, edi, esi
; ***************************************************************

displayMedian PROC 
	push ebp 
	mov	 ebp, esp 
	mov	 esi, [ebp+24]			
	mov	 eax, [ebp+20]			
	cdq
	mov	 ebx, 2
	div	 ebx
	mov	 [ebp+8], eax			
	mov	 [ebp+12], edx			
	cmp	 edx, 0
	je	 findMedian
	jne	 printMedian

printMedian: 
	mov	 edx, [ebp+16]			
	call crlf
	call crlf
	call writeString 
	mov	 edx, [ebp+8]			
	mov	 eax, [numArray + edx*4]	 
	call writeDec 
	call crlf 
	call crlf 
	jmp	 endLoop 

printNewMedian: 
	mov	  edx, [ebp+16]
	call crlf 
	call crlf 
	call writeString 
	mov	  eax, [ebp+8]
	call writeDec 
	call crlf 
	jmp	  endLoop

findMedian: 
	mov	  edx, [ebp+8]				    
	mov	  eax, [numArray + edx * 4]		
	mov	  ebx, [numArray + edx *4 + 4]	
	add	  eax, ebx
	mov	  ebx, 2
	cdq
	div	  ebx						
	mov	  [ebp+8], eax				
	jmp	  printNewMedian

endloop: 
	pop ebp 
	ret 20
displayMedian ENDP
	


END main