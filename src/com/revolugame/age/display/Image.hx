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
    
    /** The image origin (default 0 0) */
    public var origin : AgePoint; // TODO
    
    public var dirty : Bool;
    
//    private var _colorTransform:ColorTransform; // alpha and color flash TODO
 //   private var _position : Point; // TODO REMOVE
    
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
    
    /** */
	var _bounds : Rectangle;
    
    /** */
    public var mouseDown : Bool;

	private var _drawingContext : DrawingContext;

	public function new(pX: Float, pY: Float)
	{
		x = pX;
		y = pY;
		
		mouseDown = false;
		
		scale = new AgePoint(1, 1);
		rotation = 0;
		alpha = 1.0;
		
		origin = new AgePoint();
		
//		_position = new Point(); // TODO remove
		
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
		
		_drawingContext = new DrawingContext();
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
		_drawingContext.buffer = _bmpBuffer;
		dirty = true;
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
		
			var px = x - AgeData.camera.position.x;
			var py = y - AgeData.camera.position.y;
			
			// on reapplique la difference du scale
			if(mirrorX) px += width;
			if(mirrorY) py += height;
			
			AgeData.renderer.prepareRendering();
			
			_drawingContext.updateValue( px, py, scale.x, scale.y, rotation, alpha, mirrorX, mirrorY );
			
			AgeData.renderer.render( _spriteMap, _drawingContext);
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
	
	/**
	 * @return the bounding box of this image
	 */
	public function getBounds():Rectangle
    {
    	if(_bounds == null) 
    		_bounds = new Rectangle(0, 0, 0, 0);
    	
    	_bounds.x = x;
	    _bounds.y = y;
	    _bounds.width = width;
	    _bounds.height = height;
    	
    	return _bounds;
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