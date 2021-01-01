; Paranoid (Arkanoid clone) for Gameboy
; v.0.18.0
; Proof of concept for GB homebrew game development
; Author: André Baptista (www.andrebaptista.com.br)
; Nov/2020 - Jan/2021

INCLUDE "gbhw.inc" ; standard hardware definitions from devrs.com

INCLUDE "ibmpc1.inc" ; ASCII character set from devrs.com



SECTION "OAMRAM", OAM
INCLUDE "oam.inc"



SECTION "RAM", WRAM0
INCLUDE "src/ram-variables.asm"

; We are going to keep interrupts disabled for this program.
; However, it is good practice to leave the reserved memory locations for interrupts with
; executable code. It make for a nice template as well to fill in code when we use interrupts
; in the future
SECTION	"Vblank", ROM0[$0040]
	jp	VblankInt
SECTION	"LCDC", ROM0[$0048]
	jp	LCDCInt
SECTION	"Timer_Overflow", ROM0[$0050]
	reti
SECTION	"Serial", ROM0[$0058]
	reti
SECTION	"p1thru4", ROM0[$0060]
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


; GameLoop:

; 	call ReadInput
; 	call GameLogic
; 	; call SCXEffect

; .waitVBlank:
;     ld      a, [rLY]
;     cp      145					; first line of Vblank (144 (0x90) -> 153 (0x99) is the VBlank period.)
;     jr      nz, .waitVBlank

; 	call UpdateVram
; 	call UpdateOAMRam

; 	; testing speed
; 	; copying n bytes from RAM to VRAM
; 	; ld	    hl, Tiles
; 	; ld	    de, _VRAM		; $8000
; 	; ld	    bc, 72						;72 is the max (ending at line 152)
; 	; call	mem_Copy

;     ; code to check how many lines on Vblank were used
; 	ld      a, [rLY]
;     ld      [_SPR0_X], a

; 	jp GameLoop


GameLoop:
	halt 							; stop system clock
									; return from halt when
									; interrupted
	nop 							; (See WARNING on http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf, page 20)

	ld 		a, [VblankFlag]
	or 		a 						; V-Blank interrupt ?
	jr 		z, GameLoop 			; No, some other interrupt
	xor 	a
	ld 		[VblankFlag], a 			; Clear V-Blank flag
	
	call 	ReadInput
	call 	GameLogic
	
 	call 	UpdateVram

	call 	ChangeAndPlayNote

 	; testing speed
	; copying n bytes from RAM to VRAM
	; ld	    hl, Tiles
	; ld	    de, _VRAM		; $8000
	; ld	    bc, 2048						;1024 bytes: no noticeable slowdown; 2048: very slow
	; call	mem_Copy

	jp 		GameLoop

	
; ****************************************************************************************
; hard-coded data
; ****************************************************************************************
Title:
	DB	"Paranoid"
TitleEnd:

INCLUDE "tiles/tiles.asm"



; SCXEffect:
; 	ld a, [rLY]			; current line
; 	cp 60				; 
; 	jp nc, .makeScroll	; if a >= 60

; ;don't make scroll
; 	xor a				; same as ld a, 0
; 	ld [rSCX], a
; 	jp SCXEffect	
	
; .makeScroll:
; 	cp 144
; 	ret z
; 	cp 100
; 	jp nc, SCXEffect	; if a >= 100

; 	sub a, 58
; 	ld [rSCX], a
; 	jp SCXEffect	



VblankInt:
	push 	af
	push 	bc
	push 	de
	push 	hl
	
	; call SpriteDma ; Do sprite updates
	call	UpdateOAMRam
	
	ld 		a, 1
	ld 		[VblankFlag], a
	
    ; ; code to check how many lines on Vblank were used
	; ld      a, [rLY]
    ; ld      [_SPR0_X], a

	pop 	hl
	pop 	de
	pop 	bc
	pop 	af

	reti



LCDCInt:
	push 	af
	push 	bc
	push 	de
	push 	hl

    ; Read STAT (LCD Status Register)
    ; Bit 6 - LYC=LY Coincidence Interrupt (1=Enable) (Read/Write)
    ; Bit 5 - Mode 2 OAM Interrupt         (1=Enable) (Read/Write)
    ; Bit 4 - Mode 1 V-Blank Interrupt     (1=Enable) (Read/Write)
    ; Bit 3 - Mode 0 H-Blank Interrupt     (1=Enable) (Read/Write)
    ; Bit 2 - Coincidence Flag  (0:LYC<>LY, 1:LYC=LY) (Read Only)
    ; Bit 1-0 - Mode Flag       (Mode 0-3, see below) (Read Only)    

    ; Check LYC=LY
	ld      a, [rSTAT]
	and		STATF_LYCF
	jp		nz, .LYCequalLY
	jp		.reti

.LYCequalLY:

	ld      a, [rLY]

	cp      136
	jp		z, .startOfBottomWindow
	cp      8
    jp      z, .endOfTopWindow

.endOfTopWindow:
	; Disable window
    ld      a, [rLCDC]				; load current value
    res		5, a					; disable window
    ld      [rLCDC], a				; save

    ld      a, 136                  ; line to trigger the next interrupt
    ld      [rLYC], a
	jp		.reti

.startOfBottomWindow:
	; test doubling sprites
    ld		a, 136+16
	ld      [_SPR4_Y], a




	; Enable window
    ld      a, [rLCDC]				; load current value
    set		5, a					; enable window
    ld      [rLCDC], a				; save

    ld      a, 8                    ; line to trigger the next interrupt
    ld      [rLYC], a

.reti:
	pop 	hl
	pop 	de
	pop 	bc
	pop 	af

	reti