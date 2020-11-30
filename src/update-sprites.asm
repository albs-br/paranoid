
UpdateSprites:

    ld      a, [_PADDLE_X]
    ld      [_SPR0_X], a
    add     a, 8
    ld      [_SPR1_X], a
    add     a, 8
    ld      [_SPR2_X], a

    ld      a, [_BALL_X]
    ld      [_SPR3_X], a
    ld      a, [_BALL_Y]
    ld      [_SPR3_Y], a

    ret