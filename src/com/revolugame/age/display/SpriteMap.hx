package com.revolugame.age.display;

import nme.geom.Rectangle;
import nme.display.BitmapData;

import com.revolugame.age.managers.AssetsManager;
import com.revolugame.age.system.Animation;

#if (cpp || neko)
import com.revolugame.age.managers.TileSheetManager;
import com.revolugame.age.system.TileSheetData;
import nme.display.BitmapInt32;
#end

/**
 * ...
 * @author Adrien Fischer
 */
class SpriteMap 
{

	/** Array of rectangles of each parts of the sprite */
	public var rects : Array<Rectangle>;
	
	/** Data needed for render */
	public var cols(default, null) : Int; // number of cols in the spritesheet
	public var rows(default, null) : Int;
	
	/** Size */
	public var width(default, null): Int;
	public var height(default, null): Int;
	
	/** */
	public var pixels/*(default, null)*/ : BitmapData;
	
	/**  */
	var _anims : Hash<Animation>;
	var _anim : Animation; // The current animation
	
	/** index of current sprite to be used in animation */
	var _index : Int;
	var _frame : Int;
	var _timer:Float;
	
	#if (cpp || neko)
	public var tilesheetdata(default, null) : TileSheetData;
	#end
	
	/**
	 * If the animation has stopped.
	 */
	public var complete:Bool;
	
	/**
	 * Animation speed factor, alter this to speed up/slow down all animations.
	 */
	public var rate:Float;
	
	public function new () {}
	
	#if flash
	public function loadGraphic(pSrc: String, pWidth: UInt = 0, pHeight: UInt = 0):Void
	#else
	public function loadGraphic(pSrc: String, pWidth: Int = 0, pHeight: Int = 0):Void
	#end
	{
		// load the image
		pixels = AssetsManager.getBitmap(pSrc);
		
		#if (cpp || neko)
		if(pixels != null)
			tilesheetdata = TileSheetManager.addTileSheet(pixels);
		#end
		
		width = pWidth == 0 ? pixels.width : pWidth;
	    height = pHeight == 0 ? pixels.height : pHeight;
	    
	    initGraphicsData();
	}
	
	/**
	 * Initialize everythings needed for graphics
	 */
	private function initGraphicsData():Void
	{
	    cols = Math.floor(pixels.width / width);
	    rows = Math.floor(pixels.height / height);
	
	    _anims = new Hash();
	    _index  = 0;
	    _timer = 0;
	    _frame = 0;
	    complete = false;
	    rate = 1;
	
	    rects = new Array();
	    var i : Int = 0;
	    var x : Int;
	    var y : Int;
	    for(row in 0...rows)
	    {
	        for(col in 0...cols)
	        {
	            x = col * width;
	            y = row * height;
	            rects[i] = new Rectangle(x, y, width, height);
	            #if (cpp || neko)
	            tilesheetdata.tilesheet.addTileRect( rects[i] );
	            #end
	            ++i;
	        }
	    }
	}
	
	#if flash
	public function makeGraphic(pWidth: UInt, pHeight: UInt, ?pColor: UInt = 0xFF0000):Void
	#else
	public function makeGraphic(pWidth: Int, pHeight: Int, ?pColor:BitmapInt32):Void
	#end
	{
		#if (cpp || neko)
		if (pColor == null)
		{
			#if cpp
			pColor = 0xffffffff;
			#elseif neko
			pColor = { rgb: 0xffffff, a: 0xff };
			#end
		}
		#end
	
		pixels = AssetsManager.createBitmap(pWidth, pHeight, pColor);
		
		#if (cpp || neko)
		if(pixels != null)
			tilesheetdata = TileSheetManager.addTileSheet(pixels);
		#end
		
		width = pixels.width;
		height = pixels.height;
		
	    initGraphicsData();
	}
	
	/**
	 * Animation
	 * @method update
	 * @return if the index has been updated
	 */
	public function update():Bool
	{
		if(_anim == null || complete) 
			return false;
		
		var oldIndex : Int = _index;
				
		_timer += _anim.frameRate * AgeData.elapsed * rate;
		if (_timer >= 1)
		{
			while (_timer >= 1)
			{
				_timer --;
				_index++;
				if(_index >= _anim.frameCount)
				{   
				    if (_anim.loop)
					{
						_index = 0;
					}
					else
					{
						_index = _anim.frameCount - 1;
						complete = true;
						break;
					}
				    
				}
			}
			if (_anim != null) 
				_frame = _anim.frames[_index];
		}
		
		return oldIndex != _index;
	}
	
	/**
	 * Add an Animation.
	 * @param	pName		Name of the animation
	 * @param	pFrames		Array of frame indices to animate through
	 * @param	pFrameRate	Animation speed
	 * @param	pLoop		If the animation should loop
	 * @return	A new Animation object
	 */
	public function add(pName: String, pFrames: Array<Int>, pFrameRate:Float = 0, pLoop:Bool = true):Animation
	{
		if (_anims.get(pName) != null) 
			throw "Cannot have multiple animations with the same name";
			
		var anim:Animation = new Animation(pName, pFrames, pFrameRate, pLoop);
		anim.parent = this;
		
		_anims.set(pName, anim);
		return anim;
	}
	
	/**
	 * Plays an animation.
	 * @param	name		Name of the animation to play.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @return	Anim object representing the played animation.
	 */
	public function play(pName:String = "", pReset:Bool = false):Animation
	{
		if (!pReset && _anim != null && _anim.name == pName) 
		    return _anim;
		    
		_anim = _anims.get(pName);
		if (_anim == null)
		{
			_frame = _index = 0;
			complete = true;
			return null;
		}
		_index = 0;
		_frame = _anim.frames[0];
		complete = false;
		return _anim;
	}
	
	/**
	 * @return the bounding rectangle
	 */
	public function getRect():Rectangle
	{
	    return rects[_frame]; 
	}
	
	public function getFrameId():Int
	{
		return _frame;
	}
	
	public function destroy():Void
	{
//		pixels.dispose();
        pixels = null;
		#if !flash
		TileSheetManager.removeTileSheet(tilesheetdata);
		#end
	}

}
