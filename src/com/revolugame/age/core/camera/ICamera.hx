package com.revolugame.age.core.camera;

import com.revolugame.age.system.AgePoint;

import flash.geom.Rectangle;

interface ICamera
{
    /**
     * the top-left position of the camera in the World
     */
    var position : AgePoint;
    
    /**
	 * smoothing for tileSheet
	 */
	var antialiasing : Bool;
	
	/**
	 * Lock before drawing
	 */
	function lock():Void;
	
	/**
	 * Unlock after drawing
	 */
	function unlock(changeRect:Rectangle = null):Void;
	
	/**
     * Clear the screen to white
     */
    function clear():Void;
}
