package com.revolugame.age.core;

import nme.display.BitmapData;
import nme.display.Bitmap;
import com.revolugame.age.system.AgePoint;

class BitmapCamera implements ICamera, extends BitmapData
{
	/**
	 * smoothing for tileSheet
	 */
	public var antialiasing : Bool;

	/**
     * the top-left position of the camera in the World
     */
    public var position : AgePoint;
	
	public function new(pWidth: Int,  pHeight: Int, pSmoothing: Bool = false)
    {
		super(pWidth, pHeight);
		position = new AgePoint();
		antialiasing = pSmoothing;
	}		
	
	/**
     * Clear the screen to white
     */
    public function clear():Void
    {
        fillRect(rect, 0);
    }
    
    public var screen(getScreen, null): Bitmap;
    private function getScreen():Bitmap
    {
    	if(screen == null) screen = new Bitmap(this);
    	return screen;
    }

}
