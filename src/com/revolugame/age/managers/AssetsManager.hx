package com.revolugame.age.managers;

import nme.display.BitmapData;
import nme.Assets;

#if !flash
import nme.display.BitmapInt32;
#end

class AssetsManager
{
	/** Bitmap storage */
	private static var _bitmaps : Hash<BitmapData> = new Hash<BitmapData>();

	/**
	 * Create the bitmap if needed
	 */
	public static function getBitmap(pSrc: Dynamic): BitmapData
	{
		var name:String = Std.string(pSrc);
		if (_bitmaps.exists(name))
			return _bitmaps.get(name);

		var data:BitmapData = Assets.getBitmapData(pSrc);
		if (data != null)
			_bitmaps.set(name, data);

		return data;
	}
	
	/**
	 * Create a new BitmapData object
	 * @param pWidth
	 * @param pHeight
	 * @param pColor
	 * @param pCacheName Force the cache name
	 */
	#if flash
	public static function createBitmap(pWidth: UInt, pHeight: UInt, pColor:UInt, ?pCacheName: String = null): BitmapData
	#else
	public static function createBitmap(pWidth: Int, pHeight: Int, pColor:BitmapInt32, ?pCacheName: String = null): BitmapData
	#end
	{
		// Create a cache name if needed
		if(pCacheName == null)
		{
			#if neko
			pCacheName = pWidth + "x" + pHeight + ":" + pColor.a + "." + pColor.rgb;
			#else
			pCacheName = pWidth + 'x' + pHeight + ':' + pColor;
			#end
		}
		
		if (!_bitmaps.exists(pCacheName))
			_bitmaps.set(pCacheName, new BitmapData(pWidth, pHeight, true, pColor) );
	
		return _bitmaps.get(pCacheName);
	}

}