_JOYPAD_STATE	        DB
        
_PADDLE_X               DB
        
_BALL_X                 DB
_BALL_Y                 DB
_BALL_DELTA_X           DB
_BALL_DELTA_Y           DB
        
_COUNTER                DB
        
_IS_PAUSED              DB
        


; Items
NUM_ITEMS                  EQU     14
NUM_PROPERTIES_ITEM        EQU     6

_ITEM_TEMP_X               DB
_ITEM_TEMP_Y               DB
_ITEM_TEMP_DELTA_X         DB
_ITEM_TEMP_STATE           DB
_ITEM_TEMP_TYPE            DB
_ITEM_TEMP_SPR_NUMBER      DB


_ITEM_1_X                  DS       NUM_PROPERTIES_ITEM
; _ITEM_1_X                  DB
; _ITEM_1_Y                  DB
; _ITEM_1_DELTA_X            DB
; _ITEM_1_STATE              DB
; _ITEM_1_TYPE               DB
; _ITEM_1_SPR_NUMBER         DB

_ITEM_2_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_3_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_4_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_5_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_6_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_7_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_8_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_9_X                  DS       NUM_PROPERTIES_ITEM
_ITEM_10_X                 DS       NUM_PROPERTIES_ITEM
_ITEM_11_X                 DS       NUM_PROPERTIES_ITEM
_ITEM_12_X                 DS       NUM_PROPERTIES_ITEM
_ITEM_13_X                 DS       NUM_PROPERTIES_ITEM
_ITEM_14_X                 DS       NUM_PROPERTIES_ITEM


VblankFlag                 DB

_BRICKS_TOP                DS      20           ; Allocates n bytes




; Sound related vars and constants
; code adapted from http://wiki.ladecadence.net/doku.php?id=tutorial_de_ensamblador#hola_sonido

; interval between notes constant
_INTERVAL          EQU             40
; stores current note number
_NOTE           DB
; counter for interval between notes
_CONT_MUS       DB
