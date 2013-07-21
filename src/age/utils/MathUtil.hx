package age.utils;

class MathUtil
{

	public static function bound(pVal: Float, pMin: Float, pMax: Float): Float
	{
		if( Math.max(pMin, pVal) == pMin) return pMin;
		if( Math.min(pVal, pMax) == pMax) return pMax;
		return pVal;
	}

}
