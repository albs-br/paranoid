
UpdateOAMRam:

    ; Paddle
    ld      a, [_PADDLE_X]
    ld      [_SPR0_X], a
    add     a, 8
    ld      [_SPR1_X], a
    add     a, 8
    ld      [_SPR2_X], a

    ; Ball
    ld      a, [_BALL_X]
    ld      [_SPR3_X], a
    ld      a, [_BALL_Y]
    ld      [_SPR3_Y], a

    ; ; Item 1
    ; ld      a, [_ITEM_1_X]
    ; ld      [_SPR4_X], a
    ; ld      a, [_ITEM_1_Y]
    ; ld      [_SPR4_Y], a
    ; ld      a, [_ITEM_1_SPR_NUMBER]
    ; ld      [_SPR4_NUM], a

    ; ; Item 2
    ; ld      a, [_ITEM_2_X]
    ; ld      [_SPR5_X], a
    ; ld      a, [_ITEM_2_Y]
    ; ld      [_SPR5_Y], a
    ; ld      a, [_ITEM_2_SPR_NUMBER]
    ; ld      [_SPR5_NUM], a

    ; ; Item 3
    ; ld      a, [_ITEM_3_X]
    ; ld      [_SPR6_X], a
    ; ld      a, [_ITEM_3_Y]
    ; ld      [_SPR6_Y], a
    ; ld      a, [_ITEM_3_SPR_NUMBER]
    ; ld      [_SPR6_NUM], a

    ; ; Item 4
    ; ld      a, [_ITEM_4_X]
    ; ld      [_SPR7_X], a
    ; ld      a, [_ITEM_4_Y]
    ; ld      [_SPR7_Y], a
    ; ld      a, [_ITEM_4_SPR_NUMBER]
    ; ld      [_SPR7_NUM], a

    ;loop through all items
    ld      b, NUM_ITEMS            ; number of items
    ld      hl, _ITEM_1_X           ; addr of first item
    ld      de, _SPR4_Y             ; addr of first sprite on OAM
.loop:
    ld      a, [hl+]
    inc     e
    ld      [de], a            ; set x

    ld      a, [hl+]
    dec     e
    ld      [de], a            ; set y

    inc     hl
    inc     hl
    inc     hl
    ld      a, [hl]
    inc     e
    inc     e
    ld      [de], a            ; set sprite number

    inc     hl                 ; set HL to next item
    inc     e                  ;
    inc     e                  ; set DE to next sprite attributes on OAM
    dec     b
    jp      nz, .loop

    ret