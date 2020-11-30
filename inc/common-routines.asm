; Routine reading pad
ReadJoypad:
    ;  we will read the Cruzeta:
    ld      a, P1F_5            ; bit 4-0, 5-1 bit (on Cruzeta, no buttons)
    ld      [rP1], a
 
    ; now we read the status of the Cruzeta, to avoid bouncing
    ; We do several readings
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
 
    and     $0F             ; only care about the bottom 4 bits.
    swap    a               ; lower and upper exchange. 
    ld      b, a            ; We keep Cruzeta status in b
 
    ; we go for the buttons
    ld      a, P1F_4            ; bit 4 to 1, bit 5 to 0 (enabled buttons, not Cruzeta)
    ld      [rP1], a
 
    ; read several times to avoid bouncing
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
 
    ; we at A, the state of the buttons
    and     $0F             ; only care about the bottom 4 bit
    or      b               ; or make a to b, to "meter" in Part
                            ; A superior, Cruzeta status.
 
    ; we now have at A, the state of all, we complement and
    ; store it in the variable
    cpl
    ld      [_PAD], a
    ; return
    ret



; ****************************************************************************************
; StopLCD:
; turn off LCD if it is on
; and wait until the LCD is off
; ****************************************************************************************
StopLCD:
        ld      a,[rLCDC]
        rlca                    ; Put the high bit of LCDC into the Carry flag
        ret     nc              ; Screen is off already. Exit.

; Loop until we are in VBlank
.wait:
        ld      a,[rLY]
        cp      145             ; Is display on scan line 145 yet?
        jr      nz,.wait        ; no, keep waiting

; Turn off the LCD
        ld      a,[rLCDC]
        res     7,a             ; Reset bit 7 of LCDC
        ld      [rLCDC],a

        ret



ClearVRAM:
	xor a				; same as ld a, 0
	ld hl, _VRAM
	ld bc, 8 * 1024
	call mem_SetVRAM
	ret



ClearOAM:
	ld a,0 ;xor a				; same as ld a, 0
	ld hl, _OAMRAM
	ld bc, 160 ;$a0
	call mem_SetVRAM
	ret



FadeIn:
	ld	a, %11111111
	ld	[rBGP], a
	call Delay
	ld	a, %11111110
	ld	[rBGP], a
	call Delay
	ld	a, %11111001
	ld	[rBGP], a
	call Delay
	ld	a, %11100100
	ld	[rBGP], a
	call Delay
	ret



Delay:
	push de
	ld d, 255
	ld e, 64
.loop:
	dec d
	jp nz, .loop
	dec e
	jp nz, .loop
	pop de
	ret



;  Calculates whether a collision occurs between two objects
;  of a certain size
; IN: 
;    b = coordinate of object 1
;    c = size of object 1
;    d = coordinate of object 2
;    e = size of object 2
; OUT: Carry set if collision
; CHANGES: AF
CollisionCheck_8b:
        ld      a,d            ; get x2                      [5]
        sub     b              ; calculate x2-x1              [5]
        jr      c,.other        ; jump if x2<x1                [13/8]
        sub     c              ; compare with size 1          [5]
        ret                    ; return result                [11]
.other:
        ;neg                    ; use negative value          [10]
        ; emulate neg instruction
        ld      b, a
        xor     a                               ; same as ld a, 0
        sub     a, b
    
        sub     e              ; compare with size 2          [5]
        ret                    ; return result                [11]


