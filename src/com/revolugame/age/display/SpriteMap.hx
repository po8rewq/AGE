package com.revolugame.age.display;

import nme.geom.Rectangle;
import nme.display.BitmapData;

import com.revolugame.age.managers.AssetsManager;
import com.revolugame.age.system.Animation;

#if cpp || neko
import com.revolugame.age.managers.TileSheetManager;
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
	public var pixels(default, null) : BitmapData;
	
	/**  */
	private var _anims : Hash<Animation>;
	private var _anim : Animation; // The current animation
	
	/** index of current sprite to be used in animation */
	private var _index : Int;
	private var _frame : Int;
	private var _timer:Float;
	
	/**
	 * If the animation has stopped.
	 */
	public var complete:Bool;
	
	/**
	 * Animation speed factor, alter this to speed up/slow down all animations.
	 */
	public var rate:Float;
	
	public function new (pSrc: String, pWidth: Int = 0, pHeight: Int = 0):Void
	{
		// load the image
		pixels = AssetsManager.getBitmap(pSrc);
		
		width = pWidth == 0 ? pixels.width : pWidth;
	    height = pHeight == 0 ? pixels.height : pHeight;
	
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
	            ++i;
	        }
	    }
		
		#if cpp || neko
		updateTileSheet();
		#end
	}
	
	/**
	 * Animation
	 * @method update
	 * @return
	 */
	public function update():Void
	{
		if(_anim == null || complete) return;
				
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
	}
	
	/**
	 * Add an Animation.
	 * @param	name		Name of the animation.
	 * @param	frames		Array of frame indices to animate through.
	 * @param	frameRate	Animation speed.
	 * @param	loop		If the animation should loop.
	 * @return	A new Anim object for the animation.
	 */
	public function add(name: String, frames: Array<Int>, frameRate:Float = 0, loop:Bool = true):Animation
	{
		if (_anims.get(name) != null) 
			throw "Cannot have multiple animations with the same name";
		var anim:Animation = new Animation(name, frames, frameRate, loop);
		_anims.set(name, anim);
		anim.parent = this;
		return anim;
	}
	
	/**
	 * Plays an animation.
	 * @param	name		Name of the animation to play.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @return	Anim object representing the played animation.
	 */
	public function play(name:String = "", reset:Bool = false):Animation
	{
		if (!reset && _anim != null && _anim.name == name) return _anim;
		_anim = _anims.get(name);
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
	 * returns the bounding rectangle for the indexed sprite
	 * @param the index of the sprite to get the rect for, defaults to animFrame
	 * @return the bounding rectangle of indexed sprite
	 */
	public function getRect(num:Int = -1):Rectangle
	{
	    return rects[_frame];
	}
	
	#if cpp || neko
	private function updateTileSheet():Void
	{
		if(pixels != null)
			TileSheetManager.addTileSheet(_pixels);
	}
	#end

}
