UpdateVram:
    ; ld      a, [_COUNTER]
    ; inc     a
    ; ld      [_COUNTER], a
    ld      hl, _COUNTER
    inc     [hl]


    call WindowScroll
    call BackgroundScroll

    ret

; TRY TO BLINK POINTS IN BG (NOT WORKING AS EXPECTED)
; .blinkBg:
;     ; change tile 8
;     ld      a, [_COUNTER]
;     and     %00001111
;     or      a               ; same as cp 0
;     jp      z, .setTile8Dark

;     ;.setTile8Light:
; 	ld	    hl, Tiles.pointLighter
; 	ld	    de, _VRAM + (8 * 16)
; 	ld	    bc, 16
; 	call	mem_Copy

;     ret

; .setTile8Dark:
; 	ld	    hl, Tiles.pointDark
; 	ld	    de, _VRAM + (8 * 16)
; 	ld	    bc, 16
; 	call	mem_Copy

;     ret

WindowScroll:
    ld      a, [rWX]
    cp      0
    jp      z, .resetRWX
    dec     a
    jp      .notResetRWX
.resetRWX:
    ld      a, 7
.notResetRWX:
    ld      [rWX], a

    ret



BackgroundScroll:
    ld      a, [_COUNTER]
    and     %11100000
    or      a               ; same as cp 0
    jp      z, .scrollUpLeft

    ; Scrool up
    ld      hl, rSCY         ; 21 t-states
    inc     [hl]

    ;jp      .blinkBg
    ret

.scrollUpLeft:
    ld      hl, rSCX         ; 21 t-states
    inc     [hl]
    ld      hl, rSCY         ; 21 t-states
    dec     [hl]

    ret