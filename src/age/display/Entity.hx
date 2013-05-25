package age.display;

import age.core.IBehavior;
import age.core.IEntity;
import js.Dom;

class Entity implements IEntity
{
	var _image : Image;
    var _images : Hash<Image>;

	public var width : Int;
	public var height : Int;
	public var x : Float;
	public var y : Float;

	public var visible : Bool;

    public var rotation : Float;

	var _behaviors : Hash<IBehavior>;

	public function new(?pWidth: Int = 0, ?pHeight: Int = 0)
	{
		visible = true;
		x = y = 0;
        rotation = 0;

		width = pWidth;
		height = pHeight;

        _images = new Hash();
		_behaviors = new Hash();
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
            var decX : Float = x + width * .5;
            var decY : Float = y + height * .5;

            pContext.translate(decX, decY);
            pContext.rotate(rotation * Math.PI/180);
            pContext.translate(-decX, -decY );
        }

        if(width != 0 && height != 0)
		    pContext.drawImage(_image, x, y, width, height);
        else
            pContext.drawImage(_image, x, y);

        pContext.restore();
	}

	public function destroy()
	{
		for(b in _behaviors)
			b.destroy();
		_behaviors = new Hash();
	}

}
