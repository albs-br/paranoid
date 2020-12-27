_JOYPAD_STATE	        DB
        
_PADDLE_X               DB
        
_BALL_X                 DB
_BALL_Y                 DB
_BALL_DELTA_X           DB
_BALL_DELTA_Y           DB
        
_COUNTER                DB
        
_IS_PAUSED              DB
        


; Items
NUM_ITEMS                  EQU     10
NUM_PROPERTIES_ITEM        EQU     6

_ITEM_TEMP_X               DB
_ITEM_TEMP_Y               DB
_ITEM_TEMP_DELTA_X         DB
_ITEM_TEMP_STATE           DB
_ITEM_TEMP_TYPE            DB
_ITEM_TEMP_SPR_NUMBER      DB


_ITEM_1_X                  DB
_ITEM_1_Y                  DB
_ITEM_1_DELTA_X            DB
_ITEM_1_STATE              DB
_ITEM_1_TYPE               DB
_ITEM_1_SPR_NUMBER         DB

_ITEM_2_X                  DB
_ITEM_2_Y                  DB
_ITEM_2_DELTA_X            DB
_ITEM_2_STATE              DB
_ITEM_2_TYPE               DB
_ITEM_2_SPR_NUMBER         DB

_ITEM_3_X                  DB
_ITEM_3_Y                  DB
_ITEM_3_DELTA_X            DB
_ITEM_3_STATE              DB
_ITEM_3_TYPE               DB
_ITEM_3_SPR_NUMBER         DB

_ITEM_4_X                  DB
_ITEM_4_Y                  DB
_ITEM_4_DELTA_X            DB
_ITEM_4_STATE              DB
_ITEM_4_TYPE               DB
_ITEM_4_SPR_NUMBER         DB

_ITEM_5_X                  DB
_ITEM_5_Y                  DB
_ITEM_5_DELTA_X            DB
_ITEM_5_STATE              DB
_ITEM_5_TYPE               DB
_ITEM_5_SPR_NUMBER         DB

_ITEM_6_X                  DB
_ITEM_6_Y                  DB
_ITEM_6_DELTA_X            DB
_ITEM_6_STATE              DB
_ITEM_6_TYPE               DB
_ITEM_6_SPR_NUMBER         DB

_ITEM_7_X                  DB
_ITEM_7_Y                  DB
_ITEM_7_DELTA_X            DB
_ITEM_7_STATE              DB
_ITEM_7_TYPE               DB
_ITEM_7_SPR_NUMBER         DB

_ITEM_8_X                  DB
_ITEM_8_Y                  DB
_ITEM_8_DELTA_X            DB
_ITEM_8_STATE              DB
_ITEM_8_TYPE               DB
_ITEM_8_SPR_NUMBER         DB

_ITEM_9_X                  DB
_ITEM_9_Y                  DB
_ITEM_9_DELTA_X            DB
_ITEM_9_STATE              DB
_ITEM_9_TYPE               DB
_ITEM_9_SPR_NUMBER         DB

_ITEM_10_X                  DB
_ITEM_10_Y                  DB
_ITEM_10_DELTA_X            DB
_ITEM_10_STATE              DB
_ITEM_10_TYPE               DB
_ITEM_10_SPR_NUMBER         DB

VblankFlag                 DB

_BRICKS_TOP                DS      20           ; Allocates n bytes

