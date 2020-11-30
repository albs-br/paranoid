ReadInput:


    ; first, we wait for the VBlank, since we can not change
    ; VRAM out of it, or weird things will
; .wait:
;     ld      a, [rLY]
;     cp      145
;     jr      nz, .wait
	

	call ReadJoypad
	
	; ld 		a, [_PAD]
	; and		PADF_UP
	; call nz, scrollUp
	
	; ld 		a, [_PAD]
	; and		PADF_DOWN
	; call nz, scrollDown
	
	ld 		a, [_PAD]
	and		PADF_LEFT
	call nz, PaddleLeft
	
	ld 		a, [_PAD]
	and		PADF_RIGHT
	call nz, PaddleRight
	
	ret
    
; scrollUp:
; 	ld	a, [rSCY]
; 	inc a
; 	ld	[rSCY], a
; 	ret

; scrollDown:
; 	ld	a, [rSCY]
; 	dec a
; 	ld	[rSCY], a
; 	ret

PaddleLeft:
	ld	    a, [_PADDLE_X]
    ;dec     a
    sub     a, 3
    cp      8                               ; first visible collumn is 8
    jp      nc, .continue                   ; if a >= 8
	
    ld      a, 8                            ; set min X
.continue:
	ld	    [_PADDLE_X], a
	ret

PaddleRight:
	ld	    a, [_PADDLE_X]
    ;inc     a
    add     a, 3
    cp      LAST_COLUMN - (PADDLE_WIDTH)                 ; first visible collumn is 8
    jp      c, .continue                   ; if a < 160 - (3*8) + 8

    ld      a, LAST_COLUMN - (PADDLE_WIDTH)
.continue:
	ld	    [_PADDLE_X], a
	ret


; ; test move scroll
; 	ld	a, 0			
; scrollY:
; 	;ld	[rSCX], a
; 	ld	[rSCY], a
; 	call Delay
; 	inc a
; 	;cp 100
; 	jp nz, scrollY
; scrollX:
; 	ld	[rSCX], a
; 	call Delay
; 	inc a
; 	;cp 100
; 	jp nz, scrollX

; 	jp scrollY
