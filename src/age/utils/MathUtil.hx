package age.utils;

import age.geom.Point2D;

class MathUtil
{
	public inline static var PI : Float = 3.141592654;

	public static function bound(pVal: Float, pMin: Float, pMax: Float): Float
	{
		if( Math.max(pMin, pVal) == pMin) return pMin;
		if( Math.min(pVal, pMax) == pMax) return pMax;
		return pVal;
	}

	public static function randomValue(pMin:Int, pMax:Int):Int
	{
		return ( pMin + Math.round( Math.random() * (pMax - pMin) ) );
	}

	/**
	 * Distance entre deux points
	 */
	public static function distance(p1: Point2D, p2: Point2D):Int
	{
		// AB= √(xB−xA)2+(yB−yA)2
		var dx = p1.x - p2.x;
		var dy = p1.y - p2.y;
		return Math.round( Math.sqrt( dx * dx + dy * dy ) );
	}

}
