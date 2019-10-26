TITLE Sum & Average Calculator    (proj3.asm)

; Author: Ethan Duong
; Course / Project ID: CS 271 Program 3            Date: 1/22/19
; Description: This program will print the sum, number of inputs, and average of numbers

INCLUDE Irvine32.inc

; (insert constant definitions here)
INPUT_LOWER_BOUND = -100 ; lower bound for valid input
INPUT_UPPER_BOUND = -1   ; upper bound for valid input

.data
; Messages
welcomeMsg		BYTE	"My name is Ethan Duong and this program will add togeher numbers until a positive number is entered.", 0dh, 0ah, 0
getName			BYTE	"Please enter your name: ", 0
greetMsg1		BYTE	"Hello, ", 0
greetMsg2		BYTE	", welcome to my program.", 0dh, 0ah, 0
getAddend		BYTE	"Please enter an integer to add from -100 to -1 (inclusive) or enter a nonnegative number to exit.", 0dh, 0ah, 0
loopCountMsg	BYTE	"Number of negative numbers entered: ", 0
sumTotalMsg		BYTE	"Sum of all negative numbers: ", 0
averageMsg		BYTE	"The rounded average is: ", 0
byeMsg			BYTE	"Thank you for using my program, ", 0
noNegativeMsg	BYTE	"No negative numbers were entered.", 0dh, 0ah, 0
errorMsg		BYTE	"You must enter a number from -100 to -1 (inclusive).", 0dh, 0ah, 0
lineNum1		BYTE	"Line #", 0 
lineNum2		BYTE	": ", 0
ecMsg			BYTE	"EC: I did the extra credit for line numbers.", 0dh, 0ah, 0
; variables
userName		BYTE	101		DUP (0)	; user's name
addendNum		DWORD	?				; user's number to add
sumTotal		DWORD	0				; total of numbers
loopCounter		DWORD	0				; number of times loop has counted
loopCounter2	DWORD	1				; loop counter + 1
quotientNum		DWORD	?				; quotient of division
remainderNum	DWORD	?				; remainder of division
roundBound		DWORD	?				; bound for rounding numbers

.code
main PROC
		; display author's name and title of project
		mov		edx, OFFSET ecMsg
		call	WriteString
		mov		edx, OFFSET welcomeMsg
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

	getAddendLabel: ; get user's number
		mov		edx, OFFSET getAddend
		call	WriteString
		mov		edx, OFFSET lineNum1
		call	WriteString
		mov		eax, loopCounter2
		call	WriteDec
		mov		edx, OFFSET linenum2
		call	WriteString
		call	ReadInt

		; if not positive, exit loop
		cmp		eax, INPUT_UPPER_BOUND
		jg		sumEnd
		cmp		eax, INPUT_LOWER_BOUND
		jl		invalidInput

		; if valid, add to total and increase counter
		add		sumTotal, eax
		inc		loopCounter
		inc		loopCounter2
		jmp		getAddendLabel ; back to beginning of loop

	sumEnd: ; print results or skip if none
		; if did not add anything then skip
		call	CrLf
		cmp		loopCounter, 0
		je		noLoops

		; print number of numbers entered
		mov		edx, OFFSET loopCountMsg
		call	WriteString
		mov		eax, loopCounter
		call	WriteDec
		call	CrLf

		; print sum
		mov		edx, OFFSET sumTotalMsg
		call	WriteString
		mov		eax, sumTotal
		call	WriteInt
		call	CrLf

		; calculate bound for rounding
		mov		eax, loopCounter
		cdq
		mov		ebx, 2
		div		ebx
		mov		roundBound, eax

		; calculate average
		neg		sumTotal
		mov		eax, sumTotal
		cdq
		mov		ebx, loopCounter
		div		ebx
		mov		quotientNum, eax
		mov		remainderNum, edx

		; if remainder is greater than or equal to half the divisor
		mov		ebx, remainderNum
		cmp		ebx, roundBound
		jge		roundNum

	printQuotient: ; print rounded answer
		mov		edx, OFFSET averageMsg
		call	WriteString
		mov		al, '-'
		call	WriteChar
		mov		eax, quotientNum
		call	WriteDec
		call	CrLf

	sayGoodbye: ; goodbye then end
		call	CrLf
		mov		edx, OFFSET byeMsg
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString
		call	CrLf
		exit	; exit to operating system



	noLoops: ; user did not enter any negative numbers
		mov		edx, OFFSET noNegativeMsg
		call	WriteString
		jmp		sayGoodbye

	invalidInput: ; user entered number below -100
		mov		edx, OFFSET errorMsg
		call	WriteString
		jmp		getAddendLabel

	roundNum: ; round up quotient
		inc		quotientNum
		jmp		printQuotient

main ENDP

END main
