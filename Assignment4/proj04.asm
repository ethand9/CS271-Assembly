TITLE Composite Number Calculator     (proj04.asm)

; Author: Ethan Duong
; Course / Project ID: CS 271 Program 3                       Date: 2/16/19
; Description: This program outputs the composite numbers from user input

INCLUDE Irvine32.inc

; (insert constant definitions here)
INPUT_LOWER_BOUND = 1	; lower bound for valid input
INPUT_UPPER_BOUND = 400 ; upper bound for valid input

.data
; Messages
welcomeMsg		BYTE	"My name is Ethan Duong and this is the composite number calculator.", 0dh, 0ah, 0
getName			BYTE	"Please enter your name: ", 0
greetMsg1		BYTE	"Hello, ", 0
greetMsg2		BYTE	", welcome to my program.", 0dh, 0ah, 0
getNumMsg		BYTE	"Enter the number of composite numbers you would like to see (1-400).", 0dh, 0ah, 0
invalidInput	BYTE	"That is not a valid input. Please enter a positive integer from 1-400 (inclusive).", 0dh, 0ah, 0
oneSpace		BYTE	" ", 0
threeSpaces		BYTE	"   ", 0
byeMsg			BYTE	"Thank you for using my program, ", 0
ecMsg			BYTE	"EC: I aligned the columns.", 0dh, 0ah, 0
; variables
userName		BYTE	101		DUP (0)	; user's name
userNum			DWORD	?				; user's integer input
currentComp		DWORD	4				; number to check for composites
currentOutput	DWORD	0				; number of outputs on the current line
currentTermNum	DWORD	1				; the current term number
currentLineNum	DWORD	1				; the current line number

.code
main					PROC
	call	intro					; intro message to the project
	call	getNum					; get input and validate
	call	calculateCompositeNums	; calculate the composite numbers from user input
	call	goodbye					; say goodbye
	exit	; exit to operating system
main					ENDP

; (insert additional procedures here)
intro					PROC ; intro message to the project
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
	ret
intro					ENDP

getNum					PROC ; get user's number and validate
	mov		edx, OFFSET getNumMsg
	call	WriteString
	call	ReadDec
	call	validateNum ; check if input is valid
	ret
getNum					ENDP

validateNum				PROC
	; if not within 1-400 then get new input
	cmp		eax, INPUT_UPPER_BOUND
	jg		inputAgain
	cmp		eax, INPUT_LOWER_BOUND
	jl		inputAgain
	ret

	inputAgain: ; get new user input
		mov		edx, OFFSET invalidInput
		call	WriteString
		call	CrLf
		call	getNum
		ret
validateNum				ENDP

calculateCompositeNums	PROC ; find and display the composite numbers
	mov		ecx, eax ; move user num into number of times to loop
	displayCompsLoop: ; find the next comp number and print a newline if 10 terms
		call	checkComp  ; get composite number
		call	checkStyle ; check if need space or newline
		loop	displayCompsLoop
	ret
calculateCompositeNums	ENDP

checkComp				PROC ; calculate the composite numbers
	checkStart: ; the start of the checks
		; check if num is divisible by 2
		xor     edx, edx
		mov     eax, currentComp
		mov     ebx, 2
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 3
		xor     edx, edx
		mov     eax, currentComp
		mov     ebx, 3
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 5
		xor     edx, edx
		mov     eax, currentComp
		cmp		eax, 5
		jle		notDiv
		mov     ebx, 5
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 7
		xor     edx, edx
		mov     eax, currentComp
		cmp		eax, 7
		jle		notDiv
		mov     ebx, 7
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 11
		xor     edx, edx
		mov     eax, currentComp
		cmp		eax, 11
		jle		notDiv
		mov     ebx, 11
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 13
		xor     edx, edx
		mov     eax, currentComp
		cmp		eax, 13
		jle		notDiv
		mov     ebx, 13
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 17
		xor     edx, edx
		mov     eax, currentComp
		cmp		eax, 17
		jle		notDiv
		mov     ebx, 17
		div     ebx
		cmp		edx, 0
		je		isComposite
		; check if div by 19
		xor     edx, edx
		mov     eax, currentComp
		cmp		eax, 19
		jle		notDiv
		mov     ebx, 19
		div     ebx
		cmp		edx, 0
		je		isComposite
		
	notDiv: ; not divisible by any of the above
		inc		currentComp
		jmp		checkStart

	isComposite: ; number is a composite
		mov		eax, currentComp
		call	WriteDec
		mov		edx, OFFSET threeSpaces
		call	WriteString
		inc		currentComp
		inc		currentOutput
		ret
checkComp				ENDP

checkStyle				PROC ; add space or newline if necessary
	; if first line and 2nd, 3rd, 4th, or 5th term add space
	cmp		currentLineNum, 2
	jge		fifthTerm
	cmp		currentTermNum, 1
	je		addSpace1
	cmp		currentTermNum, 2
	je		addSpace1
	cmp		currentTermNum, 3
	je		addSpace1
	cmp		currentTermNum, 4
	je		addSpace1
	; if 5th term and before line 8 add space
	fifthTerm:
	cmp		currentLineNum, 8
	jge		secondTerm
	cmp		currentTermNum, 4
	je		addSpace5
	; if 6th term and before line 8 add space
	sixthTerm:
	cmp		currentLineNum, 8
	jge		secondTerm
	cmp		currentTermNum, 5
	je		addSpace6
	; if 7th term and before line 8 add space
	seventhTerm:
	cmp		currentLineNum, 8
	jge		secondTerm
	cmp		currentTermNum, 6
	je		addSpace7
	; if 8th term and before line 8 add space
	eighthTerm:
	cmp		currentLineNum, 8
	jge		secondTerm
	cmp		currentTermNum, 7
	je		addSpace8
	; if 9th term and before line 8 add space
	ninthTerm:
	cmp		currentLineNum, 8
	jge		secondTerm
	cmp		currentTermNum, 8
	je		addSpace9
	; if 10th term and before line 8 add space
	tenthTerm:
	cmp		currentLineNum, 8
	jge		secondTerm
	cmp		currentTermNum, 9
	je		addSpace10
	; if 2nd term and before line 9 add a space
	secondTerm:
	cmp		currentLineNum, 9
	jge		checkNewline
	cmp		currentTermNum, 1
	je		addSpace2
	; if 3rd term and before line 9 add a space
	thirdTerm:
	cmp		currentLineNum, 9
	jge		checkNewline
	cmp		currentTermNum, 2
	je		addSpace3
	; if 4th term and before line 9 add a space
	fourthTerm:
	cmp		currentLineNum, 9
	jge		checkNewline
	cmp		currentTermNum, 3
	je		addSpace4
	checkNewline: ; if 10 terms in the line print newline
	cmp		currentOutput, 10
	je		printNewline
	newlineExit: ; continue after printing newline
	inc		currentTermNum
	ret

	addSpace1: ; space for 1st term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		fifthTerm
	addSpace2: ; space for 2nd term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		thirdTerm
	addSpace3: ; space for 3rd term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		fourthTerm
	addSpace4: ; space for 4th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		checkNewline
	addSpace5: ; space for 5th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		sixthTerm
	addSpace6: ; space for 6th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		seventhTerm
	addSpace7: ; space for 7th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		eighthTerm
	addSpace8: ; space for 8th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		ninthTerm
	addSpace9: ; space for 9th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		tenthTerm
	addSpace10: ; space for 10th term
		mov		edx, OFFSET oneSpace
		call	WriteString
		jmp		secondTerm
	printNewline: ; print a newline
		call	CrLf
		mov		currentOutput, 0  ; reset counter
		mov		currentTermNum,	0 ; reset counter
		inc		currentLineNum
		jmp		newlineExit
checkStyle				ENDP

goodbye					PROC ; say goodbye
	call	CrLf
	mov		edx, OFFSET byeMsg
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	ret
goodbye					ENDP

END main
