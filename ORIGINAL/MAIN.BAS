'///// Mechs ////////////////////////////////////////////////////////////////
'///// July 2001 ////////////////////////////////////////////////////////////

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
DECLARE SUB wait.for (loops AS INTEGER)

DECLARE FUNCTION MULTIKEY (T!)
DECLARE SUB Wait.KeyPress ()

DECLARE SUB CLEANUP ()
DECLARE SUB LOAD.GIF.X (load.pic$, page AS INTEGER)
DECLARE SUB LOAD.PALLETE (load.pic$)

DECLARE SUB Script.Chase (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Fighter (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Wiggling (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Wandering (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Cautious (CurrentEnemy AS INTEGER)

DECLARE SUB Menu ()
DECLARE SUB Menu.HighScores ()
DECLARE SUB Menu.Options ()

DECLARE SUB Print.Text (TextOut AS STRING, x AS INTEGER, y AS INTEGER, DelayTime AS DOUBLE)
DECLARE SUB Delete.Text (x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER)
DECLARE SUB read.keyboard ()
DECLARE SUB Input.HighScore (Score AS LONG)
DECLARE SUB Load.Sprites ()
DECLARE SUB Load.Level (LevelPath AS STRING)
DECLARE SUB Intro.Company ()
DECLARE SUB Training.Script (CurrentStep AS INTEGER)
DECLARE SUB Init.Player ()
DECLARE SUB Init.Missiles ()
DECLARE SUB Init.Enemies ()
DECLARE SUB Init.PowerUps ()
DECLARE SUB Init.Explosions ()
DECLARE SUB Create.PowerUp (x AS INTEGER, y AS INTEGER)
DECLARE SUB Create.Explosion (x AS INTEGER, y AS INTEGER, Design AS INTEGER)
DECLARE SUB Shoot.Missile (CannonX AS INTEGER, CannonY AS INTEGER, VelocityX AS INTEGER, VelocityY AS INTEGER, Design AS INTEGER)
DECLARE SUB Update.Player ()
DECLARE SUB Update.Missiles ()
DECLARE SUB Update.Enemies ()
DECLARE SUB Update.PowerUps ()
DECLARE SUB Update.Target ()
DECLARE SUB Update.Explosions ()
DECLARE SUB Handle.Collisions ()
DECLARE SUB Draw.Player (DrawingLevel AS INTEGER)
DECLARE SUB Draw.Missiles (DrawingLevel AS INTEGER)
DECLARE SUB Draw.Enemies (DrawingLevel AS INTEGER)
DECLARE SUB Draw.PowerUps (DrawingLevel AS INTEGER)
DECLARE SUB Draw.Target (DrawingLevel AS INTEGER)
DECLARE SUB Draw.Explosions (DrawingLevel AS INTEGER)
DECLARE SUB Draw.All ()
DECLARE SUB Display.Score (Score AS LONG, DrawingLevel AS INTEGER, x AS INTEGER, y AS INTEGER)
DECLARE SUB Display.Bars (DrawingLevel AS INTEGER)

'///// G L O B A L S ////////////////////////////////////////////////////////
''(arrays only, all variables declared as COMMON in 'common.bi')
'DIM SHARED loops AS INTEGER                         '"FOR" loop counter
'DIM SHARED key.press AS STRING                      'Stores keyboard press
'DIM SHARED void AS INTEGER                          'For calling functions

'DIM SHARED Player AS MECHS
DIM SHARED Missile(MAXMISSILES) AS MISSILES
DIM SHARED Enemy(MAXENEMIES) AS ENEMIES
DIM SHARED PowerUp(MAXPOWERUPS) AS POWERUPS
DIM SHARED Explosion(MAXEXPLOSIONS) AS EXPLOSIONS
'DIM SHARED Target AS TARGETS
'DIM SHARED Level AS LEVELS

DIM SHARED MechUp(171) AS INTEGER                   'Allocate sprite memory
DIM SHARED MechDown(171) AS INTEGER
DIM SHARED MechLeft(171) AS INTEGER
DIM SHARED MechRight(171) AS INTEGER
DIM SHARED MechUpRight(171) AS INTEGER
DIM SHARED MechDownRight(171) AS INTEGER
DIM SHARED MechDownLeft(171) AS INTEGER
DIM SHARED MechUpLeft(171) AS INTEGER
DIM SHARED MechUpStopped(171) AS INTEGER            'Stopped
DIM SHARED MechDownStopped(171) AS INTEGER
DIM SHARED MechLeftStopped(171) AS INTEGER
DIM SHARED MechRightStopped(171) AS INTEGER
DIM SHARED MechUpRightStopped(171) AS INTEGER
DIM SHARED MechDownRightStopped(171) AS INTEGER
DIM SHARED MechDownLeftStopped(171) AS INTEGER
DIM SHARED MechUpLeftStopped(171) AS INTEGER
DIM SHARED MechBuffer(600) AS INTEGER

DIM SHARED Shield(340) AS INTEGER

DIM SHARED MissileBlue(15) AS INTEGER
DIM SHARED MissileRed(15) AS INTEGER
DIM SHARED MissileGreen(15) AS INTEGER
DIM SHARED MissileYellow(15) AS INTEGER
DIM SHARED MissileBuffer(50) AS INTEGER

DIM SHARED Enemy1(171) AS INTEGER
DIM SHARED EnemyUp1(171) AS INTEGER
DIM SHARED EnemyDown1(171) AS INTEGER
DIM SHARED EnemyLeft1(171) AS INTEGER
DIM SHARED EnemyRight1(171) AS INTEGER
DIM SHARED EnemyUp2(171) AS INTEGER
DIM SHARED EnemyDown2(171) AS INTEGER
DIM SHARED EnemyLeft2(171) AS INTEGER
DIM SHARED EnemyRight2(171) AS INTEGER
DIM SHARED EnemyUp3(171) AS INTEGER
DIM SHARED EnemyDown3(171) AS INTEGER
DIM SHARED EnemyLeft3(171) AS INTEGER
DIM SHARED EnemyRight3(171) AS INTEGER
DIM SHARED EnemyUp4(171) AS INTEGER
DIM SHARED EnemyDown4(171) AS INTEGER
DIM SHARED EnemyLeft4(171) AS INTEGER
DIM SHARED EnemyRight4(171) AS INTEGER
DIM SHARED EnemyBuffer(171) AS INTEGER

DIM SHARED Explosion1(171) AS INTEGER
DIM SHARED Explosion2(171) AS INTEGER
DIM SHARED Explosion3(171) AS INTEGER
DIM SHARED Explosion4(171) AS INTEGER

DIM SHARED Explosion1b(743) AS INTEGER
DIM SHARED Explosion2b(743) AS INTEGER
DIM SHARED Explosion3b(743) AS INTEGER
DIM SHARED Explosion4b(743) AS INTEGER
DIM SHARED Explosion5b(743) AS INTEGER
DIM SHARED Explosion1c(743) AS INTEGER
DIM SHARED Explosion2c(743) AS INTEGER
DIM SHARED Explosion3c(743) AS INTEGER
DIM SHARED Explosion4c(743) AS INTEGER
DIM SHARED Explosion5c(743) AS INTEGER
DIM SHARED ExplosionBuffer(743) AS INTEGER

DIM SHARED Target1(202) AS INTEGER
DIM SHARED Target2(202) AS INTEGER
DIM SHARED Target3(202) AS INTEGER
DIM SHARED Target4(202) AS INTEGER
DIM SHARED TargetBuffer(800) AS INTEGER

DIM SHARED PowerUpSuper(43) AS INTEGER
DIM SHARED PowerUpSpread(43) AS INTEGER
DIM SHARED PowerUpDouble(43) AS INTEGER
DIM SHARED PowerUpDoubleRed(43) AS INTEGER
DIM SHARED PowerUpRed(43) AS INTEGER
DIM SHARED PowerUpScore(43) AS INTEGER
DIM SHARED PowerUpHealth(43) AS INTEGER
DIM SHARED PowerUpEmpty(43) AS INTEGER
DIM SHARED PowerUpShield(43) AS INTEGER
DIM SHARED PowerUpBuffer(43) AS INTEGER

DIM SHARED EmptyBar(184) AS INTEGER             ''Health and Heat bars
DIM SHARED RedBar(5) AS INTEGER
DIM SHARED GreenBar(5) AS INTEGER
DIM SHARED BlueBar(5) AS INTEGER
DIM SHARED BarBuffer(184) AS INTEGER

DIM SHARED AlphabetA(17) AS INTEGER             ''The alphabet
DIM SHARED AlphabetB(17) AS INTEGER
DIM SHARED AlphabetC(17) AS INTEGER
DIM SHARED AlphabetD(17) AS INTEGER
DIM SHARED AlphabetE(17) AS INTEGER
DIM SHARED AlphabetF(17) AS INTEGER
DIM SHARED AlphabetG(17) AS INTEGER
DIM SHARED AlphabetH(17) AS INTEGER
DIM SHARED AlphabetI(17) AS INTEGER
DIM SHARED AlphabetJ(17) AS INTEGER
DIM SHARED AlphabetK(17) AS INTEGER
DIM SHARED AlphabetL(17) AS INTEGER
DIM SHARED AlphabetM(17) AS INTEGER
DIM SHARED AlphabetN(17) AS INTEGER
DIM SHARED AlphabetO(17) AS INTEGER
DIM SHARED AlphabetP(17) AS INTEGER
DIM SHARED AlphabetQ(17) AS INTEGER
DIM SHARED AlphabetR(17) AS INTEGER
DIM SHARED AlphabetS(17) AS INTEGER
DIM SHARED AlphabetT(17) AS INTEGER
DIM SHARED AlphabetU(17) AS INTEGER
DIM SHARED AlphabetV(17) AS INTEGER
DIM SHARED AlphabetW(17) AS INTEGER
DIM SHARED AlphabetX(17) AS INTEGER
DIM SHARED AlphabetY(17) AS INTEGER
DIM SHARED AlphabetZ(17) AS INTEGER
DIM SHARED Alphabet1(17) AS INTEGER
DIM SHARED Alphabet2(17) AS INTEGER
DIM SHARED Alphabet3(17) AS INTEGER
DIM SHARED Alphabet4(17) AS INTEGER
DIM SHARED Alphabet5(17) AS INTEGER
DIM SHARED Alphabet6(17) AS INTEGER
DIM SHARED Alphabet7(17) AS INTEGER
DIM SHARED Alphabet8(17) AS INTEGER
DIM SHARED Alphabet9(17) AS INTEGER
DIM SHARED Alphabet0(17) AS INTEGER
DIM SHARED AlphabetColon(17) AS INTEGER
DIM SHARED AlphabetApostrophe(17) AS INTEGER
DIM SHARED AlphabetPeriod(17) AS INTEGER
DIM SHARED AlphabetComma(17) AS INTEGER
DIM SHARED AlphabetExclamation(17) AS INTEGER
DIM SHARED AlphabetQuestion(17) AS INTEGER
DIM SHARED AlphabetSlash(17) AS INTEGER
DIM SHARED AlphabetCursor(17) AS INTEGER
DIM SHARED AlphabetBuffer(17) AS INTEGER

DIM SHARED Number0(85) AS INTEGER               ''For scoring
DIM SHARED Number1(85) AS INTEGER
DIM SHARED Number2(85) AS INTEGER
DIM SHARED Number3(85) AS INTEGER
DIM SHARED Number4(85) AS INTEGER
DIM SHARED Number5(85) AS INTEGER
DIM SHARED Number6(85) AS INTEGER
DIM SHARED Number7(85) AS INTEGER
DIM SHARED Number8(85) AS INTEGER
DIM SHARED Number9(85) AS INTEGER
DIM SHARED NumberBuffer(170) AS INTEGER

'DIM SHARED GameSpeed AS INTEGER             'The game's speed setting
'DIM SHARED GameMode AS INTEGER              'The game mode
'DIM CurrentTrainingStep AS INTEGER          'For the instructions mode
'DIM LastStepTime AS DOUBLE                  'For in-between timing in training
'DIM SHARED EnemiesKilled AS INTEGER
'DIM SHARED PowerUpsGained AS INTEGER        'For training
'DIM SHARED PowerUpSpeedDelay AS INTEGER
'DIM SHARED EnemySpeedDelay AS INTEGER
'DIM SHARED EnemyMissileSpeedDelay AS INTEGER

'DIM SHARED MissileClock AS INTEGER          'To keep missiles coming steadily
'DIM SHARED EnemyMissileClock AS INTEGER
'DIM SHARED EnemyClock AS INTEGER            'To keep the enemies slow
'DIM SHARED PlayerExplosionClock AS INTEGER  'For explosions
'DIM SHARED PlayerHeatClock AS INTEGER       'For limiting auto-fire
'DIM SHARED PowerUpClock AS INTEGER

'DIM SHARED GeneralCounter AS INTEGER
'DIM SHARED GeneralSwitch AS INTEGER

DIM SHARED PowerUpTable(100) AS INTEGER     'For random powerups

'///// M A I N //////////////////////////////////////////////////////////////

RANDOMIZE TIMER        'Seed the random number generator
		     
void = MULTIKEY(-1)    'Hook up the keyboard ISR interrupt

SCREEN 13              '320x200 256 color VGA screen mode (13h)
CLS                    'Clean up the screen

'Set screen mode X at 320x200 resolution
mxMode320x200
''Clean up the pages
CLEANUP

''Pages: 0 = Visible; 1 = Double Buffer

Load.Sprites
LOAD.PALLETE "DATA.GIF"

Intro.Company

GameSpeed = 1
GameMode = Training

Menu:

''Initialize everything, to training mode
Init.Missiles
Init.Enemies
Init.Player
Init.PowerUps
Init.Explosions

Menu

LoopClock = 0
MissileClock = 0
EnemyClock = 0
PlayerExplosionClock = 0
PlayerHeatClock = 0
EnemyMissileClock = 0
PowerUpClock = 0

LastStepTime = 96000           ''For training
CurrentTrainingStep = 1
EnemiesKilled = 0
PowerUpsGained = 0

EnemySpeedDelay = 6
EnemyMissileSpeedDelay = 5
PowerUpSpeedDelay = 2

IF (GameMode = Training) THEN
	Training.Script (1)
ELSE
	Draw.All
	Print.Text "GET READY", 137, 97, 0
	Delay 1
	Delete.Text 137, 97, 270, 104
END IF

GameLoop:
	''Make sure the delays are in range
	IF (EnemySpeedDelay <= 0) THEN EnemySpeedDelay = 1
	IF (EnemyMissileSpeedDelay <= 0) THEN EnemyMissileSpeedDelay = 1

	''To allow one missile to be fired before another one is fired,
	''the MissileClock makes sure some time has expired before the
	''next missile is allowed to fire
	MissileClock = MissileClock - 1
	IF (MissileClock = -1) THEN MissileClock = 0
      
	EnemyMissileClock = EnemyMissileClock + 1
	IF (EnemyMissileClock = EnemyMissileSpeedDelay) THEN EnemyMissileClock = 0
      
	Draw.Player (1)           ''Transpose everything onto the
	Draw.Missiles (1)         ''background on page 1
	Draw.Enemies (1)
	Draw.PowerUps (1)
	Draw.Explosions (1)
	Draw.Target (1)
	Display.Score Player.Score, 1, 2, 2
	Display.Bars (1)

	Draw.Player (2)           ''Transfer everything to page 0
	Draw.Missiles (2)         ''along with background
	Draw.Enemies (2)
	Draw.PowerUps (2)
	Draw.Explosions (2)
	Draw.Target (2)
	Display.Score Player.Score, 2, 2, 2
	Display.Bars (2)

	Draw.Player (3)           ''Restore the background on page 1
	Draw.Missiles (3)
	Draw.Enemies (3)
	Draw.PowerUps (3)
	Draw.Explosions (3)
	Draw.Target (3)
	Display.Score Player.Score, 3, 2, 2
	Display.Bars (3)

	read.keyboard

	Update.Missiles
	Update.Player
	Update.Target
	

	''If the player quit, return to the menu
	IF (GameMode = DisplayingMenu) THEN GOTO Menu

	''Slow down the powerups
	PowerUpClock = PowerUpClock + 1
	IF (PowerUpClock >= PowerUpSpeedDelay) THEN
		PowerUpClock = 0
		Update.PowerUps
	END IF

	''Only allow enemies to move every number loops (x slower than player)
	EnemyClock = EnemyClock + 1
	IF (EnemyClock >= EnemySpeedDelay) THEN
		EnemyClock = 0
		Update.Enemies
		Update.Explosions
	END IF

	Handle.Collisions

	''If we're in training, check if it's time to go to the next
	''step
	IF (GameMode = Training) AND (CurrentTrainingStep < 3) THEN
		IF (ABS(TIMER - LastStepTime) > 5) THEN
			CurrentTrainingStep = CurrentTrainingStep + 1
			Training.Script (CurrentTrainingStep)
			LastStepTime = TIMER
		END IF
	END IF
	IF (GameMode = Training) AND (PowerUpsGained = 1) THEN
		Training.Script (4)
	END IF

	''Check if we're moving on to the next level
	IF (EnemiesKilled >= Level.EnemiesToKill) THEN
		''Make sure there are no powerups flying around
		''before advancing to the next level
		GeneralSwitch = FALSE
		FOR GeneralCounter = 1 TO MAXPOWERUPS
			IF (PowerUp(GeneralCounter).State = Flying) THEN
				GeneralSwitch = MARK
			END IF
		NEXT GeneralCounter
		IF (GeneralSwitch <> MARK) THEN
			Init.Missiles
			Init.PowerUps
			Load.Level Level.NextLevel
			EnemiesKilled = 0
			Draw.All
			Print.Text "GET READY", 137, 97, 0
			Delay 1
			Delete.Text 137, 97, 270, 104
		END IF
	END IF
       
	SELECT CASE GameSpeed
		CASE IS = 0
			wait.for (3000)
		CASE IS = 1
			wait.for (2000)
		CASE IS = 2
			wait.for (500)
	END SELECT

GOTO GameLoop

End.Program:
void = MULTIKEY(-2)               'Unhook the keyboard ISR interrupt
'SCREEN 13: SCREEN 0: WIDTH 80     'Put the screen back into text mode
END                               'End the program
'SYSTEM                            'Return control to the operating system

'///// D E F I N I T I O N S ////////////////////////////////////////////////
REM $STATIC
SUB Create.Explosion (x AS INTEGER, y AS INTEGER, Design AS INTEGER)

''Start an explosion on the screen

''Declare local variables
DIM ExplosionCounter AS INTEGER

'Walk through the array of explosions finding an inactive one
ExplosionCounter = 0
DO
	ExplosionCounter = ExplosionCounter + 1
	''Error Checking
	IF (ExplosionCounter > MAXEXPLOSIONS) THEN EXIT SUB
LOOP UNTIL (Explosion(ExplosionCounter).State = Inactive)

'Found, initialize the explosion's variables
Explosion(ExplosionCounter).State = Exploding
Explosion(ExplosionCounter).Sprite.x = x
Explosion(ExplosionCounter).Sprite.y = y
Explosion(ExplosionCounter).AnimationStep = 0
Explosion(ExplosionCounter).Sprite.Design = Design

''Make sure not to draw any explosions going offscreen
IF (Design = Horizontal) THEN
	IF (x < 1) OR (x + 113 > 319) THEN Explosion(ExplosionCounter).State = Inactive
ELSEIF (Design = Vertical) THEN
	IF (y < 1) OR (y + 113 > 199) THEN Explosion(ExplosionCounter).State = Inactive
END IF


END SUB

SUB Create.PowerUp (x AS INTEGER, y AS INTEGER)

''Create a powerup on the screen

''Declare local variables
DIM PowerUpCounter AS INTEGER

'Walk through the array of powerups finding an inactive one
PowerUpCounter = 0
DO
	PowerUpCounter = PowerUpCounter + 1
	''Error Checking
	IF (PowerUpCounter > MAXPOWERUPS) THEN EXIT SUB
LOOP UNTIL (PowerUp(PowerUpCounter).State = Inactive)

'Found, initialize the powerup's variables
PowerUp(PowerUpCounter).State = Flying
PowerUp(PowerUpCounter).Sprite.x = x
PowerUp(PowerUpCounter).Sprite.y = y
PowerUp(PowerUpCounter).VelocityX = SGN(-5 + (RND * 10))    ''1, 0, or -1
PowerUp(PowerUpCounter).VelocityY = SGN(-5 + (RND * 10))
PowerUp(PowerUpCounter).Design = PowerUpTable(1 + (RND * 99))
PowerUp(PowerUpCounter).TimeCreated = TIMER

END SUB

SUB Delete.Text (x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER)

''Transfers a section of the screen from page 1 to page 0 and then
''from page 2 to page 1

''Declare local variables
DIM CounterX AS INTEGER
DIM CounterY AS INTEGER

FOR CounterX = x1 TO x2
	FOR CounterY = y1 TO y2
		mxPset Page0in320x200, CounterX, CounterY, (mxPoint(Page1in320x200, CounterX, CounterY))
		mxPset Page1in320x200, CounterX, CounterY, (mxPoint(Page2in320x200, CounterX, CounterY))
	NEXT CounterY
NEXT CounterX

END SUB

SUB Display.Bars (DrawingLevel AS INTEGER)

''Display the stat bars, and the player's current weapon type

''Declare Local Variables
DIM CounterX AS INTEGER

IF (DrawingLevel = 1) THEN
	mxPut NULLCOLOR, Page1in320x200, VARSEG(EmptyBar(0)), VARPTR(EmptyBar(0)), 3, 185
	mxPut NULLCOLOR, Page1in320x200, VARSEG(EmptyBar(0)), VARPTR(EmptyBar(0)), 3, 175
	IF (Player.WeaponType <> Normal) THEN
		mxPut NULLCOLOR, Page1in320x200, VARSEG(EmptyBar(0)), VARPTR(EmptyBar(0)), 68, 185
	END IF

	''Draw the health bar, sliver by sliver
	''It's blue if there's a shield
	IF (Player.Shield = TRUE) THEN
		FOR CounterX = 4 TO 4 + Player.Health - 1
			mxPut 0, Page1in320x200, VARSEG(BlueBar(0)), VARPTR(BlueBar(0)), CounterX, 185
			IF (CounterX >= 50 + 4) THEN EXIT FOR
		NEXT CounterX
	ELSE
		FOR CounterX = 4 TO 4 + Player.Health - 1
			mxPut 0, Page1in320x200, VARSEG(GreenBar(0)), VARPTR(GreenBar(0)), CounterX, 185
			IF (CounterX >= 50 + 4) THEN EXIT FOR
		NEXT CounterX
	END IF

	''Draw the heat bar, sliver by sliver
	FOR CounterX = 4 TO 4 + Player.Heat '- 1
		mxPut 0, Page1in320x200, VARSEG(RedBar(0)), VARPTR(RedBar(0)), CounterX, 175
		IF (CounterX >= 50 + 4) THEN EXIT FOR
	NEXT CounterX

	IF (Player.WeaponType <> Normal) THEN
		''Draw the weapon bar, sliver by sliver
		FOR CounterX = 69 TO (69 + INT(Player.WeaponTimer / 20))
			mxPut 0, Page1in320x200, VARSEG(BlueBar(0)), VARPTR(BlueBar(0)), CounterX, 185
			IF (CounterX >= 50 + 69) THEN EXIT FOR
		NEXT CounterX
	END IF

	''Draw the current weapon type
	SELECT CASE Player.WeaponType
		CASE IS = Normal
		CASE IS = PowerUpTypeSuper
			mxPut 0, Page1in320x200, VARSEG(PowerUpSuper(0)), VARPTR(PowerUpSuper(0)), 57, 185
		CASE IS = PowerUpTypeSpread
			mxPut 0, Page1in320x200, VARSEG(PowerUpSpread(0)), VARPTR(PowerUpSpread(0)), 57, 185
		CASE IS = PowerUpTypeDouble
			mxPut 0, Page1in320x200, VARSEG(PowerUpDouble(0)), VARPTR(PowerUpDouble(0)), 57, 185
		CASE IS = PowerUpTypeDoubleRed
			mxPut 0, Page1in320x200, VARSEG(PowerUpDoubleRed(0)), VARPTR(PowerUpDoubleRed(0)), 57, 185
		CASE IS = PowerUpTypeRed
			mxPut 0, Page1in320x200, VARSEG(PowerUpRed(0)), VARPTR(PowerUpRed(0)), 57, 185
	END SELECT
ELSEIF (DrawingLevel = 2) THEN
	''Bars
	mxGet Page1in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 3, 185, 54, 191
	mxPut NULLCOLOR, Page0in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 3, 185
       
	mxGet Page1in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 3, 175, 54, 181
	mxPut NULLCOLOR, Page0in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 3, 175
       
	mxGet Page1in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 68, 185, 120, 191
	mxPut NULLCOLOR, Page0in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 68, 185
      
	''Weapon Display
	mxGet Page1in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), 58, 186, 58 + 7, 186 + 7
	mxPut NULLCOLOR, Page0in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), 57, 185
ELSE
	''WeaponBar
	mxGet Page2in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 68, 185, 120, 191
	mxPut NULLCOLOR, Page1in320x200, VARSEG(BarBuffer(0)), VARPTR(BarBuffer(0)), 68, 185
      
	''Weapon Display
	mxGet Page2in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), 58, 186, 58 + 7, 186 + 7
	mxPut NULLCOLOR, Page1in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), 58, 186
END IF


END SUB

SUB Display.Score (Score AS LONG, DrawingLevel AS INTEGER, x AS INTEGER, y AS INTEGER)

''Displays the score

''Declare local variables
DIM ScoreText AS STRING
DIM Counter AS INTEGER
DIM TextLength AS INTEGER
DIM CurrentCursor AS INTEGER
DIM CurrentDigit AS STRING
'DIM X AS INTEGER
'DIM Y AS INTEGER

''Convert the score from LONG to STRING
ScoreText = STR$(Score)

''Determine text length
TextLength = LEN(ScoreText)

'X = 2   'Start here
'Y = 2

IF (DrawingLevel = 1) THEN
  ''Type the text
  FOR CurrentCursor = 1 TO TextLength
	CurrentDigit = MID$(ScoreText, CurrentCursor, 1)
  SELECT CASE CurrentDigit
	CASE IS = "0"
		mxPut 0, Page1in320x200, VARSEG(Number0(0)), VARPTR(Number0(0)), x, y
		x = x + 14
	CASE IS = "1"
		mxPut 0, Page1in320x200, VARSEG(Number1(0)), VARPTR(Number1(0)), x, y
		x = x + 6
	CASE IS = "2"
		mxPut 0, Page1in320x200, VARSEG(Number2(0)), VARPTR(Number2(0)), x, y
		x = x + 14
	CASE IS = "3"
		mxPut 0, Page1in320x200, VARSEG(Number3(0)), VARPTR(Number3(0)), x, y
		x = x + 13
	CASE IS = "4"
		mxPut 0, Page1in320x200, VARSEG(Number4(0)), VARPTR(Number4(0)), x, y
		x = x + 14
	CASE IS = "5"
		mxPut 0, Page1in320x200, VARSEG(Number5(0)), VARPTR(Number5(0)), x, y
		x = x + 14
	CASE IS = "6"
		mxPut 0, Page1in320x200, VARSEG(Number6(0)), VARPTR(Number6(0)), x, y
		x = x + 14
	CASE IS = "7"
		mxPut 0, Page1in320x200, VARSEG(Number7(0)), VARPTR(Number7(0)), x, y
		x = x + 12
	CASE IS = "8"
		mxPut 0, Page1in320x200, VARSEG(Number8(0)), VARPTR(Number8(0)), x, y
		x = x + 14
	CASE IS = "9"
		mxPut 0, Page1in320x200, VARSEG(Number9(0)), VARPTR(Number9(0)), x, y
		x = x + 14
  END SELECT
  NEXT CurrentCursor
ELSEIF (DrawingLevel = 2) THEN
  ''Transfer the text
  FOR CurrentCursor = 1 TO TextLength
	CurrentDigit = MID$(ScoreText, CurrentCursor, 1)
  SELECT CASE CurrentDigit
	CASE IS = "0"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "1"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 5, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 6
	CASE IS = "2"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "3"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 12, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 13
	CASE IS = "4"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "5"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "6"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "7"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 11, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 12
	CASE IS = "8"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "9"
		mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
  END SELECT
  mxGet Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
  mxPut NULLCOLOR, Page0in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
  NEXT CurrentCursor
ELSE
  ''Restore background
  FOR CurrentCursor = 1 TO TextLength
	CurrentDigit = MID$(ScoreText, CurrentCursor, 1)
  SELECT CASE CurrentDigit
	CASE IS = "0"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "1"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 5, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 6
	CASE IS = "2"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "3"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 12, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 13
	CASE IS = "4"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "5"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "6"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "7"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 11, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 12
	CASE IS = "8"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
	CASE IS = "9"
		mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
		mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
		x = x + 14
  END SELECT
  NEXT CurrentCursor
  mxGet Page2in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y, x + 13, y + 12
  mxPut NULLCOLOR, Page1in320x200, VARSEG(NumberBuffer(0)), VARPTR(NumberBuffer(0)), x, y
END IF


END SUB

SUB Draw.All
       
''Quite simply, draw all the objects
       
Draw.Player (1)           ''Transpose everything onto the
Draw.Missiles (1)         ''background on page 1
Draw.Enemies (1)
Draw.PowerUps (1)
Display.Score Player.Score, 1, 2, 2
Display.Bars (1)

Draw.Player (2)           ''Transfer everything to page 0
Draw.Missiles (2)         ''along with background
Draw.Enemies (2)
Draw.PowerUps (2)
Display.Score Player.Score, 2, 2, 2
Display.Bars (2)

Draw.Player (3)           ''Restore the background on page 1
Draw.Missiles (3)
Draw.Enemies (3)
Draw.PowerUps (3)
Display.Score Player.Score, 3, 2, 2
Display.Bars (3)


END SUB

SUB Draw.Enemies (DrawingLevel AS INTEGER)

''Draw all active enemies

'Declare local variables
DIM EnemyCounter AS INTEGER

IF (DrawingLevel = 1) THEN
	'Draw each active enemy
	'Draws on page 1
	FOR EnemyCounter = 1 TO MAXENEMIES
	 SELECT CASE Enemy(EnemyCounter).State
	  CASE IS = Alive
	   SELECT CASE Enemy(EnemyCounter).Class
	    CASE 1 TO 2 ''SingleFrame OR SingleFrameObject
		SELECT CASE Enemy(EnemyCounter).Sprite.Design
		    CASE IS = 1: mxPut 0, Page1in320x200, VARSEG(EnemyUp1(0)), VARPTR(EnemyUp1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
		    CASE IS = 2: mxPut 0, Page1in320x200, VARSEG(EnemyUp2(0)), VARPTR(EnemyUp2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
		    CASE IS = 3: mxPut 0, Page1in320x200, VARSEG(EnemyUp3(0)), VARPTR(EnemyUp3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
		    CASE IS = 4: mxPut 0, Page1in320x200, VARSEG(EnemyUp4(0)), VARPTR(EnemyUp4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
		END SELECT
	    CASE 3 TO 4 ''Animated OR AnimatedObject
		SELECT CASE Enemy(EnemyCounter).Sprite.Design
		    CASE IS = 1
			SELECT CASE Enemy(EnemyCounter).AnimationCounter
				CASE IS = 1: mxPut 0, Page1in320x200, VARSEG(EnemyUp1(0)), VARPTR(EnemyUp1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 2: mxPut 0, Page1in320x200, VARSEG(EnemyDown1(0)), VARPTR(EnemyDown1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 3: mxPut 0, Page1in320x200, VARSEG(EnemyLeft1(0)), VARPTR(EnemyLeft1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 4: mxPut 0, Page1in320x200, VARSEG(EnemyRight1(0)), VARPTR(EnemyRight1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 2
			SELECT CASE Enemy(EnemyCounter).AnimationCounter
				CASE IS = 1: mxPut 0, Page1in320x200, VARSEG(EnemyUp2(0)), VARPTR(EnemyUp2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 2: mxPut 0, Page1in320x200, VARSEG(EnemyDown2(0)), VARPTR(EnemyDown2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 3: mxPut 0, Page1in320x200, VARSEG(EnemyLeft2(0)), VARPTR(EnemyLeft2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 4: mxPut 0, Page1in320x200, VARSEG(EnemyRight2(0)), VARPTR(EnemyRight2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 3
			SELECT CASE Enemy(EnemyCounter).AnimationCounter
				CASE IS = 1: mxPut 0, Page1in320x200, VARSEG(EnemyUp3(0)), VARPTR(EnemyUp3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 2: mxPut 0, Page1in320x200, VARSEG(EnemyDown3(0)), VARPTR(EnemyDown3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 3: mxPut 0, Page1in320x200, VARSEG(EnemyLeft3(0)), VARPTR(EnemyLeft3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 4: mxPut 0, Page1in320x200, VARSEG(EnemyRight3(0)), VARPTR(EnemyRight3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 4
			SELECT CASE Enemy(EnemyCounter).AnimationCounter
				CASE IS = 1: mxPut 0, Page1in320x200, VARSEG(EnemyUp4(0)), VARPTR(EnemyUp4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 2: mxPut 0, Page1in320x200, VARSEG(EnemyDown4(0)), VARPTR(EnemyDown4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 3: mxPut 0, Page1in320x200, VARSEG(EnemyLeft4(0)), VARPTR(EnemyLeft4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = 4: mxPut 0, Page1in320x200, VARSEG(EnemyRight4(0)), VARPTR(EnemyRight4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		END SELECT
	    CASE IS = Directional
		SELECT CASE Enemy(EnemyCounter).Sprite.Design
		    CASE IS = 1
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp1(0)), VARPTR(EnemyUp1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown1(0)), VARPTR(EnemyDown1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft1(0)), VARPTR(EnemyLeft1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight1(0)), VARPTR(EnemyRight1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 2
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp2(0)), VARPTR(EnemyUp2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown2(0)), VARPTR(EnemyDown2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft2(0)), VARPTR(EnemyLeft2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight2(0)), VARPTR(EnemyRight2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 3
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp3(0)), VARPTR(EnemyUp3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown3(0)), VARPTR(EnemyDown3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft3(0)), VARPTR(EnemyLeft3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight3(0)), VARPTR(EnemyRight3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 4
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp4(0)), VARPTR(EnemyUp4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown4(0)), VARPTR(EnemyDown4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft4(0)), VARPTR(EnemyLeft4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight4(0)), VARPTR(EnemyRight4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		END SELECT
	    CASE IS = Boss
		SELECT CASE Enemy(EnemyCounter).AnimationCounter
		    CASE IS = 1
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp1(0)), VARPTR(EnemyUp1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown1(0)), VARPTR(EnemyDown1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft1(0)), VARPTR(EnemyLeft1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight1(0)), VARPTR(EnemyRight1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 2
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp2(0)), VARPTR(EnemyUp2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown2(0)), VARPTR(EnemyDown2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft2(0)), VARPTR(EnemyLeft2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight2(0)), VARPTR(EnemyRight2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 3
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp3(0)), VARPTR(EnemyUp3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown3(0)), VARPTR(EnemyDown3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft3(0)), VARPTR(EnemyLeft3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight3(0)), VARPTR(EnemyRight3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		    CASE IS = 4
			SELECT CASE Enemy(EnemyCounter).Direction
				CASE IS = Up: mxPut 0, Page1in320x200, VARSEG(EnemyUp4(0)), VARPTR(EnemyUp4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Down: mxPut 0, Page1in320x200, VARSEG(EnemyDown4(0)), VARPTR(EnemyDown4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Left: mxPut 0, Page1in320x200, VARSEG(EnemyLeft4(0)), VARPTR(EnemyLeft4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
				CASE IS = Right: mxPut 0, Page1in320x200, VARSEG(EnemyRight4(0)), VARPTR(EnemyRight4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
			END SELECT
		END SELECT
	   END SELECT
	  CASE IS = Exploding1
	   mxPut 0, Page1in320x200, VARSEG(Explosion1(0)), VARPTR(Explosion1(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
	  CASE IS = Exploding2
	   mxPut 0, Page1in320x200, VARSEG(Explosion2(0)), VARPTR(Explosion2(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
	  CASE IS = Exploding3
	   mxPut 0, Page1in320x200, VARSEG(Explosion3(0)), VARPTR(Explosion3(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
	  CASE IS = Exploding4
	   mxPut 0, Page1in320x200, VARSEG(Explosion4(0)), VARPTR(Explosion4(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
	  END SELECT
	NEXT EnemyCounter
ELSEIF (DrawingLevel = 2) THEN
	'Step two draws the enemies on page 0
	FOR EnemyCounter = 1 TO MAXENEMIES
	 IF (Enemy(EnemyCounter).State <> Dead) THEN
	  mxGet Page1in320x200, VARSEG(EnemyBuffer(0)), VARPTR(EnemyBuffer(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y, Enemy(EnemyCounter).Sprite.x + 17, Enemy(EnemyCounter).Sprite.y + 18
	  mxPut NULLCOLOR, Page0in320x200, VARSEG(EnemyBuffer(0)), VARPTR(EnemyBuffer(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
	 END IF
	NEXT EnemyCounter
ELSE
	'Step three restores the page 1 background
	FOR EnemyCounter = 1 TO MAXENEMIES
	 IF (Enemy(EnemyCounter).State <> Dead) THEN
	  mxGet Page2in320x200, VARSEG(EnemyBuffer(0)), VARPTR(EnemyBuffer(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y, Enemy(EnemyCounter).Sprite.x + 17, Enemy(EnemyCounter).Sprite.y + 18
	  mxPut NULLCOLOR, Page1in320x200, VARSEG(EnemyBuffer(0)), VARPTR(EnemyBuffer(0)), Enemy(EnemyCounter).Sprite.x, Enemy(EnemyCounter).Sprite.y
	 END IF
	NEXT EnemyCounter
END IF


END SUB

SUB Draw.Explosions (DrawingLevel AS INTEGER)

''Draw all active explosions

''Declare local variables
DIM ExplosionCounter AS INTEGER
DIM x AS INTEGER
DIM y AS INTEGER

IF (DrawingLevel = 1) THEN
	''Draw explosions on page 1
	FOR ExplosionCounter = 1 TO MAXEXPLOSIONS
	 IF (Explosion(ExplosionCounter).State <> Inactive) THEN
	   x = Explosion(ExplosionCounter).Sprite.x
	   y = Explosion(ExplosionCounter).Sprite.y
	   IF (Explosion(ExplosionCounter).Sprite.Design = Horizontal) THEN
	    IF (x < 1) THEN x = 1
	    IF (y < 1) THEN y = 1
	    IF (x + 113 > 319) THEN x = 319 - 113
	    IF (y + 14 > 199) THEN y = 199 - 14
	    SELECT CASE Explosion(ExplosionCounter).AnimationStep
	     CASE IS = 1
	      mxPut 0, Page1in320x200, VARSEG(Explosion1b(0)), VARPTR(Explosion1b(0)), x, y
	     CASE IS = 2
	      mxPut 0, Page1in320x200, VARSEG(Explosion2b(0)), VARPTR(Explosion2b(0)), x, y
	     CASE IS = 3
	      mxPut 0, Page1in320x200, VARSEG(Explosion3b(0)), VARPTR(Explosion3b(0)), x, y
	     CASE IS = 4
	      mxPut 0, Page1in320x200, VARSEG(Explosion4b(0)), VARPTR(Explosion4b(0)), x, y
	     CASE IS = 5
	      mxPut 0, Page1in320x200, VARSEG(Explosion5b(0)), VARPTR(Explosion5b(0)), x, y
	    END SELECT
	   ELSE
	    IF (x < 1) THEN x = 1
	    IF (y < 1) THEN y = 1
	    IF (x + 14 > 319) THEN x = 319 - 14
	    IF (y + 113 > 199) THEN y = 199 - 113
	    SELECT CASE Explosion(ExplosionCounter).AnimationStep
	     CASE IS = 1
	      mxPut 0, Page1in320x200, VARSEG(Explosion1c(0)), VARPTR(Explosion1c(0)), x, y
	     CASE IS = 2
	      mxPut 0, Page1in320x200, VARSEG(Explosion2c(0)), VARPTR(Explosion2c(0)), x, y
	     CASE IS = 3
	      mxPut 0, Page1in320x200, VARSEG(Explosion3c(0)), VARPTR(Explosion3c(0)), x, y
	     CASE IS = 4
	      mxPut 0, Page1in320x200, VARSEG(Explosion4c(0)), VARPTR(Explosion4c(0)), x, y
	     CASE IS = 5
	      mxPut 0, Page1in320x200, VARSEG(Explosion5c(0)), VARPTR(Explosion5c(0)), x, y
	    END SELECT
	   END IF
	 END IF
	NEXT ExplosionCounter
ELSEIF (DrawingLevel = 2) THEN
	''Step two draws the explosions on page 0
	FOR ExplosionCounter = 1 TO MAXEXPLOSIONS
	 IF (Explosion(ExplosionCounter).State <> Inactive) THEN
	  IF (Explosion(ExplosionCounter).Sprite.Design = Horizontal) THEN
	   ''Keep the "get" function onscreen, or itll get buggy and
	   ''start copying background from the other side of the screen
	   x = Explosion(ExplosionCounter).Sprite.x
	   y = Explosion(ExplosionCounter).Sprite.y
	   IF (x < 1) THEN x = 1
	   IF (y < 1) THEN y = 1
	   IF (x + 113 > 319) THEN x = 319 - 113
	   IF (y + 14 > 199) THEN y = 199 - 14
	   mxGet Page1in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y, x + 113, y + 12
	   mxPut NULLCOLOR, Page0in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y
	  ELSE
	   x = Explosion(ExplosionCounter).Sprite.x
	   y = Explosion(ExplosionCounter).Sprite.y
	   IF (x < 1) THEN x = 1
	   IF (y < 1) THEN y = 1
	   IF (x + 14 > 319) THEN x = 319 - 14
	   IF (y + 113 > 199) THEN y = 199 - 113
	   mxGet Page1in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y, x + 12, y + 113
	   mxPut NULLCOLOR, Page0in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y
	  END IF
	 END IF
	NEXT ExplosionCounter
ELSE
	'Step three restores the page 1 background (from page 2)
	FOR ExplosionCounter = 1 TO MAXEXPLOSIONS
	 IF (Explosion(ExplosionCounter).State <> Inactive) THEN
	  IF (Explosion(ExplosionCounter).Sprite.Design = Horizontal) THEN
	   x = Explosion(ExplosionCounter).Sprite.x
	   y = Explosion(ExplosionCounter).Sprite.y
	   IF (x < 1) THEN x = 1
	   IF (y < 1) THEN y = 1
	   IF (x + 113 > 319) THEN x = 319 - 113
	   IF (y + 14 > 199) THEN y = 199 - 14
	   mxGet Page2in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y, x + 113, y + 12
	   mxPut NULLCOLOR, Page1in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y
	  ELSE
	   x = Explosion(ExplosionCounter).Sprite.x
	   y = Explosion(ExplosionCounter).Sprite.y
	   IF (x < 1) THEN x = 1
	   IF (y < 1) THEN y = 1
	   IF (x + 14 > 319) THEN x = 319 - 14
	   IF (y + 113 > 199) THEN y = 199 - 113
	   mxGet Page2in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y, x + 12, y + 113
	   mxPut NULLCOLOR, Page1in320x200, VARSEG(ExplosionBuffer(0)), VARPTR(ExplosionBuffer(0)), x, y
	  END IF
	 END IF
	NEXT ExplosionCounter
END IF


END SUB

SUB Draw.Missiles (DrawingLevel AS INTEGER)

''Draw all active missiles

''Declare local variables
DIM MissileCounter AS INTEGER
DIM x AS INTEGER
DIM y AS INTEGER

IF (DrawingLevel = 1) THEN
	'Draw missiles on page 1
	FOR MissileCounter = 1 TO MAXMISSILES
	''Make sure we dont draw on page 1
	IF (Missile(MissileCounter).Sprite.x < 314) AND (Missile(MissileCounter).Sprite.y < 194) THEN
	 IF (Missile(MissileCounter).State = Flying) THEN
	   SELECT CASE Missile(MissileCounter).Design
	    CASE IS = Blue
	     mxPut 0, Page1in320x200, VARSEG(MissileBlue(0)), VARPTR(MissileBlue(0)), Missile(MissileCounter).Sprite.x, Missile(MissileCounter).Sprite.y
	    CASE IS = Red
	     mxPut 0, Page1in320x200, VARSEG(MissileRed(0)), VARPTR(MissileRed(0)), Missile(MissileCounter).Sprite.x, Missile(MissileCounter).Sprite.y
	    CASE IS = Green
	     mxPut 0, Page1in320x200, VARSEG(MissileGreen(0)), VARPTR(MissileGreen(0)), Missile(MissileCounter).Sprite.x, Missile(MissileCounter).Sprite.y
	    CASE IS = Yellow
	     mxPut 0, Page1in320x200, VARSEG(MissileYellow(0)), VARPTR(MissileYellow(0)), Missile(MissileCounter).Sprite.x, Missile(MissileCounter).Sprite.y
	   END SELECT
	 END IF
	END IF
	NEXT MissileCounter
ELSEIF (DrawingLevel = 2) THEN
	'Step two draws the missiles on page 0
	FOR MissileCounter = 1 TO MAXMISSILES
	 ''Make sure to erase any dead homing missiles
	 IF (Missile(MissileCounter).State = Flying) OR ((Missile(MissileCounter).Health = 0) AND ((Missile(MissileCounter).Design = Red))) THEN
	  ''Keep the "get" function onscreen, or itll get buggy and
	  ''start copying background from the other side of the screen
	  x = Missile(MissileCounter).Sprite.x
	  y = Missile(MissileCounter).Sprite.y
	  IF (x < 1) THEN x = 1
	  IF (y < 1) THEN y = 1
	  mxGet Page1in320x200, VARSEG(MissileBuffer(0)), VARPTR(MissileBuffer(0)), x - 1, y - 1, x + 6, y + 6
	  mxPut NULLCOLOR, Page0in320x200, VARSEG(MissileBuffer(0)), VARPTR(MissileBuffer(0)), x - 1, y - 1
	 END IF
	NEXT MissileCounter
ELSE
	'Step three restores the page 1 background (from page 2)
	FOR MissileCounter = 1 TO MAXMISSILES
	 ''Make sure to erase any dead homing missiles
	 IF (Missile(MissileCounter).State = Flying) OR ((Missile(MissileCounter).Health = 0) AND ((Missile(MissileCounter).Design = Red))) THEN
	  mxGet Page2in320x200, VARSEG(MissileBuffer(0)), VARPTR(MissileBuffer(0)), Missile(MissileCounter).Sprite.x, Missile(MissileCounter).Sprite.y, Missile(MissileCounter).Sprite.x + 4, Missile(MissileCounter).Sprite.y + 4
	  mxPut NULLCOLOR, Page1in320x200, VARSEG(MissileBuffer(0)), VARPTR(MissileBuffer(0)), Missile(MissileCounter).Sprite.x, Missile(MissileCounter).Sprite.y
	 END IF
	NEXT MissileCounter
END IF
 

END SUB

SUB Draw.Player (DrawingLevel AS INTEGER)

''Draw the player according to direction and position

IF (DrawingLevel = 1) THEN
	'Draws on page 1
	SELECT CASE Player.State
		CASE IS = Flying
			SELECT CASE Player.Direction
				CASE IS = Up
					mxPut 0, Page1in320x200, VARSEG(MechUp(0)), VARPTR(MechUp(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = Down
					mxPut 0, Page1in320x200, VARSEG(MechDown(0)), VARPTR(MechDown(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = Left
					mxPut 0, Page1in320x200, VARSEG(MechLeft(0)), VARPTR(MechLeft(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = Right
					mxPut 0, Page1in320x200, VARSEG(MechRight(0)), VARPTR(MechRight(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = UpRight
					mxPut 0, Page1in320x200, VARSEG(MechUpRight(0)), VARPTR(MechUpRight(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = DownRight
					mxPut 0, Page1in320x200, VARSEG(MechDownRight(0)), VARPTR(MechDownRight(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = DownLeft
					mxPut 0, Page1in320x200, VARSEG(MechDownLeft(0)), VARPTR(MechDownLeft(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = UpLeft
					mxPut 0, Page1in320x200, VARSEG(MechUpLeft(0)), VARPTR(MechUpLeft(0)), Player.Sprite.x, Player.Sprite.y
			END SELECT
		CASE IS = Inactive
			SELECT CASE Player.Direction
				CASE IS = Up
					mxPut 0, Page1in320x200, VARSEG(MechUpStopped(0)), VARPTR(MechUpStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = Down
					mxPut 0, Page1in320x200, VARSEG(MechDownStopped(0)), VARPTR(MechDownStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = Left
					mxPut 0, Page1in320x200, VARSEG(MechLeftStopped(0)), VARPTR(MechLeftStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = Right
					mxPut 0, Page1in320x200, VARSEG(MechRightStopped(0)), VARPTR(MechRightStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = UpRight
					mxPut 0, Page1in320x200, VARSEG(MechUpRightStopped(0)), VARPTR(MechUpRightStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = DownRight
					mxPut 0, Page1in320x200, VARSEG(MechDownRightStopped(0)), VARPTR(MechDownRightStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = DownLeft
					mxPut 0, Page1in320x200, VARSEG(MechDownLeftStopped(0)), VARPTR(MechDownLeftStopped(0)), Player.Sprite.x, Player.Sprite.y
				CASE IS = UpLeft
					mxPut 0, Page1in320x200, VARSEG(MechUpLeftStopped(0)), VARPTR(MechUpLeftStopped(0)), Player.Sprite.x, Player.Sprite.y
			END SELECT
		CASE IS = Exploding1
			mxPut 0, Page1in320x200, VARSEG(Explosion1(0)), VARPTR(Explosion1(0)), Player.Sprite.x, Player.Sprite.y
		CASE IS = Exploding2
			mxPut 0, Page1in320x200, VARSEG(Explosion2(0)), VARPTR(Explosion2(0)), Player.Sprite.x, Player.Sprite.y
		CASE IS = Exploding3
			mxPut 0, Page1in320x200, VARSEG(Explosion3(0)), VARPTR(Explosion3(0)), Player.Sprite.x, Player.Sprite.y
		CASE IS = Exploding4
			mxPut 0, Page1in320x200, VARSEG(Explosion4(0)), VARPTR(Explosion4(0)), Player.Sprite.x, Player.Sprite.y
	END SELECT
	IF (Player.Shield = TRUE) THEN
		mxPut 0, Page1in320x200, VARSEG(Shield(0)), VARPTR(Shield(0)), Player.Sprite.x - 5, Player.Sprite.y - 6
	END IF
ELSEIF (DrawingLevel = 2) THEN
	'Step two transfers to page 0
	IF (Player.Shield = TRUE) OR (Player.Shield = MARK) THEN
		mxGet Page1in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x - 6, Player.Sprite.y - 7, Player.Sprite.x + 17 + 6, Player.Sprite.y + 18 + 6
		mxPut NULLCOLOR, Page0in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x - 6, Player.Sprite.y - 7
	ELSE
		mxGet Page1in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x, Player.Sprite.y, Player.Sprite.x + 17, Player.Sprite.y + 18
		mxPut NULLCOLOR, Page0in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x, Player.Sprite.y
	END IF
ELSE
	'Step three restores the page 1 background
	IF (Player.Shield = TRUE) OR (Player.Shield = MARK) THEN
		mxGet Page2in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x - 6, Player.Sprite.y - 7, Player.Sprite.x + 17 + 6, Player.Sprite.y + 18 + 6
		mxPut NULLCOLOR, Page1in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x - 6, Player.Sprite.y - 7
	ELSE
		mxGet Page2in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x, Player.Sprite.y, Player.Sprite.x + 17, Player.Sprite.y + 18
		mxPut NULLCOLOR, Page1in320x200, VARSEG(MechBuffer(0)), VARPTR(MechBuffer(0)), Player.Sprite.x, Player.Sprite.y
	END IF
END IF


END SUB

SUB Draw.PowerUps (DrawingLevel AS INTEGER)

''Draw the powerups

''Declare local variables
DIM PowerUpCounter AS INTEGER

IF (DrawingLevel = 1) THEN
	'Draws on page 1
	FOR PowerUpCounter = 1 TO MAXPOWERUPS
		IF (PowerUp(PowerUpCounter).State = Flying) THEN
			SELECT CASE PowerUp(PowerUpCounter).Design
				CASE IS = PowerUpTypeShield: mxPut 0, Page1in320x200, VARSEG(PowerUpShield(0)), VARPTR(PowerUpShield(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeSuper: mxPut 0, Page1in320x200, VARSEG(PowerUpSuper(0)), VARPTR(PowerUpSuper(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeSpread: mxPut 0, Page1in320x200, VARSEG(PowerUpSpread(0)), VARPTR(PowerUpSpread(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeDouble: mxPut 0, Page1in320x200, VARSEG(PowerUpDouble(0)), VARPTR(PowerUpDouble(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeDoubleRed: mxPut 0, Page1in320x200, VARSEG(PowerUpDoubleRed(0)), VARPTR(PowerUpDoubleRed(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeRed: mxPut 0, Page1in320x200, VARSEG(PowerUpRed(0)), VARPTR(PowerUpRed(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeScore: mxPut 0, Page1in320x200, VARSEG(PowerUpScore(0)), VARPTR(PowerUpScore(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				CASE IS = PowerUpTypeHealth: mxPut 0, Page1in320x200, VARSEG(PowerUpHealth(0)), VARPTR(PowerUpHealth(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
			END SELECT
		ELSE
			mxPut 0, Page1in320x200, VARSEG(PowerUpEmpty(0)), VARPTR(PowerUpEmpty(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
		END IF
	NEXT PowerUpCounter
ELSEIF (DrawingLevel = 2) THEN
	'Step two transfers to page 0
	FOR PowerUpCounter = 1 TO MAXPOWERUPS
		IF (PowerUp(PowerUpCounter).State = Flying) THEN
			mxGet Page1in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y, PowerUp(PowerUpCounter).Sprite.x + 8, PowerUp(PowerUpCounter).Sprite.y + 8
			mxPut NULLCOLOR, Page0in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
		ELSEIF (PowerUp(PowerUpCounter).State = Dying) THEN
			mxGet Page1in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y, PowerUp(PowerUpCounter).Sprite.x + 8, PowerUp(PowerUpCounter).Sprite.y + 8
			mxPut NULLCOLOR, Page0in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
		END IF
	NEXT PowerUpCounter
ELSE
	'Step three restores the page 1 background
	FOR PowerUpCounter = 1 TO MAXPOWERUPS
		IF (PowerUp(PowerUpCounter).State = Flying) THEN
			mxGet Page2in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y, PowerUp(PowerUpCounter).Sprite.x + 8, PowerUp(PowerUpCounter).Sprite.y + 8
			mxPut NULLCOLOR, Page1in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
				''In case we're in training, let them know a powerups been drawn
				IF (GameMode = Training) THEN PowerUpsGained = 1
		ELSEIF (PowerUp(PowerUpCounter).State = Dying) THEN
			mxGet Page2in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y, PowerUp(PowerUpCounter).Sprite.x + 8, PowerUp(PowerUpCounter).Sprite.y + 8
			mxPut NULLCOLOR, Page1in320x200, VARSEG(PowerUpBuffer(0)), VARPTR(PowerUpBuffer(0)), PowerUp(PowerUpCounter).Sprite.x, PowerUp(PowerUpCounter).Sprite.y
			PowerUp(PowerUpCounter).State = Inactive
		END IF
	NEXT PowerUpCounter
END IF


END SUB

SUB Draw.Target (DrawingLevel AS INTEGER)

''Draw the target according to frame and position

IF (DrawingLevel = 1) THEN
	'Draws on page 1
	SELECT CASE Target.AnimationStep
		CASE IS = 1: mxPut 0, Page1in320x200, VARSEG(Target1(0)), VARPTR(Target1(0)), Target.Sprite.x, Target.Sprite.y
		CASE IS = 2: mxPut 0, Page1in320x200, VARSEG(Target2(0)), VARPTR(Target2(0)), Target.Sprite.x, Target.Sprite.y
		CASE IS = 3: mxPut 0, Page1in320x200, VARSEG(Target3(0)), VARPTR(Target3(0)), Target.Sprite.x, Target.Sprite.y
		CASE IS = 4: mxPut 0, Page1in320x200, VARSEG(Target4(0)), VARPTR(Target4(0)), Target.Sprite.x, Target.Sprite.y
	END SELECT
ELSEIF (DrawingLevel = 2) THEN
	'Step two transfers to page 0
	mxGet Page1in320x200, VARSEG(TargetBuffer(0)), VARPTR(TargetBuffer(0)), Target.Sprite.x - 2, Target.Sprite.y - 2, Target.Sprite.x + 22, Target.Sprite.y + 22
	mxPut NULLCOLOR, Page0in320x200, VARSEG(TargetBuffer(0)), VARPTR(TargetBuffer(0)), Target.Sprite.x - 2, Target.Sprite.y - 2
ELSE
	'Step three restores the page 1 background
	mxGet Page2in320x200, VARSEG(TargetBuffer(0)), VARPTR(TargetBuffer(0)), Target.Sprite.x - 2, Target.Sprite.y - 2, Target.Sprite.x + 22, Target.Sprite.y + 22
	mxPut NULLCOLOR, Page1in320x200, VARSEG(TargetBuffer(0)), VARPTR(TargetBuffer(0)), Target.Sprite.x - 2, Target.Sprite.y - 2
END IF


END SUB

SUB Handle.Collisions

''Check each active missile with each active enemy to see if there are
''any collisions, see if any enemies hit the player, if
''any missiles hit the player, and if the player picked up any powerups

'Declare local variables
DIM MissileCounter AS INTEGER
DIM EnemyCounter AS INTEGER
DIM PowerUpCounter AS INTEGER

FOR MissileCounter = 1 TO MAXMISSILES
	IF (Missile(MissileCounter).State = Flying) THEN
		''The player
		IF (Missile(MissileCounter).Sprite.x + 2 > Player.Sprite.x + 4) THEN
		  IF (Missile(MissileCounter).Sprite.x + 2 < Player.Sprite.x + 17 - 4) THEN
		    IF (Missile(MissileCounter).Sprite.y + 2 > Player.Sprite.y + 4) THEN
		      IF (Missile(MissileCounter).Sprite.y + 2 < Player.Sprite.y + 18 - 4) THEN
			SELECT CASE Missile(MissileCounter).Design
			  CASE IS = Blue
			  CASE IS = Red
			  CASE IS = Green
			    IF (Player.Shield = TRUE) THEN
			      Player.Health = Player.Health - 2
			    ELSE
			      Player.Health = Player.Health - 5
			    END IF
			    Missile(MissileCounter).State = Inactive
			  CASE IS = Yellow
			END SELECT
		      END IF
		    END IF
		  END IF
		END IF
		FOR EnemyCounter = 1 TO MAXENEMIES
			IF (Enemy(EnemyCounter).State = Alive) THEN
				IF (Missile(MissileCounter).Sprite.x + 2 > Enemy(EnemyCounter).Sprite.x + 4) THEN
				  IF (Missile(MissileCounter).Sprite.x + 2 < Enemy(EnemyCounter).Sprite.x + 17 - 4) THEN
				    IF (Missile(MissileCounter).Sprite.y + 2 > Enemy(EnemyCounter).Sprite.y + 4) THEN
				      IF (Missile(MissileCounter).Sprite.y + 2 < Enemy(EnemyCounter).Sprite.y + 18 - 4) THEN
					SELECT CASE Missile(MissileCounter).Design
					  CASE IS = Blue
					    IF (Enemy(EnemyCounter).Class = AnimatedObject) OR (Enemy(EnemyCounter).Class = SingleFrameObject) THEN
						Missile(MissileCounter).State = Inactive
					    ELSE
						Enemy(EnemyCounter).Health = Enemy(EnemyCounter).Health - 5
						Player.Score = Player.Score + 5
						Missile(MissileCounter).State = Inactive
					    END IF
					  CASE IS = Red
					    IF (Enemy(EnemyCounter).Class = AnimatedObject) OR (Enemy(EnemyCounter).Class = SingleFrameObject) THEN
						Missile(MissileCounter).State = Inactive
						Missile(MissileCounter).Health = 0
					    ELSE
						Player.Score = Player.Score + 5
						Enemy(EnemyCounter).Health = Enemy(EnemyCounter).Health - 10
						Missile(MissileCounter).State = Inactive
					    END IF
					  CASE IS = Green
					    IF (Enemy(EnemyCounter).Class = AnimatedObject) OR (Enemy(EnemyCounter).Class = SingleFrameObject) THEN
						Missile(MissileCounter).State = Inactive
					    END IF
					  CASE IS = Yellow
					    IF (Enemy(EnemyCounter).Class = AnimatedObject) OR (Enemy(EnemyCounter).Class = SingleFrameObject) THEN
						Missile(MissileCounter).State = Inactive
						Missile(MissileCounter).Health = 0
					    ELSE
						Player.Score = Player.Score + 5
						Enemy(EnemyCounter).Health = Enemy(EnemyCounter).Health - 100
						Missile(MissileCounter).Health = Missile(MissileCounter).Health - 1
					    END IF
					END SELECT
				      END IF
				    END IF
				  END IF
				END IF
			END IF
		NEXT EnemyCounter
	END IF
NEXT MissileCounter

''See if any of the enemies hit the player
FOR EnemyCounter = 1 TO MAXENEMIES
   IF (Enemy(EnemyCounter).State = Alive) THEN
	IF (Enemy(EnemyCounter).Sprite.x + 9 > Player.Sprite.x) THEN
	  IF (Enemy(EnemyCounter).Sprite.x + 9 < Player.Sprite.x + 18) THEN
	    IF (Enemy(EnemyCounter).Sprite.y + 9 > Player.Sprite.y) THEN
	      IF (Enemy(EnemyCounter).Sprite.y + 9 < Player.Sprite.y + 19) THEN
		IF (Player.Shield = TRUE) THEN
		  IF (Enemy(EnemyCounter).Class = AnimatedObject) OR (Enemy(EnemyCounter).Class = SingleFrameObject) THEN
		    'Player.Health = Player.Health - 1
		  ELSE
		    Player.Health = Player.Health - 2
		    Enemy(EnemyCounter).State = Exploding1
		    Enemy(EnemyCounter).PlayerCrashed = TRUE
		  END IF
		ELSE
		  IF (Enemy(EnemyCounter).Class = AnimatedObject) OR (Enemy(EnemyCounter).Class = SingleFrameObject) THEN
		    'Player.Health = Player.Health - 1
		  ELSE
		    Player.Health = Player.Health - Enemy(EnemyCounter).Damage
		    Enemy(EnemyCounter).State = Exploding1
		    Enemy(EnemyCounter).PlayerCrashed = TRUE
		  END IF
		END IF
	      END IF
	    END IF
	  END IF
	END IF
   END IF
NEXT EnemyCounter

''See if the player hit any powerups
FOR PowerUpCounter = 1 TO MAXPOWERUPS
	IF (PowerUp(PowerUpCounter).State = Flying) THEN
	  IF (PowerUp(PowerUpCounter).Sprite.x + 4 > Player.Sprite.x + 4) THEN
	    IF (PowerUp(PowerUpCounter).Sprite.x + 4 < Player.Sprite.x + 18 - 4) THEN
	      IF (PowerUp(PowerUpCounter).Sprite.y + 4 > Player.Sprite.y + 4) THEN
		IF (PowerUp(PowerUpCounter).Sprite.y + 4 < Player.Sprite.y + 19 - 4) THEN
		  PowerUp(PowerUpCounter).State = Inactive
		  SELECT CASE PowerUp(PowerUpCounter).Design
		    CASE IS = PowerUpTypeShield
			Player.Shield = TRUE
		    CASE IS = PowerUpTypeSuper
			Player.WeaponType = PowerUpTypeSuper
			'Player.WeaponTimeAcquired = TIMER
			Player.WeaponTimer = 1000
		    CASE IS = PowerUpTypeSpread
			Player.WeaponType = PowerUpTypeSpread
			'Player.WeaponTimeAcquired = TIMER
			Player.WeaponTimer = 1000
		    CASE IS = PowerUpTypeDouble
			Player.WeaponType = PowerUpTypeDouble
			'Player.WeaponTimeAcquired = TIMER
			Player.WeaponTimer = 1000
		    CASE IS = PowerUpTypeDoubleRed
			Player.WeaponType = PowerUpTypeDoubleRed
			'Player.WeaponTimeAcquired = TIMER
			Player.WeaponTimer = 1000
		    CASE IS = PowerUpTypeRed
			Player.WeaponType = PowerUpTypeRed
			'Player.WeaponTimeAcquired = TIMER
			Player.WeaponTimer = 1000
		    CASE IS = PowerUpTypeScore
			Player.Score = Player.Score + 25
		    CASE IS = PowerUpTypeHealth
			Player.Health = Player.Health + 10
		  END SELECT
		END IF
	      END IF
	    END IF
	  END IF
	END IF
NEXT PowerUpCounter


END SUB

SUB Init.Enemies

''Initialize enemy properties

''Declare local variables
DIM EnemyCounter AS INTEGER

''Initialize 0 for the targeting system to target when no other enemies are
''around
Enemy(0).Sprite.x = 150
Enemy(0).Sprite.y = 90

'Walk through the enemy array, initializing properties for each
FOR EnemyCounter = 1 TO MAXENEMIES
	DO
		Enemy(EnemyCounter).Sprite.x = INT(RND * 300)
	LOOP UNTIL (Enemy(EnemyCounter).Sprite.x < 140) OR (Enemy(EnemyCounter).Sprite.x > 180)
       
	DO
		Enemy(EnemyCounter).Sprite.y = INT(RND * 180)
	LOOP UNTIL (Enemy(EnemyCounter).Sprite.y < 80) OR (Enemy(EnemyCounter).Sprite.x > 120)
       
	Enemy(EnemyCounter).State = Dead
	Enemy(EnemyCounter).Health = 20
	Enemy(EnemyCounter).LogicState = Stationary
	Enemy(EnemyCounter).VelocityX = SGN(-10 + (RND * 20))
	Enemy(EnemyCounter).VelocityY = SGN(-10 + (RND * 20))
	Enemy(EnemyCounter).PlayerCrashed = FALSE
	Enemy(EnemyCounter).Sprite.Design = 1
	Enemy(EnemyCounter).Direction = Left
	Enemy(EnemyCounter).AnimationCounter = 1 + (RND * 2)
	Enemy(EnemyCounter).Class = Animated
	Enemy(EnemyCounter).Area.MinX = 0
	Enemy(EnemyCounter).Area.MinY = 0
	Enemy(EnemyCounter).Area.MaxX = 300
	Enemy(EnemyCounter).Area.MaxY = 180
	Enemy(EnemyCounter).Damage = 5
NEXT EnemyCounter


END SUB

SUB Init.Explosions

''Initialize explosion properties

''Declare local variables
DIM ExplosionCounter AS INTEGER

''Walk through the powerup array, initializing properties for each
FOR ExplosionCounter = 1 TO MAXEXPLOSIONS
	Explosion(ExplosionCounter).State = Inactive
NEXT ExplosionCounter


END SUB

SUB Init.Missiles

''Set all missiles to inactive state

'Local variables
DIM MissileCounter AS INTEGER

'Walk through all the missiles, setting State to Inactive
FOR MissileCounter = 1 TO MAXMISSILES
	Missile(MissileCounter).State = Inactive
NEXT MissileCounter

END SUB

SUB Init.Player

''Initialize properties and values of the player

Player.Sprite.x = 100
Player.Sprite.y = 90
Player.Direction = Up
Player.Strafing = FALSE
Player.TurnDelayCounter = 0
IF (Player.ControlStyle <> ShipOriented) THEN Player.ControlStyle = ScreenOriented
Player.WeaponType = Normal
Player.Heat = 0
Player.State = Inactive
Player.Shield = FALSE
Player.CannonX = Player.Sprite.x + 9
Player.CannonY = Player.Sprite.y + 1
Player.CannonVelocityX = 0
Player.CannonVelocityY = -1
Player.Health = 5000
Player.Score = 0
Player.Area.MinX = 0
Player.Area.MaxX = 300
Player.Area.MinY = 0
Player.Area.MaxY = 180
Player.WeaponTimeAcquired = 0
Player.WeaponTimer = 5000

''Initialize the target
Target.Sprite.x = 150
Target.Sprite.y = 90
Target.AnimationStep = 1

END SUB

SUB Init.PowerUps

''Initialize powerup properties

''Declare local variables
DIM PowerUpCounter AS INTEGER

''Walk through the powerup array, initializing properties for each
FOR PowerUpCounter = 1 TO MAXPOWERUPS
	PowerUp(PowerUpCounter).State = Inactive
NEXT PowerUpCounter

''Initialize the PowerUpTable to certian values, making some powerups more
''likely than others
FOR PowerUpCounter = 1 TO 99 STEP 2
	PowerUpTable(PowerUpCounter) = PowerUpTypeHealth
NEXT PowerUpCounter
FOR PowerUpCounter = 2 TO 100 STEP 2
	PowerUpTable(PowerUpCounter) = PowerUpTypeScore
NEXT PowerUpCounter
FOR PowerUpCounter = 26 TO 75
	PowerUpTable(PowerUpCounter) = PowerUpTypeDouble
NEXT PowerUpCounter

FOR PowerUpCounter = 41 TO 60
	PowerUpTable(PowerUpCounter) = PowerUpTypeRed
NEXT PowerUpCounter
FOR PowerUpCounter = 51 TO 60
	PowerUpTable(PowerUpCounter) = PowerUpTypeShield
NEXT PowerUpCounter


FOR PowerUpCounter = 46 TO 55
	PowerUpTable(PowerUpCounter) = PowerUpTypeSpread
NEXT PowerUpCounter
FOR PowerUpCounter = 49 TO 52
	PowerUpTable(PowerUpCounter) = PowerUpTypeDoubleRed
NEXT PowerUpCounter
FOR PowerUpCounter = 50 TO 51
	PowerUpTable(PowerUpCounter) = PowerUpTypeSuper
NEXT PowerUpCounter


END SUB

SUB Input.HighScore (Score AS LONG)

''Collect the high scorer name from the player
''and add it to the table

''Declare local variables
DIM CounterX AS INTEGER
DIM CounterY AS INTEGER
DIM KeyPressed AS INTEGER
DIM KeyCounter AS SINGLE
DIM NameToSave AS STRING
DIM Length AS INTEGER
DIM Counter AS INTEGER
DIM CursorX AS INTEGER
DIM CursorY AS INTEGER
DIM HighScoreNames(10) AS STRING
DIM Names(10) AS STRING
DIM Scores(10) AS STRING
DIM NewNames(10) AS STRING
DIM NewScores(10) AS STRING
DIM PlayerNamePosition AS INTEGER

''Cleanup (fade menu a little w/ palletes)
CLEANUP

IF (GameMode = Training) THEN EXIT SUB

''Open the high scores file
OPEN "HSCR.DAT" FOR INPUT AS #1
	FOR Counter = 1 TO 10
		INPUT #1, HighScoreNames(Counter)
	NEXT Counter
	FOR Counter = 1 TO 10
		INPUT #1, Names(Counter)
	NEXT Counter
	FOR Counter = 1 TO 10
		INPUT #1, Scores(Counter)
	NEXT Counter
CLOSE

''Walk through the records and find where the player's will fit in
Counter = 1
DO UNTIL (Score > VAL(Scores(Counter)))
	NewScores(Counter) = Scores(Counter)
	NewNames(Counter) = Names(Counter)
	Counter = Counter + 1
	IF Counter = 11 THEN EXIT SUB 'If we're through, score is too low, leave
LOOP

NewScores(Counter) = STR$(Score)
PlayerNamePosition = Counter
CounterY = 40 + (Counter * 10)

SELECT CASE Counter
	CASE 1 TO 9
		FOR Counter = Counter TO 9
			NewNames(Counter + 1) = Names(Counter)
			NewScores(Counter + 1) = Scores(Counter)
		NEXT Counter
	CASE IS = 10
END SELECT

Print.Text "CONGRATULATIONS...", 95, 20, 0

''Type all the names on screen
FOR Counter = 1 TO 10
	Print.Text NewNames(Counter) + "~", 95, 40 + (Counter * 10), 0
	IF (Counter = PlayerNamePosition) THEN
		Print.Text NewScores(Counter) + "~", 320 - 102, 40 + (Counter * 10), 0
	ELSE
		Print.Text NewScores(Counter) + "~", 320 - 95, 40 + (Counter * 10), 0
	END IF
	'Print.Text HighScoreNames(Counter) + "~", 95, 40 + (Counter * 10), 0
NEXT Counter

''Now the player can type their name onto the table
CounterX = 95
KeyPressed = 0
KeyCounter = 0

''Keep cycling through all the keys until one is pressed
ReadKeyboard:
	KeyPressed = 0
	WHILE KeyPressed = 0
		FOR KeyCounter = 1 TO 128
			IF (MULTIKEY(KeyCounter) = 1) THEN KeyPressed = KeyCounter
		NEXT KeyCounter
	'Delay .01
	WEND
       
	IF (KeyPressed = 14) THEN ''Backspace
		IF (LEN(NameToSave) >= 1) THEN
			CounterX = CounterX - 14
			Delete.Text CounterX + 7, CounterY, CounterX + 7 + 5, CounterY + 4
			Length = LEN(NameToSave)
			NameToSave = MID$(NameToSave, 1, Length - 1)
		ELSE
			CounterX = CounterX - 7
			Delete.Text CounterX + 7, CounterY, CounterX + 7 + 5, CounterY + 4
		END IF
		IF (CounterX < 40) THEN CounterX = 33
		CounterX = CounterX + 7
	ELSEIF (KeyPressed = 28) THEN   ''Pressed enter
		GOTO Done
	ELSE
	    IF (LEN(NameToSave) < 11) THEN
		SELECT CASE KeyPressed
			CASE IS = 2
				Print.Text "1*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 3
				Print.Text "2*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 4
				Print.Text "3*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 5
				Print.Text "4*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 6
				Print.Text "5*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 7
				Print.Text "6*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 8
				Print.Text "7*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 9
				Print.Text "8*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 10
				Print.Text "9*", CounterX, CounterY, 0
				NameToSave = NameToSave + "1"
			CASE IS = 11
				Print.Text "0*", CounterX, CounterY, 0
				NameToSave = NameToSave + "0"
			CASE IS = 16
				Print.Text "Q*", CounterX, CounterY, 0
				NameToSave = NameToSave + "Q"
			CASE IS = 17
				Print.Text "W*", CounterX, CounterY, 0
				NameToSave = NameToSave + "W"
			CASE IS = 18
				Print.Text "E*", CounterX, CounterY, 0
				NameToSave = NameToSave + "E"
			CASE IS = 19
				Print.Text "R*", CounterX, CounterY, 0
				NameToSave = NameToSave + "R"
			CASE IS = 20
				Print.Text "T*", CounterX, CounterY, 0
				NameToSave = NameToSave + "T"
			CASE IS = 21
				Print.Text "Y*", CounterX, CounterY, 0
				NameToSave = NameToSave + "Y"
			CASE IS = 22
				Print.Text "U*", CounterX, CounterY, 0
				NameToSave = NameToSave + "U"
			CASE IS = 23
				Print.Text "I*", CounterX, CounterY, 0
				NameToSave = NameToSave + "I"
			CASE IS = 24
				Print.Text "O*", CounterX, CounterY, 0
				NameToSave = NameToSave + "O"
			CASE IS = 25
				Print.Text "P*", CounterX, CounterY, 0
				NameToSave = NameToSave + "P"
			CASE IS = 30
				Print.Text "A*", CounterX, CounterY, 0
				NameToSave = NameToSave + "A"
			CASE IS = 31
				Print.Text "S*", CounterX, CounterY, 0
				NameToSave = NameToSave + "S"
			CASE IS = 32
				Print.Text "D*", CounterX, CounterY, 0
				NameToSave = NameToSave + "D"
			CASE IS = 33
				Print.Text "F*", CounterX, CounterY, 0
				NameToSave = NameToSave + "F"
			CASE IS = 34
				Print.Text "G*", CounterX, CounterY, 0
				NameToSave = NameToSave + "G"
			CASE IS = 35
				Print.Text "H*", CounterX, CounterY, 0
				NameToSave = NameToSave + "H"
			CASE IS = 36
				Print.Text "J*", CounterX, CounterY, 0
				NameToSave = NameToSave + "J"
			CASE IS = 37
				Print.Text "K*", CounterX, CounterY, 0
				NameToSave = NameToSave + "K"
			CASE IS = 38
				Print.Text "L*", CounterX, CounterY, 0
				NameToSave = NameToSave + "L"
			CASE IS = 44
				Print.Text "Z*", CounterX, CounterY, 0
				NameToSave = NameToSave + "Z"
			CASE IS = 45
				Print.Text "X*", CounterX, CounterY, 0
				NameToSave = NameToSave + "X"
			CASE IS = 46
				Print.Text "C*", CounterX, CounterY, 0
				NameToSave = NameToSave + "C"
			CASE IS = 47
				Print.Text "V*", CounterX, CounterY, 0
				NameToSave = NameToSave + "V"
			CASE IS = 48
				Print.Text "B*", CounterX, CounterY, 0
				NameToSave = NameToSave + "B"
			CASE IS = 49
				Print.Text "N*", CounterX, CounterY, 0
				NameToSave = NameToSave + "N"
			CASE IS = 50
				Print.Text "M*", CounterX, CounterY, 0
				NameToSave = NameToSave + "M"
			CASE IS = 57  ''Space
				NameToSave = NameToSave + " "
			CASE ELSE
				CounterX = CounterX - 7
		END SELECT
		CounterX = CounterX + 7
	     END IF ''The Length statement (under 10)
	END IF ''The backspace if statement
	Delay .12
GOTO ReadKeyboard

Done:

IF (NameToSave = "") THEN NameToSave = "ANONYMOUS"

NewNames(PlayerNamePosition) = NameToSave

''Save the new list, with the player's new name and score
OPEN "HSCR.DAT" FOR OUTPUT AS #1
	FOR Counter = 1 TO 10
		PRINT #1, NewNames(Counter), NewScores(Counter)
	NEXT Counter
	FOR Counter = 1 TO 10
		PRINT #1, NewNames(Counter)
	NEXT Counter
	FOR Counter = 1 TO 10
		PRINT #1, NewScores(Counter)
	NEXT Counter
CLOSE


END SUB

SUB Intro.Company

''The company logo/intro thing

''Declare local variables
DIM Logo(550)  AS INTEGER
DIM CounterY AS INTEGER
DIM DelayCounter AS DOUBLE

''Load the animation frames
LOAD.GIF.X "LOGO.GIF", 1

DelayCounter = .15

''Diplay each frame in the animation, with a delay after each frame'
FOR CounterY = 1 TO 91 STEP 6
	mxGet Page1in320x200, VARSEG(Logo(0)), VARPTR(Logo(0)), 1, CounterY, 218, CounterY + 4
	mxPut NULLCOLOR, Page0in320x200, VARSEG(Logo(0)), VARPTR(Logo(0)), 77, 191
	DelayCounter = DelayCounter * .9
	Delay DelayCounter
NEXT CounterY

END SUB

SUB Load.Level (LevelPath AS STRING)

''Load the level from the specified file
''and initialize the enemies and player

''Declare local variables
DIM EnemyCounter AS INTEGER
DIM StringBuffer AS STRING

''Cleanup
CLEANUP

''Open the file
OPEN LevelPath FOR INPUT AS #1

''Start with the properties of the level itself
INPUT #1, Level.PreviousLevel
INPUT #1, Level.NextLevel
INPUT #1, StringBuffer: Level.EnemiesToKill = VAL(StringBuffer)
INPUT #1, StringBuffer: Level.IncreaseEnemySpeed = VAL(StringBuffer)
INPUT #1, StringBuffer: Level.IncreaseEnemyMissileSpeed = VAL(StringBuffer)
INPUT #1, Level.Background
INPUT #1, Level.SpriteFile

''The player properties
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.Sprite.x = VAL(StringBuffer)
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.Sprite.y = VAL(StringBuffer)
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.Direction = VAL(StringBuffer)
INPUT #1, StringBuffer: Player.Heat = VAL(StringBuffer)
INPUT #1, StringBuffer: Player.State = VAL(StringBuffer)
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.CannonX = VAL(StringBuffer)
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.CannonY = VAL(StringBuffer)
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.CannonVelocityX = VAL(StringBuffer)
INPUT #1, StringBuffer: IF (VAL(StringBuffer) <> 400) THEN Player.CannonVelocityY = VAL(StringBuffer)
INPUT #1, StringBuffer: Player.Area.MinX = VAL(StringBuffer)
INPUT #1, StringBuffer: Player.Area.MaxX = VAL(StringBuffer)
INPUT #1, StringBuffer: Player.Area.MinY = VAL(StringBuffer)
INPUT #1, StringBuffer: Player.Area.MaxY = VAL(StringBuffer)

''Walk through the enemy array, initializing properties for each
FOR EnemyCounter = 1 TO 25
	INPUT #1, StringBuffer
		IF (VAL(StringBuffer) = 400) THEN
			DO
				Enemy(EnemyCounter).Sprite.x = INT(RND * 300)
			LOOP UNTIL (Enemy(EnemyCounter).Sprite.y < 140) OR (Enemy(EnemyCounter).Sprite.x > 180)
		ELSE
			Enemy(EnemyCounter).Sprite.x = VAL(StringBuffer)
		END IF
	INPUT #1, StringBuffer
		IF (VAL(StringBuffer) = 400) THEN
			DO
				Enemy(EnemyCounter).Sprite.y = INT(RND * 180)
			LOOP UNTIL (Enemy(EnemyCounter).Sprite.y < 80) OR (Enemy(EnemyCounter).Sprite.x > 120)
		ELSE
			Enemy(EnemyCounter).Sprite.y = VAL(StringBuffer)
		END IF
	INPUT #1, StringBuffer: Enemy(EnemyCounter).State = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Health = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).LogicState = VAL(StringBuffer)
	INPUT #1, StringBuffer
		IF (VAL(StringBuffer) = 400) THEN
			Enemy(EnemyCounter).VelocityX = SGN(-10 + (RND * 20))
		ELSE
			Enemy(EnemyCounter).VelocityX = VAL(StringBuffer)
		END IF
	INPUT #1, StringBuffer
		IF (VAL(StringBuffer) = 400) THEN
			Enemy(EnemyCounter).VelocityY = SGN(-10 + (RND * 20))
		ELSE
			Enemy(EnemyCounter).VelocityY = VAL(StringBuffer)
		END IF
	INPUT #1, StringBuffer: Enemy(EnemyCounter).PlayerCrashed = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Sprite.Design = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Direction = VAL(StringBuffer)
	INPUT #1, StringBuffer
		IF (VAL(StringBuffer) = 400) THEN
			Enemy(EnemyCounter).AnimationCounter = 1 + (RND * 2)
		ELSE
			Enemy(EnemyCounter).AnimationCounter = VAL(StringBuffer)
		END IF
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Class = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Area.MinX = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Area.MinY = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Area.MaxX = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Area.MaxY = VAL(StringBuffer)
	INPUT #1, StringBuffer: Enemy(EnemyCounter).Damage = VAL(StringBuffer)
NEXT EnemyCounter

CLOSE

''Load the background
'LOAD.GIF.X "c:\dos\mechs\orbit1.gif", 2  ''Level.Background, 2
LOAD.GIF.X Level.Background, 2
mxPCopy Page2in320x200, Page1in320x200, Full320x200
mxPCopy Page2in320x200, Page0in320x200, Full320x200

END SUB

SUB Load.Sprites

''This function loads and stores the frames for all sprites in the game

''Load the picture with the frames
LOAD.GIF.X "DATA.GIF", 1

''The player's mech
mxGet Page1in320x200, VARSEG(MechUp(0)), VARPTR(MechUp(0)), 1, 1, 18, 19
mxGet Page1in320x200, VARSEG(MechUpRight(0)), VARPTR(MechUpRight(0)), 20, 1, 37, 19
mxGet Page1in320x200, VARSEG(MechRight(0)), VARPTR(MechRight(0)), 39, 1, 56, 19
mxGet Page1in320x200, VARSEG(MechDownRight(0)), VARPTR(MechDownRight(0)), 58, 1, 75, 19
mxGet Page1in320x200, VARSEG(MechDown(0)), VARPTR(MechDown(0)), 1, 21, 18, 39
mxGet Page1in320x200, VARSEG(MechDownLeft(0)), VARPTR(MechDownLeft(0)), 20, 21, 37, 39
mxGet Page1in320x200, VARSEG(MechLeft(0)), VARPTR(MechLeft(0)), 39, 21, 56, 39
mxGet Page1in320x200, VARSEG(MechUpLeft(0)), VARPTR(MechUpLeft(0)), 58, 21, 75, 39
mxGet Page1in320x200, VARSEG(MechUpStopped(0)), VARPTR(MechUpStopped(0)), 1, 41, 18, 59
mxGet Page1in320x200, VARSEG(MechUpRightStopped(0)), VARPTR(MechUpRightStopped(0)), 20, 41, 37, 59
mxGet Page1in320x200, VARSEG(MechRightStopped(0)), VARPTR(MechRightStopped(0)), 39, 41, 56, 59
mxGet Page1in320x200, VARSEG(MechDownRightStopped(0)), VARPTR(MechDownRightStopped(0)), 58, 41, 75, 59
mxGet Page1in320x200, VARSEG(MechDownStopped(0)), VARPTR(MechDownStopped(0)), 1, 61, 18, 79
mxGet Page1in320x200, VARSEG(MechDownLeftStopped(0)), VARPTR(MechDownLeftStopped(0)), 20, 61, 37, 79
mxGet Page1in320x200, VARSEG(MechLeftStopped(0)), VARPTR(MechLeftStopped(0)), 39, 61, 56, 79
mxGet Page1in320x200, VARSEG(MechUpLeftStopped(0)), VARPTR(MechUpLeftStopped(0)), 58, 61, 75, 79

''The shield
mxGet Page1in320x200, VARSEG(Shield(0)), VARPTR(Shield(0)), 164, 11, 189, 36

''The missiles
mxGet Page1in320x200, VARSEG(MissileBlue(0)), VARPTR(MissileBlue(0)), 77, 1, 81, 5
mxGet Page1in320x200, VARSEG(MissileRed(0)), VARPTR(MissileRed(0)), 77, 7, 81, 11
mxGet Page1in320x200, VARSEG(MissileGreen(0)), VARPTR(MissileGreen(0)), 77, 13, 81, 17
mxGet Page1in320x200, VARSEG(MissileYellow(0)), VARPTR(MissileYellow(0)), 77, 19, 81, 23

''The enemies
'mxGet page1in320x200, VARSEG(Enemy1(0)), VARPTR(Enemy1(0)), 1, 81, 18, 59
mxGet Page1in320x200, VARSEG(EnemyUp1(0)), VARPTR(EnemyUp1(0)), 1, 81, 18, 99
mxGet Page1in320x200, VARSEG(EnemyDown1(0)), VARPTR(EnemyDown1(0)), 20, 81, 37, 99
mxGet Page1in320x200, VARSEG(EnemyLeft1(0)), VARPTR(EnemyLeft1(0)), 39, 81, 56, 99
mxGet Page1in320x200, VARSEG(EnemyRight1(0)), VARPTR(EnemyRight1(0)), 58, 81, 75, 99
mxGet Page1in320x200, VARSEG(EnemyUp2(0)), VARPTR(EnemyUp2(0)), 1, 101, 18, 119
mxGet Page1in320x200, VARSEG(EnemyDown2(0)), VARPTR(EnemyDown2(0)), 20, 101, 37, 119
mxGet Page1in320x200, VARSEG(EnemyLeft2(0)), VARPTR(EnemyLeft2(0)), 39, 101, 56, 119
mxGet Page1in320x200, VARSEG(EnemyRight2(0)), VARPTR(EnemyRight2(0)), 58, 101, 75, 119
mxGet Page1in320x200, VARSEG(EnemyUp3(0)), VARPTR(EnemyUp3(0)), 1, 121, 18, 139
mxGet Page1in320x200, VARSEG(EnemyDown3(0)), VARPTR(EnemyDown3(0)), 20, 121, 37, 139
mxGet Page1in320x200, VARSEG(EnemyLeft3(0)), VARPTR(EnemyLeft3(0)), 39, 121, 56, 139
mxGet Page1in320x200, VARSEG(EnemyRight3(0)), VARPTR(EnemyRight3(0)), 58, 121, 75, 139
mxGet Page1in320x200, VARSEG(EnemyUp4(0)), VARPTR(EnemyUp4(0)), 1, 141, 18, 159
mxGet Page1in320x200, VARSEG(EnemyDown4(0)), VARPTR(EnemyDown4(0)), 20, 141, 37, 159
mxGet Page1in320x200, VARSEG(EnemyLeft4(0)), VARPTR(EnemyLeft4(0)), 39, 141, 56, 159
mxGet Page1in320x200, VARSEG(EnemyRight4(0)), VARPTR(EnemyRight4(0)), 58, 141, 75, 159

''The explosion animation
mxGet Page1in320x200, VARSEG(Explosion1(0)), VARPTR(Explosion1(0)), 1, 181, 18, 199
mxGet Page1in320x200, VARSEG(Explosion2(0)), VARPTR(Explosion2(0)), 20, 181, 37, 199
mxGet Page1in320x200, VARSEG(Explosion3(0)), VARPTR(Explosion3(0)), 39, 181, 56, 199
mxGet Page1in320x200, VARSEG(Explosion4(0)), VARPTR(Explosion4(0)), 58, 181, 75, 199

mxGet Page1in320x200, VARSEG(Explosion1b(0)), VARPTR(Explosion1b(0)), 205, 130, 318, 142
mxGet Page1in320x200, VARSEG(Explosion2b(0)), VARPTR(Explosion2b(0)), 205, 144, 318, 156
mxGet Page1in320x200, VARSEG(Explosion3b(0)), VARPTR(Explosion3b(0)), 205, 158, 318, 170
mxGet Page1in320x200, VARSEG(Explosion4b(0)), VARPTR(Explosion4b(0)), 205, 172, 318, 184
mxGet Page1in320x200, VARSEG(Explosion5b(0)), VARPTR(Explosion5b(0)), 205, 186, 318, 198
mxGet Page1in320x200, VARSEG(Explosion1c(0)), VARPTR(Explosion1c(0)), 135, 85, 147, 198
mxGet Page1in320x200, VARSEG(Explosion2c(0)), VARPTR(Explosion2c(0)), 149, 85, 161, 198
mxGet Page1in320x200, VARSEG(Explosion3c(0)), VARPTR(Explosion3c(0)), 163, 85, 175, 198
mxGet Page1in320x200, VARSEG(Explosion4c(0)), VARPTR(Explosion4c(0)), 177, 85, 189, 198
mxGet Page1in320x200, VARSEG(Explosion5c(0)), VARPTR(Explosion5c(0)), 191, 85, 203, 198

''The targeting crosshairs
mxGet Page1in320x200, VARSEG(Target1(0)), VARPTR(Target1(0)), 191, 41, 209, 59
mxGet Page1in320x200, VARSEG(Target2(0)), VARPTR(Target2(0)), 211, 41, 229, 59
mxGet Page1in320x200, VARSEG(Target3(0)), VARPTR(Target3(0)), 231, 41, 249, 59
mxGet Page1in320x200, VARSEG(Target4(0)), VARPTR(Target4(0)), 251, 41, 269, 59

''The powerups
mxGet Page1in320x200, VARSEG(PowerUpShield(0)), VARPTR(PowerUpShield(0)), 101, 1, 109, 9
mxGet Page1in320x200, VARSEG(PowerUpSuper(0)), VARPTR(PowerUpSuper(0)), 111, 1, 119, 9
mxGet Page1in320x200, VARSEG(PowerUpSpread(0)), VARPTR(PowerUpSpread(0)), 121, 1, 129, 9
mxGet Page1in320x200, VARSEG(PowerUpDouble(0)), VARPTR(PowerUpDouble(0)), 131, 1, 139, 9
mxGet Page1in320x200, VARSEG(PowerUpDoubleRed(0)), VARPTR(PowerUpDoubleRed(0)), 141, 1, 149, 9
mxGet Page1in320x200, VARSEG(PowerUpRed(0)), VARPTR(PowerUpRed(0)), 151, 1, 159, 9
mxGet Page1in320x200, VARSEG(PowerUpScore(0)), VARPTR(PowerUpScore(0)), 161, 1, 169, 9
mxGet Page1in320x200, VARSEG(PowerUpHealth(0)), VARPTR(PowerUpHealth(0)), 171, 1, 179, 9
mxGet Page1in320x200, VARSEG(PowerUpEmpty(0)), VARPTR(PowerUpEmpty(0)), 181, 1, 189, 9

''The stat bars
mxGet Page1in320x200, VARSEG(EmptyBar(0)), VARPTR(EmptyBar(0)), 191, 15, 242, 21
mxGet Page1in320x200, VARSEG(RedBar(0)), VARPTR(RedBar(0)), 244, 15, 244, 21
mxGet Page1in320x200, VARSEG(GreenBar(0)), VARPTR(GreenBar(0)), 246, 15, 246, 21
mxGet Page1in320x200, VARSEG(BlueBar(0)), VARPTR(BlueBar(0)), 248, 15, 248, 21

''The alphabet for text messages
mxGet Page1in320x200, VARSEG(AlphabetA(0)), VARPTR(AlphabetA(0)), 191, 23, 196, 27
mxGet Page1in320x200, VARSEG(AlphabetB(0)), VARPTR(AlphabetB(0)), 198, 23, 203, 27
mxGet Page1in320x200, VARSEG(AlphabetC(0)), VARPTR(AlphabetC(0)), 205, 23, 210, 27
mxGet Page1in320x200, VARSEG(AlphabetD(0)), VARPTR(AlphabetD(0)), 212, 23, 217, 27
mxGet Page1in320x200, VARSEG(AlphabetE(0)), VARPTR(AlphabetE(0)), 219, 23, 224, 27
mxGet Page1in320x200, VARSEG(AlphabetF(0)), VARPTR(AlphabetF(0)), 226, 23, 231, 27
mxGet Page1in320x200, VARSEG(AlphabetG(0)), VARPTR(AlphabetG(0)), 233, 23, 238, 27
mxGet Page1in320x200, VARSEG(AlphabetH(0)), VARPTR(AlphabetH(0)), 240, 23, 245, 27
mxGet Page1in320x200, VARSEG(AlphabetI(0)), VARPTR(AlphabetI(0)), 247, 23, 252, 27
mxGet Page1in320x200, VARSEG(AlphabetJ(0)), VARPTR(AlphabetJ(0)), 254, 23, 259, 27
mxGet Page1in320x200, VARSEG(AlphabetK(0)), VARPTR(AlphabetK(0)), 261, 23, 266, 27
mxGet Page1in320x200, VARSEG(AlphabetL(0)), VARPTR(AlphabetL(0)), 268, 23, 273, 27
mxGet Page1in320x200, VARSEG(AlphabetM(0)), VARPTR(AlphabetM(0)), 275, 23, 280, 27
mxGet Page1in320x200, VARSEG(AlphabetN(0)), VARPTR(AlphabetN(0)), 282, 23, 287, 27
mxGet Page1in320x200, VARSEG(AlphabetO(0)), VARPTR(AlphabetO(0)), 289, 23, 294, 27
mxGet Page1in320x200, VARSEG(AlphabetP(0)), VARPTR(AlphabetP(0)), 296, 23, 301, 27
mxGet Page1in320x200, VARSEG(AlphabetQ(0)), VARPTR(AlphabetQ(0)), 303, 23, 308, 27
mxGet Page1in320x200, VARSEG(AlphabetR(0)), VARPTR(AlphabetR(0)), 310, 23, 315, 27
mxGet Page1in320x200, VARSEG(AlphabetS(0)), VARPTR(AlphabetS(0)), 191, 29, 196, 33
mxGet Page1in320x200, VARSEG(AlphabetT(0)), VARPTR(AlphabetT(0)), 198, 29, 203, 33
mxGet Page1in320x200, VARSEG(AlphabetU(0)), VARPTR(AlphabetU(0)), 205, 29, 210, 33
mxGet Page1in320x200, VARSEG(AlphabetV(0)), VARPTR(AlphabetV(0)), 212, 29, 217, 33
mxGet Page1in320x200, VARSEG(AlphabetW(0)), VARPTR(AlphabetW(0)), 219, 29, 224, 33
mxGet Page1in320x200, VARSEG(AlphabetX(0)), VARPTR(AlphabetX(0)), 226, 29, 231, 33
mxGet Page1in320x200, VARSEG(AlphabetY(0)), VARPTR(AlphabetY(0)), 233, 29, 238, 33
mxGet Page1in320x200, VARSEG(AlphabetZ(0)), VARPTR(AlphabetZ(0)), 240, 29, 245, 33
mxGet Page1in320x200, VARSEG(Alphabet1(0)), VARPTR(Alphabet1(0)), 247, 29, 252, 33
mxGet Page1in320x200, VARSEG(Alphabet2(0)), VARPTR(Alphabet2(0)), 254, 29, 259, 33
mxGet Page1in320x200, VARSEG(Alphabet3(0)), VARPTR(Alphabet3(0)), 261, 29, 266, 33
mxGet Page1in320x200, VARSEG(Alphabet4(0)), VARPTR(Alphabet4(0)), 268, 29, 273, 33
mxGet Page1in320x200, VARSEG(Alphabet5(0)), VARPTR(Alphabet5(0)), 275, 29, 280, 33
mxGet Page1in320x200, VARSEG(Alphabet6(0)), VARPTR(Alphabet6(0)), 282, 29, 287, 33
mxGet Page1in320x200, VARSEG(Alphabet7(0)), VARPTR(Alphabet7(0)), 289, 29, 294, 33
mxGet Page1in320x200, VARSEG(Alphabet8(0)), VARPTR(Alphabet8(0)), 296, 29, 301, 33
mxGet Page1in320x200, VARSEG(Alphabet9(0)), VARPTR(Alphabet9(0)), 303, 29, 308, 33
mxGet Page1in320x200, VARSEG(Alphabet0(0)), VARPTR(Alphabet0(0)), 310, 29, 315, 33
mxGet Page1in320x200, VARSEG(AlphabetColon(0)), VARPTR(AlphabetColon(0)), 191, 35, 196, 39
mxGet Page1in320x200, VARSEG(AlphabetApostrophe(0)), VARPTR(AlphabetApostrophe(0)), 198, 35, 203, 39
mxGet Page1in320x200, VARSEG(AlphabetPeriod(0)), VARPTR(AlphabetPeriod(0)), 205, 35, 210, 39
mxGet Page1in320x200, VARSEG(AlphabetComma(0)), VARPTR(AlphabetComma(0)), 212, 35, 217, 39
mxGet Page1in320x200, VARSEG(AlphabetExclamation(0)), VARPTR(AlphabetExclamation(0)), 219, 35, 224, 39
mxGet Page1in320x200, VARSEG(AlphabetQuestion(0)), VARPTR(AlphabetQuestion(0)), 226, 35, 231, 39
mxGet Page1in320x200, VARSEG(AlphabetSlash(0)), VARPTR(AlphabetSlash(0)), 233, 35, 238, 39
mxGet Page1in320x200, VARSEG(AlphabetCursor(0)), VARPTR(AlphabetCursor(0)), 240, 35, 245, 39

''The numbers for the scoring display
mxGet Page1in320x200, VARSEG(Number1(0)), VARPTR(Number1(0)), 191, 1, 195, 13
mxGet Page1in320x200, VARSEG(Number2(0)), VARPTR(Number2(0)), 197, 1, 209, 13
mxGet Page1in320x200, VARSEG(Number3(0)), VARPTR(Number3(0)), 211, 1, 222, 13
mxGet Page1in320x200, VARSEG(Number4(0)), VARPTR(Number4(0)), 224, 1, 236, 13
mxGet Page1in320x200, VARSEG(Number5(0)), VARPTR(Number5(0)), 238, 1, 250, 13
mxGet Page1in320x200, VARSEG(Number6(0)), VARPTR(Number6(0)), 252, 1, 264, 13
mxGet Page1in320x200, VARSEG(Number7(0)), VARPTR(Number7(0)), 266, 1, 276, 13
mxGet Page1in320x200, VARSEG(Number8(0)), VARPTR(Number8(0)), 278, 1, 290, 13
mxGet Page1in320x200, VARSEG(Number9(0)), VARPTR(Number9(0)), 292, 1, 304, 13
mxGet Page1in320x200, VARSEG(Number0(0)), VARPTR(Number0(0)), 306, 1, 318, 13

''Clean up after
mxFill Page0in320x200, Full320x200, 0
mxFill Page1in320x200, Full320x200, 0


END SUB

SUB Print.Text (TextOut AS STRING, x AS INTEGER, y AS INTEGER, DelayTime AS DOUBLE)

''Print a string of text using the preloaded font

''Declare local variables
DIM Counter AS INTEGER
DIM TextLength AS INTEGER
DIM CurrentLetter AS INTEGER
DIM CurrentCharacter AS STRING
DIM OriginalX AS INTEGER
DIM OriginalY AS INTEGER
DIM LargestX AS INTEGER

''Determine text length
TextLength = LEN(TextOut)
OriginalX = x
OriginalY = y
LargestX = 0

''Find the longest line in the text
FOR CurrentLetter = 1 TO TextLength
	CurrentCharacter = MID$(TextOut, CurrentLetter, 1)
	SELECT CASE CurrentCharacter
		CASE IS = "~"
			IF (x > LargestX) THEN LargestX = x
			x = OriginalX
			y = y + 6
		CASE IS = "*"   ''For typing single letters
		CASE ELSE: x = x + 7
	END SELECT
NEXT CurrentLetter

''Type the text
x = OriginalX
y = OriginalY

FOR CurrentLetter = 1 TO TextLength
	CurrentCharacter = MID$(TextOut, CurrentLetter, 1)
	IF (DelayTime <> 0) THEN
		mxGet Page0in320x200, VARSEG(AlphabetBuffer(0)), VARPTR(AlphabetBuffer(0)), x, y, x + 5, y + 4
		mxPut 0, Page0in320x200, VARSEG(AlphabetCursor(0)), VARPTR(AlphabetCursor(0)), x, y
		Delay (DelayTime)
		mxPut NULLCOLOR, Page0in320x200, VARSEG(AlphabetBuffer(0)), VARPTR(AlphabetBuffer(0)), x, y
	END IF
	SELECT CASE CurrentCharacter
		CASE IS = "A": mxPut 0, Page0in320x200, VARSEG(AlphabetA(0)), VARPTR(AlphabetA(0)), x, y: x = x + 7
		CASE IS = "B": mxPut 0, Page0in320x200, VARSEG(AlphabetB(0)), VARPTR(AlphabetB(0)), x, y: x = x + 7
		CASE IS = "C": mxPut 0, Page0in320x200, VARSEG(AlphabetC(0)), VARPTR(AlphabetC(0)), x, y: x = x + 7
		CASE IS = "D": mxPut 0, Page0in320x200, VARSEG(AlphabetD(0)), VARPTR(AlphabetD(0)), x, y: x = x + 7
		CASE IS = "E": mxPut 0, Page0in320x200, VARSEG(AlphabetE(0)), VARPTR(AlphabetE(0)), x, y: x = x + 7
		CASE IS = "F": mxPut 0, Page0in320x200, VARSEG(AlphabetF(0)), VARPTR(AlphabetF(0)), x, y: x = x + 7
		CASE IS = "G": mxPut 0, Page0in320x200, VARSEG(AlphabetG(0)), VARPTR(AlphabetG(0)), x, y: x = x + 7
		CASE IS = "H": mxPut 0, Page0in320x200, VARSEG(AlphabetH(0)), VARPTR(AlphabetH(0)), x, y: x = x + 7
		CASE IS = "I": mxPut 0, Page0in320x200, VARSEG(AlphabetI(0)), VARPTR(AlphabetI(0)), x, y: x = x + 7
		CASE IS = "J": mxPut 0, Page0in320x200, VARSEG(AlphabetJ(0)), VARPTR(AlphabetJ(0)), x, y: x = x + 7
		CASE IS = "K": mxPut 0, Page0in320x200, VARSEG(AlphabetK(0)), VARPTR(AlphabetK(0)), x, y: x = x + 7
		CASE IS = "L": mxPut 0, Page0in320x200, VARSEG(AlphabetL(0)), VARPTR(AlphabetL(0)), x, y: x = x + 7
		CASE IS = "M": mxPut 0, Page0in320x200, VARSEG(AlphabetM(0)), VARPTR(AlphabetM(0)), x, y: x = x + 7
		CASE IS = "N": mxPut 0, Page0in320x200, VARSEG(AlphabetN(0)), VARPTR(AlphabetN(0)), x, y: x = x + 7
		CASE IS = "O": mxPut 0, Page0in320x200, VARSEG(AlphabetO(0)), VARPTR(AlphabetO(0)), x, y: x = x + 7
		CASE IS = "P": mxPut 0, Page0in320x200, VARSEG(AlphabetP(0)), VARPTR(AlphabetP(0)), x, y: x = x + 7
		CASE IS = "Q": mxPut 0, Page0in320x200, VARSEG(AlphabetQ(0)), VARPTR(AlphabetQ(0)), x, y: x = x + 7
		CASE IS = "R": mxPut 0, Page0in320x200, VARSEG(AlphabetR(0)), VARPTR(AlphabetR(0)), x, y: x = x + 7
		CASE IS = "S": mxPut 0, Page0in320x200, VARSEG(AlphabetS(0)), VARPTR(AlphabetS(0)), x, y: x = x + 7
		CASE IS = "T": mxPut 0, Page0in320x200, VARSEG(AlphabetT(0)), VARPTR(AlphabetT(0)), x, y: x = x + 7
		CASE IS = "U": mxPut 0, Page0in320x200, VARSEG(AlphabetU(0)), VARPTR(AlphabetU(0)), x, y: x = x + 7
		CASE IS = "V": mxPut 0, Page0in320x200, VARSEG(AlphabetV(0)), VARPTR(AlphabetV(0)), x, y: x = x + 7
		CASE IS = "W": mxPut 0, Page0in320x200, VARSEG(AlphabetW(0)), VARPTR(AlphabetW(0)), x, y: x = x + 7
		CASE IS = "X": mxPut 0, Page0in320x200, VARSEG(AlphabetX(0)), VARPTR(AlphabetX(0)), x, y: x = x + 7
		CASE IS = "Y": mxPut 0, Page0in320x200, VARSEG(AlphabetY(0)), VARPTR(AlphabetY(0)), x, y: x = x + 7
		CASE IS = "Z": mxPut 0, Page0in320x200, VARSEG(AlphabetZ(0)), VARPTR(AlphabetZ(0)), x, y: x = x + 7
		CASE IS = ":": mxPut 0, Page0in320x200, VARSEG(AlphabetColon(0)), VARPTR(AlphabetColon(0)), x, y: x = x + 7
		CASE IS = "'": mxPut 0, Page0in320x200, VARSEG(AlphabetApostrophe(0)), VARPTR(AlphabetApostrophe(0)), x, y: x = x + 7
		CASE IS = ".": mxPut 0, Page0in320x200, VARSEG(AlphabetPeriod(0)), VARPTR(AlphabetPeriod(0)), x, y: x = x + 7
		CASE IS = ",": mxPut 0, Page0in320x200, VARSEG(AlphabetComma(0)), VARPTR(AlphabetComma(0)), x, y: x = x + 7
		CASE IS = "!": mxPut 0, Page0in320x200, VARSEG(AlphabetExclamation(0)), VARPTR(AlphabetExclamation(0)), x, y: x = x + 7
		CASE IS = "?": mxPut 0, Page0in320x200, VARSEG(AlphabetQuestion(0)), VARPTR(AlphabetQuestion(0)), x, y: x = x + 7
		CASE IS = "/": mxPut 0, Page0in320x200, VARSEG(AlphabetSlash(0)), VARPTR(AlphabetSlash(0)), x, y: x = x + 7
		CASE IS = "0": mxPut 0, Page0in320x200, VARSEG(Alphabet0(0)), VARPTR(Alphabet0(0)), x, y: x = x + 7
		CASE IS = "1": mxPut 0, Page0in320x200, VARSEG(Alphabet1(0)), VARPTR(Alphabet1(0)), x, y: x = x + 7
		CASE IS = "2": mxPut 0, Page0in320x200, VARSEG(Alphabet2(0)), VARPTR(Alphabet2(0)), x, y: x = x + 7
		CASE IS = "3": mxPut 0, Page0in320x200, VARSEG(Alphabet3(0)), VARPTR(Alphabet3(0)), x, y: x = x + 7
		CASE IS = "4": mxPut 0, Page0in320x200, VARSEG(Alphabet4(0)), VARPTR(Alphabet4(0)), x, y: x = x + 7
		CASE IS = "5": mxPut 0, Page0in320x200, VARSEG(Alphabet5(0)), VARPTR(Alphabet5(0)), x, y: x = x + 7
		CASE IS = "6": mxPut 0, Page0in320x200, VARSEG(Alphabet6(0)), VARPTR(Alphabet6(0)), x, y: x = x + 7
		CASE IS = "7": mxPut 0, Page0in320x200, VARSEG(Alphabet7(0)), VARPTR(Alphabet7(0)), x, y: x = x + 7
		CASE IS = "8": mxPut 0, Page0in320x200, VARSEG(Alphabet8(0)), VARPTR(Alphabet8(0)), x, y: x = x + 7
		CASE IS = "9": mxPut 0, Page0in320x200, VARSEG(Alphabet9(0)), VARPTR(Alphabet9(0)), x, y: x = x + 7
		CASE IS = "*": x = x - 7 ''For typing single letters
		CASE IS = " ": x = x + 7
		CASE IS = "~": x = OriginalX: y = y + 6
	END SELECT
NEXT CurrentLetter


END SUB

SUB read.keyboard

''Reads the keyboard and
''updates the properties according to keypresses

''Declare local variables
DIM KeyPressed AS INTEGER    ''For quitting
DIM KeyCounter AS SINGLE

KeyPressed = FALSE
KeyCounter = 0
Player.Strafing = FALSE

''Reset the player's variables in case no key is pressed
''but only if he's actually flying, not exploding or standing still
IF (Player.State = Flying) THEN Player.State = Inactive

''Regular movements
''Cardinal directions
IF (Player.ControlStyle = ScreenOriented) THEN ''''Switch: control orientations

IF (MULTIKEY(72) = 1) THEN 'press up
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = Up
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = Up
			Player.State = Flying
		END IF
	END IF
END IF

IF (MULTIKEY(77) = 1) THEN 'press right
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = Right
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = Right
			Player.State = Flying
		END IF
	END IF
END IF

IF (MULTIKEY(80) = 1) THEN 'press down
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = Down
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = Down
			Player.State = Flying
		END IF
	END IF
END IF

IF (MULTIKEY(75) = 1) THEN 'press left
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = Left
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = Left
			Player.State = Flying
		END IF
	END IF
END IF

ELSE  ''''Switching between screen oriented to ship oriented

IF (MULTIKEY(72) = 1) THEN 'press up
	IF (Player.State = Flying) OR (Player.State = Inactive) THEN
		Player.State = Flying
	END IF
END IF

IF (MULTIKEY(77) = 1) THEN 'press right
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			SELECT CASE Player.Direction
				CASE IS = Up
					Player.Strafing = Right
				CASE IS = Down
					Player.Strafing = Left
				CASE IS = Left
					Player.Strafing = Up
				CASE IS = Right
					Player.Strafing = Down
				CASE IS = UpRight
					Player.Strafing = DownRight
				CASE IS = DownRight
					Player.Strafing = DownLeft
				CASE IS = UpLeft
					Player.Strafing = UpRight
				CASE IS = DownLeft
					Player.Strafing = UpLeft
			END SELECT
			Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			IF (Player.TurnDelayCounter = 0) THEN
				Player.Direction = Player.Direction + 1
				IF (Player.Direction = 9) THEN Player.Direction = 1
			END IF
		END IF
	END IF
END IF

IF (MULTIKEY(80) = 1) THEN 'press down
	IF (Player.State = Flying) OR (Player.State = Inactive) THEN
	SELECT CASE Player.Direction
		CASE IS = Up
			Player.Strafing = Down
		CASE IS = Down
			Player.Strafing = Up
		CASE IS = Left
			Player.Strafing = Right
		CASE IS = Right
			Player.Strafing = Left
		CASE IS = UpRight
			Player.Strafing = DownLeft
		CASE IS = DownRight
			Player.Strafing = UpLeft
		CASE IS = UpLeft
			Player.Strafing = DownRight
		CASE IS = DownLeft
			Player.Strafing = UpRight
		END SELECT
		Player.State = Flying
	END IF
END IF

IF (MULTIKEY(75) = 1) THEN 'press left
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			SELECT CASE Player.Direction
				CASE IS = Up
					Player.Strafing = Left
				CASE IS = Down
					Player.Strafing = Right
				CASE IS = Left
					Player.Strafing = Down
				CASE IS = Right
					Player.Strafing = Up
				CASE IS = UpRight
					Player.Strafing = UpLeft
				CASE IS = DownRight
					Player.Strafing = UpRight
				CASE IS = UpLeft
					Player.Strafing = DownLeft
				CASE IS = DownLeft
					Player.Strafing = DownRight
			END SELECT
			Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			IF (Player.TurnDelayCounter = 0) THEN
				Player.Direction = Player.Direction - 1
				IF (Player.Direction = 0) THEN Player.Direction = 8
			END IF
		END IF
	END IF
END IF

END IF ''''Orientation Switch


''Diagonal directions
IF (1) THEN ''''To disable diagonal if necessary

IF (MULTIKEY(72) = 1) AND (MULTIKEY(77) = 1) THEN 'press up+right
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = UpRight
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = UpRight
			Player.State = Flying
		END IF
	END IF
END IF

IF (MULTIKEY(77) = 1) AND (MULTIKEY(80) = 1) THEN 'press down+right
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = DownRight
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = DownRight
			Player.State = Flying
		END IF
	END IF
END IF

IF (MULTIKEY(80) = 1) AND (MULTIKEY(75) = 1) THEN 'press down+left
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = DownLeft
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = DownLeft
			Player.State = Flying
		END IF
	END IF
END IF

IF (MULTIKEY(72) = 1) AND (MULTIKEY(75) = 1) THEN 'press up+left
	IF (MULTIKEY(31) = 1) THEN ''S is pressed, Strafe!
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
				Player.Strafing = UpLeft
				Player.State = Flying
		END IF
	ELSE
		IF (Player.State = Flying) OR (Player.State = Inactive) THEN
			Player.Direction = UpLeft
			Player.State = Flying
		END IF
	END IF
END IF

END IF ''''See if diagonal is enabled

	''Set the cannon variables for firing
	SELECT CASE Player.Direction
		CASE IS = Up
			Player.CannonX = Player.Sprite.x + 9
			Player.CannonY = Player.Sprite.y + 1
			Player.CannonVelocityX = 0
			Player.CannonVelocityY = -1
		CASE IS = Down
			Player.CannonX = Player.Sprite.x + 5
			Player.CannonY = Player.Sprite.y + 5
			Player.CannonVelocityX = 0
			Player.CannonVelocityY = 1
		CASE IS = Left
			Player.CannonX = Player.Sprite.x - 1
			Player.CannonY = Player.Sprite.y + 3
			Player.CannonVelocityX = -1
			Player.CannonVelocityY = 0
		CASE IS = Right
			Player.CannonX = Player.Sprite.x + 19
			Player.CannonY = Player.Sprite.y + 3
			Player.CannonVelocityX = 1
			Player.CannonVelocityY = 0
		CASE IS = UpRight
			Player.CannonX = Player.Sprite.x + 14
			Player.CannonY = Player.Sprite.y + 4
			Player.CannonVelocityX = 1
			Player.CannonVelocityY = -1
		CASE IS = DownRight
			Player.CannonX = Player.Sprite.x + 6
			Player.CannonY = Player.Sprite.y + 4
			Player.CannonVelocityX = 1
			Player.CannonVelocityY = 1
		CASE IS = UpLeft
			Player.CannonX = Player.Sprite.x + 2
			Player.CannonY = Player.Sprite.y + 4
			Player.CannonVelocityX = -1
			Player.CannonVelocityY = -1
		CASE IS = DownLeft
			Player.CannonX = Player.Sprite.x + 12
			Player.CannonY = Player.Sprite.y + 4
			Player.CannonVelocityX = -1
			Player.CannonVelocityY = 1
	END SELECT


IF (MULTIKEY(57) = 1) THEN 'press space
	IF (Player.State = Flying) OR (Player.State = Inactive) THEN
		''Make sure player can shoot missile (not overheated) and that
		''no missile is being shot right now
		IF (Player.Heat < 48) AND (MissileClock = 0) THEN
			''Shoot depending on current weapon
			SELECT CASE Player.WeaponType
				CASE IS = Normal
					Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, Player.CannonVelocityY, Blue
				CASE IS = PowerUpTypeSuper
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, 1, 1, Yellow
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, 0, 1, Red
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, -1, 1, Yellow
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, -1, 0, Red
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, -1, -1, Yellow
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, 0, -1, Red
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, 1, -1, Yellow
					Shoot.Missile Player.Sprite.x, Player.Sprite.y, 1, 0, Red
				CASE IS = PowerUpTypeSpread
					IF (Player.Direction = Up) OR (Player.Direction = Down) THEN
						Shoot.Missile Player.CannonX, Player.CannonY, -1, Player.CannonVelocityY, Yellow
						Shoot.Missile Player.CannonX, Player.CannonY, 0, Player.CannonVelocityY, Yellow
						Shoot.Missile Player.CannonX, Player.CannonY, 1, Player.CannonVelocityY, Yellow
					ELSE
						Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, -1, Yellow
						Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, 0, Yellow
						Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, 1, Yellow
					END IF
				CASE IS = PowerUpTypeDouble
					IF (Player.Direction = Up) THEN
						Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, Player.CannonVelocityY, Blue
						Shoot.Missile Player.CannonX - 5, Player.CannonY + 5, Player.CannonVelocityX, Player.CannonVelocityY, Blue
					ELSE
						Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, Player.CannonVelocityY, Blue
						Shoot.Missile Player.CannonX + 5, Player.CannonY + 5, Player.CannonVelocityX, Player.CannonVelocityY, Blue
					END IF
				CASE IS = PowerUpTypeDoubleRed
					Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, Player.CannonVelocityY, Red
					Shoot.Missile Player.CannonX + 5, Player.CannonY + 5, Player.CannonVelocityX, Player.CannonVelocityY, Red
				CASE IS = PowerUpTypeRed
					Shoot.Missile Player.CannonX, Player.CannonY, Player.CannonVelocityX, Player.CannonVelocityY, Red
			END SELECT
			Player.Heat = Player.Heat + 2
			IF (Player.Heat > 50) THEN Player.Heat = 50
			MissileClock = 10
		END IF
	END IF
END IF

IF (MULTIKEY(25) = 1) THEN 'press "P"
	Print.Text "PAUSED~", 145, 97, 0
	Delay .2
	Wait.KeyPress
	Delay .2
	Delete.Text 145, 97, 187, 104
END IF

IF (MULTIKEY(23) = 1) THEN 'press "I"
END IF

''Enter is 28

IF (MULTIKEY(16) = 1) OR (MULTIKEY(1) = 1) THEN 'press "Q" or Escape
	Print.Text "ARE YOU SURE?", 120, 97, 0
	Delay .1

	''Keep cycling through all the keys until one is pressed
	WHILE KeyPressed = FALSE
		FOR KeyCounter = 1 TO 128
			IF (MULTIKEY(KeyCounter) = 1) THEN KeyPressed = KeyCounter
		NEXT KeyCounter
	WEND

	IF (KeyPressed = 21) THEN ''Press Y
		Input.HighScore Player.Score
		GameMode = DisplayingMenu
	ELSE
		Delete.Text 120, 97, 214, 104
	END IF
END IF

END SUB

SUB Shoot.Missile (CannonX AS INTEGER, CannonY AS INTEGER, VelocityX AS INTEGER, VelocityY AS INTEGER, Design AS INTEGER)

''Create a missile and shoot it

'Local variables
DIM MissileCounter AS INTEGER
DIM EnemyCounter AS INTEGER
DIM CurrentNearestEnemy AS INTEGER
DIM CurrentDistance AS INTEGER
DIM LastDistance AS INTEGER
DIM Distance AS INTEGER

CurrentDistance = 400

'Walk through the array of missiles finding an inactive one
MissileCounter = 0
DO
	MissileCounter = MissileCounter + 1
	''Error Checking
	IF (MissileCounter > MAXMISSILES) THEN EXIT SUB
LOOP UNTIL (Missile(MissileCounter).State = Inactive)

'Found, initialize the missiles variables
Missile(MissileCounter).State = Flying
Missile(MissileCounter).Sprite.x = CannonX
Missile(MissileCounter).Sprite.y = CannonY
Missile(MissileCounter).VelocityX = VelocityX
Missile(MissileCounter).VelocityY = VelocityY
Missile(MissileCounter).Design = Design

''Homing missiles
IF (Missile(MissileCounter).Design = Red) THEN
	''Make sure we're locked on
	IF (Target.AnimationStep = 4) THEN
		''Walk through all the enemies, and find the closest one
		FOR EnemyCounter = 1 TO MAXENEMIES
			IF (Enemy(EnemyCounter).State = Alive) THEN
			Distance = ABS(Player.Sprite.x - Enemy(EnemyCounter).Sprite.x) + ABS(Player.Sprite.y - Enemy(EnemyCounter).Sprite.y)
				IF (Distance < CurrentDistance) THEN
					CurrentDistance = Distance
					CurrentNearestEnemy = EnemyCounter
				END IF
			END IF
		NEXT EnemyCounter
		Missile(MissileCounter).Target = CurrentNearestEnemy
		Missile(MissileCounter).Health = 1
	END IF
ELSEIF (Missile(MissileCounter).Design = Yellow) THEN
	Missile(MissileCounter).Health = 5
END IF


END SUB

SUB Training.Script (CurrentStep AS INTEGER)

''This function is called by the program at various intervals in
''the training process

SELECT CASE CurrentStep
	CASE IS = 1 ''Initialize
		Enemy(1).Sprite.x = 220
		Enemy(1).Sprite.y = 90
		Enemy(1).State = Alive
		Enemy(1).Health = 1000
		Enemy(1).LogicState = Standing
		Enemy(1).PlayerCrashed = FALSE
		Enemy(1).Sprite.Design = 1
		Enemy(1).Direction = Left
		Enemy(1).AnimationCounter = 1 + (RND * 2)
		Enemy(1).Class = AnimatedObject
		Enemy(1).Area.MinX = 0
		Enemy(1).Area.MinY = 0
		Enemy(1).Area.MaxX = 300
		Enemy(1).Area.MaxY = 180
		Player.Health = 5000
		Level.EnemiesToKill = 20
	CASE IS = 2 ''Explain the bars and tell the player to move around
		''the more rapidly you fire, the more it increases
		''when it's full, u can no longer fire
		''foretunately, it decreases over time
		Print.Text "THIS IS YOU...~", 61, 80, 0
		Print.Text "THIS IS THE HEALTH BAR~", 60, 186, 0
		Print.Text "THIS IS THE HEAT BAR~", 60, 176, 0
		Delay .5
		Wait.KeyPress
		Delete.Text 61, 80, 180, 86
		Delete.Text 60, 185, 320, 194
		Delete.Text 60, 175, 320, 184
		Print.Text "MOVE AROUND USING THE ARROW KEYS,~", 30, 5, .01
		Print.Text "HOLD DOWN THE S KEY TO STRAFE.~", 30, 12, .01
		Delay .5
		Wait.KeyPress
		Delete.Text 30, 5, 320, 18
       
	CASE IS = 3 ''Tell the player to shoot
		Print.Text "THE CROSSHAIRS POINT TO~", 30, 5, .01
		Print.Text "THE NEAREST ENEMY,~", 30, 12, .01
		Print.Text "SHOOT USING THE SPACEBAR,~", 30, 19, .01
		Print.Text "TRY KILLING IT...~", 30, 26, .01
		Delay .5
		Wait.KeyPress
		Delete.Text 30, 5, 320, 34
		Enemy(1).Health = 10
		Enemy(1).Class = Animated
	CASE IS = 4 ''Explain the powerups and list the various powerups
		Print.Text "ENEMIES DROP POWERUPS...~", 30, 5, .01
		Delay .5
		Wait.KeyPress
		Delete.Text 30, 5, 250, 17
		Print.Text "HERE ARE SOME OF THEM...~", 94, 43, 0
		mxPut 0, Page0in320x200, VARSEG(PowerUpSpread(0)), VARPTR(PowerUpSpread(0)), 94, 59
		Print.Text "SPREADFIRE~", 104, 61, 0
		mxPut 0, Page0in320x200, VARSEG(PowerUpDouble(0)), VARPTR(PowerUpDouble(0)), 94, 79
		Print.Text "DOUBLE~", 104, 81, 0
		mxPut 0, Page0in320x200, VARSEG(PowerUpDoubleRed(0)), VARPTR(PowerUpDoubleRed(0)), 94, 99
		Print.Text "DOUBLE HOMING MISSILES~", 104, 101, 0
		mxPut 0, Page0in320x200, VARSEG(PowerUpRed(0)), VARPTR(PowerUpRed(0)), 94, 119
		Print.Text "HOMING MISSILES~", 104, 121, 0
		mxPut 0, Page0in320x200, VARSEG(PowerUpScore(0)), VARPTR(PowerUpScore(0)), 94, 139
		Print.Text "BONUS POINTS~", 104, 141, 0
		mxPut 0, Page0in320x200, VARSEG(PowerUpHealth(0)), VARPTR(PowerUpHealth(0)), 94, 159
		Print.Text "EXTRA HEALTH~", 104, 161, 0
		Delay .5
		Wait.KeyPress
		GameMode = DisplayingMenu
END SELECT



END SUB

SUB Update.Enemies

''Update the positions of the enemies according to their logic state,
''update any exploding enemies, create powerups in place of kills, and
''update the animation counters to animate enemies

'Local variables
DIM EnemyCounter AS INTEGER

'Walk through all the enemies, updating any active ones and
'checking for health

FOR EnemyCounter = 1 TO MAXENEMIES
	''Animation
	Enemy(EnemyCounter).AnimationCounter = Enemy(EnemyCounter).AnimationCounter + 1
	IF (Enemy(EnemyCounter).AnimationCounter = 5) THEN Enemy(EnemyCounter).AnimationCounter = 1
	''Explode dead enemies
	IF (Enemy(EnemyCounter).Health <= 0) AND (Enemy(EnemyCounter).State = Alive) THEN Enemy(EnemyCounter).State = Exploding1
	''Update using logic scripts
	SELECT CASE Enemy(EnemyCounter).State
		CASE IS = Alive
			SELECT CASE Enemy(EnemyCounter).LogicState
				CASE IS = Chasing
					Script.Chase EnemyCounter
				CASE IS = Stationary
				CASE IS = Wiggling
					'Script.Wiggling EnemyCounter
				CASE IS = Fighter
					Script.Fighter EnemyCounter
				CASE IS = Wandering
					Script.Wandering EnemyCounter
				CASE IS = Cautious
					Script.Cautious EnemyCounter
			END SELECT
		''Keep everyone in their designated area
		IF (Enemy(EnemyCounter).Sprite.x < Enemy(EnemyCounter).Area.MinX) THEN Enemy(EnemyCounter).Sprite.x = Enemy(EnemyCounter).Area.MinX
		IF (Enemy(EnemyCounter).Sprite.x > Enemy(EnemyCounter).Area.MaxX) THEN Enemy(EnemyCounter).Sprite.x = Enemy(EnemyCounter).Area.MaxX
		IF (Enemy(EnemyCounter).Sprite.y < Enemy(EnemyCounter).Area.MinY) THEN Enemy(EnemyCounter).Sprite.y = Enemy(EnemyCounter).Area.MinY
		IF (Enemy(EnemyCounter).Sprite.y > Enemy(EnemyCounter).Area.MaxY) THEN Enemy(EnemyCounter).Sprite.y = Enemy(EnemyCounter).Area.MaxY
	       
		CASE IS = Exploding4
			Enemy(EnemyCounter).State = Dead
			''Enemy died, so create a powerup
			'IF ((1 + (RND * 2)) = 2) THEN
			''Training only
			IF (Enemy(EnemyCounter).PlayerCrashed = FALSE) OR (GameMode = Training) THEN
				Create.PowerUp Enemy(EnemyCounter).Sprite.x + 5, Enemy(EnemyCounter).Sprite.y + 5
			ELSE
				Enemy(EnemyCounter).PlayerCrashed = FALSE
			END IF
			EnemiesKilled = EnemiesKilled + 1
			Create.Explosion Enemy(EnemyCounter).Sprite.x + 2, Enemy(EnemyCounter).Sprite.y - 47, Vertical
		CASE IS = Exploding3
			Enemy(EnemyCounter).State = Exploding4
		CASE IS = Exploding2
			Enemy(EnemyCounter).State = Exploding3
			Create.Explosion Enemy(EnemyCounter).Sprite.x - 47, Enemy(EnemyCounter).Sprite.y + 2, Horizontal
		CASE IS = Exploding1
			Enemy(EnemyCounter).State = Exploding2
	END SELECT
NEXT EnemyCounter


END SUB

SUB Update.Explosions

''Update any explosions going on at the time

'Local variables
DIM ExplosionCounter AS INTEGER

'Walk through all the explosions, updating any active ones

FOR ExplosionCounter = 1 TO MAXEXPLOSIONS
	IF (Explosion(ExplosionCounter).State = Dying) THEN Explosion(ExplosionCounter).State = Inactive
	''Animation
	IF (Explosion(ExplosionCounter).State <> Inactive) THEN
		Explosion(ExplosionCounter).AnimationStep = Explosion(ExplosionCounter).AnimationStep + 1
		IF (Explosion(ExplosionCounter).AnimationStep = 6) THEN
			Explosion(ExplosionCounter).State = Dying
		END IF
	END IF
NEXT ExplosionCounter

END SUB

SUB Update.Missiles

''Move all active missiles including red homing ones

''Declare local variables
DIM MissileCounter AS INTEGER

''Walk through all the missiles, updating any active ones
FOR MissileCounter = 1 TO MAXMISSILES
	IF (Missile(MissileCounter).Design = Red) THEN
		''Check of the target is gone, in which case, explode
		IF (Enemy(Missile(MissileCounter).Target).State <> Alive) THEN
			Missile(MissileCounter).State = Inactive
			Missile(MissileCounter).Health = 0
		ELSE
			''Homing missiles, fly towards the target
			IF (Missile(MissileCounter).Sprite.x + 1 < Enemy(Missile(MissileCounter).Target).Sprite.x + 9) THEN Missile(MissileCounter).Sprite.x = Missile(MissileCounter).Sprite.x + 2
			IF (Missile(MissileCounter).Sprite.x + 1 > Enemy(Missile(MissileCounter).Target).Sprite.x + 9) THEN Missile(MissileCounter).Sprite.x = Missile(MissileCounter).Sprite.x - 2
			IF (Missile(MissileCounter).Sprite.y + 1 < Enemy(Missile(MissileCounter).Target).Sprite.y + 9) THEN Missile(MissileCounter).Sprite.y = Missile(MissileCounter).Sprite.y + 2
			IF (Missile(MissileCounter).Sprite.y + 1 > Enemy(Missile(MissileCounter).Target).Sprite.y + 9) THEN Missile(MissileCounter).Sprite.y = Missile(MissileCounter).Sprite.y - 2
		END IF
	ELSEIF (Missile(MissileCounter).Design = Yellow) THEN
		''Bouncing
		Missile(MissileCounter).Sprite.x = Missile(MissileCounter).Sprite.x + (Missile(MissileCounter).VelocityX * 2)
		Missile(MissileCounter).Sprite.y = Missile(MissileCounter).Sprite.y + (Missile(MissileCounter).VelocityY * 2)
		''Hit the wall?
		IF (Missile(MissileCounter).Sprite.x > 320) OR (Missile(MissileCounter).Sprite.x < 0 - 7) THEN
			Missile(MissileCounter).VelocityX = Missile(MissileCounter).VelocityX * -1
			Missile(MissileCounter).Health = Missile(MissileCounter).Health - 1
			IF (Missile(MissileCounter).Health <= 0) THEN Missile(MissileCounter).State = Inactive
		END IF
		IF (Missile(MissileCounter).Sprite.y > 200) OR (Missile(MissileCounter).Sprite.y < 0 - 7) THEN
			Missile(MissileCounter).VelocityY = Missile(MissileCounter).VelocityY * -1
			Missile(MissileCounter).Health = Missile(MissileCounter).Health - 1
			IF (Missile(MissileCounter).Health <= 0) THEN Missile(MissileCounter).State = Inactive
		END IF
	ELSE
		IF (Missile(MissileCounter).State = Flying) THEN
			Missile(MissileCounter).Sprite.x = Missile(MissileCounter).Sprite.x + (Missile(MissileCounter).VelocityX * 2)
			Missile(MissileCounter).Sprite.y = Missile(MissileCounter).Sprite.y + (Missile(MissileCounter).VelocityY * 2)
			''Hit the wall?
			IF (Missile(MissileCounter).Sprite.x > 320) OR (Missile(MissileCounter).Sprite.x < 0 - 7) THEN Missile(MissileCounter).State = Inactive
			IF (Missile(MissileCounter).Sprite.y > 200) OR (Missile(MissileCounter).Sprite.y < 0 - 7) THEN Missile(MissileCounter).State = Inactive
		END IF
	END IF
NEXT MissileCounter

END SUB

SUB Update.Player

''Do all kinds of maintenance on the player...movement, health,
''exploding, dying, weapons time limit checking

''Shield already erased?
IF (Player.Shield = MARK) THEN Player.Shield = FALSE

''Update the turn delay, in case turning is currently ship-oriented
Player.TurnDelayCounter = Player.TurnDelayCounter + 1
IF (Player.TurnDelayCounter >= 15) THEN Player.TurnDelayCounter = 0

''See if it's time to drop the weapon powerup
IF (Player.WeaponType <> Normal) THEN
	Player.WeaponTimer = Player.WeaponTimer - 1
	IF (Player.WeaponTimer = 0) THEN Player.WeaponType = Normal
END IF

''Keep updating explosion clock
PlayerExplosionClock = PlayerExplosionClock + 1
IF (PlayerExplosionClock = 20) THEN PlayerExplosionClock = 0

''Update the heat clock and reduce heat if necessary
PlayerHeatClock = PlayerHeatClock + 1
IF (PlayerHeatClock = 20) THEN PlayerHeatClock = 0
IF (PlayerHeatClock = 10) AND (Player.Heat > 0) THEN Player.Heat = Player.Heat - 1
IF (Player.Heat < 0) THEN Player.Heat = 0

''Move the player according to the direction
SELECT CASE Player.State
	CASE IS = Flying
		IF (Player.Strafing = FALSE) THEN
			SELECT CASE Player.Direction
				CASE IS = Up
					Player.Sprite.y = Player.Sprite.y - 1
				CASE IS = Down
					Player.Sprite.y = Player.Sprite.y + 1
				CASE IS = Left
					Player.Sprite.x = Player.Sprite.x - 1
				CASE IS = Right
					Player.Sprite.x = Player.Sprite.x + 1
				CASE IS = UpRight
					Player.Sprite.y = Player.Sprite.y - 1
					Player.Sprite.x = Player.Sprite.x + 1
				CASE IS = DownRight
					Player.Sprite.y = Player.Sprite.y + 1
					Player.Sprite.x = Player.Sprite.x + 1
				CASE IS = DownLeft
					Player.Sprite.y = Player.Sprite.y + 1
					Player.Sprite.x = Player.Sprite.x - 1
				CASE IS = UpLeft
					Player.Sprite.y = Player.Sprite.y - 1
					Player.Sprite.x = Player.Sprite.x - 1
			END SELECT
		ELSE
			SELECT CASE Player.Strafing
				CASE IS = Up
					Player.Sprite.y = Player.Sprite.y - 1
				CASE IS = Down
					Player.Sprite.y = Player.Sprite.y + 1
				CASE IS = Left
					Player.Sprite.x = Player.Sprite.x - 1
				CASE IS = Right
					Player.Sprite.x = Player.Sprite.x + 1
				CASE IS = UpRight
					Player.Sprite.y = Player.Sprite.y - 1
					Player.Sprite.x = Player.Sprite.x + 1
				CASE IS = DownRight
					Player.Sprite.y = Player.Sprite.y + 1
					Player.Sprite.x = Player.Sprite.x + 1
				CASE IS = DownLeft
					Player.Sprite.y = Player.Sprite.y + 1
					Player.Sprite.x = Player.Sprite.x - 1
				CASE IS = UpLeft
					Player.Sprite.y = Player.Sprite.y - 1
					Player.Sprite.x = Player.Sprite.x - 1
			END SELECT
		END IF
		''Keep the player in his designated area
		IF (Player.Sprite.x < Player.Area.MinX) THEN Player.Sprite.x = Player.Area.MinX
		IF (Player.Sprite.x > Player.Area.MaxX) THEN Player.Sprite.x = Player.Area.MaxX
		IF (Player.Sprite.y < Player.Area.MinY) THEN Player.Sprite.y = Player.Area.MinY
		IF (Player.Sprite.y > Player.Area.MaxY) THEN Player.Sprite.y = Player.Area.MaxY
       
	CASE IS = Exploding4
		IF (PlayerExplosionClock = 0) THEN Player.State = Dead
		''Say game over, go back to the menu
		Print.Text "GAME OVER", 127, 97, 0
		Delay 1
		GameMode = DisplayingMenu
		Input.HighScore Player.Score
	CASE IS = Exploding3
		IF (PlayerExplosionClock = 0) THEN Player.State = Exploding4
	CASE IS = Exploding2
		IF (PlayerExplosionClock = 0) THEN Player.State = Exploding3
	CASE IS = Exploding1
		IF (PlayerExplosionClock = 0) THEN Player.State = Exploding2
END SELECT

''Check the player's health
IF ((Player.State = Flying) OR (Player.State = Inactive)) AND (Player.Health <= 0) THEN
	IF (Player.Shield = TRUE) THEN
		Player.Shield = MARK
		Player.Health = 50
	ELSE
		Player.State = Exploding1
	END IF
END IF
IF (Player.Health >= 50) THEN Player.Health = 50

END SUB

SUB Update.PowerUps

''Move all the powerups

''Declare local variables
DIM PowerUpCounter AS INTEGER

''Cycle through all the powerups, moving each
FOR PowerUpCounter = 1 TO MAXPOWERUPS
	IF (PowerUp(PowerUpCounter).State = Flying) THEN
		PowerUp(PowerUpCounter).Sprite.x = PowerUp(PowerUpCounter).Sprite.x + PowerUp(PowerUpCounter).VelocityX
		PowerUp(PowerUpCounter).Sprite.y = PowerUp(PowerUpCounter).Sprite.y + PowerUp(PowerUpCounter).VelocityY
		''Check if the 6 seconds have expired
		IF (ABS(TIMER - PowerUp(PowerUpCounter).TimeCreated) >= 10) THEN PowerUp(PowerUpCounter).State = Dying
	END IF
	''Bounce them off the walls...
	IF (PowerUp(PowerUpCounter).Sprite.x >= 312) THEN PowerUp(PowerUpCounter).VelocityX = PowerUp(PowerUpCounter).VelocityX * -1
	IF (PowerUp(PowerUpCounter).Sprite.y >= 192) THEN PowerUp(PowerUpCounter).VelocityY = PowerUp(PowerUpCounter).VelocityY * -1
	IF (PowerUp(PowerUpCounter).Sprite.x <= 1) THEN PowerUp(PowerUpCounter).VelocityX = PowerUp(PowerUpCounter).VelocityX * -1
	IF (PowerUp(PowerUpCounter).Sprite.y <= 1) THEN PowerUp(PowerUpCounter).VelocityY = PowerUp(PowerUpCounter).VelocityY * -1
NEXT PowerUpCounter


END SUB

SUB Update.Target

''Update the homing missile target

''Declare local variables
DIM EnemyCounter AS INTEGER
DIM CurrentNearestEnemy AS INTEGER
DIM CurrentDistance AS INTEGER
DIM LastDistance AS INTEGER
DIM Distance AS INTEGER

CurrentDistance = 400

''Find the nearest enemy and fly towards it
FOR EnemyCounter = 1 TO MAXENEMIES
''Make sure we arent targeting an object
IF (Enemy(EnemyCounter).State = Alive) AND ((Enemy(EnemyCounter).Class <> AnimatedObject) OR (Enemy(EnemyCounter).Class <> SingleFrameObject)) THEN
	Distance = ABS(Player.Sprite.x - Enemy(EnemyCounter).Sprite.x) + ABS(Player.Sprite.y - Enemy(EnemyCounter).Sprite.y)
	IF (Distance < CurrentDistance) THEN
		CurrentDistance = Distance
		CurrentNearestEnemy = EnemyCounter
	END IF
END IF
NEXT EnemyCounter
Target.Enemy = CurrentNearestEnemy
		      
''Update frame depending on distance
Distance = ABS(Target.Sprite.x - Enemy(Target.Enemy).Sprite.x) + ABS(Target.Sprite.y - Enemy(Target.Enemy).Sprite.y)
IF (Distance < 10) THEN
	Target.AnimationStep = 4
ELSEIF (Distance < 40) THEN
	Target.AnimationStep = 3
ELSEIF (Distance < 80) THEN
	Target.AnimationStep = 2
ELSEIF (Distance < 150) THEN
	Target.AnimationStep = 1
END IF

''Fly towards the target          
IF (Target.Sprite.x < Enemy(Target.Enemy).Sprite.x) THEN Target.Sprite.x = Target.Sprite.x + 2
IF (Target.Sprite.x > Enemy(Target.Enemy).Sprite.x) THEN Target.Sprite.x = Target.Sprite.x - 2
IF (Target.Sprite.y < Enemy(Target.Enemy).Sprite.y) THEN Target.Sprite.y = Target.Sprite.y + 2
IF (Target.Sprite.y > Enemy(Target.Enemy).Sprite.y) THEN Target.Sprite.y = Target.Sprite.y - 2
      
''See if the player's done with the level
IF (EnemiesKilled = Level.EnemiesToKill) THEN Target.Enemy = 0

END SUB
