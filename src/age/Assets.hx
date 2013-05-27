/** 
 * Author: adrien
 * Date: 05/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age;

#if js
import js.html.Image;
#elseif flash
import flash.display.BitmapData;
#end

class Assets
{
	#if js
    private static var _cache : Map<String,Image> = new Map();
    #elseif flash
    private static var _cache : Map<String,BitmapData> = new Map();
    #end

	#if js
    public static function getImage(pSrc: String): Image
    #elseif flash
    public static function getImage(pSrc: String): BitmapData
    #end
    {
    	#if js
        var image : Image;
        #elseif flash
        var image : BitmapData;
        #end

        if(_cache.exists(pSrc))
        {
            image = _cache.get(pSrc);
        }
        else
        {
        	#if js
            image = untyped __js__("new Image()");
            image.style.position = "absolute";
            image.src = pSrc;
			#elseif flash
			// TODO
			#end
			
            _cache.set(pSrc, image);
        }
        return image;
    }

}
