UpdateVram:
    ; ld      a, [_COUNTER]
    ; inc     a
    ; ld      [_COUNTER], a
    ld      hl, _COUNTER
    inc     [hl]


; Window scroll
    ; ld      hl, rWX
    ; dec     [hl]


; Background scroll
    ld      [_COUNTER], a
    and     %11100000
    or      a               ; same as cp 0
    jp      z, .scrollLeft

    ; Scrool up
    ld      hl, rSCY         ; 21 t-states
    inc     [hl]

    jp      .blinkBg

.scrollLeft:
    ld      hl, rSCX         ; 21 t-states
    inc     [hl]

.blinkBg:
    ; change tile 8
    ld      a, [_COUNTER]
    and     %00001111
    or      a               ; same as cp 0
    jp      z, .setTile8Dark

    ;.setTile8Light:
	ld	    hl, Tiles.pointLighter
	ld	    de, _VRAM + (8 * 16)
	ld	    bc, 16
	call	mem_Copy

    ret

.setTile8Dark:
	ld	    hl, Tiles.pointDark
	ld	    de, _VRAM + (8 * 16)
	ld	    bc, 16
	call	mem_Copy

    ret