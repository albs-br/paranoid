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
    ld      a, 80
    ld      b, 62
    ld      c, TILE_PACMAN_GHOST
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_2_X
    ld      a, 16
    ld      b, 72
    ld      c, TILE_HEART
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_3_X
    ld      a, 16
    ld      b, 52
    ld      c, TILE_DIAMOND
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_4_X
    ld      a, 32
    ld      b, 52
    ld      c, TILE_MUSHROOM
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_5_X
    ld      a, 16
    ld      b, 32
    ld      c, TILE_PACMAN_GHOST
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_6_X
    ld      a, 32
    ld      b, 32
    ld      c, TILE_PACMAN_GHOST
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_7_X
    ld      a, 48
    ld      b, 32
    ld      c, TILE_PACMAN_GHOST
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_8_X
    ld      a, 64
    ld      b, 32
    ld      c, TILE_PACMAN_GHOST
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_9_X
    ld      a, 80
    ld      b, 32
    ld      c, TILE_PACMAN_GHOST
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_10_X
    ld      a, 96
    ld      b, 32
    ld      c, TILE_PACMAN_GHOST
    ld      d, +1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_11_X
    ld      a, 96
    ld      b, 42
    ld      c, TILE_HEART
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_12_X
    ld      a, 104
    ld      b, 42
    ld      c, TILE_HEART
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_13_X
    ld      a, 112
    ld      b, 42
    ld      c, TILE_HEART
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

    ld      hl, _ITEM_14_X
    ld      a, 120
    ld      b, 42
    ld      c, TILE_HEART
    ld      d, -1
    call    .InitItem               ; HL: item addr, A: x coord, B: y coord, C: type, D: delta X

	ld      a, 1                    ; number of tiles for bricks
	ld      hl, _BRICKS_TOP
	ld      bc, 20
	call    mem_Set                 ; Writes BC times the value in A, starting in HL

    ret


.InitItem:
    ld      [hl+], a                            ; _ITEM_n_X
    ld      a, b
    ld      [hl+], a                            ; _ITEM_n_Y

    ld      a, d
    ld      [hl+], a                            ; _ITEM_n_DELTA_X

    ld      a, FRAMES_ITEM_DEATH_ANIMATION
    ld      [hl+], a                            ; _ITEM_n_STATE

    ld      a, c
    ld      [hl+], a                            ; _ITEM_n_TYPE

    ld      [hl], a                            ; _ITEM_n_SPR_NUMBER

    ret