_JOYPAD_STATE	        DB
        
_PADDLE_X               DB
        
_BALL_X                 DB
_BALL_Y                 DB
_BALL_DELTA_X           DB
_BALL_DELTA_Y           DB
        
_COUNTER                DB
        
_IS_PAUSED              DB
        

NUM_PROPERTIES_ITEM        EQU     5
_ITEM_TEMP_X               DB
_ITEM_TEMP_Y               DB
_ITEM_TEMP_DELTA_X         DB
_ITEM_TEMP_STATE           DB
_ITEM_TEMP_SPR_NUMBER      DB


_ITEM_1_X                  DB
_ITEM_1_Y                  DB
_ITEM_1_DELTA_X            DB
_ITEM_1_STATE              DB
_ITEM_1_SPR_NUMBER         DB

_ITEM_2_X                  DB
_ITEM_2_Y                  DB
_ITEM_2_DELTA_X            DB
_ITEM_2_STATE              DB
_ITEM_2_SPR_NUMBER         DB

VblankFlag                 DB

_BRICKS_TOP                DS      20           ; Allocates n bytes

