InitVariables:
; set initial values for variables
    xor     a ; same as ld a, 0
    ld      [_COUNTER], a
    ld      [_IS_PAUSED], a

    ld      a, SCREEN_WIDTH/2 - (PADDLE_WIDTH/2) + FIRST_COLUMN
    ld      [_PADDLE_X], a

    ld      a, SCREEN_WIDTH/2 - BALL_WIDTH/2 + FIRST_COLUMN  ; horizontal center of screen
    ld      [_BALL_X], a     
    ld      a, SCREEN_WIDTH/2
    ld      [_BALL_Y], a  

    ld      a, 2
    ld      [_BALL_DELTA_X], a  
    ld      a, -2
    ld      [_BALL_DELTA_Y], a  

    ld      a, 8
    ld      [_ITEM_1_X], a
    ld      a, 32
    ld      [_ITEM_1_Y], a

    ld      a, -1
    ld      [_ITEM_1_DELTA_X], a

    ld      a, FRAMES_ITEM_DEATH_ANIMATION
    ld      [_ITEM_1_STATE], a

    ld      a, 12
    ld      [_ITEM_1_SPR_NUMBER], a


	ld      a, 1                    ; number of tiles for bricks
	ld      hl, _BRICKS_TOP
	ld      bc, 20
	call    mem_Set                 ; Writes BC times the value in A, starting in HL

    ret