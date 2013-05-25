/** 
 * Author: adrien
 * Date: 04/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.display.text;

enum TextAlign {
    LEFT;
    CENTER;
    RIGHT;
    JUSTIFY;
}

class TextAlignEnum
{
    public static function toStyle(pType: TextAlign):String
    {
        return switch(pType)
        {
            case LEFT: "left";
            case RIGHT: "right";
            case CENTER: "center";
            case JUSTIFY: "justify";
        }
    }
}
