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

title1of3		BYTE	"Sorting Random Integers", 0 ;name of the program displayed at the start
title2of3		BYTE	"Programmed by Ian Paul", 0  ;name of programmer

;prompt to let the user know how the program works
title3of3		BYTE	"This program generates random numbers in the range [100...999],", 0dh, 0ah, 
				"displays the original list, sortst the list, and calculates the", 0dh, 0ah,
				"median value. Finally, it displays the list sorted in descending order. ", 0 

prompt1of1		     BYTE	"How many numbers should be generated? [10...200]:  ", 0 ;prompt to ask how many numbers to be printed
errorMessage1of1		BYTE	"Invalid Input", 0								  ;respons if user number is out of range
unsortedListTitle		BYTE	"The unsorted random numbers: ", 0	  				  ;display title of all the randoms generated
medianTitle		     BYTE	"The median is: ", 0							  ;display title of the median
sortedListTitle		BYTE	"The sorted list: ", 0							  ;display title of the sorted list of randoms

randomArray	DWORD	200 DUP(?)	; max size for array is 200. The capacity will be determined later by the user 
userNumber	DWORD	?			; will be capacity, num of elements in array 
medianINDEX  	DWORD	?			; variable for index value of median 
medVALUE		DWORD	?			; variable for value of median 

count		DWORD	-1			; start at -1 because we start the procedure by inc, so it goes to 0
count1		DWORD	-1			; start at -1 because we start the procedure by inc, so it goes to 0

tempValue		DWORD	0			; temp value to hold request 
lineMod		DWORD	10			; used to print 10 numbers per line 
remain1		DWORD	?			; variable to hold remainder for testing 
remain2		DWORD	?			; used for median 


.code
main PROC



; (insert executable instructions here)

call	RANDOMIZE					; assigment notes say to call at beginning of main, Randomize Procedure in Irvine Library 

;push intro variables for title procedure
	push	OFFSET	title1of3		
	push	OFFSET	title2of3		
	push	OFFSET	title3of3		
	call	introductionPro			

;push prompts for get data procedure
	push	OFFSET prompt1of1		 
	push	OFFSET errorMessage1of1		
	push	OFFSET userNumber		
	call	getDataPro				

;push for filling the array with random numbers
	push	OFFSET	randomArray		
	push	userNumber			
	call	fillArrayPro				

;display random array list title
    call crlf
    mov edx, OFFSET unsortedListTitle
    call	writestring 
    call crlf

;push array to be able to display it 	
	push	OFFSET	randomArray		
	push	userNumber				
	call	displayListPro			

;push array and other variables to sort the random number array		
	push	OFFSET randomArray		
	push tempValue				
	push	count1				
	push	userNumber			
	call	sortListPro				

;display sorted array list title
    call crlf
    mov  edx, OFFSET sortedListTitle			
    call crlf
    call writestring 

;push the radom array that is now sorted to be displayed
    push	OFFSET	randomArray		
    push	userNumber					
    call	displaySortedListPro


;display median title
    call crlf
    mov  edx, OFFSET medianTitle			
    call crlf
    call writestring 
    
;push the random aray and other variables to calculate and display the median
    push	OFFSET	randomArray		
    push	userNumber			
    push	OFFSET medianTitle			
    push remain2				
    push medianIndex				
    call	displayMedianPro			



	exit		; exit to operating system
main ENDP

; (insert additional procedures here)


;introductionPro Introduction Procedure

; ************************************************************************************ ;
; This procedure takes the intro variables and then displays them                      ;
; ************************************************************************************ ;
introductionPro PROC 
	push	ebp					 
	mov		ebp, esp			
	mov		edx, [ebp+16]		;prints title1of3
	call	writeString 
	call	crlf
	call	crlf 
	mov		edx, [ebp+12]		;prints title2of3
	call	writeString 
	call	crlf 
	call	crlf
	mov		edx, [ebp+8]		;prints title3of3
	call	writeString 
	call	crlf 
	call	crlf
	pop		ebp				
	ret		12
introductionPro ENDP


;getDataPro Get Data Procedure

; *********************************************************************************************** ;
; This procedure gets the user's number, checks it against the MIN and MAX, prints an error       ;
; message if the user number is outside of the MIN or MAX, and stores the number if it is         ;
; within the MIN and MAX                                                                          ;
; *********************************************************************************************** ;
getDataPro PROC 
	push	ebp						
	mov		ebp, esp				
getDataLoop: 
	mov		edx, [ebp+16]		;prints prompt1of1	 
	call		Writestring			
	call		readInt			;gets the user input	 
	cmp		eax, MIN			;compares user input to MIN	
	jl		errorMessage			
	cmp		eax, MAX			;compares user input to MAX	
	jg		errorMessage			
	mov		ebx, [ebp+8]			
	mov		[ebx], eax			  
	jmp		afterLoopJump				

errorMessage: 
	call	crlf
	mov		edx, [ebp+12]		;prints the error message if outside of MIN and MAX	 
	call	writeString 
	call	crlf
	call	crlf
	jmp		getDataLoop

afterLoopJump: 
	pop		ebp					
	ret		12					
getDataPro ENDP


;fillArrayPro Fill Array Procedure

; ****************************************************************** ;
; This procedure fills the array with random numbers bassed on how   ;
; many numbers the user requested earlier then saves the array.      ;
; uses RandomRange from library                                      ;
; ****************************************************************** ;
fillArrayPro PROC 
	push	ebp						
	mov		ebp, esp				 
	mov		ecx, [ebp+8]			 
	mov		edi, [ebp + 12]		 
fillArrayLoop: 
	mov		eax, HI					
	sub		eax, LO				
	inc		eax 
	call	RandomRange				 
	add		eax, LO				
	mov		[edi], eax	;moves the random number into array		 
	add		edi, 4				 
	loop	fillArrayLoop
	
	pop ebp						 
	ret 8
fillArrayPro ENDP


;displayListPro

; *************************************************************** ;
; This procedure displays the array that contains all the random  ;
; numbers that were created earlier                               ;
; *************************************************************** ;
displayListPro PROC 
	push	 ebp					 
	mov	 ebp, esp				
	mov	 esi, [ebp+12]			 
	mov	 ecx, [ebp+8]
	mov	 eax, 1
	mov	 count, eax			 

    addLoop: 
	    mov		eax, [esi]		
	    call	writeDec 
	    mov		eax, count		
	    cdq
	    div		lineMod			
	    mov		remain1, edx		
	    cmp		remain1, 0
	    jne		tabber
	    je		newliner
	
    newLiner:					 ;adds a new line when 10 numbers have been printed 
	    call crlf
	    jmp  secondPartOfLoop

    tabber: 
	    mov		al, TAB		 ;adds a tab between numbers	 
	    call	writeChar

secondPartOfLoop:
	inc		count			 
	add		esi, 4			 
	loop	addLoop

endPro: 	
	pop		ebp
	ret		12
displayListPro ENDP


;sortListPro

; *************************************************************** ;
; This procedure takes the array and then sorts it from highest   ; 
; to lowest, then saves it in the array                           ;
; *************************************************************** ;

sortListPro PROC				 ;compares each number to its next neighbor, swaps them if the second is greater than the first
	push ebp
	mov ebp, esp
	mov esi, [ebp+16]			 
	mov ebx, [ebp+12]			
	mov eax, [ebp+8]								
	dec eax					
	mov [ebp+12], eax			

    upperLoop:
	   inc esi
	   mov edi, [ebp+16]			
	   mov eax, [ebp+8]			
	   cmp esi, eax			 
	   je endOfLoops					

    lowerLoop:
	    mov ebx, [ebp+12]			 
	    inc edi					   
	    cmp edi, ebx				
	    je upperLoop				

compare:
	mov eax, [randomArray + edi * 4]		    
	mov ebx, [randomArray + edi * 4 + 4]	   
	cmp ebx, eax					    
	jle lowerLoop					    

swapper:
	mov [randomArray + edi * 4], ebx		     
	mov [randomArray + edi * 4 + 4], eax	    
	jmp lowerLoop

endOfLoops:
	pop ebp
	ret 16
sortListPro ENDP


;displaySortedListPro Display Sorted List Procedure

; ******************************************************* ;
; This procedure displays the sorted list from the array  ;
; ******************************************************* ;
displaySortedListPro PROC                 
	push ebp					
	mov	ebp, esp				 
	mov	esi, [ebp+12]			
	mov  ecx, [ebp+8]
	call crlf
	mov	eax, 1
	mov	count, eax			 

addNextNumberLoop: 
	mov		eax, [esi]		
	call	writeDec 
	mov		eax, count		
	cdq
	div		lineMod			
	mov		remain1, edx		
	cmp		remain1, 0
	jne		tabber
	je		newLiner
	

	   newLiner:				 ;adds a new line after 10 numbers have been printed
		   call crlf
		   jmp  secondPartOfLoop

	   tabber: 
		   mov		al, TAB	 ;adds a tab between numbers		
		   call	writeChar

secondPartOfLoop:
	inc		count			
	add		esi, 4			
	loop	addNextNumberLoop

endOfPro: 	
	pop		ebp
	ret		12
displaySortedListPro ENDP


;displayMedianPro
							
; ************************************************************************** ;
; This procedure takes the array and calculates the median then displays it. ;
; Two different calculations depending on if the array has an even or odd    ;
; set of numbers                                                             ;
; ************************************************************************** ;

displayMedianPro PROC 
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
	mov	 edx, [ebp+8]			
	mov	 eax, [randomArray + edx*4]	 
	call writeDec                    ;prints the median
	call crlf 
	call crlf 
	jmp	 endOfPro 

printNewMedian:  
	mov	  eax, [ebp+8]
	call writeDec            ;prints the median
	call crlf 
	jmp	  endOfPro

findMedian: 
	mov	  edx, [ebp+8]				    
	mov	  eax, [randomArray + edx * 4]		
	mov	  ebx, [randomArray + edx *4 + 4]	
	add	  eax, ebx
	mov	  ebx, 2
	cdq
	div	  ebx						
	mov	  [ebp+8], eax				
	jmp	  printNewMedian

endOfPro: 
	pop ebp 
	ret 20
displayMedianPro ENDP
	


END main