TITLE Random Array Sorter     (proj05.asm)

; Author: Ethan Duong
; Course / Project ID: CS 271 Program 5                 Date: 2/22/19
; Description: This program will generate a random set of numbers and sort them.

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN = 10		; lower bound for user input
MAX = 200		; upper bound for user input
LO = 100		; lower bound for random integers
HI = 999		; upper bound for random integers
MAX_SIZE = 200  ; max size for array and string

.data
; Messages
welcomeMsg		BYTE	"My name is Ethan Duong and this is the random array sorter.", 0dh, 0ah, 0
descMsg			BYTE	"The random integers will be created from 100-999.", 0dh, 0ah, 0
getName			BYTE	"Please enter your name: ", 0
greetMsg1		BYTE	"Hello, ", 0
greetMsg2		BYTE	", welcome to my program.", 0dh, 0ah, 0
getNumMsg		BYTE	"Please enter the number of terms you would like to create (10-200).", 0dh, 0ah, 0
invalidInput	BYTE	"That is not a valid input. Please enter a positive integer from 10-200 (inclusive).", 0dh, 0ah, 0
comma			BYTE	", ", 0
unsortedMsg		BYTE	"Unsorted List:", 0dh, 0ah, 0
sortedMsg		BYTE	"Sorted List:", 0dh, 0ah, 0
medianMsg		BYTE	"The median is: ", 0
evenMedianMsg	BYTE	"The rounded median is: ", 0
byeMsg			BYTE	"Thank you for using my program, ", 0
; variables
userName		BYTE	MAX_SIZE	DUP(0)	; user's name
termNum			DWORD	?					; the number of terms to create
isBadInput		DWORD	1					; bool for if the input is invalid
integerList		DWORD	MAX_SIZE	DUP(?)	; array of random integers
listCounter		DWORD	0					; number of terms output

.code
main			PROC
	call	Randomize	 ; randomize the numbers
	call	introduction ; intro message to the project

	invalidInputLabel:
		; get the number of terms to create
		push	OFFSET termNum
		call	getData
		; validate the user's input
		push	termNum
		push	OFFSET isBadInput
		call	validateNum
		cmp		isBadInput, 1
		je		invalidInputLabel

	; put random numbers into array
	push	termNum
	push	OFFSET integerList
	push	listCounter
	call	fillArray

	; display unsorted list
	call	CrLf
	mov		edx, OFFSET unsortedMsg
	call	WriteString
	push	termNum
	push	OFFSET integerList
	push	listCounter
	call	displayList

	; bubble sort the list
	push	termNum
	push	OFFSET integerList
	call	sortList

	; calculate and display median
	push	termNum
	push	OFFSET integerList
	call	displayMedian

	; display sorted list
	call	CrLf
	mov		edx, OFFSET sortedMsg
	call	WriteString
	push	termNum
	push	OFFSET integerList
	push	listCounter
	call	displayList

	call	goodbye	; say goodbye

	exit	; exit to operating system
main			ENDP

;---------------------------------------------------
; greets user and gives description of program
;
; registers used: edx, ecx
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
introduction	PROC
	; display author's name and title of project
	;mov		edx, OFFSET ecMsg
	;call	WriteString
	mov		edx, OFFSET welcomeMsg
	call	WriteString
	mov		edx, OFFSET descMsg
	call	WriteString
	call	CrLf

	; get name and greet user with a max of 100 char
	mov		edx, OFFSET getName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 101
	call	ReadString
	mov		edx, OFFSET greetMsg1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET greetMsg2
	call	WriteString
	call	CrLf
	ret
introduction	ENDP

;---------------------------------------------------
; gets an input from user
;
; registers used: ebp, esp, edx, eax
; Receives: address of termNum
; Returns: user input in termNum
;---------------------------------------------------
getData			PROC ; get the number of terms to create
	push	ebp
	mov		ebp, esp
	mov		edx, OFFSET getNumMsg
	call	WriteString
	call	ReadDec
	mov		ebx, [ebp+8] ; termnum address to ebx
	mov		[ebx], eax
	pop		ebp
	ret		4
getData			ENDP

;---------------------------------------------------
; checks if user input is an integer within 10-200
; 
; registers used: ebp, esp, ebx, eax,
; Receives: value of termNum, address of isBadInput
; Returns: bool of isBadInput
;---------------------------------------------------
validateNum		PROC
	; if not within 10-200 then get new input
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+12] ; move input address to ebx
	cmp		ebx, MAX
	jg		inputAgain
	cmp		ebx, MIN
	jl		inputAgain
	mov		ebx, [ebp+8] ; isBadData address to ebx
	mov		eax, 0
	mov		[ebx], eax
	pop		ebp
	ret		8

	inputAgain: ; get new user input
		mov		edx, OFFSET invalidInput
		call	WriteString
		call	CrLf
		pop		ebp
		ret		8
validateNum		ENDP

;---------------------------------------------------
; fills the array with integers from 100-999 up to
; the number that the user has specfified
; registers used: ebp, esp, eax, edi
; Receives: value of listCounter, address of integerList, value of termNum
; Returns: integerList with random integers
;---------------------------------------------------
fillArray		PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12] ; array address to edi
	mov		ecx, [ebp+16] ; termnum to ecx

	createElement:
		; create random integer from 100-999
		mov		eax, 900
		call	RandomRange
		add		eax, 100
		; move that integer into the next index
		mov		[edi], eax
		add		edi, 4
		loop	createElement

	pop		ebp
	ret		12
fillArray		ENDP

;---------------------------------------------------
; bubble sort a list of integers from high to low
;
; registers used: ebp, esp, ecx, edi, eax
; Receives: address of integerList, value of termNum
; Returns: integerList sorted from high to low
;---------------------------------------------------
sortList		PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+12]	; termnum to ecx
	dec		ecx	
	; bubble sort:
	L1:
		push	ecx
		mov		edi, [ebp+8]	; first element to edi

	L2:
		mov		eax, [edi]		; move current array element to eax
		cmp		[edi+4], eax	; if [ESI] >= [ESI+4], do not swap
		jl		L3				
		xchg	eax, [edi+4]	; swap the elements
		mov		[edi], eax	
	
	L3:
		add		edi, 4			; next element
		loop	L2				; inner loop
		pop		ecx
		loop	L1				; else repeat outer loop

	pop		ebp
	ret		8
sortList		ENDP

;---------------------------------------------------
; finds the median of an array and displays it
;
; registers used: ebp, esp, edx, eax, ebx, edi
; Receives: value of termNum, address of integerList
; Returns: nothing
;---------------------------------------------------
displayMedian	PROC
	; local variables for finding median
	LOCAL tempNum:DWORD, evenMedian1:DWORD, evenMedian2:DWORD

	call	CrLf
	call	CrLf
	push	ebp
	mov		ebp, esp
	; check if number of elements is even or odd
	xor		edx, edx
	mov		eax, [ebp+28]	; termNum to eax
	mov		tempNum, eax	; termNum to tempNum
	mov		ebx, 2
	div		ebx
	cmp		edx, 0
	je		evenLabel

	; odd # of elements
	; find median with ((tempNum - 1)/2)*4
	mov		eax, tempNum
	dec		eax
	cdq
	mov		ebx, 2
	div		ebx
	mov		ebx, 4
	mul		ebx
	; display median
	mov		edi, [ebp+24]	; first element to edi
	mov		eax, [edi+eax]  ; address of median to eax
	mov		edx, OFFSET medianMsg
	call	WriteString
	call	WriteDec
	jmp		endLabel

	evenLabel: ; even # of elements
	; find median with (edi@(tempNum/2) + edi@((tempNum/2)+1))/2
	mov		eax, tempNum
	cdq
	mov		ebx, 2
	div		ebx
	dec		eax
	mov		evenMedian1, eax
	inc		eax
	mov		ebx, 4
	mul		ebx
	mov		evenMedian2, eax ; relative address of second median
	mov		eax, evenMedian1
	mov		ebx, 4
	mul		ebx
	mov		evenMedian1, eax ; relative address of first median

	; get values of elements
	mov		edi, [ebp+24]	; first element to edi
	mov		ebx, evenMedian1
	mov		eax, [edi+ebx]  ; address of median1 to eax
	mov		ebx, evenMedian2
	add		eax, [edi+ebx]	; add median2
	cdq
	mov		ebx, 2
	div		ebx				; average them
	cmp		edx, 1
	je		round

	; display median
	mov		edx, OFFSET medianMsg
	call	WriteString
	call	WriteDec
	jmp		endLabel

	round: ; round up then display
	mov		edx, OFFSET evenMedianMsg
	call	WriteString
	inc		eax
	call	WriteDec

	endLabel:
	call	CrLf
	pop		ebp
	ret		8
displayMedian	ENDP

;---------------------------------------------------
; displays the contents of an array
;
; registers used: ebp, esp, ebx, esi, ecx, eax
; Receives: value of listCounter, address of integerList, value of termNum
; Returns: nothing
;---------------------------------------------------
displayList		PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+8]  ; listCount to ebx
	mov		esi, [ebp+12] ; array address to esi
	mov		ecx, [ebp+16] ; termnum to ecx

	displayElement:
		mov		eax, [esi]  ; current element to eax
		call	WriteDec
		;call	CrLf
		mov		edx, OFFSET comma
		call	WriteString
		add		esi, 4		; next element
		; check if need to print newline
		inc		ebx			; add 1 to number of terms printed on line
		cmp		ebx, 10
		je		printNewline

		loopEnd:
		loop	displayElement

	pop		ebp
	ret		12

	printNewline:
		call	CrLf
		mov		ebx, 0
		jmp		loopEnd
displayList		ENDP

;---------------------------------------------------
; says goodbye to user
;
; registers used: edx
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
goodbye			PROC
	call	CrLf
	call	CrLf
	mov		edx, OFFSET byeMsg
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	ret
goodbye			ENDP


END main
