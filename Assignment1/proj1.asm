TITLE First Assembly program	(proj1.asm)

;// Author: Ethan Duong
;// Course / Project ID : CS271 program 1                 Date: 1/10/19
;// Description: This program will get two numbers and apply mathematical operations on them.

INCLUDE Irvine32.inc

.data
;// Messages
welcomeMsg		BYTE	"My name is Ethan Duong and this program will give the sum, difference, product, quotient, and remainder of two numbers.", 0dh, 0ah, 0
getNum1			BYTE	"Please enter your first integer.", 0dh, 0ah, 0
getNum2			BYTE	"Please enter your second integer.", 0dh, 0ah, 0
;// sumMsg			BYTE	"The sum is: ", 0
;// diffMsg			BYTE	"The difference is: ", 0
;// prodMsg			BYTE	"The product is: ", 0
;// quotMsg			BYTE	"The quotient is: ", 0
remMsg			BYTE	"   The remainder is: ", 0
;// decimalMsg		BYTE	"The decimal answer is: ", 0
byeMsg			BYTE	"Thank you for using my program, goodbye!", 0
againMsg		BYTE	"Do you want to use the program again? (Enter 1 to go again or anything else to exit)", 0dh, 0ah, 0
errorMsg		BYTE	"The second integer must be less than the first.", 0dh, 0ah, 0
ecMsg			BYTE	"EC: I did the extra credit for repeating again and validating that num1 > num2", 0dh, 0ah, 0
plusSign		BYTE	" + ", 0
minusSign		BYTE	" - ", 0
timesSign		BYTE	" * ", 0
divSign			BYTE	" / ", 0
equalSign		BYTE	" = ", 0
;// Number variables
num1			DWORD	?	;// user's first number
num2			DWORD	?	;// user's second number
sumNum			DWORD	?	;// sum of numbers
diffNum			DWORD	?	;// difference of num1 - num2
prodNum			DWORD	?	;// product of numbers
quotNum			DWORD	?	;// quotient of num1/num2
remNum			DWORD	?	;// remainder of num1/num2
;// decimalNum		REAL4 ? ;// decimal of num1/num2

.code
main PROC
again:
	;// display author's name and title of project
	mov		edx, OFFSET ecMsg
	call	WriteString
	mov		edx, OFFSET welcomeMsg
	call	WriteString
	call	CrLf

	invalid:
		;// get integer 1
		mov		edx, OFFSET getNum1
		call	WriteString
		call	ReadInt
		mov		num1, eax

		;// get integer 2
		mov		edx, OFFSET getNum2
		call	WriteString
		call	ReadInt
		mov		num2, eax
		call	CrLf

		;;// compare if num1 > num2
		;mov		eax, num1
		;cmp		eax, num2
		;jl		error

		;// add numbers
		mov		eax, num1
		add		eax, num2
		mov		sumNum, eax

		;// subtract num2 from num1
		mov		eax, num1
		sub		eax, num2
		mov		diffNum, eax

		;// multiply numbers
		mov		eax, num1
		mov		ebx, num2
		mul		ebx
		mov		prodNum, eax

		;// divide num1/num2 with remainder
		mov		eax, num1
		cdq
		mov		ebx, num2
		div		ebx
		mov		quotNum, eax
		mov		remNum, edx

		;// divide num1/num2 with decimal
		;// fild num1
		;// fidiv num2
		;// fstp decimalNum

		;// output results
		;// sum
		mov		eax, num1
		call	WriteInt
		mov		edx, OFFSET plusSign
		call	WriteString
		mov		eax, num2
		call	WriteInt
		mov		edx, OFFSET equalSign
		call	WriteString
		mov		eax, sumNum
		call	WriteInt
		call	CrLf
		;// difference
		mov		eax, num1
		call	WriteInt
		mov		edx, OFFSET minusSign
		call	WriteString
		mov		eax, num2
		call	WriteInt
		mov		edx, OFFSET equalSign
		call	WriteString
		mov		eax, diffNum
		call	WriteInt
		call	CrLf
		;// product
		mov		eax, num1
		call	WriteInt
		mov		edx, OFFSET timesSign
		call	WriteString
		mov		eax, num2
		call	WriteInt
		mov		edx, OFFSET equalSign
		call	WriteString
		mov		eax, prodNum
		call	WriteInt
		call	CrLf
		;// quotient
		mov		eax, num1
		call	WriteInt
		mov		edx, OFFSET divSign
		call	WriteString
		mov		eax, num2
		call	WriteInt
		mov		edx, OFFSET equalSign
		call	WriteString
		mov		eax, quotNum
		call	WriteInt
		;// remainder
		mov		edx, OFFSET remMsg
		call	WriteString
		mov		eax, remNum
		call	WriteInt
		call	CrLf
		;// decimal
		;// mov edx, OFFSET decimalMsg
		;// call WriteString
		;// mov eax, decimalNum
		;// call WriteDec
		;// call  CrLf

		;// ask if want to go again
		call	CrLf
		mov		edx, OFFSET againMsg
		call	WriteString
		call	ReadInt
		call	CrLf
		cmp		eax, 1
		je		again

		;// say goodbye
		call	CrLf
		mov		edx, OFFSET byeMsg
		call	WriteString
		call	CrLf
		exit	;// exit to operating system

	;// num1 is less than num2
	error:
		mov		edx, OFFSET errorMsg
		call	WriteString
		call	CrLf
		jmp		invalid ;// go back to get input again

main ENDP

END main
