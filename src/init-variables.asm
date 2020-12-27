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

    ld      hl, _ITEM_1_X
    ld      a, 8
    ld      b, 32
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord

    ld      hl, _ITEM_2_X
    ld      a, 24
    ld      b, 48
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord


	ld      a, 1                    ; number of tiles for bricks
	ld      hl, _BRICKS_TOP
	ld      bc, 20
	call    mem_Set                 ; Writes BC times the value in A, starting in HL

    ret


.InitItem:
    ;ld      a, 8
    ld      [hl+], a                            ; _ITEM_n_X
    ld      a, b
    ld      [hl+], a                            ; _ITEM_n_Y

    ld      a, -1
    ld      [hl+], a                            ; _ITEM_n_DELTA_X

    ld      a, FRAMES_ITEM_DEATH_ANIMATION
    ld      [hl+], a                            ; _ITEM_n_STATE

    ld      a, 12
    ld      [hl], a                            ; _ITEM_n_SPR_NUMBER

    ret