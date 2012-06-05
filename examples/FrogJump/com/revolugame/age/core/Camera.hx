package com.revolugame.age.core;

/**
 * ...
 * @author Adrien Fischer
 */

#if cpp || neko
import nme.display.Sprite;

class Camera extends Sprite // ou Graphics ??
{
	
	public function new(pWidth: Int,  pHeight: Int)
	{
		super();
	}
	
	// getScreen : return this ??
	
}

#else

import nme.display.BitmapData;
import nme.display.Bitmap;
import com.revolugame.age.system.AgePoint;

class Camera extends BitmapData
{
	/**
     * the top-left position of the camera in the World
     */
    public var position : AgePoint;
	
	public function new(pWidth: Int,  pHeight: Int)
    {
		super(pWidth, pHeight);
		position = new AgePoint();	
	}		
	
	/**
     * Clear the screen to white
     */
    public function clear():Void
    {
        fillRect(rect, 0);
    }
    
    private var _screen : Bitmap;
    public var screen(getScreen, null): Bitmap;
    private function getScreen():Bitmap
    {
    	if(_screen == null) _screen = new Bitmap(this);
    	return _screen;
    }

}
#end