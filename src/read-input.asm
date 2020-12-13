ReadInput:

	call ReadJoypad
	
	; ld 		a, [_PAD]
	; and		PADF_UP
	; call nz, scrollUp
	
	; ld 		a, [_PAD]
	; and		PADF_DOWN
	; call nz, scrollDown
	
	ld 		a, [_JOYPAD_STATE]
	and		PADF_LEFT
	call 	nz, PaddleLeft
	
	ld 		a, [_JOYPAD_STATE]
	and		PADF_RIGHT
	call 	nz, PaddleRight
	
	; ld 		a, [_JOYPAD_STATE]
	; and		PADF_START
	; call 	nz, Pause
	
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
    cp      8
    jp      nc, .continue                   ; if a >= n
	
    ld      a, 8                            ; set min X
.continue:
	ld	    [_PADDLE_X], a
	ret

PaddleRight:
	ld	    a, [_PADDLE_X]
    ;inc     a
    add     a, 3
    cp      LAST_COLUMN - (PADDLE_WIDTH)
    jp      c, .continue                   ; if a < n

    ld      a, LAST_COLUMN - (PADDLE_WIDTH)
.continue:
	ld	    [_PADDLE_X], a
	ret


; NOT FINISHED
; Pause:
; 	ld	    a, [_IS_PAUSED]
; 	or		a ; same as cp 0
; 	jp		z, .doPause
; .doPause:
; 	ld		a, 1
; 	ld	    [_IS_PAUSED], a
; 	ret



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
