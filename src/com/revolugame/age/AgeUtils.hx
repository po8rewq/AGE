package com.revolugame.age;

import flash.geom.Rectangle;

class AgeUtils
{

    /**
	 * Finds the sign of the provided value.
	 * @param	value		The Float to evaluate.
	 * @return	1 if value > 0, -1 if value < 0, and 0 when value == 0.
	 */
	public static inline function sign(value:Float):Int
	{
		return value < 0 ? -1 : (value > 0 ? 1 : 0);
	}
	 
	/**
	 * Returns true if the given x/y coordinate is within the given rectangular block
	 * @param	pX		The X value to test
	 * @param	pY		The Y value to test
	 * @param	pRect	The Rectanglt to test within
	 * @return	true if is within the rect
	 */
	public static inline function pointInRect(pX:Int, pY:Int, pRect:Rectangle):Bool
	{
        return( pX >= pRect.x && pX <= pRect.x + pRect.width && pY >= pRect.y && pY <= pRect.y + pRect.height );
	}

	/**
     * Return an integer between the 2 values
     * @param
	 */
	public static inline function rand(pLow: Int = 0,  pHight: Int = 1):Int
	{
		return Math.floor( Math.random() * ( 1 + pHight - pLow ) ) + pLow;
	}

}
