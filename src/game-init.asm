GameInit:

    ; Disable interrupts
    ld      a, 0
    ld      [rIE], a

	ld	    a, %11100100 	; Window palette colors, from darkest to lightest
	ld	    [rBGP], a		; CLEAR THE SCREEN

	ld	    [rOBP0], a      ; and sprite palette 0


	ld	    a, 0			; SET SCREEN TO UPPER RIGHT HAND CORNER
	ld	    [rSCX], a
	ld	    [rSCY], a


    ; Set STAT (LCD Status Register)
    ; Bit 6 - LYC=LY Coincidence Interrupt (1=Enable) (Read/Write)
    ; Bit 5 - Mode 2 OAM Interrupt         (1=Enable) (Read/Write)
    ; Bit 4 - Mode 1 V-Blank Interrupt     (1=Enable) (Read/Write)
    ; Bit 3 - Mode 0 H-Blank Interrupt     (1=Enable) (Read/Write)
    ; Bit 2 - Coincidence Flag  (0:LYC<>LY, 1:LYC=LY) (Read Only)
    ; Bit 1-0 - Mode Flag       (Mode 0-3, see below) (Read Only)    
    ld      a, STATF_LYC | STATF_MODE01
    ld      [rSTAT], a

    ; Set LYC register
    ld      a, 40                   ; line to trigger the first interrupt
    ld      [rLYC], a
    


	call	StopLCD		; YOU CAN NOT LOAD $8000 WITH LCD ON
	
	call    ClearRAM
	call    ClearVRAM
	call    ClearOAM


; Load font tiles
	ld	    hl, FontsTile
	ld	    de, _VRAM		; $8000
	ld	    bc, 8*256 		; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	mem_CopyMono	; load tile data
	
; Load tiles
	ld	    hl, Tiles
	ld	    de, _VRAM		; $8000
	ld	    bc, EndTiles - Tiles
	call	mem_CopyVRAM
	
	
; Set sprites
    ; Paddle
    ld      a, PADDLE_Y                              ; first visible line is 16
    ld      [_SPR0_Y], a     
    ld      [_SPR1_Y], a     
    ld      [_SPR2_Y], a     
    
    ld      a, 5
    ld      [_SPR0_NUM], a
    inc     a
    ld      [_SPR1_NUM], a
    inc     a
    ld      [_SPR2_NUM], a

    ; Bit7   OBJ-to-BG Priority (0=OBJ Above BG, 1=OBJ Behind BG color 1-3)
    ;         (Used for both BG and Window. BG color 0 is always behind OBJ)
    ; Bit6   Y flip          (0=Normal, 1=Vertically mirrored)
    ; Bit5   X flip          (0=Normal, 1=Horizontally mirrored)
    ; Bit4   Palette number  **Non CGB Mode Only** (0=OBP0, 1=OBP1)
    ; Bit3   Tile VRAM-Bank  **CGB Mode Only**     (0=Bank 0, 1=Bank 1)
    ; Bit2-0 Palette number  **CGB Mode Only**     (OBP0-7)
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

    ; ;item 1
    ; ;ld      a, %00000000
    ; ld      [_SPR4_ATT], a

    ; ;item 2
    ; ld      [_SPR5_ATT], a

    ; ;item 3
    ; ld      [_SPR6_ATT], a

    ; ;item 4
    ; ld      [_SPR7_ATT], a

    ;loop through all items
    ld      b, NUM_ITEMS            ; number of items
    ld      hl, _SPR4_ATT           ; addr of first item
    ld      de, 4                   ; size of attr table per sprite
.loop:
    ld      [hl], a                 ; set attribute for sprite
    add     hl, de
    dec     b
    jp      nz, .loop
    

; set window position
    ld      a, 7
    ld      [rWX], a
    ld      a, 0
    ld      [rWY], a

; configure and activate the display
    ; Bit	Name	                            Usage notes
    ; 7	    LCD Display Enable	                0=Off, 1=On
    ; 6	    Window Tile Map Display Select	    0=9800-9BFF, 1=9C00-9FFF
    ; 5	    Window Display Enable	            0=Off, 1=On
    ; 4	    BG & Window Tile Data Select	    0=8800-97FF, 1=8000-8FFF
    ; 3	    BG Tile Map Display Select	        0=9800-9BFF, 1=9C00-9FFF
    ; 2	    OBJ (Sprite) Size	                0=Off, 1=On
    ; 1	    OBJ (Sprite) Display Enable	        0=Off, 1=On
    ; 0	    BG/Window Display/Priority	        0=Off, 1=On
    ld      a, LCDCF_ON|LCDCF_WIN9C00|LCDCF_WINON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_OBJ8|LCDCF_OBJON|LCDCF_BGON
    ld      [rLCDC], a



; Fill all background with blank tiles
	; ld	    a, 32		                ; ASCII FOR BLANK SPACE
	; ld	    hl, _SCRN0
	; ld	    bc, SCRN_VX_B * SCRN_VY_B
	; call	mem_SetVRAM

; Fill all background with a sequence of 3 tiles (8, 9 and 10)
	ld      hl, _SCRN0
    ld      a, 8
    ld	    bc, SCRN_VX_B * SCRN_VY_B
.loop1:	
    ld	    [hl+], a                    ; since screen is off, we can write to VRAM without constraints
    inc     a
    cp      11
    jp      nz, .notSetTile8

    ld      a, 8
.notSetTile8:
    ld      d, a
    dec     bc
    ld      a, b
    or      c                           ; check if bc == 0
    ld      a, d
    jp      nz, .loop1
	
; Print some strings on the screen
	ld	    hl, Title
	ld	    de, _SCRN0 + (SCRN_VY_B * 0)
	ld	    bc, TitleEnd-Title
	call	mem_CopyVRAM
	
	ld	    hl, Title
	ld	    de, _SCRN0 + (SCRN_VY_B * 16) + 16
	ld	    bc, TitleEnd-Title
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

; Fill all window with tiles
	ld	    a, 1
	ld	    hl, _SCRN1
	ld	    bc, SCRN_VX_B * SCRN_VY_B
	call    mem_SetVRAM                ; Writes BC times the value in A, starting in HL

; Write text on bottom window (not working)
	; ld	    hl, Title
	; ld	    de, _SCRN1 + (SCRN_VX_B * (SCRN_Y_B - 1))
	; ld	    bc, TitleEnd - Title
	; call	mem_CopyVRAM


    call    InitVariables


    call    InitSound           ;
    


    ; Setup sound variables

    ; current note
    xor     a ; same as ld a, 0
    ld      [_NOTE], a

    ; counter for interval between notes
    ld      [_CONT_MUS], a



	call    FadeIn



    ; Enable Vblank and LCDC interrupts
    ld      a, IEF_VBLANK | IEF_LCDC
    ld      [rIE], a

    ret