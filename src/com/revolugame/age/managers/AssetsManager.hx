package com.revolugame.age.managers;

import nme.display.BitmapData;
import nme.Assets;

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

}