GameLogic:
    ; ld      a, [_BALL_Y]        ; 30 t-states
    ; inc     a
    ; ld      [_BALL_Y], a
    ;           versus
    ; ld      hl, _BALL_Y         ; 21 t-states
    ; inc     [hl]

    ; Increment counter
    ld      hl, _COUNTER
    inc     [hl]


    ; ld      hl, _ITEM_1_X
    ; call    UpdateItemPosition
    ; ; call    CheckCollision_Ball_Item

    ; ld      hl, _ITEM_2_X
    ; call    UpdateItemPosition

    ; ld      hl, _ITEM_3_X
    ; call    UpdateItemPosition

    ; ld      hl, _ITEM_4_X
    ; call    UpdateItemPosition

    ;loop through all items
    ld      b, NUM_ITEMS            ; number of items
    ld      hl, _ITEM_1_X           ; addr of first item
.loop:
    push    bc
    push    hl
    call    UpdateItemPosition
    ld      de, NUM_PROPERTIES_ITEM
    pop     hl
    add     hl, de
    pop     bc
    dec     b
    jp      nz, .loop



    call    UpdateBallPosition
    call    CheckCollision_Ball_Paddle

    ret


; input: HL: addr of first property
UpdateItemPosition:
    push    hl                              ; save HL to use on collision check

    ; Copy properties from HL to temp variables
    push    hl
    ld      de, _ITEM_TEMP_X
    ld      bc, NUM_PROPERTIES_ITEM
    call    mem_Copy                        ; copy BC bytes from HL to DE



    ld      a, [_ITEM_TEMP_STATE]
    or      a   ; same as cp 0
    jp      z, .return
    cp      FRAMES_ITEM_DEATH_ANIMATION
    jp      z, .isAlive

    ; check for animation end
    dec     a
    ld      [_ITEM_TEMP_STATE], a
    or      a   ; same as cp 0
    jp      z, .hideItem

    ; animation for death
    ld      a, [_COUNTER]
    and     %00000001
    jp      z, .itemSprNumber255
    ld      a, [_ITEM_TEMP_TYPE]
    ld      [_ITEM_TEMP_SPR_NUMBER], a
    jp      .return
.itemSprNumber255:
    ld      a, 255
    ld      [_ITEM_TEMP_SPR_NUMBER], a
    jp      .return

.hideItem:
    ld      a, LAST_COLUMN
    ld      [_ITEM_TEMP_X], a
    ld      a, LAST_LINE
    ld      [_ITEM_TEMP_Y], a
    ld      a, 255
    ld      [_ITEM_TEMP_SPR_NUMBER], a
    jp      .return

.isAlive:
    ; update item x position
    ld      a, [_ITEM_TEMP_DELTA_X]
    ld      b, a
    ld      a, [_ITEM_TEMP_X]
    add     a, b
    ld      [_ITEM_TEMP_X], a
    cp      FIRST_COLUMN
    jp      c, .bounceLeft                  ; if a < 8

    cp      LAST_COLUMN - ITEM_WIDTH
    jp      nc, .bounceRight                ; if a >= n

    jp      .return

.bounceLeft:
    ld      a, 8
    ld      [_ITEM_TEMP_X], a

    ld      a, [_ITEM_TEMP_DELTA_X]
    
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b

    ld      [_ITEM_TEMP_DELTA_X], a

    jp      .return

.bounceRight:
    ld      a, LAST_COLUMN - ITEM_WIDTH
    ld      [_ITEM_TEMP_X], a

    ld      a, [_ITEM_TEMP_DELTA_X]
    
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b

    ld      [_ITEM_TEMP_DELTA_X], a

    jp      .return

.return:
    ; Copy properties back from temp variables to HL
    ld      hl, _ITEM_TEMP_X
    pop     de                              ; item addr
    ld      bc, NUM_PROPERTIES_ITEM
    call    mem_Copy                        ; copy BC bytes from HL to DE

    pop     hl
    call    CheckCollision_Ball_Item

    ret


    
UpdateBallPosition:
    ; update ball y position
    ld      a, [_BALL_DELTA_Y]
    ld      b, a
    ld      a, [_BALL_Y]
    add     a, b
    ld      [_BALL_Y], a

    cp      FIRST_LINE + 8  ;bottom of bricks
    jp      c, .checkBrickHit       ; if a < n

    ; cp      FIRST_LINE
    ; jp      c, .bounceTop           ; if a < n

    cp      144 + 16 + 1
    jp      nc, .ballLost           ; if a >= n


    ; update ball x position
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

.checkBrickHit:
    ; divide x by 8 to get the char position of the ball
    ld      a, [_BALL_X]
    sub     BALL_WIDTH / 2
    srl     a
    srl     a
    srl     a

    ; change brick at the place
	ld	    hl, _BRICKS_TOP
    ld      bc, 0
    ld      c, a
    add     hl, bc          ; add hl, a
	ld	    a, 0            ; tile number
    ld      [hl], a

.bounceTop:
    ld      a, FIRST_LINE + 8   ;bottom of bricks
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



CheckCollision_Ball_Paddle:
    ld      a, [_BALL_X]
    ld      b, a
    ld      a, [_BALL_Y]
    ld      c, a
    ld      a, [_PADDLE_X]
    ld      d, a
    ld      e, PADDLE_Y
    call    CheckCollision_8x8_8x24
    ret      nc
    
    ; Collision between ball and paddle
    ld      a, [_BALL_Y]
    cp      PADDLE_Y
    jp      nc, .bounceSideOfPaddle                   ; if a >= n
    ;jp      .bounceTopOfPaddle

.bounceTopOfPaddle:
    ld      a, -BALL_SPEED
    ld      [_BALL_DELTA_Y], a

    ret

.bounceSideOfPaddle:
    ld      a, [_BALL_DELTA_X]
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b
    ld      [_BALL_DELTA_X], a

    ld      a, PADDLE_Y + BALL_HEIGHT
    ld      [_BALL_Y], a

    ret





CheckCollision_Ball_Item:

    ; Copy properties from HL to temp variables
    push    hl
    ld      de, _ITEM_TEMP_X
    ld      bc, NUM_PROPERTIES_ITEM
    call    mem_Copy                        ; copy BC bytes from HL to DE

    ; check if the item is already dead or in death animation
    ld      a, [_ITEM_TEMP_STATE]
    cp      FRAMES_ITEM_DEATH_ANIMATION
    jp      z, .continue
    jp      .return

.continue:
    ld      a, [_BALL_X]
    ld      b, a
    ld      a, [_BALL_Y]
    ld      c, a
    ld      a, [_ITEM_TEMP_X]
    ld      d, a
    ld      a, [_ITEM_TEMP_Y]
    ld      e, a
    call    CheckCollision_8x8_8x8
    jp      nc, .return
    
    ; Collision between ball and item
    ld      a, [_ITEM_TEMP_Y]
    add     ITEM_HEIGHT/2
    ld      b, a
    ld      a, [_BALL_Y]
    cp      b
    jp      nc, .bounceBottomOfItem                   ; if _BALL_Y >= _ITEM_TEMP_Y + 4
    ;jp      .bounceTopOfItem                         ; if a < n

.bounceTopOfItem:
    ld      a, -BALL_SPEED
    ld      [_BALL_DELTA_Y], a

    ; ld      a, [_ITEM_1_Y]
    ; ld      [_BALL_Y], a

    call    ItemWasHit

    jp      .return

.bounceBottomOfItem:
    ;jp .bounceBottomOfItem
    ld      a, [_BALL_DELTA_Y]
    ; emulate neg instruction
    ld      b, a
    xor     a                               ; same as ld a, 0
    sub     a, b
    ld      [_BALL_DELTA_Y], a

    ;ld      a, PADDLE_Y + BALL_HEIGHT
    ld      a, [_ITEM_TEMP_Y]
    add     ITEM_HEIGHT
    ld      [_BALL_Y], a

    call    ItemWasHit

.return:
    ; Copy properties back from temp variables to HL
    ld      hl, _ITEM_TEMP_X
    pop     de                              ; item addr
    ld      bc, NUM_PROPERTIES_ITEM
    call    mem_Copy                        ; copy BC bytes from HL to DE

    ret



ItemWasHit:
    ld      a, FRAMES_ITEM_DEATH_ANIMATION - 1
    ld      [_ITEM_TEMP_STATE], a
    ret

WIDTH1      EQU 8
HEIGHT1     EQU 8

;WIDTH 2:
WIDTH24     EQU 24
WIDTH8      EQU 8

HEIGHT2     EQU 8

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
CheckCollision_8x8_8x24:

;Constants definition:

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
    
        sub    WIDTH24                      ; compare with size 2
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
CheckCollision_8x8_8x8:

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
    
        sub     WIDTH8                      ; compare with size 2
        ret     nc                          ; return if no collision

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
    
        sub     HEIGHT2                     ; compare with size 2
        ret                                 ; return collision or no collision

