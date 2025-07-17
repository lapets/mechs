'///// Mechs : Menu.bas /////////////////////////////////////////////////////
'///// July 26, 2001 ////////////////////////////////////////////////////////

'///// I N C L U D E S //////////////////////////////////////////////////////
REM $INCLUDE: 'qb.bi'                        ''for assembly routines
REM $INCLUDE: 'modexlib.bi'                  ''for mode X graphics
REM $INCLUDE: 'struct.bi'                    ''the structures
REM $INCLUDE: 'common.bi'                    ''the shared variables
REM $INCLUDE: 'const.bi'                     ''for specific constants

''Make sure memory for arrays is allocated dynamically
REM $DYNAMIC

'///// P R O T O T Y P E S //////////////////////////////////////////////////
DECLARE SUB Delay (Seconds AS DOUBLE)

DECLARE FUNCTION MULTIKEY (T!)
DECLARE SUB Wait.KeyPress ()

DECLARE SUB CLEANUP ()
DECLARE SUB LOAD.GIF.X (load.pic$, page AS INTEGER)
DECLARE SUB LOAD.PALLETE (load.pic$)

DECLARE SUB Print.Text (TextOut AS STRING, x AS INTEGER, y AS INTEGER, DelayTime AS DOUBLE)
DECLARE SUB Delete.Text (x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER)
DECLARE SUB Load.Level (LevelPath AS STRING)

DECLARE SUB Menu ()
DECLARE SUB Menu.HighScores ()
DECLARE SUB Menu.Options ()

''Clear and reinitialize the stack to 25000 (it crashed at 4096)
CLEAR , , 25000

REM $STATIC
SUB Menu

''This is the startup menu in its entirety

''Declare local variables
DIM TinyTextCursorX AS INTEGER
DIM TinyTextCursorY AS INTEGER
DIM RandomNumber AS INTEGER
DIM TinyTextClock AS INTEGER
DIM MenuSelectionCursorX AS INTEGER
DIM MenuSelectionCursorY AS INTEGER
DIM MenuSelectionCursorBlinkClock AS INTEGER
DIM KeyBoardCheck AS INTEGER
DIM CursorToMove AS INTEGER
DIM MoveCursorUp AS INTEGER
DIM MoveCursorDown AS INTEGER
DIM MoveCursorClock AS INTEGER

''Cleanup
mxFill Page1in320x200, Full320x200, 0
LOAD.GIF.X "MENU.GIF", 1
'LOAD.PALLETE "MENU1.GIF"
mxPCopy Page1in320x200, Page0in320x200, Full320x200

''Greet the player and write out the menu options
IF (TIMER / 100 <= 12 * 36) THEN
	Print.Text "GOOD MORNING~", 40, 40, .01
ELSEIF (TIMER / 100 < 18 * 36) THEN
	Print.Text "GOOD AFTERNOON~", 40, 40, .01
ELSEIF (TIMER / 100 >= 18 * 36) THEN
	Print.Text "GOOD EVENING~", 40, 40, .01
END IF

Print.Text "INSTRUCTIONS~", 40, 60, .01
Print.Text "START~", 40, 70, .02
Print.Text "OPTIONS~", 40, 80, .01
Print.Text "HIGH SCORES~", 40, 90, .01
Print.Text "EXIT~", 40, 100, .01

TinyTextCursorX = 150
TinyTextCursorY = 20
TinyTextClock = 0

MenuSelectionCursorX = 32
MenuSelectionCursorY = 60
MenuSelectionCursorBlinkClock = 0
CursorToMove = 0
MoveCursorUp = 11          ''Constants
MoveCursorDown = 22        ''
MoveCursorClock = 0

KeyBoardCheck = TRUE


MenuSelectionLoop:

MenuSelectionCursorBlinkClock = MenuSelectionCursorBlinkClock + 1
IF (MenuSelectionCursorBlinkClock = 600) THEN MenuSelectionCursorBlinkClock = 0

KeyboardCheckClock = KeyboardCheckClock + 1
IF (KeyboardCheckClock = 50) THEN KeyboardCheckClock = 0

TinyTextClock = TinyTextClock + 1
IF (TinyTextClock = 1) THEN
	TinyTextClock = 0
	TinyTextCursorX = TinyTextCursorX + 1
	IF (TinyTextCursorX = 300) THEN
		TinyTextCursorX = 150
		TinyTextCursorY = TinyTextCursorY + 4
	END IF

	IF (TinyTextCursorY >= 180) THEN
		TinyTextCursorY = 20
	END IF
      
	RandomNumber = RND * 10
	IF (RandomNumber > 5) THEN mxPset Page0in320x200, TinyTextCursorX, TinyTextCursorY, 78
	IF (RandomNumber < 5) THEN mxPset Page0in320x200, TinyTextCursorX, TinyTextCursorY, 0
END IF


''Draw the selection cursor
IF (MenuSelectionCursorBlinkClock = 300) THEN
	mxPut 0, Page0in320x200, VARSEG(AlphabetCursor(0)), VARPTR(AlphabetCursor(0)), MenuSelectionCursorX, MenuSelectionCursorY
ELSEIF (MenuSelectionCursorBlinkClock = 0) THEN
	Delete.Text MenuSelectionCursorX, MenuSelectionCursorY, MenuSelectionCursorX + 5, MenuSelectionCursorY + 4
END IF

''Clean up the cursor on other choices
SELECT CASE MenuSelectionCursorY
	CASE IS = 60
		Delete.Text 32, 70, 32 + 5, 70 + 4
		Delete.Text 32, 80, 32 + 5, 80 + 4
		Delete.Text 32, 90, 32 + 5, 90 + 4
		Delete.Text 32, 100, 32 + 5, 100 + 4
	CASE IS = 70
		Delete.Text 32, 60, 32 + 5, 60 + 4
		Delete.Text 32, 80, 32 + 5, 80 + 4
		Delete.Text 32, 90, 32 + 5, 90 + 4
		Delete.Text 32, 100, 32 + 5, 100 + 4
	CASE IS = 80
		Delete.Text 32, 60, 32 + 5, 60 + 4
		Delete.Text 32, 70, 32 + 5, 70 + 4
		Delete.Text 32, 90, 32 + 5, 90 + 4
		Delete.Text 32, 100, 32 + 5, 100 + 4
	CASE IS = 90
		Delete.Text 32, 60, 32 + 5, 60 + 4
		Delete.Text 32, 70, 32 + 5, 70 + 4
		Delete.Text 32, 80, 32 + 5, 80 + 4
		Delete.Text 32, 100, 32 + 5, 100 + 4
	CASE IS = 100
		Delete.Text 32, 60, 32 + 5, 60 + 4
		Delete.Text 32, 70, 32 + 5, 70 + 4
		Delete.Text 32, 80, 32 + 5, 80 + 4
		Delete.Text 32, 90, 32 + 5, 90 + 4
END SELECT

''Move the cursor
IF (MoveCursorClock = 0) THEN
	IF (CursorToMove = MoveCursorUp) THEN
		MenuSelectionCursorY = MenuSelectionCursorY - 10
		IF (MenuSelectionCursorY <= 50) THEN MenuSelectionCursorY = 60
	ELSEIF (CursorToMove = MoveCursorDown) THEN
		MenuSelectionCursorY = MenuSelectionCursorY + 10
		IF (MenuSelectionCursorY >= 110) THEN MenuSelectionCursorY = 100
	END IF
	CursorToMove = 0
END IF
MoveCursorClock = MoveCursorClock + 1
IF (MoveCursorClock = 400) THEN KeyBoardCheck = TRUE: MoveCursorClock = 0

''Check the keyboard
IF (KeyBoardCheck = TRUE) THEN
	IF (MULTIKEY(72) = 1) THEN 'press up
		CursorToMove = MoveCursorUp
		MoveCursorClock = 0
		KeyBoardCheck = FALSE
	END IF

	IF (MULTIKEY(80) = 1) THEN 'press down
		CursorToMove = MoveCursorDown
		MoveCursorClock = 0
		KeyBoardCheck = FALSE
	END IF

	IF (MULTIKEY(57) = 1) OR (MULTIKEY(28) = 1) THEN 'press space or enter
		SELECT CASE MenuSelectionCursorY
			CASE IS = 60
				GameMode = Training
				CLEANUP
				EXIT SUB
			CASE IS = 70
				GameMode = Playing
				CLEANUP
				Load.Level "GAME.DAT"
				EXIT SUB
			CASE IS = 80
				Menu.Options
			CASE IS = 90
				Menu.HighScores
			CASE IS = 100   'Exit
				void = MULTIKEY(-2)            'Unhook keyboard ISR
				SCREEN 13: SCREEN 0: WIDTH 80  'Put the screen back into text mode
				END                            'End the program
				SYSTEM                         'Return control to the operating system
		END SELECT
		MoveCursorClock = 0
		KeyBoardCheck = FALSE
	END IF
END IF

IF (MULTIKEY(16) = 1) OR (MULTIKEY(1) = 1) THEN 'press "Q" or Escape
		void = MULTIKEY(-2)            'Unhook keyboard ISR
		SCREEN 13: SCREEN 0: WIDTH 80  'Put the screen back into text mode
		END                            'End the program
		SYSTEM                         'Return control to the operating system
END IF

GOTO MenuSelectionLoop


END SUB

SUB Menu.HighScores

''Loads the highscores file and displays them

''Declare local variables
DIM Counter AS INTEGER
DIM CursorX AS INTEGER
DIM CursorY AS INTEGER
DIM HighScoreNames(10) AS STRING

''Cleanup (fade menu a little w/ palletes)
CLEANUP

''Open the high scores file
OPEN "HSCR.DAT" FOR INPUT AS #1
	FOR Counter = 1 TO 10
		INPUT #1, HighScoreNames(Counter)
	NEXT Counter
CLOSE

''Type all the names on screen
FOR Counter = 1 TO 10
	Print.Text HighScoreNames(Counter) + "~", 95, 40 + (Counter * 10), 0
NEXT Counter
			  
Delay .5

''Done, wait for the player to..
Wait.KeyPress

''Cleanup and redraw the menu
mxFill Page1in320x200, Full320x200, 0
LOAD.GIF.X "MENU.GIF", 1
mxPCopy Page1in320x200, Page0in320x200, Full320x200

Print.Text "GOOD MORNING...~", 40, 40, 0

Print.Text "INSTRUCTIONS~", 40, 60, 0
Print.Text "START~", 40, 70, 0
Print.Text "OPTIONS~", 40, 80, 0
Print.Text "HIGH SCORES~", 40, 90, 0
Print.Text "EXIT~", 40, 100, 0


END SUB

SUB Menu.Options

''This is the options menu

''Declare local variables
DIM TinyTextCursorX AS INTEGER
DIM TinyTextCursorY AS INTEGER
DIM RandomNumber AS INTEGER
DIM TinyTextClock AS INTEGER
DIM MenuSelectionCursorX AS INTEGER
DIM MenuSelectionCursorY AS INTEGER
DIM MenuSelectionCursorBlinkClock AS INTEGER
DIM KeyBoardCheck AS INTEGER
DIM CursorToMove AS INTEGER
DIM MoveCursorUp AS INTEGER
DIM MoveCursorDown AS INTEGER
DIM MoveCursorClock AS INTEGER
DIM ChangeSpeedOptions AS INTEGER
DIM ChangeControlOptions AS INTEGER

''Cleanup
CLEANUP

''Greet the player and write out the menu options

Print.Text "OPTIONS~", 40, 40, .04

SELECT CASE GameSpeed
	CASE IS = 0
		Print.Text "SPEED: SLOW~", 40, 60, .04
	CASE IS = 1
		Print.Text "SPEED: NORMAL~", 40, 60, .04
	CASE IS = 2
		Print.Text "SPEED: FAST~", 40, 60, .04
END SELECT

SELECT CASE Player.ControlStyle
	CASE IS = ScreenOriented
		Print.Text "CONTROL: SCREEN~", 40, 70, .04
	CASE IS = ShipOriented
		Print.Text "CONTROL: MECH~", 40, 70, .04
END SELECT

Print.Text "BACK~", 40, 80, .04

TinyTextCursorX = 150
TinyTextCursorY = 20
TinyTextClock = 0

MenuSelectionCursorX = 32
MenuSelectionCursorY = 60
MenuSelectionCursorBlinkClock = 0
CursorToMove = 0
ChangeSpeedOptions = 0
ChangeControlOptions = 0
MoveCursorUp = 11          ''Constants
MoveCursorDown = 22        ''
MoveCursorClock = 0

KeyBoardCheck = TRUE


OptionsMenuSelectionLoop:

MenuSelectionCursorBlinkClock = MenuSelectionCursorBlinkClock + 1
IF (MenuSelectionCursorBlinkClock = 600) THEN MenuSelectionCursorBlinkClock = 0

KeyboardCheckClock = KeyboardCheckClock + 1
IF (KeyboardCheckClock = 50) THEN KeyboardCheckClock = 0

TinyTextClock = TinyTextClock + 1
IF (TinyTextClock = 1) THEN
	TinyTextClock = 0
	TinyTextCursorX = TinyTextCursorX + 1
	IF (TinyTextCursorX = 300) THEN
		TinyTextCursorX = 150
		TinyTextCursorY = TinyTextCursorY + 4
	END IF

	IF (TinyTextCursorY >= 180) THEN
		TinyTextCursorY = 20
	END IF
     
	RandomNumber = RND * 10
	IF (RandomNumber > 5) THEN mxPset Page0in320x200, TinyTextCursorX, TinyTextCursorY, 78
	IF (RandomNumber < 5) THEN mxPset Page0in320x200, TinyTextCursorX, TinyTextCursorY, 0
END IF


''Draw the selection cursor
IF (MenuSelectionCursorBlinkClock = 300) THEN
	mxPut 0, Page0in320x200, VARSEG(AlphabetCursor(0)), VARPTR(AlphabetCursor(0)), MenuSelectionCursorX, MenuSelectionCursorY
ELSEIF (MenuSelectionCursorBlinkClock = 0) THEN
	Delete.Text MenuSelectionCursorX, MenuSelectionCursorY, MenuSelectionCursorX + 5, MenuSelectionCursorY + 4
END IF

''Clean up the cursor on other choices
SELECT CASE MenuSelectionCursorY
	CASE IS = 60
		Delete.Text 32, 70, 32 + 5, 70 + 4
		Delete.Text 32, 80, 32 + 5, 80 + 4
		'Delete.Text 32, 90, 32 + 5, 90 + 4
		'Delete.Text 32, 100, 32 + 5, 100 + 4
	CASE IS = 70
		Delete.Text 32, 60, 32 + 5, 60 + 4
		Delete.Text 32, 80, 32 + 5, 80 + 4
		'Delete.Text 32, 90, 32 + 5, 90 + 4
		'Delete.Text 32, 100, 32 + 5, 100 + 4
	CASE IS = 80
		Delete.Text 32, 60, 32 + 5, 60 + 4
		Delete.Text 32, 70, 32 + 5, 70 + 4
		'Delete.Text 32, 90, 32 + 5, 90 + 4
		'Delete.Text 32, 100, 32 + 5, 100 + 4
	'CASE IS = 90
	'        Delete.Text 32, 60, 32 + 5, 60 + 4
	'        Delete.Text 32, 70, 32 + 5, 70 + 4
	'        Delete.Text 32, 80, 32 + 5, 80 + 4
	'        Delete.Text 32, 100, 32 + 5, 100 + 4
	'CASE IS = 100
	'        Delete.Text 32, 60, 32 + 5, 60 + 4
	'        Delete.Text 32, 70, 32 + 5, 70 + 4
	'        Delete.Text 32, 80, 32 + 5, 80 + 4
	'        Delete.Text 32, 90, 32 + 5, 90 + 4
END SELECT

''Move the cursor
IF (MoveCursorClock = 0) THEN
	IF (ChangeSpeedOptions = 1) THEN
		ChangeSpeedOptions = 0
		Delete.Text 82, 60, 170, 46
		Delete.Text 89, 60, 140, 67
		SELECT CASE GameSpeed
			CASE IS = 0
				Print.Text "SLOW  ~", 89, 60, 0
			CASE IS = 1
				Print.Text "NORMAL~", 89, 60, 0
			CASE IS = 2
				Print.Text "FAST  ~", 89, 60, 0
		END SELECT
	ELSEIF (ChangeControlOptions = 1) THEN
		ChangeControlOptions = 0
		Delete.Text 89, 70, 145, 77
		SELECT CASE Player.ControlStyle
			CASE IS = ScreenOriented
				Print.Text "CONTROL: SCREEN~", 40, 70, 0
			CASE IS = ShipOriented
				Print.Text "CONTROL: SHIP  ~", 40, 70, 0
		END SELECT
	ELSE
		IF (CursorToMove = MoveCursorUp) THEN
			MenuSelectionCursorY = MenuSelectionCursorY - 10
			IF (MenuSelectionCursorY <= 50) THEN MenuSelectionCursorY = 60
		ELSEIF (CursorToMove = MoveCursorDown) THEN
			MenuSelectionCursorY = MenuSelectionCursorY + 10
			IF (MenuSelectionCursorY >= 90) THEN MenuSelectionCursorY = 80
		END IF
	CursorToMove = 0
	END IF
END IF
MoveCursorClock = MoveCursorClock + 1
IF (MoveCursorClock = 800) THEN KeyBoardCheck = TRUE: MoveCursorClock = 0

''Check the keyboard
IF (KeyBoardCheck = TRUE) THEN
	IF (MULTIKEY(72) = 1) THEN 'press up
		CursorToMove = MoveCursorUp
		MoveCursorClock = 0
		KeyBoardCheck = FALSE
	END IF

	IF (MULTIKEY(80) = 1) THEN 'press down
		CursorToMove = MoveCursorDown
		MoveCursorClock = 0
		KeyBoardCheck = FALSE
	END IF

	IF (MULTIKEY(77) = 1) THEN 'press right
		IF (MenuSelectionCursorY = 60) THEN
			GameSpeed = GameSpeed - 1
			IF (GameSpeed < 0) THEN GameSpeed = 0
			ChangeSpeedOptions = 1
			MoveCursorClock = 0
			KeyBoardCheck = FALSE
		ELSEIF (MenuSelectionCursorY = 70) THEN
			Player.ControlStyle = ShipOriented
			ChangeControlOptions = 1
			MoveCursorClock = 0
			KeyBoardCheck = FALSE
		END IF
	END IF

	IF (MULTIKEY(75) = 1) THEN 'press left
		IF (MenuSelectionCursorY = 60) THEN
			GameSpeed = GameSpeed + 1
			IF (GameSpeed > 2) THEN GameSpeed = 2
			ChangeSpeedOptions = 1
			MoveCursorClock = 0
			KeyBoardCheck = FALSE
		ELSEIF (MenuSelectionCursorY = 70) THEN
			Player.ControlStyle = ScreenOriented
			ChangeControlOptions = 1
			MoveCursorClock = 0
			KeyBoardCheck = FALSE
		END IF
	END IF

	IF (MULTIKEY(57) = 1) OR (MULTIKEY(28) = 1) THEN 'press space or enter
		SELECT CASE MenuSelectionCursorY
			CASE IS = 60
			CASE IS = 70
			CASE IS = 80
				CLEANUP
				GOTO OptionsDone
			CASE IS = 90
				Menu.HighScores
			CASE IS = 100   'Exit
				void = MULTIKEY(-2)            'Unhook keyboard ISR
				'SCREEN 13: SCREEN 0: WIDTH 80  'Put the screen back into text mode
				END                            'End the program
				'SYSTEM                         'Return control to the operating system
		END SELECT
		MoveCursorClock = 0
		KeyBoardCheck = FALSE
	END IF
END IF

IF (MULTIKEY(16) = 1) OR (MULTIKEY(1) = 1) THEN 'press "Q" or Escape
	GOTO OptionsDone
END IF

GOTO OptionsMenuSelectionLoop

OptionsDone:
	''Greet the player and write out the menu options again
	mxFill Page1in320x200, Full320x200, 0
	LOAD.GIF.X "MENU.GIF", 1
	mxPCopy Page1in320x200, Page0in320x200, Full320x200

	IF (TIMER / 100 <= 12 * 36) THEN
		Print.Text "GOOD MORNING...~", 40, 40, 0
	ELSEIF (TIMER / 100 < 18 * 36) THEN
		Print.Text "GOOD AFTERNOON...~", 40, 40, 0
	ELSEIF (TIMER / 100 >= 18 * 36) THEN
		Print.Text "GOOD EVENING...~", 40, 40, 0
	END IF

	Print.Text "INSTRUCTIONS~", 40, 60, 0
	Print.Text "START~", 40, 70, 0
	Print.Text "OPTIONS~", 40, 80, 0
	Print.Text "HIGH SCORES~", 40, 90, 0
	Print.Text "EXIT~", 40, 100, 0

END SUB
