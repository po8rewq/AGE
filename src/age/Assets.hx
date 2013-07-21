/** 
 * Author: adrien
 * Date: 05/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age;

//#if js
import age.managers.SoundManager;
import js.html.Image;
import js.html.ArrayBuffer;
//#elseif flash
//import flash.display.BitmapData;
//#end

class Assets
{
	//#if js
    private static var _cacheImg : Map<String, Image> = new Map();
    private static var _cacheSounds : Map<String, ArrayBuffer> = new Map();
    //#elseif flash
    //private static var _cache : Map<String,BitmapData> = new Map();
    //#end

	//#if js
    public static function getImage(pName: String): Image
    //#elseif flash
    //public static function getImage(pSrc: String): BitmapData
    //#end
    {
//    	#if js
        var image : Image;
//        #elseif flash
//        var image : BitmapData;
//        #end

        if(_cacheImg.exists(pName))
        {
            image = _cacheImg.get(pName);
        }
        else
        {
        	//#if js
            image = untyped __js__("new Image()");
            image.style.position = "absolute";
            image.src = pName;
			
            _cacheImg.set(pName, image);
        }
        return image;
    }

    /**
     * Used by the loader
     */
    public static function setImage(pName: String, pImage: Image)
    {
//        trace(pName);
        _cacheImg.set(pName, pImage);
    }

    public static function getSound(pName: String): ArrayBuffer
    {
        if( _cacheSounds.exists(pName) )
        {
            return _cacheSounds.get(pName);
        }
        throw "Error sound not loaded";
//        return null;
    }

    public static function setSound(pName: String, pAudio: ArrayBuffer)
    {
        _cacheSounds.set(pName, pAudio);
    }

}
