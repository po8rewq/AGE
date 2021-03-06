package age.display;

import js.html.Image;
import js.html.CanvasRenderingContext2D;
import age.geom.Rectangle;
import age.core.IBehavior;
import age.core.IEntity;

class Entity implements IEntity
{
	var _image : Image;
    var _images : Map<String,Image>;

	public var width : Int;
	public var height : Int;
	public var x : Int;
	public var y : Int;

    public var dead : Bool;

    public var depth : Int;
    public var alpha : Float;

    public var hitbox : Rectangle;

	public var visible : Bool;
    public var mirror : Bool;
    public var rotation : Float;

	var _behaviors : Map<String,IBehavior>;

    #if debug
    var _debugMode : Bool;
    var _debugColor: String;
    #end

	public function new(?pWidth: Int = 0, ?pHeight: Int = 0, ?pImgSrc: String = "")
	{
		visible = true;
		x = y = 0;
        rotation = 0;
        depth = 0;
        alpha = 1;
        mirror = false;

        dead = false;

		width = pWidth;
		height = pHeight;

        hitbox = {
            x: 0,
            y: 0,
            width: pWidth,
            height: pHeight
        };

        _images = new Map();
		_behaviors = new Map();

        #if debug
        _debugMode = false;
        _debugColor = "FF0000";
        #end

        if(pImgSrc != "")
            addImage("default", pImgSrc, true);
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
        if(!dead)
        {
            for(b in _behaviors)
                if(b.activated)
                    b.update();
        }
	}

	public function render(pContext: CanvasRenderingContext2D)
	{
        if(_image == null || !visible || dead) return;

        pContext.save();

        if(mirror)
        {
            var decX : Int = Std.int( x + width * .5 );
            var decY : Int = Std.int( y + height * .5 );

            pContext.translate(decX, decY);
            pContext.scale(-1, 1);
            pContext.translate(-decX, -decY );
        }

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
		_behaviors = new Map();
	}

    public function collideRect(pX: Int, pY: Int, pWidth: Int, pHeight: Int): Bool
    {
        // haut gauche
        if( pX >= x + hitbox.x && pX <= x + hitbox.x + hitbox.width && pY >= y + hitbox.y && pY <= y + hitbox.y + hitbox.height) return true;

        // haut droit
        if( pX + pWidth >= x + hitbox.x && pX + pWidth <= x + hitbox.x + hitbox.width && pY >= y + hitbox.y && pY <= y + hitbox.y + hitbox.height) return true;

        // bas gauche
        if( pX >= x + hitbox.x && pX <= x + hitbox.x + hitbox.width && pY + pHeight >= y + hitbox.y && pY + pHeight <= y + hitbox.y + hitbox.height) return true;

        // bas droit
        if( pX + pWidth >= x + hitbox.x && pX + pWidth <= x + hitbox.x + hitbox.width && pY + pHeight >= y + hitbox.y && pY + pHeight <= y + hitbox.y + hitbox.height) return true;

        return false;
    }

    public function collideEntity(pEntity: Entity): Bool
    {
        return collideRect(
            pEntity.x + pEntity.hitbox.x, 
            pEntity.y + pEntity.hitbox.y, 
            pEntity.hitbox.width, 
            pEntity.hitbox.height );
    }

    public function collidePoint(pX: Int, pY:Int): Bool
    {
        return collideRect(pX, pY, 0, 0);
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
