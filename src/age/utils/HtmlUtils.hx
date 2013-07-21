package age.utils;

import js.html.RequestAnimationFrameCallback;

class HtmlUtils
{

	/** 
	 * Use requestAnimationFrame if available, otherwise a 60 FPS setInterval
	 * https://developer.mozilla.org/en/DOM/window.mozRequestAnimationFrame
	 */
//	public static function getRequestAnimationFrame(): Dynamic // RequestAnimationFrameCallback->Int
//	{
//		var requestFunctions : Array<String> = [
//			"requestAnimationFrame",
//			"webkitRequestAnimationFrame",
//			"mozRequestAnimationFrame"
////			"oRequestAnimationFrame", // ?
////			"msRequestAnimationFrame" // ?
//		];
//
//		var win = js.Browser.window;
//		for(fnc in requestFunctions)
//		{
//			if( Reflect.field(win, fnc) )
//			{
//				return cast Reflect.field(win, fnc);
//			}
//		}
//
//		return null;
//	}

    public static var VENDOR_PREFIXES = ["webkit", "moz", "ms", "o", "khtml"];
    public static function loadExtension(pName: String): Extension
    {
        var obj = js.Browser.window;
        var extension = Reflect.field(obj, pName);
        if (extension != null)
            return {prefix: "", field: pName, value: extension};

        // Look through common vendor prefixes
        var capitalized = pName.charAt(0).toUpperCase() + pName.substr(1);
        for (prefix in VENDOR_PREFIXES) {
            var field = prefix + capitalized;
            var extension = Reflect.field(obj, field);
            if (extension != null)
                return {prefix: prefix, field: field, value: extension};
        }

        // Not found
        return {prefix: null, field: null, value: null};
    }

//    public static function getAudioContext(): Dynamic
//    {
//        var functions : Array<String> = [
//            "AudioContext",
//            "webkitAudioContext"
//        ];
//
//
//    }

}

typedef Extension = {
    var prefix  : String;
    var field   : String;
    var value   : Dynamic;
}
