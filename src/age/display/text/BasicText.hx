package age.display.text;

import age.display.text.TextAlignEnum.TextAlign;
import age.core.IEntity;

using age.display.text.TextAlignEnum;

class BasicText implements IEntity
{
    public var text : String;

    public var x : Float;
    public var y : Float;
    public var width : Int;
    public var height : Int;

    public var visible : Bool;

    public var bold : Bool;
    public var color : String;
    public var size : Int;

    public var font : String;
    public var textAlign : TextAlign;

	public function new(pText: String, pX: Float, pY: Float)
	{
        text = pText;

        visible = true;
        font = "sans-serif";
        size = 12;
        bold = false;
        color = "#000";
        textAlign = TextAlign.LEFT;

        x = pX;
        y = pY;
        width = 0;
        height = 0;
	}

    public function setStyle(?pFont: String = "", ?pSize: Int = 0, ?pColor: String = "", ?pBold: Bool = false, ?pTextAlign: TextAlign)
    {
        if(pFont != "")
            font = pFont;

        if(pSize > 0)
            size = pSize;

        if(pColor != "")
            color = pColor;

        bold = pBold;

        if(pTextAlign != null)
            textAlign = pTextAlign;
    }

	public function update()
	{

	}

	public function render(pContext: CanvasRenderingContext2D)
	{
        pContext.fillStyle = color;

        pContext.font = (bold ? "bold " : "") + size + "px " + font;
        pContext.textAlign = textAlign.toStyle();
        pContext.textBaseline = "top";

        pContext.fillText(text, x, y);
	}

    public function destroy()
    {

    }

}