package com.revolugame.age.core;

import com.revolugame.age.system.AgePoint;

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
     * Clear the screen to white
     */
    function clear():Void;
}
