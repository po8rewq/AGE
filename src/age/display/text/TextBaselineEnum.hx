/** 
 * Author: adrien
 * Date: 04/08/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.display.text;

enum TextBaseline {
    TOP;
    BOTTOM;
    MIDDLE;
    ALPHABETIC;
    HANGING;
}

/**
 * cf http://www.w3schools.com/tags/canvas_textbaseline.asp
 **/
class TextBaselineEnum
{
    public static function toStyle(pType: TextBaseline):String
    {
        return switch(pType)
        {
            case TOP: "top";
            case BOTTOM: "bottom";
            case MIDDLE: "middle";
            case ALPHABETIC: "alphabetic";
            case HANGING: "hanging";
        }
    }
}
