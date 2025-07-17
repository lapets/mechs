'///// Mechs : AI.bas ///////////////////////////////////////////////////////
'///// July 24, 2001 ////////////////////////////////////////////////////////

'///// I N C L U D E S //////////////////////////////////////////////////////
REM $INCLUDE: 'qb.bi'                        ''for assembly routines
REM $INCLUDE: 'modexlib.bi'                  ''for mode X graphics
REM $INCLUDE: 'struct.bi'                    ''the structures
REM $INCLUDE: 'common.bi'                    ''the shared variables
REM $INCLUDE: 'const.bi'                     ''for specific constants

''Make sure memory for arrays is allocated dynamically
REM $DYNAMIC

'///// P R O T O T Y P E S //////////////////////////////////////////////////
DECLARE SUB Shoot.Missile (CannonX AS INTEGER, CannonY AS INTEGER, VelocityX AS INTEGER, VelocityY AS INTEGER, Design AS INTEGER)

DECLARE SUB Script.Chase (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Fighter (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Wiggling (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Wandering (CurrentEnemy AS INTEGER)
DECLARE SUB Script.Cautious (CurrentEnemy AS INTEGER)

''Clear and reinitialize the stack to 25000 (it crashed at 4096)
CLEAR , , 25000

REM $STATIC
SUB Script.Cautious (CurrentEnemy AS INTEGER)

''This is the CAUTIOUS enemy logic script
''This enemy tries to shoot the player but stays away from him

''Figure out on which axis the player is closer, move
''forward on the other axis, and then fire


''Follow the player
IF (ABS(Enemy(CurrentEnemy).Sprite.x - Player.Sprite.x)) > ABS(Enemy(CurrentEnemy).Sprite.y - Player.Sprite.y) THEN
	''X greater, move along Y
	IF (Enemy(CurrentEnemy).Sprite.y < Player.Sprite.y) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y + 1
	IF (Enemy(CurrentEnemy).Sprite.y > Player.Sprite.y) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y - 1
	''Make sure it's facing the player
	IF (Enemy(CurrentEnemy).Sprite.x < Player.Sprite.x) THEN Enemy(CurrentEnemy).Direction = Right
	IF (Enemy(CurrentEnemy).Sprite.x > Player.Sprite.x) THEN Enemy(CurrentEnemy).Direction = Left
ELSEIF (ABS(Enemy(CurrentEnemy).Sprite.x - Player.Sprite.x)) < ABS(Enemy(CurrentEnemy).Sprite.y - Player.Sprite.y) THEN
	''Y Greater, move along X
	IF (Enemy(CurrentEnemy).Sprite.x < Player.Sprite.x) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x + 1
	IF (Enemy(CurrentEnemy).Sprite.x > Player.Sprite.x) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x - 1
	''Make sure it's facing the player
	IF (Enemy(CurrentEnemy).Sprite.y < Player.Sprite.y) THEN Enemy(CurrentEnemy).Direction = Down
	IF (Enemy(CurrentEnemy).Sprite.y > Player.Sprite.y) THEN Enemy(CurrentEnemy).Direction = Up
END IF



''Destroy
IF (EnemyMissileClock = 0) THEN  'Keep it under control
	IF (Enemy(CurrentEnemy).Sprite.x = Player.Sprite.x) THEN
		IF (Enemy(CurrentEnemy).Sprite.y > Player.Sprite.y) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x + 8, Enemy(CurrentEnemy).Sprite.y + 19, 0, -1, Green
		ELSEIF (Enemy(CurrentEnemy).Sprite.y < Player.Sprite.y) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x + 8, Enemy(CurrentEnemy).Sprite.y - 1, 0, 1, Green
		END IF
	END IF

	IF (Enemy(CurrentEnemy).Sprite.y = Player.Sprite.y) THEN
		IF (Enemy(CurrentEnemy).Sprite.x < Player.Sprite.x) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x + 19, Enemy(CurrentEnemy).Sprite.y + 8, 1, 0, Green
		ELSEIF (Enemy(CurrentEnemy).Sprite.x > Player.Sprite.x) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x - 1, Enemy(CurrentEnemy).Sprite.y + 8, -1, 0, Green
		END IF
	END IF
END IF


END SUB

SUB Script.Chase (CurrentEnemy AS INTEGER)

''This is the CHASE enemy logic script

IF (Enemy(CurrentEnemy).Sprite.x < Player.Sprite.x) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x + 1: Enemy(CurrentEnemy).Direction = Right
IF (Enemy(CurrentEnemy).Sprite.x > Player.Sprite.x) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x - 1: Enemy(CurrentEnemy).Direction = Left
IF (Enemy(CurrentEnemy).Sprite.y < Player.Sprite.y) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y + 1: Enemy(CurrentEnemy).Direction = Down
IF (Enemy(CurrentEnemy).Sprite.y > Player.Sprite.y) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y - 1: Enemy(CurrentEnemy).Direction = Up


END SUB

SUB Script.Fighter (CurrentEnemy AS INTEGER)

''This is the FIGHTER enemy logic script
''The enemy must seek and destroy its target (player or whatnot) with missiles

''Seek
IF (Enemy(CurrentEnemy).Sprite.x < Player.Sprite.x) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x + 1
IF (Enemy(CurrentEnemy).Sprite.x > Player.Sprite.x) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x - 1
IF (Enemy(CurrentEnemy).Sprite.y < Player.Sprite.y) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y + 1
IF (Enemy(CurrentEnemy).Sprite.y > Player.Sprite.y) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y - 1

''Destroy
IF (EnemyMissileClock = 0) THEN  'Keep it under control
	IF (Enemy(CurrentEnemy).Sprite.x = Player.Sprite.x) THEN
		IF (Enemy(CurrentEnemy).Sprite.y > Player.Sprite.y) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x + 8, Enemy(CurrentEnemy).Sprite.y + 19, 0, -1, Green
		ELSEIF (Enemy(CurrentEnemy).Sprite.y < Player.Sprite.y) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x + 8, Enemy(CurrentEnemy).Sprite.y - 1, 0, 1, Green
		END IF
	END IF

	IF (Enemy(CurrentEnemy).Sprite.y = Player.Sprite.y) THEN
		IF (Enemy(CurrentEnemy).Sprite.x < Player.Sprite.x) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x + 19, Enemy(CurrentEnemy).Sprite.y + 8, 1, 0, Green
		ELSEIF (Enemy(CurrentEnemy).Sprite.x > Player.Sprite.x) THEN
			Shoot.Missile Enemy(CurrentEnemy).Sprite.x - 1, Enemy(CurrentEnemy).Sprite.y + 8, -1, 0, Green
		END IF
	END IF
END IF

END SUB

SUB Script.Wandering (CurrentEnemy AS INTEGER)

''This is the WANDERING enemy logic script

''Declare local variables
DIM RandomNumber AS INTEGER

''Move the enemy in some direction, wherever its current velocities lead it
Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x + Enemy(CurrentEnemy).VelocityX
Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y + Enemy(CurrentEnemy).VelocityY

''Reverse its direction based on a random number
RandomNumber = 1 + (RND * 50)
IF (RandomNumber = 10) THEN Enemy(CurrentEnemy).VelocityX = Enemy(CurrentEnemy).VelocityX * -1
IF (RandomNumber = 20) THEN Enemy(CurrentEnemy).VelocityY = Enemy(CurrentEnemy).VelocityY * -1
IF (RandomNumber = 30) THEN
	Enemy(CurrentEnemy).VelocityX = Enemy(CurrentEnemy).VelocityX * -1
	Enemy(CurrentEnemy).VelocityY = Enemy(CurrentEnemy).VelocityY * -1
END IF


END SUB

SUB Script.Wiggling (CurrentEnemy AS INTEGER)

''This is the WIGGLING enemy logic script

''Declare local variables
DIM Direction AS INTEGER

''Generate a random direction (a number 1 to 4)
Direction = 1 + INT(RND * 4)

IF (Direction = 1) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x + 1
IF (Direction = 2) THEN Enemy(CurrentEnemy).Sprite.x = Enemy(CurrentEnemy).Sprite.x - 1
IF (Direction = 3) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y + 1
IF (Direction = 4) THEN Enemy(CurrentEnemy).Sprite.y = Enemy(CurrentEnemy).Sprite.y - 1


END SUB

