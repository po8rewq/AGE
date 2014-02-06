package age.core;

import age.geom.Point2D;
import age.utils.GamepadSupport;
import age.geom.Rectangle;
import age.utils.HtmlUtils;

import js.html.MouseEvent;
import js.html.KeyboardEvent;
import js.html.CanvasElement;
import js.html.ClientRect;

/**
 * Based on haxepunk
 * https://github.com/HaxePunk/HaxePunk/blob/master/com/haxepunk/utils/Input.hx
 **/
class Input
{
	static var _root : CanvasElement;
	
	static var _key:Array<Bool> = new Array<Bool>();
	static var _keyNum:Int = 0;

	static var _press:Array<Int> = new Array<Int>();
	static var _pressNum:Int = 0;

	static var _release:Array<Int> = new Array<Int>();
	static var _releaseNum:Int = 0;

	static var _control:Map<String,Array<Int>> = new Map();

    public static var mousePosition : Point2D = {x: 0, y: 0};

	public static function new(pRoot: CanvasElement)
	{
		_root = pRoot;

        var b = js.Browser.document;
        b.addEventListener("keydown", onKeyDown);
        b.addEventListener("keyup", onKeyUp);

        _root.addEventListener("mousemove", onMouseMove);

        GamepadSupport.init();
	}

    private static function onMouseMove(pEvt: MouseEvent)
    {
        var bounds = getCanvasBounds();
        mousePosition.x = Math.round(pEvt.clientX - bounds.left);       //      trace(pEvt.clientX + "/" + pEvt.clientY);
        mousePosition.y = Math.round(pEvt.clientY - bounds.top);
    }

    public static function registerGlobalClickHandler(pCallback: MouseEvent->Void)
    {
        _root.addEventListener("click", pCallback);
    }

    public static function removeGlobalClickHandler(pCallback: MouseEvent->Void)
    {
        _root.removeEventListener("click", pCallback);
    }

    public static function getCanvasBounds(): ClientRect
    {
        return _root.getBoundingClientRect();
    }
	
	private static function onKeyDown(pEvt: KeyboardEvent)
	{
		var code:Int = pEvt.keyCode;
		if (!_key[code])
		{
			_key[code] = true;
			_keyNum++;
			_press[_pressNum++] = code;
		}
	}
	
	private static function onKeyUp(pEvt: KeyboardEvent)
	{
		var code:Int = pEvt.keyCode;
		if (_key[code])
		{
			_key[code] = false;
			_keyNum--;
			_release[_releaseNum++] = code;
		}
	}

	/**
	 * Copy of Lambda.indexOf for speed/memory reasons
	 * @param	a array to use
	 * @param	v value to find index of
	 * @return	index of value in the array
	 */
	private static function indexOf(a:Array<Int>, v:Int):Int
	{
		var i = 0;
		for( v2 in a ) {
			if( v == v2 )
				return i;
			i++;
		}
		return -1;
	}

	public static function update()
	{
		while (_pressNum-- > -1) _press[_pressNum] = -1;
		_pressNum = 0;

		while (_releaseNum-- > -1) _release[_releaseNum] = -1;
		_releaseNum = 0;

        GamepadSupport.update();
	}

    /**
	 * If the input or key is held down.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
    public static function check(input:Dynamic):Bool
    {
        if (Std.is(input, String))
        {
            var v:Array<Int> = _control.get(input), i:Int = v.length;
            while (i-- > 0)
            {
                if (v[i] < 0 && _keyNum > 0)
                    return true;
                else if (_key[v[i]] == true)
                    return true;
            }
            return false;
        }
        return input < 0 ? _keyNum > 0 : _key[input];
    }

	/**
	 * If the input or key was pressed this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function pressed(input:Dynamic):Bool
	{
		if (Std.is(input, String))
		{
			var v:Array<Int> = _control.get(input);
			var i:Int = v.length;
			while (i-- > 0)
				if ((v[i] < 0) ? _pressNum != 0 : indexOf(_press, v[i]) >= 0)
                    return true;
			return false;
		}
		return (input < 0) ? _pressNum != 0 : indexOf(_press, input) >= 0;
	}

	/**
	 * If the input or key was released this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function released(input:Dynamic):Bool
	{
		if (Std.is(input, String))
		{
			var v:Array<Int> = _control.get(input);
			var i:Int = v.length;
			while (i-- > 0)
				if ((v[i] < 0) ? _releaseNum != 0 : indexOf(_release, v[i]) >= 0)
                    return true;
			return false;
		}
		return (input < 0) ? _releaseNum != 0 : indexOf(_release, input) >= 0;
	}

}
