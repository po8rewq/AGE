package com.revolugame.age.display;

import com.revolugame.age.core.IBehavior;

import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.BitmapData;

class Entity implements IEntity
{
	public var exists : Bool;
	public var visible : Bool;
	
	/** Position sur la scene */
	public var x : Int;
	public var y: Int;
	
	/** If the entity is active */
    public var active : Bool;
	
	/** All the behaviors of the actor */
    private var _behaviors : List<IBehavior>;
    
    private var _spriteMap : SpriteMap;
	
	public function new(pX: Int = 0, pY: Int = 0, ?pSpriteMap: SpriteMap = null):Void
	{
		x = pX;
		y = pY;
		
		exists = true;
		visible = true;
		active = true;
		
		_spriteMap = pSpriteMap;
		
		_behaviors = new List();
	}
	
	public function update():Void
	{
		if(active)
		{
			_spriteMap.update();
		
			for(b in _behaviors)
				b.update();
		}
	}
	
	public function render():Void
	{
		if(active && visible)
		{
			var srcRect : Rectangle = _spriteMap.getRect();
            var newBmp : BitmapData = new BitmapData(_spriteMap.width * _spriteMap.cols, _spriteMap.height * _spriteMap.rows, true, 0xcecece);
            newBmp.copyPixels( _spriteMap.pixels, srcRect, new Point(0, 0), null, null, false);

            #if cpp || neko
            // TODO
            #else
            AgeData.camera.copyPixels( newBmp, newBmp.rect, new Point(x - AgeData.camera.position.x , y - AgeData.camera.position.y) );
            #end
		}
	}
	
	public function destroy():Void
	{
		
	}
	
	/**
     * Add a specific behavior
     */
	public function addBehavior(b: IBehavior):Void
	{
		_behaviors.push(b);
		b.enable();
	}
	
	/**
    * Delete a behavior
     */
    public function removeBehavior(b: IBehavior):Void
    {
        b.disable();
        _behaviors.remove( b );
    }
    
    /**
	 * Callback for a collision detection (with tangible set to true)
	 * @param otherEntity
	 * @param type
	 */
	public function collide(otherEntity: Entity, type:String):Void
	{
	    if(active)
	    {        
	        for(b in _behaviors)
				b.collide(otherEntity, type);
	    }
	}
	
}