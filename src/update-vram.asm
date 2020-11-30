UpdateVram:
    ld      a, [_COUNTER]
    inc     a
    ld      [_COUNTER], a
    and     %11100000

    ; Background scroll
    cp 0
    jp      z, .scrollLeft

    ld      hl, rSCY         ; 21 t-states
    inc     [hl]

    ret

.scrollLeft:
    ld      hl, rSCX         ; 21 t-states
    inc     [hl]

    ret