TITLE Average Calculator     (proj06a.asm)

; Author: Ethan Duong
; Course / Project ID: CS 271 Program 6                 Date: 3/11/19
; Description: This program will take ten positive integers and average them.

INCLUDE Irvine32.inc

; Macros
;---------------------------------------------------
; prompt user then get a string input from user
;
; registers used: edx, ecx
; Receives: a memory address and a string
; Returns: user's input
;---------------------------------------------------
getString MACRO destination, string
	push	edx
	push	ecx
	displayString string	 ; prompt user
	mov     edx, destination ; receive the input
	mov     ecx, 101		 ; max size
	call    ReadString
	pop		ecx
	pop		edx
ENDM

;---------------------------------------------------
; display the received string
;
; registers used: edx
; Receives: a string
; Returns: nothing
;---------------------------------------------------
displayString MACRO msg1
	push	edx
	mov		edx, OFFSET msg1
	call	WriteString
	pop		edx
ENDM

.data
; Messages
welcomeMsg		BYTE	"Hello user, my name is Ethan Duong and this is the average calculator.", 0dh, 0ah, 0
descMsg			BYTE	"The calculator will take ten non-negative integers and average them.", 0dh, 0ah, 0
getNumMsg		BYTE	"Please enter a non-negative integer you would like to add to the average.", 0dh, 0ah, 0
errorMsg		BYTE	"That is not a valid input. Please enter an unsigned integer that can fit in 32 bits.", 0dh, 0ah, 0
sumMsg			BYTE	"The sum is: ", 0
avgMsg			BYTE	"The average (rounded down) is: ", 0
; variables
userNum			BYTE	20		DUP(?)	; user's input number
sumNum			DWORD	0				; total of inputs
avgNum			DWORD	0				; average of user's input
numArray		DWORD	10		DUP(?)	; array for ints
counter			DWORD	0				; element number

.code
main PROC
	call	introduction		; intro message to the project

	push	counter				; element number
	push	OFFSET	numArray	; array of integer inputs
	push	OFFSET	sumNum		; total of user inputs
	push	OFFSET	userNum		; user's string input
	call	ReadVal				; get ten inputs

	push	OFFSET numArray		; array of integer values from user
	push	OFFSET sumNum		; sum of those integers
	push	OFFSET avgNum		; average of those integers
	call	calculate			; calculate sum and average

	push	OFFSET sumNum		; sum of user's numbers
	push	OFFSET avgNum		; average of user's numbers
	call	WriteVal			; print the sum and average

	exit	; exit to operating system
main ENDP


;---------------------------------------------------
; greets user and gives description of program
;
; registers used: edx
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
introduction	PROC
	push	edx
	; display author's name and title of project
	displayString welcomeMsg
	displayString descMsg
	call	CrLf
	pop		edx
	ret
introduction	ENDP

;---------------------------------------------------
; prompts user to enter ten numbers and converts them from string to int
; the integers are then stored in an array and returned
;
; registers used: ebp, esp, ecx, edx, esi, eax, ebx, al, 
; Receives: counter, numArray, sumNum, userNum
; Returns: numArray with ten of the user's numbers
;---------------------------------------------------
ReadVal			PROC
	; local variables
	LOCAL loopCounter:DWORD, strLen:DWORD; loopCounter:NOT USED, strLen:length of input

	push	ebp
	mov		ebp, esp
	mov		ecx, 10 ; loop for ten numbers
	getNumLabel:	; start of getting a number
	push	ecx		; save counter for later
	redo:			; user needs to get a new input
	getString [ebp+20], getNumMsg	; pass userNum and prompt for input
	mov		strLen, eax				; store the length of input
	cmp     strLen, 10				; fit in 32 bits
	jg      invalidInput			; if bigger then redo

	mov     ecx, eax		; loop for each char in string
	mov     esi, [ebp+20]   ; point at first character
	loopString:             ; loop looks at each char in string
		lodsb				; move input into AL
		cmp		al, 48		; ASCII if less then 0
		jl		invalidInput; redo move
		cmp		al, 57		; ASCII if greater than 9
		jg		invalidInput; redo move
	loop    loopString		; loop for every character

	; convert string to int
	mov		edx, [ebp+20]	; move userNum to edx
    mov     ecx, strLen		; mov length of input to ecx
    call    ParseDecimal32	; converts unsigned demical integer to string into 32-bit binary           
    .IF CARRY?              ; check to see if number is too big
    jmp     getNumLabel     ; if true, get new input
    .ENDIF
    mov     edx, [ebp+28]   ; numArray to edx
    mov     ebx, [ebp+32]   ; element number to ebx
    imul    ebx, 4          ; multiply the count by size of dword to see where to place it
    mov     [edx+ebx], eax  ; put the value into the array

	mov		eax, [ebp+32]	; counter to eax
	inc		eax				; increment the counter
	mov		[ebp+32], eax	; save the number

	pop		ecx				; retrieve the original counter
	loop	getNumLabel		; get another number

	jmp		endLabel		; end procedure

	invalidInput:
		displayString errorMsg ; tell user that input is invalid
	jmp		redo			   ; get another input

	endLabel: ; end procedure
	pop		ebp
	ret		16
ReadVal			ENDP

;---------------------------------------------------
; displays the sum and average
;
; registers used: ebp, esp, eax, ebx
; Receives: avgNum, sumNum
; Returns: nothing
;---------------------------------------------------
WriteVal		PROC
	push	ebp
	mov		ebp, esp
	; display sum
	displayString sumMsg	
	mov		ebx, [ebp+12]	; sumNum to ebx
	mov		eax, [ebx]		; sumNum to eax
	call	WriteDec
	call	CrLf
	; display average
	displayString avgMsg
	mov		ebx, [ebp+8]	; avgNum to ebx
	mov		eax, [ebx]		; avgNum to eax
	call	WriteDec

	pop		ebp
	ret		8
WriteVal		ENDP

;---------------------------------------------------
; calculates the sum and average
;
; registers used: ebp, esp, eax, ebx
; Receives: avgNum, sumNum
; Returns: avgNum, sumNum
;---------------------------------------------------
calculate		PROC
	push	ebp
	mov		ebp, esp

	mov		ecx, 10			; loop ten times, number of elements in array
	mov     edi, [ebp+16]	; array to edi

	sumLoop: ; total of the user's inputs
	mov     eax, [edi]		; put an element from the array to eax
	mov		ebx, [ebp+12]	; sumNum to ebx
	add		[ebx], eax		; add the number to sumNum
	add     edi, 4			; point to next element
	loop	sumLoop

	mov		eax, [ebx]		; sumNum to eax
	cdq
	mov		ebx, 10			; divide sumNum by 10
	div		ebx
	mov		ebx, [ebp+8]	; avgNum to ebx
	mov		[ebx], eax		; average answer to avgNum

	pop		ebp
	ret		12
calculate		ENDP

END main
