package age.utils;

class MathUtil
{

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

}
