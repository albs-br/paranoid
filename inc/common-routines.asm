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
    ld      [_JOYPAD_STATE], a
    ; return
    ret



; ****************************************************************************************
; StopLCD:
; turn off LCD if it is on
; and wait until the LCD is off
; ****************************************************************************************
StopLCD:
        ld      a, [rLCDC]
        rlca                    ; Put the high bit of LCDC into the Carry flag
        ret     nc              ; Screen is off already. Exit.

; Loop until we are in VBlank
.wait:
        ld      a, [rLY]
        cp      145             ; Is display on scan line 145 yet?
        jr      nz, .wait        ; no, keep waiting

; Turn off the LCD
        ld      a, [rLCDC]
        res     7, a             ; Reset bit 7 of LCDC
        ld      [rLCDC], a

        ret



ClearRAM:
	xor     a			; same as ld a, 0
	ld      hl, _RAM
	ld      bc, $E000 - $C000
	call    mem_Set                 ; Writes BC times the value in A, starting in HL
	ret


ClearVRAM:
	xor     a			; same as ld a, 0
	ld      hl, _VRAM
	ld      bc, 8 * 1024
	call    mem_SetVRAM             ; Writes BC times the value in A, starting in HL
	ret



ClearOAM:
	xor     a			; same as ld a, 0
	ld      hl, _OAMRAM
	ld      bc, 160 ;$a0
	call    mem_SetVRAM             ; Writes BC times the value in A, starting in HL
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
        jr      c,.other       ; jump if x2<x1                [13/8]
        sub     c              ; compare with size 1          [5]
        ret                    ; return result                [11]
.other:
        ;neg                    ; use negative value          [10]
        ; emulate neg instruction
        ld      b, a
        xor     a              ; same as ld a, 0
        sub     a, b
    
        sub     e              ; compare with size 2          [5]
        ret                    ; return result                [11]






;* Random # - Calculate as you go *
; (Allocate 3 bytes of ram labeled 'Seed')
; Exit: A = 0-255, random number
; http://devrs.com/gb/files/random.txt
; RandomNumber:
;         ld      hl, Seed
;         ld      a, [hl+]
;         sra     a
;         sra     a
;         sra     a
;         xor     [hl]
;         inc     hl
;         rra
;         rl      [hl]
;         dec     hl
;         rl      [hl]
;         dec     hl
;         rl      [hl]
;         ld      a, [$fff4]          ; get divider register to increase randomness
;         add     [hl]
;         ret




; Routine to init sound system
InitSound:
        ; activate sound system
        ld              a, %10000000
        ld              [rNR52], a
        ; start up volumes, etc
        ld              a, %01110111            ; SO1 and S02 at max volume
        ld              [rNR50], a
 
        ld              a, %00000010            ; Channel 2, output by SO1 and S02
        ld              [rNR51], a
 
        ; channel 2, length 63, cycle 50%
        ld              a, %10111111
        ld              [rNR21], a
        ; channel 2, enveloping, max initial volume, decrescent
        ld              a, %11110111
        ld              [rNR22], a
 
        ; channel 2, activated length and high frequency value
        ld              a, %01000110            ; 1 in bit 6, activated length, and
        ld              [rNR24], a              ; we wrote %110 in the e3 high bits of frequency
 
        ret
 
ChangeAndPlayNote:
        ld              a, [_CONT_MUS]          ; check if it's time to play the note or to wait
        cp              a, _INTERVAL
        jr              z, .playNote
        inc             a
        ld              [_CONT_MUS], a
        ret
.playNote:
        ; reset the counter
        ld              a, 0
        ld              [_CONT_MUS], a
 
        ; let's play the note
        ld              a, [_NOTE]              ; get the note number to be played
        ld              c, a                    ; save it
        ld              b, 0
        ld              hl, Notes               ;
        add             hl, bc                  ;
        ld              a, [hl]                 ;
        ld              [rNR23], a              ; write the note to the register of channel 2 frenquency
        ; reset the note
        ld              a, [rNR24]
        set             7,a
        ld              [rNR24], a
 
        ; check for end of notes
        ld              a, c
        inc             a
        cp              a, EndNotes - Notes     ;
        jr              z, .resetNotes
        ; if not save current note number
        ld              [_NOTE], a
        ret
.resetNotes:
        ; if yes, reset, save it and return
        ld              a, 0
        ld              [_NOTE], a
        ret

; Music data
; Vamos a usar la quinta octava, porque sus valores comparten los mismos
; tres bits superiores, %110, asi no tendremos que variarlos.
Notes:
        ; 5ª Octava, Do, Re, Mi, Fa, Sol, La, Si (poniendo $6 en freq hi)
        DB      $0A, $42, $72, $89, $B2, $D6, $F7
EndNotes: