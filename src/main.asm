; Paranoid (Arkanoid clone) for Gameboy
; v.0.6.0
; Proof of concept for GB homebrew game development

INCLUDE "gbhw.inc" ; standard hardware definitions from devrs.com
;INCLUDE "oam.inc"

INCLUDE "ibmpc1.inc" ; ASCII character set from devrs.com



SECTION "OAMRAM", OAM
INCLUDE "oam.inc"



SECTION "RAM", WRAM0
INCLUDE "src/ram-variables.asm"

; We are going to keep interrupts disabled for this program.
; However, it is good practice to leave the reserved memory locations for interrupts with
; executable code. It make for a nice template as well to fill in code when we use interrupts
; in the future
SECTION	"Vblank",ROM0[$0040]
	reti
SECTION	"LCDC",ROM0[$0048]
	reti
SECTION	"Timer_Overflow",ROM0[$0050]
	reti
SECTION	"Serial",ROM0[$0058]
	reti
SECTION	"p1thru4",ROM0[$0060]
	reti

SECTION	"start",ROM0[$0100]
	nop
	jp	begin



; ****************************************************************************************
; ROM HEADER and ASCII character set
; ****************************************************************************************
; ROM header
	ROM_HEADER	ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE

INCLUDE "src/constants.asm"
INCLUDE "memory.asm"
INCLUDE "common-routines.asm"
INCLUDE "src/read-input.asm"
INCLUDE "src/game-init.asm"
INCLUDE "src/init-variables.asm"
INCLUDE "src/update-vram.asm"
INCLUDE "src/update-sprites.asm"
INCLUDE "src/game-logic.asm"


FontsTile:
	chr_IBMPC1	1,8 ; LOAD ENTIRE CHARACTER SET



begin:
	nop
	di
	ld	sp, $ffff		; set the stack pointer to highest mem location we can use + 1


;init:
	call GameInit


GameLoop:

	call ReadInput
	call GameLogic
	; call SCXEffect

.waitVBlank:
    ld      a, [rLY]
    cp      145					; first line of Vblank (144 (0x90) -> 153 (0x99) is the VBlank period.)
    jr      nz, .waitVBlank

	call UpdateVram
	call UpdateOAMRam

	; testing speed
	; copying n bytes from RAM to VRAM
	; ld	    hl, Tiles
	; ld	    de, _VRAM		; $8000
	; ld	    bc, 72						;72 is the max (ending at line 152)
	; call	mem_Copy

    ; code to check how many lines on Vblank were used
	ld      a, [rLY]
    ld      [_SPR0_X], a

	jp GameLoop



	
; ****************************************************************************************
; hard-coded data
; ****************************************************************************************
Title:
	DB	"Paranoid"
TitleEnd:

INCLUDE "tiles/tiles.asm"



SCXEffect:
	ld a, [rLY]			; current line
	cp 60				; 
	jp nc, .makeScroll	; if a >= 60

;don't make scroll
	xor a				; same as ld a, 0
	ld [rSCX], a
	jp SCXEffect	
	
.makeScroll:
	cp 144
	ret z
	cp 100
	jp nc, SCXEffect	; if a >= 100

	sub a, 58
	ld [rSCX], a
	jp SCXEffect	
