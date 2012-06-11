package com.revolugame.age.display;

import com.revolugame.age.system.AgePoint;

import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.ColorTransform;

#if flash
import nme.geom.Matrix;
#else
import com.revolugame.age.system.TileSheetData;
import nme.display.BitmapInt32;
#end

/**
 * Simple graphical element
 */
class Image implements IEntity
{
	/**
	 * If the graphic should render
	 */
	public var visible : Bool;
	
	/**
	 * If the graphic should update.
	 */
	public var dead : Bool;
	
	/** Position */
	public var x : Float;
	public var y : Float;
	
	/** Scale */
	public var scale : AgePoint;
	
	/** Angle */
	public var rotation : Float;
	
	/** Alpha */
	public var alpha : Float; // TODO flash
	
    /** The visual data */
    private var _spriteMap : SpriteMap;
    
    /**  */
    public var mirrorX : Bool;
    public var mirrorY : Bool;
    
    public var dirty : Bool;
    
//    private var _colorTransform:ColorTransform; // alpha and color flash TODO
    private var _position : Point;
    
    #if flash
    private var _matrix : Matrix;
    private var _bmpBuffer : BitmapData;
    private var _pZero : Point;
//	public var color(default, setColor):UInt;
//    #else
//    public var color(default, setColor):BitmapInt32;
//    private var _red : Float;
//    private var _green : Float;
//    private var _blue : Float;
    #end

	public function new(pX: Float, pY: Float)
	{
		x = pX;
		y = pY;
		
		scale = new AgePoint(1, 1);
		rotation = 0;
		alpha = 1.0;
		
		_position = new Point();
		
		#if flash
		_matrix = new Matrix();
		_pZero = new Point();
//		#else
//		_red = 1.0;
//		_green = 1.0;
//		_blue = 1.0;
		#end
		
		dirty = false;
		
		visible = true;
		dead = false;
		
		mirrorX = false;
		mirrorY = false;
		
		visible = true;
	}
	
	/**
	 * Load an embedded graphic
	 */
	public function loadGraphic(pSrc: String, pWidth: Int = 0, pHeight: Int = 0):SpriteMap
	{
	    if(_spriteMap == null) _spriteMap = new SpriteMap();
		else _spriteMap.destroy();
		
	    _spriteMap.loadGraphic(pSrc, pWidth, pHeight);
	    
	    #if flash
		_bmpBuffer = new BitmapData(pWidth, pHeight);
		#end
	    
	    return _spriteMap;
	}
	
	/**
	 * Create a rectangle
	 */
	#if flash
	public function makeGraphic(pWidth: UInt, pHeight: UInt, pColor: UInt):SpriteMap
	#else
	public function makeGraphic(pWidth: Int, pHeight: Int, ?pColor:BitmapInt32):SpriteMap
	#end
	{
		if(_spriteMap == null) _spriteMap = new SpriteMap();
		else _spriteMap.destroy();
		
	    _spriteMap.makeGraphic(pWidth, pHeight, pColor);
	    
	    #if flash
		_bmpBuffer = new BitmapData(pWidth, pHeight);
		#end
	    
	    return _spriteMap;
	}
	
	/**
	 * Add an animation to the spritemap
	 */
	public function addAnimation(pName: String, pFrames: Array<Int>, pFrameRate:Float = 0, pLoop:Bool = true):Void
	{
	    if(_spriteMap == null) throw 'SpriteMap is not defined !!';
	    _spriteMap.add(pName, pFrames, pFrameRate, pLoop);
	}
	
	public function play(pName: String)
	{
		_spriteMap.play(pName);
	}
	
	/**
	 * Udate animation and behaviors
	 */
	public function update():Void
	{
		if(!dead)
		{
			if(_spriteMap.update())
				dirty = true;
		}
	}
	
	public function render():Void
	{
		if(!dead && visible && onScreen())
		{
			if(dirty) drawFrame();
		
			_position.x = x - AgeData.camera.position.x;
			_position.y = y - AgeData.camera.position.y;
			
			#if flash
			if( scale.x != 1 || scale.y != 1 || rotation != 0 || mirrorX || mirrorY)
			{
				_matrix.identity();
				
				// mirror
				var sclX : Float = scale.x * (mirrorX ? -1 : 1);
				var sclY : Float = scale.y * (mirrorY ? -1 : 1);
				if(sclX != 1 && sclY != 1)
					_matrix.scale(sclX, sclY);
				
				if(rotation != 0)
					_matrix.rotate(rotation * 0.017453293);
	
				_matrix.translate(_position.x, _position.y);
				
				AgeData.camera.draw( _bmpBuffer, _matrix, null, null, null, AgeData.camera.antialiasing );
			}
			else
			{
				AgeData.camera.copyPixels( _spriteMap.pixels, _spriteMap.getRect(), _position, null, null, true );
	        }
			#else
			var ts : TileSheetData = _spriteMap.tilesheetdata;
			
			/** Reset drawing data */
			ts.resetData();
			
            /** Position */
            ts.setPosition( _position.x, _position.y );
            
            /** Set current frame id */
            ts.setFrameId( _spriteMap.getFrameId() );
            
            /** Scale && rotation */
			ts.setTransform(scale.x, scale.y, rotation, mirrorX, mirrorY);
            
            /** rgb */
//			ts.setRGB( _red, _green, _blue );
            
            /** alpha */
            ts.setAlpha(alpha);
            
            ts.render();
            #end
		}
	}
	
	/**
	 * Redraw the bitmapdata if needed
	 */
	private function drawFrame():Void
	{
		#if flash
		_bmpBuffer.copyPixels( _spriteMap.pixels, _spriteMap.getRect(), _pZero );
//		if (_colorTransform != null)
//			_bmpBuffer.colorTransform(_spriteMap.getRect(), _colorTransform);
		dirty = false;
		#end
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
	
	public function destroy(): Void
	{
		_spriteMap.destroy();
		#if flash
		_bmpBuffer.dispose();
		#end
	}

	public var width(getWidth, null): Int;
    private function getWidth():Int { return _spriteMap.width; }
    
    public var height(getHeight, null): Int;
    private function getHeight():Int { return _spriteMap.height; }
}