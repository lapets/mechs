''This include file contains all the structures used in
''the mech game

'///// S T R U C T U R E S //////////////////////////////////////////////////
TYPE SPRITES                             'Define SPRITE as a data type
        Design AS INTEGER
        x AS INTEGER
        y AS INTEGER
        High AS INTEGER
        Wide AS INTEGER
        Segment AS INTEGER
        Pointer AS INTEGER
END TYPE

TYPE AREAS                               'Define MECHS as a data type
        MinX AS INTEGER
        MaxX AS INTEGER
        MinY AS INTEGER
        MaxY AS INTEGER
END TYPE

TYPE MECHS                               'Define MECHS as a data type
        Sprite AS SPRITES
        Area AS AREAS
        Health AS INTEGER
        Direction AS INTEGER
        Strafing AS INTEGER
        TurnDelayCounter AS INTEGER
        ControlStyle AS INTEGER
        Shield AS INTEGER
        WeaponTimeAcquired AS DOUBLE
        WeaponTimer AS INTEGER
        WeaponType AS INTEGER
        CannonX AS INTEGER
        CannonY AS INTEGER
        CannonVelocityX AS INTEGER       'For shooting missiles
        CannonVelocityY AS INTEGER
        Heat AS INTEGER                  'Keep to many missiles form shooting
        State AS INTEGER
        Score AS LONG
END TYPE

TYPE MISSILES                            'Define MISSILES as a data type
        Sprite AS SPRITES
        Design AS INTEGER
        State AS INTEGER
        VelocityX AS INTEGER
        VelocityY AS INTEGER
        Target AS INTEGER                'For red homing missiles
        Health AS INTEGER                'For yellow bouncing missiles
END TYPE

TYPE ENEMIES                             'Define ENEMIES as a data type
        Sprite AS SPRITES
        Area AS AREAS
        Class AS INTEGER
        LogicState AS INTEGER
        State AS INTEGER
        Health AS INTEGER
        VelocityX AS INTEGER
        VelocityY AS INTEGER
        Direction AS INTEGER
        AnimationCounter AS INTEGER
        PlayerCrashed AS INTEGER   'To ensure no powerups are made for crashes
        Damage AS INTEGER
END TYPE

TYPE EXPLOSIONS                          'Define EXPLOSIONS as a data type
        Sprite AS SPRITES
        AnimationStep AS INTEGER
        State AS INTEGER
END TYPE

TYPE TARGETS                             'Define TARGETS as a data type
        Sprite AS SPRITES
        Enemy AS INTEGER
        AnimationStep AS INTEGER
        State AS INTEGER
END TYPE

TYPE POWERUPS                            'Define POWERUPS as a data type
        Sprite AS SPRITES
        Design AS INTEGER
        State AS INTEGER
        VelocityX AS INTEGER
        VelocityY AS INTEGER
        TimeCreated AS DOUBLE
END TYPE

TYPE LEVELS                              'Define ENEMIES as a data type
        PreviousLevel AS STRING * 100    '(a linked list of levels)
        NextLevel AS STRING * 100
        EnemiesToKill AS INTEGER
        IncreaseEnemySpeed AS INTEGER
        IncreaseEnemyMissileSpeed AS INTEGER
        Background AS STRING * 100
        SpriteFile AS STRING * 100
END TYPE

