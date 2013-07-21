package age;

import js.html.Image;
import js.html.Event;
import js.html.XMLHttpRequest;

class Loader
{
    public static var LOADED: Int = 0;
    public static var ERROR: Int = 0;

    private static var _dataToLoad : List<Resource> = new List();
    private static var _endCallback : Void->Void;

    private static var _totalToLoad: Int = 0;

    /**
     *
     **/
    public static function addResource(pSrc: String, pType: ResourceType, ?pName: String = "")
    {
    	switch(pType)
    	{
    		case ResourceType.IMAGE:
    			_dataToLoad.add({type: ResourceType.IMAGE, src: pSrc, name: pName != "" ? pName : pSrc});
    		case ResourceType.TEXT:
    			_dataToLoad.add({type: ResourceType.TEXT, src: pSrc, name: pName != "" ? pName : pSrc});
            case ResourceType.SOUND:
                _dataToLoad.add({type: ResourceType.SOUND, src: pSrc, name: pName != "" ? pName : pSrc});
    	}
    }

    /**
     * Remove a resource from the queue
     **/
    private static function removeResource(pName: String)
    {
        for(r in _dataToLoad)
        {
            if(r.name == pName)
            {
                _dataToLoad.remove(r);
                return;
            }
        }
    }

	private static function onImageError(pEvt: Event)
	{
		trace("Error: " + pEvt.currentTarget);

		ERROR++;
		allComplete();
	}

	private static function onResourceLoaded(pName: String)
	{
		LOADED++;
        removeResource(pName);
		allComplete();
	}

	/**
	 * Lancer les téléchargements
	 * @param pCallback : function called after all resources are loaded
	 */
	public static function start(pCallback: Void->Void)
	{
		_endCallback = pCallback;
        _totalToLoad = _dataToLoad.length;

		for(data in _dataToLoad)
		{
			switch(data.type)
			{
				case ResourceType.IMAGE: loadImage(data.name, data.src);
				case ResourceType.TEXT: loadText(data.src);
                case ResourceType.SOUND: loadSound(data.name, data.src);
			}
		}
	}

	private static function loadImage(pName: String, pSrc: String)
	{
		var image : Image = untyped __js__("new Image()");
        image.style.position = "absolute";

//        image.onload = onImageLoaded;
        image.onload = function(pEvt: Event){
            Assets.setImage(pName, cast pEvt.currentTarget);
            onResourceLoaded(pName);
        };

        image.onerror = onImageError;
        image.src = pSrc;
	}

	private static function loadText(pSrc: String)
	{ // TODO
		var r = new haxe.Http(pSrc);
        r.onError = function(r:String) { trace("Error: " + r); };
        r.onData = function(r:String) { trace("Loaded: " + r); };
        r.request(false);
	}

    private static function loadSound(pName: String, pSrc: String)
    {
        var r = new XMLHttpRequest();
        r.open("GET", pSrc, true);
        r.responseType = "arraybuffer";
        r.onload = function(pEvt: Event){
            Assets.setSound(pName, cast r.response);
            onResourceLoaded(pName);
        };
        r.send();
    }

	private static function allComplete()
	{
		if(_totalToLoad <= LOADED + ERROR)
		{
			_endCallback();
		}
	}

}

typedef Resource = {
	var type    : ResourceType;
	var src     : String;
    var name    : String;
}

enum ResourceType {
	IMAGE;
	TEXT;
	SOUND;
}