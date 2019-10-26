TITLE Fibonacci Sequence     (proj02.asm)

; Author: Ethan Duong
; Course / Project ID : CS271 Program 2               Date: 1/15/19
; Description: This program will print out the fibonacci series

 INCLUDE Irvine32.inc

.data
; Messages
welcomeMsg		BYTE	"My name is Ethan Duong and this program will print the fibonacci series.", 0dh, 0ah, 0
getName			BYTE	"Please enter your name: ", 0
greetMsg1		BYTE	"Hello, ", 0
greetMsg2		BYTE	", welcome to my program.", 0dh, 0ah, 0
getTermNum		BYTE	"Please enter how many terms you would like to print (1-46).", 0dh, 0ah, 0
fibStart		BYTE	"Fibonacci Sequence:", 0dh, 0ah, 0
errorMsg		BYTE	"Please enter an integer from 1-46.", 0dh, 0ah, 0
byeMsg			BYTE	"Thank you for using my program, ", 0
ecMsg			BYTE	"EC: I did the extra credit for aligning the numbers.", 0dh, 0ah, 0
oneSpace		BYTE	" ", 0
fiveSpaces		BYTE	"     ", 0
fifteenSpaces	BYTE	"               ", 0
; Variables
termNum			DWORD	?				; number of terms
termCount		DWORD	1				; number of printed terms in line
lineNum			DWORD	1				; number of lines printed
userName		BYTE	101		DUP (0)	; user's name
fib1			DWORD	0				; Fibonacci addend 1
fib2			DWORD	0				; Fibonacci addend 2
fibAns			DWORD	1				; Fibonacci answer
numOfSpaces		DWORD	5				; number of spaces needed to align

.code
main PROC
	; display author's name and title of project
	; mov		edx, OFFSET ecMsg
	; call	WriteString
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

	getNumLabel:
		; get integer for number of terms to print
		mov		edx, OFFSET getTermNum
		call	WriteString
		call	ReadDec
		mov		termNum, eax

		; if input is not within 1-46 or invalid then jump
		cmp		termNum, 1
		jl		inputError ; jump to print error message
		cmp		termNum, 46
		jg		inputError ; jump to print error message
		call	CrLf

		; calculate and print fibonacci sequence
		mov		edx, OFFSET fibStart
		sub		termNum, 1				; always print 1 at start so minus 1 from counter
		; if counter is 0 then don't loop and jump to end
		cmp		termNum, 0
		je		fibEnd					
		; set up loop and print first term
		mov		ecx, termNum ; loop for number of terms requested
		mov		eax, fibAns
		call	WriteDec
		mov		edx, OFFSET fiveSpaces
		call	WriteString

		fibLoopStart:
			; second addend replaces first
			mov		eax, fib2
			mov		fib1, eax
			; answer replaces second addend
			mov		eax, fibAns
			mov		fib2, eax
			; add together to get answer and print
			mov		eax, fib1
			add		eax, fib2
			mov		fibAns, eax
			call	WriteDec
			inc		termCount	; add one to number of terms in line

			; print five spaces
			mov		edx, OFFSET fiveSpaces
			call	WriteString
			; if fifth term then newline
			cmp		termCount, 5
			je		resetCounter			
			continueSeq: ; continue after printing newline
				loop	fibLoopStart

		fibEnd: ; label for skipping the loop
			call	CrLf
			call	CrLf

			; say goodbye
			mov		edx, OFFSET byeMsg
			call	Writestring
			mov		edx, OFFSET userName
			call	WriteString

			exit	; exit to operating system

	inputError: ; input is not within 1-46
		mov		edx, OFFSET errorMsg
		call	WriteString
		call	CrLf
		jmp		getNumLabel ; get input again

	; unused code
	printSpaces:
		cmp		lineNum, 1
		je		line1or2
		printSpacesContinue:
			mov		edx, OFFSET oneSpace
			call	WriteString
			loop	printSpacesContinue
			mov		ecx, ebx ; move loop iteration back into ecx
			; jmp		continueNewline

	; unused code
	line1or2:
		mov		ebx, ecx	; store loop iteration in ebx
		mov		ecx, 15
		mov		edx, OFFSET fifteenSpaces
		call	WriteString
		;jmp		continueNewline
		;jmp		printSpacesContinue


	resetCounter: ; reset the counter, print newline, then continue
		mov		termCount, 0	; reset counter
		inc		lineNum			; add 1 to number of lines
		call	CrLf
		jmp		continueSeq

main ENDP

END main
