package com.revolugame.age.display;

import com.revolugame.age.core.IBehavior;

import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.BitmapData;

#if flash
import nme.geom.Matrix;
#else
import com.revolugame.age.system.TileSheetData;
#end

class Entity implements IEntity
{
	public var exists : Bool;
	public var visible : Bool;
	
	/** Position sur la scene */
	public var x : Int;
	public var y: Int;
	
	/** Scale */
	public var scaleX : Float;
	public var scaleY : Float;
	
	/** Angle */
	public var angle : Float;
	
	/** Alpha */
	public var alpha : Float;	
	
	/** If the entity is active */
    public var active : Bool;
	
	/** All the behaviors of the actor */
    private var _behaviors : List<IBehavior>;
    
    /** The visual data */
    private var _spriteMap : SpriteMap;
    
    #if flash
    private var _matrix : Matrix;
    #else
    private var _red 	: Float;
    private var _green 	: Float;
    private var _blue 	: Float;
    #end
	
	public function new(pX: Int = 0, pY: Int = 0, ?pSpriteMap: SpriteMap = null):Void
	{
		x = pX;
		y = pY;
		
		scaleX = 1;
		scaleY = 1;
		angle = 0;
		alpha = 1;
		
		#if flash
		_matrix = new Matrix();
		#else
		_red = 1.0;
		_green = 1.0;
		_blue = 1.0;
		#end
		
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
		if(active && visible && onScreen())
		{
			#if flash
			if( scaleX != 1 || scaleY != 1 || angle != 0)
			{
				var rect : Rectangle = _spriteMap.getRect();
				
				_matrix.identity();
				
				if(scaleX != 1 && scaleY != 1)
					_matrix.scale(scaleX, scaleY);
				
				if(angle != 0)
					_matrix.rotate(angle * 0.017453293);
	
				_matrix.translate(x - AgeData.camera.position.x, y - AgeData.camera.position.y);
				
				/** Create the buffer with the correct matrix */
				var buffer : BitmapData = new BitmapData(Std.int(rect.width), Std.int(rect.height) );
				buffer.copyPixels( _spriteMap.pixels, rect, new Point(0, 0),  null, null, AgeData.camera.antialiasing );
				
				AgeData.camera.draw( buffer, _matrix, null, null, null, AgeData.camera.antialiasing );
			}
			else
			{
				AgeData.camera.copyPixels( _spriteMap.pixels, 
	            						   _spriteMap.getRect(), 
	            						   new Point(x - AgeData.camera.position.x , y - AgeData.camera.position.y), 
	            						   null, null, AgeData.camera.antialiasing );
	        }
			#else
			var ts : TileSheetData = _spriteMap.tilesheetdata;
			
			ts.resetData();
			
            /** Position */
            ts.setPosition( x - AgeData.camera.position.x, y - AgeData.camera.position.y );
            
            /** Set current frame id */
            ts.setFrameId( _spriteMap.getFrameId() );
            
            /** Scale */
            ts.setScale(scaleX, scaleY);
			
			/** Rotation */
			ts.setRotation( angle );
            
            // rgb
			ts.setRGB( _red, _green, _blue );
            
            // alpha
            ts.setAlpha(alpha);
            
            ts.render();
            #end
		}
	}
	
	/**
     * His on the screen and need to be rendered
     * @return Bool
     */
    public function onScreen():Bool
    {
    	return (x + width >= AgeData.camera.position.x
        		&& x <= AgeData.camera.position.x + AgeData.stageWidth
                && y + height >= AgeData.camera.position.y && y <= AgeData.camera.position.y + AgeData.stageHeight);
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
	
	public function destroy():Void
	{
		_spriteMap.destroy();
		for(b in _behaviors)
			b.destroy();
	}

	public var width(getWidth, null): Int;
    private function getWidth():Int { return _spriteMap.width; }
    
    public var height(getHeight, null): Int;
    private function getHeight():Int { return _spriteMap.height; }
			
}