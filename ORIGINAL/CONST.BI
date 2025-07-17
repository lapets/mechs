''This include file contains all the constants used in
''the mech game

'///// C O N S T A N T S ////////////////////////////////////////////////////
CONST TRUE = 1
CONST FALSE = 0
CONST MARK = 2

CONST NULLCOLOR = 255                  'Color never used

CONST Training = 0                     'Engine states
CONST Playing = 1
CONST DisplayingMenu = 2

CONST KeyUp = 72
CONST KeyDown = 80
CONST KeyLeft = 75
CONST KeyRight = 77
CONST KeyEnter = 0
CONST KeyEscape = 1
CONST KeySpace = 57

CONST ShipOriented = 2
CONST ScreenOriented = 3

CONST Up = 1
CONST Down = 5
CONST Left = 7
CONST Right = 3
CONST UpRight = 2
CONST DownRight = 4
CONST UpLeft = 8
CONST DownLeft = 6

CONST Horizontal = 1                     'Explosion types
CONST Vertical = 2

CONST Flying = 111                       'States for objects
CONST Inactive = 222
CONST Alive = 333
CONST Exploding = 5
CONST Exploding1 = 11
CONST Exploding2 = 22
CONST Exploding3 = 33
CONST Exploding4 = 44
CONST Dying = 66
CONST Dead = 555                         'For powerups to disappear

CONST Chasing = 1                        'Logic States of enemies
CONST Stationary = 2
CONST Wiggling = 3
CONST Running = 4
CONST Cannon = 5
CONST Turret = 6
CONST Fighter = 7
CONST Wandering = 8
CONST Cautious = 9
CONST Arbitrary = 10

CONST SingleFrame = 1                    'Enemy (sprite) classes
CONST SingleFrameObject = 2
CONST Animated = 3
CONST AnimatedObject = 4
CONST Directional = 5
CONST Boss = 6

CONST NormalWeapon = 0
CONST PowerUpTypeSuper = 1                          'Powerup designs
CONST PowerUpTypeSpread = 2
CONST PowerUpTypeDouble = 3
CONST PowerUpTypeDoubleRed = 4
CONST PowerUpTypeRed = 5
CONST PowerUpTypeScore = 6
CONST PowerUpTypeHealth = 7
CONST PowerUpTypeShield = 8

CONST Blue = 1                           'Missile types
CONST Red = 2
CONST Green = 3
CONST Yellow = 4

CONST MAXMISSILES = 200                  'Maximum number of missiles
CONST MAXENEMIES = 25                    'Maximum number of enemies
CONST MAXPOWERUPS = MAXENEMIES           'Maximum number of powerups
CONST MAXEXPLOSIONS = MAXENEMIES * 4

