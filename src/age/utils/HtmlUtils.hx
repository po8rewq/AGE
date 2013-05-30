package age.utils;

import js.html.RequestAnimationFrameCallback;

class HtmlUtils
{

	/** 
	 * Use requestAnimationFrame if available, otherwise a 60 FPS setInterval
	 * https://developer.mozilla.org/en/DOM/window.mozRequestAnimationFrame
	 */
	public static function getRequestAnimationFrame(): Dynamic // RequestAnimationFrameCallback->Int
	{
		var requestFunctions : Array<String> = [
			"requestAnimationFrame",
			"webkitRequestAnimationFrame",
			"mozRequestAnimationFrame"
//			"oRequestAnimationFrame", // ?
//			"msRequestAnimationFrame" // ?
		];
	
		var win = js.Browser.window;
		for(fnc in requestFunctions)
		{
			if( Reflect.field(win, fnc) )
			{
				return cast Reflect.field(win, fnc);
			}
		}
		
		return null;
	}

}
