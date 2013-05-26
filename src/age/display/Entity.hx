package age.display;

import age.geom.Rectangle;
import age.core.IBehavior;
import age.core.IEntity;
import js.Dom;

class Entity implements IEntity
{
	var _image : Image;
    var _images : Hash<Image>;

	public var width : Int;
	public var height : Int;
	public var x : Int;
	public var y : Int;

    public var depth : Int;
    public var alpha : Float;

    public var hitbox : Rectangle;

	public var visible : Bool;

    public var rotation : Float;

	var _behaviors : Hash<IBehavior>;

    #if debug
    var _debugMode : Bool;
    var _debugColor: String;
    #end

	public function new(?pWidth: Int = 0, ?pHeight: Int = 0)
	{
		visible = true;
		x = y = 0;
        rotation = 0;
        depth = 0;
        alpha = 1;

		width = pWidth;
		height = pHeight;

        hitbox = {
            x: 0,
            y: 0,
            width: pWidth,
            height: pHeight
        };

        _images = new Hash();
		_behaviors = new Hash();

        #if debug
        _debugMode = false;
        _debugColor = "FF0000";
        #end
	}

    public function addImage(pName: String, pSrc: String, ?pDefault: Bool = false)
    {
        _images.set( pName, Assets.getImage(pSrc) );
        if(pDefault) play(pName);
    }

    public function play(pName: String)
    {
        _image = _images.get(pName);
    }

	public function addBehavior(pName:String, pBehavior: IBehavior)
	{
        _behaviors.set(pName, pBehavior);
	}

	public function removeBehavior(pName: String)
	{
        if(_behaviors.exists(pName))
            _behaviors.remove(pName);
	}

    public function getBehavior(pName: String): IBehavior
    {
        return _behaviors.get(pName);
    }

	public function update()
	{
		for(b in _behaviors)
			if(b.activated)
				b.update();
	}

	public function render(pContext: CanvasRenderingContext2D)
	{
        if(_image == null) return;

        pContext.save();

        if(rotation != 0)
        {
            var decX : Int = Std.int( x + width * .5 );
            var decY : Int = Std.int( y + height * .5 );

            pContext.translate(decX, decY);
            pContext.rotate(rotation * Math.PI/180);
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

        #if debug
        drawDebug(pContext);
        #end
	}

	public function destroy()
	{
		for(b in _behaviors)
			b.destroy();
		_behaviors = new Hash();
	}

    #if debug
    private function setDebugMode(pActive: Bool, ?pColor: String = "")
    {
        _debugMode = pActive;
        if(pColor != "") _debugColor = pColor;
    }

    private function drawDebug(pContext: CanvasRenderingContext2D)
    {
        if(_debugMode)
        {
            pContext.beginPath();
            pContext.rect(x + hitbox.x, y + hitbox.y, hitbox.width, hitbox.height);
            pContext.lineWidth = 2;
            pContext.strokeStyle = _debugColor;
            pContext.stroke();
        }
    }
    #end

}
