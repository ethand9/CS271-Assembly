TITLE Tic Tac Toe     (TicTacToe.asm)

; Author: Ethan Duong
; Course / Project ID: CS 271 EC Program           Date: 1/26/19
; Description: This program simulates the game, Tic Tac Toe.

INCLUDE Irvine32.inc

; (insert constant definitions here)
MAX_LENGTH_NAME = 101	; max length of user's name

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
welcomeMsg		BYTE	"My name is Ethan Duong and welcome to tic-tac-toe.", 0dh, 0ah, 0
getName			BYTE	"Please enter your name: ", 0
greetMsg1		BYTE	"Hello, ", 0
greetMsg2		BYTE	", let's play tic-tac-toe. Games are played best two out of three.", 0dh, 0ah, 0
instrcMsg		BYTE	"Please enter an integer from 1 to 9 to make a move. (Think of a numpad)", 0dh, 0ah, 0
checkMsg		BYTE	"You entered: ", 0
invalidMsg		BYTE	"That is not a valid move.", 0dh, 0ah, 0
againMsg		BYTE	"Do you want to play again? (Enter 1 for yes, anything else for no)", 0dh, 0ah, 0
byeMsg			BYTE	"I hope you liked playing tic-tac-toe, ", 0
gameModeMsg		BYTE	"Would you like to play with a friend or against a computer? (1 for computer, anything else for human)", 0dh, 0ah, 0
player1Msg		BYTE	"Player 1, make a move.", 0dh, 0ah, 0
player2Msg		BYTE	"Player 2, make a move.", 0dh, 0ah, 0
filledMsg		BYTE	"That space is already taken!", 0dh, 0ah, 0
xWinMsg			BYTE	"Player 1 has won!", 0dh, 0ah, 0
oWinMsg			BYTE	"Player 2 has won!", 0dh, 0ah, 0
tieMsg			BYTE	"Stalemate!", 0dh, 0ah, 0
cpuMsg			BYTE	"The computer has made its move.", 0dh, 0ah, 0
orderMsg		BYTE	"Who should go first? (1 for player1, anything else for player 2)", 0dh, 0ah, 0
rematchMsg		BYTE	"Another game is beginning!", 0dh, 0ah, 0
player1Won		BYTE	"Player 1 has won the best two out of three!", 0dh, 0ah, 0
player2Won		BYTE	"Player 2 has won the best two out of three!", 0dh, 0ah, 0
instrcMsg2		BYTE	"Enter the respective number to make that move (Think of a numpad).", 0dh, 0ah, 0
; board states
boardLine1		BYTE	"   |   |   ", 0dh, 0ah, 0	; line 1, 3, 5, 7, 9
boardLine214	BYTE	" ", 0						; line (2, 6, 10) spaces 1, 4
boardLine223	BYTE	" | ", 0					; line (2, 6, 10) spaces 2, 3
boardLine4		BYTE	"-----------", 0dh, 0ah, 0	; line 4, 8
; variables
userName		BYTE	MAX_LENGTH_NAME		DUP (0)	; user's name
currentChar		BYTE	1					DUP	(0)	; current player X or O
player1Wins		DWORD	0							; player 1's number of wins
player2Wins		DWORD	0							; player 2's number of wins
; bools
gameIsOver		DWORD	0	; if board is full or someone has won
againBool		DWORD	0	; if user wants to play again
gameModeType	DWORD	0	; 0 for human v human, 1 for human v cpu
orderBool		DWORD	0	; 1 for human first, other for cpu
; variables for board positions
space1			BYTE	"1", 0
space2			BYTE	"2", 0
space3			BYTE	"3", 0
space4			BYTE	"4", 0
space5			BYTE	"5", 0
space6			BYTE	"6", 0
space7			BYTE	"7", 0
space8			BYTE	"8", 0
space9			BYTE	"9", 0
; bools for if space is occupied
space1Bool		DWORD	0
space2Bool		DWORD	0
space3Bool		DWORD	0
space4Bool		DWORD	0
space5Bool		DWORD	0
space6Bool		DWORD	0
space7Bool		DWORD	0
space8Bool		DWORD	0
space9Bool		DWORD	0

.code
main PROC
	push	OFFSET username		; user's name
	call	introduction		; greet user and display instructions

	startAgain:					; label for if user wants to play again
	call	randomize			; randomize the numbers
	call	displayBoard		; display tic tac toe board with numbers
	displayString instrcMsg2    ; tell user how to make moves
	push	OFFSET gameIsOver	; if the game needs to be reset
	call	resetGame			; reset board values
	push	OFFSET gameModeType ; bool of game type
	call	getGameMode			; if user wants to play with human or cpu
	rematch:					; label for playing same mode again
	cmp		gameModeType, 1		; if human v cpu
	je		cpuStart			; play against cpu

	humanLoop: ; human vs human
		; get player order
		displayString orderMsg		; ask user who they want to go first
		call	ReadDec
		;call	displayBoard		; show tic tac toe board
		cmp		eax, 1				; if input is 1 then player1 goes first
		jne		player2Start		; skip player1's turn
	player1Start: ; get move for player 1
		call	displayBoard		; update board
		displayString player1Msg	; prompt player 1
		call	getMoveX			; player 1 makes a move
		; check if board is full or someone won
		push	OFFSET player1Wins  ; number of times player 1 has won
		push	OFFSET player2Wins	; number of times player 2 has won
		push	OFFSET gameIsOver	; bool if game is over
		call	checkGameWin		; check if someone won
		cmp		gameIsOver, 1		; check if player 1 has won
		je		endLoop				; then exit game
		push	OFFSET gameIsOver	; bool if game is over
		call	checkBoardFull		; check if there are no possible moves left
		cmp		gameIsOver, 1		; check if board full
		je		endLoop				; then exit game
	player2Start: ; get move for player 2
		call	displayBoard		; update board
		displayString player2Msg	; prompt player 2
		call	getMoveO			; player 2 makes a move
		; check if board is full or someone won
		push	OFFSET player1Wins  ; number of times player 1 has won
		push	OFFSET player2Wins	; number of times player 2 has won
		push	OFFSET gameIsOver	; bool if game is over
		call	checkGameWin		; check if someone won
		cmp		gameIsOver, 1		; check if player 2 has won
		je		endLoop				; then exit game
		push	OFFSET gameIsOver	; bool if game is over
		call	checkBoardFull		; check if there are no possible moves left
		cmp		gameIsOver, 0		; check if board not full and someone not won
		je		player1Start		; if not over then player 1 makes a move again
		jmp		endLoop				; exit game
	
	cpuStart: ; human vs cpu
		; get player order
		displayString orderMsg		; ask user who they want to go first
		call	ReadDec
		call	displayBoard		; show tic tac toe board
		cmp		eax, 1				; if input is 1 then human goes first
		jne		cpuMove				; skip human's turn
	cpuLoopStart: ; start getting moves from players
		; get player move
		call	getMoveX			; human makes a move
		call	displayBoard		; update board
		; check if board full or someone won
		push	OFFSET player1Wins  ; number of times human has won
		push	OFFSET player2Wins	; number of times cpu has won
		push	OFFSET gameIsOver	; bool if game is over
		call	checkGameWin		; check if someone has won
		cmp		gameIsOver, 1		; check if human won
		je		endLoop				; then exit game
		push	OFFSET gameIsOver	; bool if game is over
		call	checkBoardFull		; check if there are no possible moves left
		cmp		gameIsOver, 1		; check if board full
		je		endLoop				; then exit game
	cpuMove: ; CPU makes a move
		call	getCpuMove			; CPU makes a move
		call	displayBoard		; update board
		; check if board full or someone won
		push	OFFSET player1Wins  ; number of times human has won
		push	OFFSET player2Wins	; number of times cpu has won
		push	OFFSET gameIsOver	; bool if game is over
		call	checkGameWin		; check if someone won
		cmp		gameIsOver, 1		; check if cpu has won
		je		endLoop				; then exit game
		push	OFFSET gameIsOver	; bool if game is over
		call	checkBoardFull		; check if there are no possible moves left
		cmp		gameIsOver, 0		; check if board not full and someone not won
		je		cpuLoopStart		; then human makes a move again

	endLoop: ; a game has ended
	; check if someone has won a best 2 out of 3
	cmp		player1Wins, 2	 ; if player 1 has two wins
	je		player1Victory	 ; then jump to their victory message
	cmp		player2Wins, 2	 ; if player 2 has two wins
	je		player2Victory	 ; then jump to their victory message
	displayString rematchMsg ; alert player that another game is starting
	call	CrLf
	push	OFFSET gameIsOver ; bool to end game or not
	call	resetGame		  ; reset board values
	jmp		rematch			  ; start another game of the same game mode

	player1Victory:			 ; player 1 wins
	displayString player1Won ; congrats message
	jmp		askAgain		 ; jump to ask if they want to play again
	player2Victory:			 ; player 2 wins
	displayString player2Won ; congrats message

	askAgain:
	push	OFFSET againBool ; if user wants to play again
	call	playAgain		 ; ask user if they want to play again
	cmp		againBool, 1	 ; 1 to play again
	jne		goodbyeLabel	 ; end program
	mov		player1Wins, 0	 ; reset win counter
	mov		player2Wins, 0	 ; reset win counter
	jmp		startAgain		 ; back to beginning

	goodbyeLabel:
	call	goodbye			 ; say goodbye
	exit					 ; exit to operating system
main ENDP

;---------------------------------------------------
; greets user and gives description of program
;
; registers used: edx, ecx
; Receives: address of username
; Returns: username
;---------------------------------------------------
introduction	PROC
	push	ebp
	mov		ebp, esp
	; display author's name and title of project
	displayString welcomeMsg
	call	CrLf

	; get name and greet user with a max of 100 char
	displayString getName		 ; prompt user
	mov		edx, [ebp+8]		 ; userName to edx
	mov		ecx, MAX_LENGTH_NAME ; max length of name
	call	ReadString
	; greet user
	displayString greetMsg1
	displayString userName
	displayString greetMsg2
	call	CrLf
	pop		ebp
	ret		4
introduction	ENDP

;---------------------------------------------------
; outputs the tic tac toe board
;
; registers used: edx
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
displayBoard	PROC
	; boardLines are the edges of the board
	; spaces are blanks, X, and O
	call	Clrscr			; clear screen
	; line 1
	displayString boardLine1
	; line 2
	displayString boardLine214
	displayString space7
	displayString boardLine223
	displayString space8
	displayString boardLine223
	displayString space9
	displayString boardLine214
	call	CrLf
	; line 3
	displayString boardLine1
	; line 4
	displayString boardLine4
	; line 5
	displayString boardLine1
	; line 6
	displayString boardLine214
	displayString space4
	displayString boardLine223
	displayString space5
	displayString boardLine223
	displayString space6
	displayString boardLine214
	call	CrLf
	; line 7
	displayString boardLine1
	; line 8
	displayString boardLine4
	; line 9
	displayString boardLine1
	; line 10
	displayString boardLine214
	displayString space1
	displayString boardLine223
	displayString space2
	displayString boardLine223
	displayString space3
	displayString boardLine214
	call	CrLf
	; line 11
	displayString boardLine1
	call	CrLf
	call	CrLf
	ret
displayBoard	ENDP

;---------------------------------------------------
; gets an input from player X and fills the space
;
; registers used: edx, eax
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
getMoveX			PROC
	; local variables
	LOCAL inputMove:DWORD	; user's move

	getMoveStart:			; get input for move
	displayString instrcMsg ; prompt user
	call	ReadDec
	mov		inputMove, eax	; move user input to inputMove
	call	CrLf

	; check if valid (1-9)
	cmp		inputMove, 1
	jl		invalidMove
	cmp		inputMove, 9
	jg		invalidMove

	; check what user wrote and go to that space
	cmp		inputMove, 1
	je		xMove1
	cmp		inputMove, 2
	je		xMove2
	cmp		inputMove, 3
	je		xMove3
	cmp		inputMove, 4
	je		xMove4
	cmp		inputMove, 5
	je		xMove5
	cmp		inputMove, 6
	je		xMove6
	cmp		inputMove, 7
	je		xMove7
	cmp		inputMove, 8
	je		xMove8
	cmp		inputMove, 9
	je		xMove9

	; Player X makes a move, put X into space
	xMove1:
		; check if space is empty
		cmp		space1, " "
		jne		filledspace1x	; this space is already full
		; if empty then fill space with X
		mov		space1, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace1x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove2:
		; check if space is empty
		cmp		space2, " "
		jne		filledspace2x	; this space is already full
		; if empty then fill space with X
		mov		space2, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace2x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove3:
		; check if space is empty
		cmp		space3, " "
		jne		filledspace3x	; this space is already full
		; if empty then fill space with X
		mov		space3, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace3x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove4:
		; check if space is empty
		cmp		space4, " "
		jne		filledspace4x	; this space is already full
		; if empty then fill space with X
		mov		space4, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace4x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove5:
		; check if space is empty
		cmp		space5, " "
		jne		filledspace5x	; this space is already full
		; if empty then fill space with X
		mov		space5, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace5x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove6:
		; check if space is empty
		cmp		space6, " "
		jne		filledspace6x	; this space is already full
		; if empty then fill space with X
		mov		space6, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace6x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove7:
		; check if space is empty
		cmp		space7, " "
		jne		filledspace7x	; this space is already full
		; if empty then fill space with X
		mov		space7, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace7x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove8:
		; check if space is empty
		cmp		space8, " "
		jne		filledspace8x	; this space is already full
		; if empty then fill space with X
		mov		space8, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace8x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	xMove9:
		; check if space is empty
		cmp		space9, " "
		jne		filledspace9x	; this space is already full
		; if empty then fill space with X
		mov		space9, "X"
		jmp		endLabel1		; exit this procedure
		; if filled then get move again
		filledspace9x:			; this space is already full
		displayString filledMsg
		jmp		getMoveStart	; get a new move

	invalidMove: ; input is out of bounds
		displayString invalidMsg
		call	CrLf
		jmp		getMoveStart ; get a new move

	endLabel1:
	ret
getMoveX			ENDP

;---------------------------------------------------
; gets an input from player O and fills the space
;
; registers used: edx, eax
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
getMoveO			PROC
	; local variables
	LOCAL inputMove:DWORD	; user's move

	getMoveStartO:			; get input for move
	displayString instrcMsg ; prompt user
	call	ReadDec
	mov		inputMove, eax	; move user input to inputMove
	call	CrLf

	; check if valid (1-9)
	cmp		inputMove, 1
	jl		invalidMoveO
	cmp		inputMove, 9
	jg		invalidMoveO

	; check what user wrote then go to respective space
	cmp		inputMove, 1
	je		OMove1
	cmp		inputMove, 2
	je		OMove2
	cmp		inputMove, 3
	je		OMove3
	cmp		inputMove, 4
	je		OMove4
	cmp		inputMove, 5
	je		OMove5
	cmp		inputMove, 6
	je		OMove6
	cmp		inputMove, 7
	je		OMove7
	cmp		inputMove, 8
	je		OMove8
	cmp		inputMove, 9
	je		OMove9

	; Player O makes a move, put O into respective space
	oMove1:
		; check if space is empty
		cmp		space1, " "
		jne		filledspace1o	; this space is already full
		; if empty then set space to O
		mov		space1, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace1o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove2:
		; check if space is empty
		cmp		space2, " "
		jne		filledspace2o	; this space is already full
		; if empty then set space to O
		mov		space2, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace2o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove3:
		; check if space is empty
		cmp		space3, " "
		jne		filledspace3o	; this space is already full
		; if empty then set space to O
		mov		space3, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace3o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove4:
		; check if space is empty
		cmp		space4, " "
		jne		filledspace4o	; this space is already full
		; if empty then set space to O
		mov		space4, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace4o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove5:
		; check if space is empty
		cmp		space5, " "
		jne		filledspace5o	; this space is already full
		; if empty then set space to O
		mov		space5, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace5o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove6:
		; check if space is empty
		cmp		space6, " "
		jne		filledspace6o	; this space is already full
		; if empty then set space to O
		mov		space6, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace6o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove7:
		; check if space is empty
		cmp		space7, " "
		jne		filledspace7o	; this space is already full
		; if empty then set space to O
		mov		space7, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace7o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove8:
		; check if space is empty
		cmp		space8, " "
		jne		filledspace8o	; this space is already full
		; if empty then set space to O
		mov		space8, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace8o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	oMove9:
		; check if space is empty
		cmp		space9, " "
		jne		filledspace9o	; this space is already full
		; if empty then set space to O
		mov		space9, "O"
		jmp		endLabelO1		; exit this procedure
		; if filled then get move again
		filledspace9o:			; this space is already full
		displayString filledMsg
		jmp		getMoveStartO	; get move again

	invalidMoveO: ; input is out of bounds
		displayString invalidMsg
		call	CrLf
		jmp		getMoveStartO ; get move again

	endLabelO1: ; exit procedure
	ret
getMoveO			ENDP

;---------------------------------------------------
; makes a random move for the cpu and fills the space
;
; registers used: edx, eax
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
getCpuMove			PROC
	; pick a random number from 1-9
	; then check if it is a valid move
	getRandomNum:		; start of loop for getting random numbers
	mov		eax, 9		; max of 9
	call	randomRange ; get random number
	inc		eax			; min of 1
	
	; check what cpu chose and go to that space
	cmp		eax, 1
	je		space1CPU
	cmp		eax, 2
	je		space2CPU
	cmp		eax, 3
	je		space3CPU
	cmp		eax, 4
	je		space4CPU
	cmp		eax, 5
	je		space5CPU
	cmp		eax, 6
	je		space6CPU
	cmp		eax, 7
	je		space7CPU
	cmp		eax, 8
	je		space8CPU
	cmp		eax, 9
	je		space9CPU

	; check if the space is blank
	; if not get a new number, if it is then put O in it and exit procedure
	space1CPU:
	cmp		space1, " "
	jne		getRandomNum
	mov		space1, "O"
	jmp		cpuEnd ; end procedure
	space2CPU:
	cmp		space2, " "
	jne		getRandomNum
	mov		space2, "O"
	jmp		cpuEnd ; end procedure
	space3CPU:
	cmp		space3, " "
	jne		getRandomNum
	mov		space3, "O"
	jmp		cpuEnd ; end procedure
	space4CPU:
	cmp		space4, " "
	jne		getRandomNum
	mov		space4, "O"
	jmp		cpuEnd ; end procedure
	space5CPU:
	cmp		space5, " "
	jne		getRandomNum
	mov		space5, "O"
	jmp		cpuEnd ; end procedure
	space6CPU:
	cmp		space6, " "
	jne		getRandomNum
	mov		space6, "O"
	jmp		cpuEnd ; end procedure
	space7CPU:
	cmp		space7, " "
	jne		getRandomNum
	mov		space7, "O"
	jmp		cpuEnd ; end procedure
	space8CPU:
	cmp		space8, " "
	jne		getRandomNum
	mov		space8, "O"
	jmp		cpuEnd ; end procedure
	space9CPU:
	cmp		space9, " "
	jne		getRandomNum
	mov		space9, "O"

	cpuEnd: ; end procedure
	displayString cpuMsg
	call	CrLf
	ret
getCpuMove			ENDP
;---------------------------------------------------
; checks if board is full
;
; registers used: ebp, esp, ebx, eax
; Receives: address of gameIsOver
; Returns: gameIsOver
;---------------------------------------------------
checkBoardFull	PROC
	push	ebp
	mov		ebp, esp
	; check if pieces are present in the respective space
	; if there is, then set the bool for that space to true
	space1Check: ; space 1
		cmp		space1, "X"
		je		space1Full
		cmp		space1, "O"
		je		space1Full
	space2Check: ; space 2
		cmp		space2, "X"
		je		space2Full
		cmp		space2, "O"
		je		space2Full
	space3Check: ; space 3
		cmp		space3, "X"
		je		space3Full
		cmp		space3, "O"
		je		space3Full
	space4Check: ; space 4
		cmp		space4, "X"
		je		space4Full
		cmp		space4, "O"
		je		space4Full
	space5Check: ; space 5
		cmp		space5, "X"
		je		space5Full
		cmp		space5, "O"
		je		space5Full
	space6Check: ; space 6
		cmp		space6, "X"
		je		space6Full
		cmp		space6, "O"
		je		space6Full
	space7Check: ; space 7
		cmp		space7, "X"
		je		space7Full
		cmp		space7, "O"
		je		space7Full
	space8Check: ; space 8
		cmp		space8, "X"
		je		space8Full
		cmp		space8, "O"
		je		space8Full
	space9Check: ; space 9
		cmp		space9, "X"
		je		space9Full
		cmp		space9, "O"
		je		space9Full
	space10Check: ; exit for space 9, here for consistency
	
	; check if all 9 pieces are filled
	; if a space is not filled, then skip
	cmp		space1Bool, 1
	jne		endLabel2
	cmp		space2Bool, 1
	jne		endLabel2
	cmp		space3Bool, 1
	jne		endLabel2
	cmp		space4Bool, 1
	jne		endLabel2
	cmp		space5Bool, 1
	jne		endLabel2
	cmp		space6Bool, 1
	jne		endLabel2
	cmp		space7Bool, 1
	jne		endLabel2
	cmp		space8Bool, 1
	jne		endLabel2
	cmp		space9Bool, 1
	jne		endLabel2
	
	; set bool of gameIsOver to 1
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard
	displayString tieMsg ; stalemate message
	jmp		endLabel2

	; check if spaces are occupied
	; if true then set bool to true and check next space
	space1Full:
		mov		space1Bool, 1
		jmp		space2Check
	space2Full:
		mov		space2Bool, 1
		jmp		space3Check
	space3Full:
		mov		space3Bool, 1
		jmp		space4Check
	space4Full:
		mov		space4Bool, 1
		jmp		space5Check
	space5Full:
		mov		space5Bool, 1
		jmp		space6Check
	space6Full:
		mov		space6Bool, 1
		jmp		space7Check
	space7Full:
		mov		space7Bool, 1
		jmp		space8Check
	space8Full:
		mov		space8Bool, 1
		jmp		space9Check
	space9Full:
		mov		space9Bool, 1
		jmp		space10Check

	endLabel2: ; exit procedure
	pop		ebp
	ret		4
checkBoardFull	ENDP

;---------------------------------------------------
; checks if a player has won
;
; registers used: ebp, esp
; Receives: address of gameIsOver
; Returns: gameIsOver
;---------------------------------------------------
checkGameWin	PROC
	push	ebp
	mov		ebp, esp

	; check bottom row X, if not 3 in a row then check next
	cmp		space1, "X"
	jne		oBottom
	cmp		space2, "X"
	jne		oBottom
	cmp		space3, "X"
	jne		oBottom
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oBottom: ; check bottom row O, if not 3 in a row then check next
	cmp		space1, "O"
	jne		xMid
	cmp		space2, "O"
	jne		xMid
	cmp		space3, "O"
	jne		xMid
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xMid: ; check middle row X, if not 3 in a row then check next
	cmp		space4, "X"
	jne		oMid
	cmp		space5, "X"
	jne		oMid
	cmp		space6, "X"
	jne		oMid
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oMid: ; check middle row O, if not 3 in a row then check next
	cmp		space4, "O"
	jne		xTop
	cmp		space5, "O"
	jne		xTop
	cmp		space6, "O"
	jne		xTop
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xTop: ; check top row X, if not 3 in a row then check next
	cmp		space7, "X"
	jne		oTop
	cmp		space8, "X"
	jne		oTop
	cmp		space9, "X"
	jne		oTop
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oTop: ; check top row O, if not 3 in a row then check next
	cmp		space7, "O"
	jne		xCol1
	cmp		space8, "O"
	jne		xCol1
	cmp		space9, "O"
	jne		xCol1
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xCol1: ; check left col X, if not 3 in a row then check next
	cmp		space7, "X"
	jne		oCol1
	cmp		space4, "X"
	jne		oCol1
	cmp		space1, "X"
	jne		oCol1
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oCol1: ; check left col O, if not 3 in a row then check next
	cmp		space7, "O"
	jne		xCol2
	cmp		space4, "O"
	jne		xCol2
	cmp		space1, "O"
	jne		xCol2
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xCol2: ; check middle col X, if not 3 in a row then check next
	cmp		space8, "X"
	jne		oCol2
	cmp		space5, "X"
	jne		oCol2
	cmp		space2, "X"
	jne		oCol2
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oCol2: ; check middle col O, if not 3 in a row then check next
	cmp		space8, "O"
	jne		xCol3
	cmp		space5, "O"
	jne		xCol3
	cmp		space2, "O"
	jne		xCol3
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xCol3: ; check right col X, if not 3 in a row then check next
	cmp		space9, "X"
	jne		oCol3
	cmp		space6, "X"
	jne		oCol3
	cmp		space3, "X"
	jne		oCol3
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oCol3: ; check right col O, if not 3 in a row then check next
	cmp		space9, "O"
	jne		xDiag1
	cmp		space6, "O"
	jne		xDiag1
	cmp		space3, "O"
	jne		xDiag1
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xDiag1: ; check first diagonal X, if not 3 in a row then check next
	cmp		space7, "X"
	jne		oDiag1
	cmp		space5, "X"
	jne		oDiag1
	cmp		space3, "X"
	jne		oDiag1
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oDiag1: ; check first diagonal O, if not 3 in a row then check next
	cmp		space7, "O"
	jne		xDiag2
	cmp		space5, "O"
	jne		xDiag2
	cmp		space3, "O"
	jne		xDiag2
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg
	jmp		gameEnd		 ; end procedure

	xDiag2: ; check second diagonal X, if not 3 in a row then check next
	cmp		space1, "X"
	jne		oDiag2
	cmp		space5, "X"
	jne		oDiag2
	cmp		space9, "X"
	jne		oDiag2
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+16]; player1wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player1wins by one
	displayString xWinMsg
	jmp		gameEnd		 ; end procedure

	oDiag2: ; check second diagonal O, if not 3 in a row then check next
	cmp		space1, "O"
	jne		gameEnd
	cmp		space5, "O"
	jne		gameEnd
	cmp		space9, "O"
	jne		gameEnd
	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 1
	mov		[ebx], eax	 ; 1 to gameIsOver
	call	displayBoard ; update board
	mov		ebx, [ebp+12]; player2wins to ebx
	mov		eax, 1
	add		[ebx], eax	 ; increase player2wins by one
	displayString oWinMsg

	gameEnd: ; end procedure
	pop		ebp
	ret		12
checkGameWin	ENDP

;---------------------------------------------------
; asks user if they want to play again
;
; registers used: edx, eax, ebx, esp, ebp
; Receives: address of againBool
; Returns: againBool
;---------------------------------------------------
playAgain		PROC
	push	ebp
	mov		ebp, esp
	; ask if want to play again
	displayString againMsg	; prompt user
	call	ReadDec
	call	Clrscr			; clear screen
	cmp		eax, 1			; enter 1 to play again
	jne		endLabel3		; if user does not want to play again

	; want to play again, reset values
	mov		ebx, [ebp+8]	  ; againBool to ebx
	mov		eax, 1
	mov		[ebx], eax		  ; 1 into againBool
	push	OFFSET gameIsOver ; if game needs to restart
	call	resetGame		  ; reset board values
	jmp		endLabel4		  ; jump to end

	endLabel3:			 ; user does not want to play again
	mov		ebx, [ebp+8] ; againBool to ebx
	mov		eax, 0
	mov		[ebx], eax	 ; 0 to againBool
	endLabel4:			 ; exit label
	pop		ebp
	ret		4
playAgain		ENDP

;---------------------------------------------------
; reset board state to play another game
;
; registers used: edx
; Receives: address of gameIsOver
; Returns: gameIsOver
;---------------------------------------------------
resetGame		PROC
	push	ebp
	mov		ebp, esp
	; want to play again, reset values
	; clear spaces
	mov		space1, " "
	mov		space2, " "
	mov		space3, " "
	mov		space4, " "
	mov		space5, " "
	mov		space6, " "
	mov		space7, " "
	mov		space8, " "
	mov		space9, " "
	; reset: spaces are not full
	mov		space1Bool, 0
	mov		space2Bool, 0
	mov		space3Bool, 0
	mov		space4Bool, 0
	mov		space5Bool, 0
	mov		space6Bool, 0
	mov		space7Bool, 0
	mov		space8Bool, 0
	mov		space9Bool, 0

	mov		ebx, [ebp+8] ; gameIsOver to ebx
	mov		eax, 0
	mov		[ebx], eax	 ; 0 to gameIsOver

	pop		ebp
	ret		4
resetGame		ENDP

;---------------------------------------------------
; says goodbye to user
;
; registers used: edx
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
goodbye			PROC
	; say goodbye
	displayString byeMsg
	displayString userName
	call	CrLf
	ret
goodbye			ENDP

;---------------------------------------------------
; asks user if they want to play against a human or computer
;
; registers used: ebp, esp, edx, eax
; Receives: address of gameModeType
; Returns: gameModeType
;---------------------------------------------------
getGameMode		PROC
	push	ebp
	mov		ebp, esp
	displayString gameModeMsg	; prompt
	call	ReadDec	
	mov		ebx, [ebp+8]		; address of gameModetype to ebx
	mov		[ebx], eax			; move user input into gameModeType
	call	CrLf

	pop		ebp
	ret		4
getGameMode		ENDP

END main