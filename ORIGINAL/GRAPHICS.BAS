'///// Mechs : Graphics.bas /////////////////////////////////////////////////
'///// July 18, 2001 ////////////////////////////////////////////////////////

'///// I N C L U D E S //////////////////////////////////////////////////////
REM $INCLUDE: 'qb.bi'                        ''for assembly routines
REM $INCLUDE: 'modexlib.bi'                  ''for mode X graphics

''Make sure memory for arrays is allocated dynamically
REM $DYNAMIC

'///// P R O T O T Y P E S //////////////////////////////////////////////////
DECLARE SUB CLEANUP ()
DECLARE SUB LOAD.GIF.X (load.pic$, page AS INTEGER)
DECLARE SUB LOAD.PALLETE (load.pic$)

''Clear and reinitialize the stack to 25000 (it crashed at 4096)
CLEAR , , 25000

REM $STATIC
SUB CLEANUP

''This function cleans up each page of screen mode X

mxFill Page0in320x200, Full320x200, 0
mxFill Page1in320x200, Full320x200, 0
mxFill Page2in320x200, Full320x200, 0
mxFill Page3in320x200, Full320x200, 0


END SUB

SUB LOAD.GIF.X (load.pic$, page AS INTEGER)

'****************************************************************************
'*//////This function loads *.GIF files that are 320x200 and////////////////*
'*//////have 256 colors to a page in mode X/////////////////////////////////*
'*//////--Andrei Lapets 8/24/1999--/////////////////////////////////////////*
'****************************************************************************

''Local variables
DEFINT A-Z
DIM Prefix(4095), Suffix(4095), OutStack(4095), shiftout%(8)
DIM Ybase AS LONG, powersof2(11) AS LONG, WorkCode AS LONG
DIM DrawPage

''Check which page we're drawing on
SELECT CASE page
	CASE IS = 0: DrawPage = Page0in320x200
	CASE IS = 1: DrawPage = Page1in320x200
	CASE IS = 2: DrawPage = Page2in320x200
	CASE IS = 3: DrawPage = Page3in320x200
END SELECT

''Clean up the page we're drawing to
mxFill DrawPage, Full320x200, 0

FOR a% = 0 TO 7: shiftout%(8 - a%) = 2 ^ a%: NEXT a%
FOR a% = 0 TO 11: powersof2(a%) = 2 ^ a%: NEXT a%

''Open the file
OPEN load.pic$ FOR BINARY AS #1
a$ = "      ": GET #1, , a$

GET #1, , TotalX: GET #1, , TotalY: GOSUB GetByteX
NumColors = 2 ^ ((a% AND 7) + 1): NoPalette = (a% AND 128) = 0
GOSUB GetByteX: Background = a%
GOSUB GetByteX: IF a% <> 0 THEN PRINT "Bad screen descriptor.": END
IF NoPalette = 0 THEN P$ = SPACE$(NumColors * 3): GET #1, , P$
DO
    GOSUB GetByteX
    IF a% = 44 THEN
	EXIT DO
    ELSEIF a% <> 33 THEN
	PRINT "Unknown extension type.": END
    END IF
    GOSUB GetByteX
    DO: GOSUB GetByteX: a$ = SPACE$(a%): GET #1, , a$: LOOP UNTIL a% = 0
LOOP
GET #1, , XStart: GET #1, , YStart: GET #1, , XLength: GET #1, , YLength
XEnd = XStart + XLength: YEnd = YStart + YLength: GOSUB GetByteX
IF a% AND 128 THEN PRINT "Can't handle local colormaps.": END
Interlaced = a% AND 64: PassNumber = 0: PassStep = 8
GOSUB GetByteX
ClearCode = 2 ^ a%
EOSCode = ClearCode + 1
FirstCode = ClearCode + 2: NextCode = FirstCode
StartCodeSize = a% + 1: CodeSize = StartCodeSize
StartMaxCode = 2 ^ (a% + 1) - 1: MaxCode = StartMaxCode

BitsIn = 0: BlockSize = 0: BlockPointer = 1
x% = XStart: y% = YStart: Ybase = y% * 320&

''Start from mode 13h, then switch to mode X
''***Deactivate temporarily, since everything is already set up at runtime***
'SCREEN 13: mxMode320x200

''Load the pallete
IF NoPalette = 0 THEN
    OUT &H3C7, 0: OUT &H3C8, 0
    FOR a% = 1 TO NumColors * 3: OUT &H3C9, ASC(MID$(p$, a%, 1)) \ 4: NEXT a%
END IF

DO
    GOSUB GetCodeX
    IF code <> EOSCode THEN
	IF code = ClearCode THEN
	    NextCode = FirstCode
	    CodeSize = StartCodeSize
	    MaxCode = StartMaxCode
	    GOSUB GetCodeX
	    CurCode = code: LastCode = code: LastPixel = code
	    IF x% < 320 THEN mxPset DrawPage, x%, y%, LastPixel
	    x% = x% + 1: IF x% = XEnd THEN GOSUB NextScanLineX
	ELSE
	    CurCode = code: StackPointer = 0
	    IF code > NextCode THEN EXIT DO
	    IF code = NextCode THEN
		CurCode = LastCode
		OutStack(StackPointer) = LastPixel
		StackPointer = StackPointer + 1
	    END IF

	    DO WHILE CurCode >= FirstCode
		OutStack(StackPointer) = Suffix(CurCode)
		StackPointer = StackPointer + 1
		CurCode = Prefix(CurCode)
	    LOOP

	    LastPixel = CurCode
	    IF x% < 320 THEN mxPset DrawPage, x%, y%, LastPixel
	    x% = x% + 1: IF x% = XEnd THEN GOSUB NextScanLineX

	    FOR a% = StackPointer - 1 TO 0 STEP -1
		IF x% < 320 THEN mxPset DrawPage, x%, y%, OutStack(a%)
		x% = x% + 1: IF x% = XEnd THEN GOSUB NextScanLineX
	    NEXT a%

	    IF NextCode < 4096 THEN
		Prefix(NextCode) = LastCode
		Suffix(NextCode) = LastPixel
		NextCode = NextCode + 1
		IF NextCode > MaxCode AND CodeSize < 12 THEN
		    CodeSize = CodeSize + 1
		    MaxCode = MaxCode * 2 + 1
		END IF
	    END IF
	    LastCode = code
	END IF
    END IF
LOOP UNTIL DoneFlag OR code = EOSCode
CLOSE #1
EXIT SUB

GetByteX: a$ = " ": GET #1, , a$: a% = ASC(a$): RETURN

NextScanLineX:
    IF Interlaced THEN
	y% = y% + PassStep
	IF y% >= YEnd THEN
	    PassNumber = PassNumber + 1
	    SELECT CASE PassNumber
	    CASE 1: y% = 4: PassStep = 8
	    CASE 2: y% = 2: PassStep = 4
	    CASE 3: y% = 1: PassStep = 2
	    END SELECT
	END IF
    ELSE
	y% = y% + 1
    END IF
    x% = XStart: Ybase = y% * 320&: DoneFlag = y% > 199
RETURN
GetCodeX:
    IF BitsIn = 0 THEN GOSUB ReadBufferedByteX: LastChar = a%: BitsIn = 8
    WorkCode = LastChar \ shiftout%(BitsIn)
    DO WHILE CodeSize > BitsIn
	GOSUB ReadBufferedByteX: LastChar = a%
	WorkCode = WorkCode OR LastChar * powersof2(BitsIn)
	BitsIn = BitsIn + 8
    LOOP
    BitsIn = BitsIn - CodeSize
    code = WorkCode AND MaxCode
RETURN
ReadBufferedByteX:
    IF BlockPointer > BlockSize THEN
	GOSUB GetByteX: BlockSize = a%
	a$ = SPACE$(BlockSize): GET #1, , a$
	BlockPointer = 1
    END IF
    a% = ASC(MID$(a$, BlockPointer, 1)): BlockPointer = BlockPointer + 1
RETURN


END SUB

DEFSNG A-Z
SUB LOAD.PALLETE (load.pic$)

'****************************************************************************
'*//////This function loads a pallete from *.GIF ///////////////////////////*
'*//////files that are 320x200, 256 colors (out of 16 million)//////////////*
'*//////--Andrei Lapets 7/16/2000--/////////////////////////////////////////*
'****************************************************************************

DEFINT A-Z
DIM Prefix(4095), Suffix(4095), OutStack(4095), shiftout%(8)
DIM Ybase AS LONG, powersof2(11) AS LONG, WorkCode AS LONG

FOR a% = 0 TO 7: shiftout%(8 - a%) = 2 ^ a%: NEXT a%
FOR a% = 0 TO 11: powersof2(a%) = 2 ^ a%: NEXT a%

OPEN load.pic$ FOR BINARY AS #1
a$ = "      ": GET #1, , a$

GET #1, , TotalX: GET #1, , TotalY: GOSUB GetPalByte
NumColors = 2 ^ ((a% AND 7) + 1): NoPalette = (a% AND 128) = 0
GOSUB GetPalByte: Background = a%
GOSUB GetPalByte: IF a% <> 0 THEN PRINT "Bad screen descriptor.": END
IF NoPalette = 0 THEN P$ = SPACE$(NumColors * 3): GET #1, , P$
DO
    GOSUB GetPalByte
    IF a% = 44 THEN
	EXIT DO
    ELSEIF a% <> 33 THEN
	PRINT "Unknown extension type.": END
    END IF
    GOSUB GetPalByte
    DO: GOSUB GetPalByte: a$ = SPACE$(a%): GET #1, , a$: LOOP UNTIL a% = 0
LOOP
GET #1, , XStart: GET #1, , YStart: GET #1, , XLength: GET #1, , YLength
XEnd = XStart + XLength: YEnd = YStart + YLength: GOSUB GetPalByte
IF a% AND 128 THEN PRINT "Can't handle local colormaps.": END
Interlaced = a% AND 64: PassNumber = 0: PassStep = 8
GOSUB GetPalByte
ClearCode = 2 ^ a%
EOSCode = ClearCode + 1
FirstCode = ClearCode + 2: NextCode = FirstCode
StartCodeSize = a% + 1: CodeSize = StartCodeSize
StartMaxCode = 2 ^ (a% + 1) - 1: MaxCode = StartMaxCode

BitsIn = 0: BlockSize = 0: BlockPointer = 1
x% = XStart: y% = YStart: Ybase = y% * 320&

'SCREEN 13
DEF SEG = &HA000
IF NoPalette = 0 THEN
    ''To allow loading palletes w/o screen erasures
    OUT &H3C7, 0: OUT &H3C8, 0
    FOR a% = 1 TO NumColors * 3: OUT &H3C9, ASC(MID$(P$, a%, 1)) \ 4: NEXT a%
END IF
'LINE (0, 0)-(319, 199), BackGround, BF
CLOSE #1
EXIT SUB

GetPalByte: a$ = " ": GET #1, , a$: a% = ASC(a$): RETURN

ReadBufferedPalByte:
    IF BlockPointer > BlockSize THEN
	GOSUB GetPalByte: BlockSize = a%
	a$ = SPACE$(BlockSize): GET #1, , a$
	BlockPointer = 1
    END IF
    a% = ASC(MID$(a$, BlockPointer, 1)): BlockPointer = BlockPointer + 1
RETURN

END SUB
