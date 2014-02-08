package age.display.ui;

import js.html.Image;
import js.html.CanvasRenderingContext2D;
import age.core.IEntity;

class Rect implements IEntity
{
	public var width : Int;
	public var height : Int;
	public var x : Int;
	public var y : Int;

	public var alpha : Float;

	public var depth : Int;
	public var visible : Bool;

	public var _backgroundColor : String;

	public function new(pX: Int, pY: Int, pWidth: Int, pHeight: Int, pColor: String, ?pAlpha : Float = 1)
	{
		visible = true;

		x = pX;
		y = pY;

        depth = 0;
        alpha = pAlpha;
        _backgroundColor = pColor;

		width = pWidth;
		height = pHeight;
	}

	public function update(){}

	public function render(pContext: CanvasRenderingContext2D)
	{
		if(_backgroundColor != "")
        {
        	pContext.save();

        	var globalAlpha = pContext.globalAlpha;
	        if(alpha < 1 && alpha >= 0)
	            pContext.globalAlpha = alpha;

	        // draw background
	        pContext.beginPath();
	        pContext.rect(x, y, width, height);

	        if(_backgroundColor != "")
	        {
	            pContext.fillStyle = _backgroundColor;
	            pContext.fill();
	        }	        

	        pContext.globalAlpha = globalAlpha;

	        pContext.restore();
	    }
	}

	public function destroy()
	{

	}

}