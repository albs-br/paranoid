GameInit:

	ld	    a, %11100100 	; Window palette colors, from darkest to lightest
	ld	    [rBGP], a		; CLEAR THE SCREEN

	ld	    [rOBP0], a      ; and sprite palette 0


	ld	    a,0			; SET SCREEN TO UPPER RIGHT HAND CORNER
	ld	    [rSCX], a
	ld	    [rSCY], a



	call	StopLCD		; YOU CAN NOT LOAD $8000 WITH LCD ON
	
	call    ClearVRAM
	call    ClearOAM


; Load font tiles
	ld	hl, FontsTile
	ld	de, _VRAM		; $8000
	ld	bc, 8*256 		; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	mem_CopyMono	; load tile data
	
; Load tiles
	ld	hl, Tiles
	ld	de, _VRAM		; $8000
	ld	bc, EndTiles - Tiles
	call	mem_CopyVRAM
	
; Set sprites
    ; Paddle
    ld      a, 144                              ; first visible line is 16
    ld      [_SPR0_Y], a     
    ld      [_SPR1_Y], a     
    ld      [_SPR2_Y], a     
    
    ld      a, 5
    ld      [_SPR0_NUM], a
    inc     a
    ld      [_SPR1_NUM], a
    inc     a
    ld      [_SPR2_NUM], a

    ;ld      a, OAMF_PRI|OAMF_YFLIP|OAMF_XFLIP|OAMF_PAL0
    ;ld      a, OAMF_YFLIP|OAMF_PAL1
    ld      a, %00000000
    ld      [_SPR0_ATT], a
    ld      [_SPR1_ATT], a
    ld      [_SPR2_ATT], a
 
    ;ball
    ld      a, 3
    ld      [_SPR3_NUM], a

    ld      a, %00000000
    ld      [_SPR3_ATT], a

    ; configure and activate the display
    ld      a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON
    ld      [rLCDC], a



; set initial values for variables
    ld      a, SCREEN_WIDTH/2 - (PADDLE_WIDTH/2) + FIRST_COLUMN
    ld      [_PADDLE_X], a

    ld      a, SCREEN_WIDTH/2 - BALL_WIDTH/2 + FIRST_COLUMN  ; horizontal center of screen
    ld      [_BALL_X], a     
    ld      a, SCREEN_WIDTH/2
    ld      [_BALL_Y], a  

    ld      a, -2
    ld      [_BALL_DELTA_X], a  
    ld      a, -2
    ld      [_BALL_DELTA_Y], a  



; Fill all background with blank tiles
	ld	    a, 8; 32		; ASCII FOR BLANK SPACE
	ld	    hl, _SCRN0
	ld	    bc, SCRN_VX_B * SCRN_VY_B
	call	mem_SetVRAM

	
; Print some strings in the screen
	ld	hl, Title
	ld	de, _SCRN0 + (SCRN_VY_B * 0)
	ld	bc, TitleEnd-Title
	call	mem_CopyVRAM
	
	ld	hl, Title
	ld	de, _SCRN0 + (SCRN_VY_B * 16) + 16
	ld	bc, TitleEnd-Title
	call	mem_CopyVRAM

; test - show all 256 chars
; 	ld	a, 0
; 	ld	hl, _SCRN0 + (SCRN_VY_B * 1) 
; .loop:
; 	ld	bc, 1
; 	push af
; 	call	mem_SetVRAM
; 	pop af
; 	; inc hl
; 	inc a
; 	;cp 0
; 	jp nz, .loop


	call FadeIn

    call UpdateSprites

    ret