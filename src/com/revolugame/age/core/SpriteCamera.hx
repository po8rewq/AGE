package com.revolugame.age.core;

import nme.display.Sprite;
import com.revolugame.age.system.AgePoint;

class SpriteCamera implements ICamera
{
	/**
     * the top-left position of the camera in the World
     */
    public var position : AgePoint;
    
    /**
	 * smoothing for tileSheet
	 */
	public var antialiasing : Bool;
    
    public var screen(default, null) : Sprite;
	
	public function new(pWidth: Int,  pHeight: Int, pSmoothing: Bool = false)
	{
		screen = new Sprite();
		position = new AgePoint();
		antialiasing = pSmoothing;
	}
	
	public function clear():Void
	{
		screen.graphics.clear();
	}
	
}
