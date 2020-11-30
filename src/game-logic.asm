GameLogic:
    ; ld      a, [_BALL_Y]        ; 30 t-states
    ; inc     a
    ; ld      [_BALL_Y], a
    ;           versus
    ; ld      hl, _BALL_Y         ; 21 t-states
    ; inc     [hl]



    ld      a, [_BALL_X]
    ld      b, a
    ld      a, [_BALL_Y]
    ld      c, a
    ld      a, [_PADDLE_X]
    ld      d, a
    ld      e, PADDLE_Y
    call    CollisionCheck_Ball_Paddle
    jp      nc, .continue
    
    ; Collision between ball and paddle
    ld      a, [_BALL_Y]
    cp      PADDLE_Y
    jp      nc, .bounceSideOfPaddle                   ; if a >= n
    jp      .bounceTopOfPaddle

.bounceSideOfPaddle:
    ld      a, [_BALL_DELTA_X]
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b
    ld      [_BALL_DELTA_X], a

    ld      a, PADDLE_Y + BALL_HEIGHT
    ld      [_BALL_Y], a

    jp      .continue

.bounceTopOfPaddle:
    ld      a, -2
    ld      [_BALL_DELTA_Y], a

.continue:
    ; update ball y position
    ld      a, [_BALL_DELTA_Y]
    ld      b, a
    ld      a, [_BALL_Y]
    add     a, b
    ld      [_BALL_Y], a
    cp      FIRST_LINE
    jp      c, .bounceTop           ; if a < n

    cp      144 + 16 + 1
    jp      nc, .ballLost           ; if a >= n



    ld      a, [_BALL_DELTA_X]
    ld      b, a
    ld      a, [_BALL_X]
    add     a, b
    ld      [_BALL_X], a
    cp      FIRST_COLUMN
    jp      c, .bounceLeft           ; if a < 8

    cp      LAST_COLUMN - BALL_WIDTH
    jp      nc, .bounceRight         ; if a >= n

    ret

.bounceTop:
    ld      a, FIRST_LINE
    ld      [_BALL_Y], a

    ld      a, [_BALL_DELTA_Y]
    
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b

    ld      [_BALL_DELTA_Y], a

    ret

.bounceLeft:
    ld      a, 8
    ld      [_BALL_X], a

    ld      a, [_BALL_DELTA_X]
    
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b

    ld      [_BALL_DELTA_X], a

    ret

.bounceRight:
    ld      a, LAST_COLUMN - BALL_WIDTH
    ld      [_BALL_X], a

    ld      a, [_BALL_DELTA_X]
    
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b

    ld      [_BALL_DELTA_X], a

    ret
    
.ballLost:
    ; jp      .ballLost
    jp         begin
    ret



;  Calculates whether a collision occurs between two objects
;  of a fixed size
; IN: 
;    b = x1
;    c = y1
;    d = x2
;    e = y2
; Constants:
;    WIDTH1, HEIGHT1, WIDTH2, HEIGHT2
; OUT: Carry set if collision
; CHANGES: AF
CollisionCheck_Ball_Paddle:

;Constants definition:
WIDTH1      EQU 8
HEIGHT1      EQU 8
WIDTH2      EQU 24
HEIGHT2      EQU 8

        ld      a, d                        ; get x2
        sub     b                           ; calculate x2 - x1
        jr      c,.x1IsLarger               ; jump if x2 < x1
        sub     WIDTH1                      ; compare with size 1
        ret     nc                          ; return if no collision
        jp      .checkVerticalCollision
.x1IsLarger:
        ;neg                                ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ld      b, a
        xor     a                           ; same as ld a, 0
        sub     a, b
    
        sub    WIDTH2                       ; compare with size 2
        ret    nc                           ; return if no collision

.checkVerticalCollision:
        ld      a, e                        ; get y2
        sub     c                           ; calculate y2 - y1
        jr      c,.y1IsLarger               ; jump if y2 < y1
        sub     HEIGHT1                     ; compare with size 1
        ret                                 ; return collision or no collision
.y1IsLarger:
        ;neg                                ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ld      c, a
        xor     a                           ; same as ld a, 0
        sub     a, c
    
        sub    HEIGHT2                      ; compare with size 2
        ret                                 ; return collision or no collision

