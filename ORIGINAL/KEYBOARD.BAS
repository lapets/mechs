'///// Mechs : Keyboard.bas /////////////////////////////////////////////////
'///// July 18, 2001 ////////////////////////////////////////////////////////

'///// I N C L U D E S //////////////////////////////////////////////////////
REM $INCLUDE: 'qb.bi'                        ''for assembly routines

'///// P R O T O T Y P E S //////////////////////////////////////////////////
DECLARE FUNCTION MULTIKEY (T!)
DECLARE SUB Wait.KeyPress ()

'///// D E F I N I T I O N S ////////////////////////////////////////////////
REM $STATIC

FUNCTION MULTIKEY (T)

''This is the keyboard ISR function that allows
''simultaneous keypresses to be detected.

STATIC kbcontrol%(), kbmatrix%(), Firsttime, StatusFlag

IF Firsttime = 0 THEN          'Initalize
 DIM kbcontrol%(128)
 DIM kbmatrix%(128)
 code$ = ""
 code$ = code$ + "E91D00E93C00000000000000000000000000000000000000000000000000"
 code$ = code$ + "00001E31C08ED8BE24000E07BF1400FCA5A58CC38EC0BF2400B85600FAAB"
 code$ = code$ + "89D8ABFB1FCB1E31C08EC0BF2400BE14000E1FFCFAA5A5FB1FCBFB9C5053"
 code$ = code$ + "51521E560657E460B401A8807404B400247FD0E088C3B700B0002E031E12"
 code$ = code$ + "002E8E1E100086E08907E4610C82E661247FE661B020E6205F075E1F5A59"
 code$ = code$ + "5B589DCF"
 DEF SEG = VARSEG(kbcontrol%(0))
 FOR i% = 0 TO 155                     ' Load ASM
     d% = VAL("&h" + MID$(code$, i% * 2 + 1, 2))
     POKE VARPTR(kbcontrol%(0)) + i%, d%
 NEXT i%
 i& = 16       ' I think this stuff connects the interrupt with kbmatrix%()
 n& = VARSEG(kbmatrix%(0)): l& = n& AND 255: h& = ((n& AND &HFF00) \ 256): POKE i&, l&: POKE i& + 1, h&: i& = i& + 2
 n& = VARPTR(kbmatrix%(0)): l& = n& AND 255: h& = ((n& AND &HFF00) \ 256): POKE i&, l&: POKE i& + 1, h&: i& = i& + 2
 DEF SEG
 Firsttime = 1
END IF

SELECT CASE T
 CASE -1
  IF StatusFlag = 0 THEN
   DEF SEG = VARSEG(kbcontrol%(0))
   CALL ABSOLUTE(0)                     ' Run interrupt
   DEF SEG
   StatusFlag = 1
  END IF
 CASE -2
  IF StatusFlag = 1 THEN
   DEF SEG = VARSEG(kbcontrol%(0))      ' Turn off interrupt
   CALL ABSOLUTE(3)
   DEF SEG
   StatusFlag = 0
  END IF
 CASE 1 TO 128
  MULTIKEY = kbmatrix%(T)               ' Return status
 CASE ELSE
  MULTIKEY = 0                          ' User Supidity Error
END SELECT

END FUNCTION

SUB Wait.KeyPress

''Wait until one of the keys is pressed

''Declare local variables
DIM KeyPressed AS INTEGER
DIM KeyCounter AS SINGLE

KeyPressed = FALSE
KeyCounter = 0

''Keep cycling through all the keys until one is pressed
WHILE KeyPressed <> TRUE
	FOR KeyCounter = 1 TO 128
		IF (MULTIKEY(KeyCounter) = 1) THEN KeyPressed = TRUE
	NEXT KeyCounter
WEND

END SUB
