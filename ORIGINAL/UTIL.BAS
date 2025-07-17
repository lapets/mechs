'///// Mechs : Util.bas /////////////////////////////////////////////////////
'///// July 24, 2001 ////////////////////////////////////////////////////////

'///// I N C L U D E S //////////////////////////////////////////////////////
REM $INCLUDE: 'qb.bi'                        ''for assembly routines
REM $INCLUDE: 'modexlib.bi'                  ''for mode X graphics

''Make sure memory for arrays is allocated dynamically
REM $DYNAMIC

'///// P R O T O T Y P E S //////////////////////////////////////////////////
DECLARE SUB Delay (Seconds AS DOUBLE)
DECLARE SUB wait.for (loops AS INTEGER)

''Clear and reinitialize the stack to 25000 (it crashed at 4096)
CLEAR , , 25000

REM $STATIC
SUB Delay (Seconds AS DOUBLE)

''Delay for a specified amount of time

''Declare local variables
DIM StartingTime AS DOUBLE

''Record current starting time
StartingTime = TIMER

''Loop until specified time expires
WHILE (TIMER - StartingTime < Seconds)
WEND

END SUB

SUB wait.for (loops AS INTEGER)

'///////This function delays program flow for////////////////////////////////
'///////"loops" number of "for" loops////////////////////////////////////////

FOR repeat = 1 TO loops
NEXT repeat

END SUB
