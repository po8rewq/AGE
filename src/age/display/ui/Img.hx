package age.display.ui;

import js.html.Image;
import js.html.CanvasRenderingContext2D;
import age.core.IEntity;

class Img implements IEntity
{
	var _image : Image;

	public var width : Int;
	public var height : Int;
	public var x : Int;
	public var y : Int;

	public var alpha : Float;
	public var rotation : Float;
	public var scale : Float;

	public var depth : Int;
	public var visible : Bool;

	public function new(pX: Int, pY: Int, pSrc: String, ?pScale: Float = 1)
	{
		visible = true;

		x = pX;
		y = pY;
		scale = pScale;

		rotation = 0;
        depth = 0;
        alpha = 1;

		_image = Assets.getImage(pSrc);

		width = _image.width;
		height = _image.height;
	}

	public function changeImg(pSrc: String)
	{
		_image = Assets.getImage(pSrc);

		width = _image.width;
		height = _image.height;
	}

	public function update(){}

	public function render(pContext: CanvasRenderingContext2D)
	{
		if(_image == null || !visible) return;

		pContext.save();

        if(rotation != 0)
        {
            var decX : Int = Std.int( x + width * .5 );
            var decY : Int = Std.int( y + height * .5 );

            pContext.translate(decX, decY);
            pContext.rotate(rotation * Math.PI/180);
            pContext.translate(-decX, -decY );
        }

        if(scale != 1)
        {
        	var decX : Int = Std.int( x + width * .5 );
            var decY : Int = Std.int( y + height * .5 );

            pContext.translate(decX, decY);
            pContext.scale(scale, scale);
            pContext.translate(-decX, -decY );
        }

        var globalAlpha = pContext.globalAlpha;
        if(alpha < 1 && alpha >= 0)
            pContext.globalAlpha = alpha;

        if(width != 0 && height != 0)
		    pContext.drawImage(_image, x, y, width, height);
        else
            pContext.drawImage(_image, x, y);

        pContext.globalAlpha = globalAlpha;

        pContext.restore();
	}

	public function destroy()
	{

	}

}