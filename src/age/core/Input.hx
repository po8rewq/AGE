package age.core;

//#if js
import js.Lib;
import js.Dom;
//#elseif flash
//import flash.events.Event;
//import flash.events.KeyboardEvent;
//import flash.display.DisplayObjectContainer;
//#end

/**
 * Based on haxepunk
 * https://github.com/HaxePunk/HaxePunk/blob/master/com/haxepunk/utils/Input.hx
 **/
class Input
{
//	#if js
	static var _root : Canvas;
//	#elseif flash
//	static var _root : DisplayObjectContainer;
//	#end
	
	static var _key:Array<Bool> = new Array<Bool>();
	static var _keyNum:Int = 0;

	static var _press:Array<Int> = new Array<Int>();
	static var _pressNum:Int = 0;

	static var _release:Array<Int> = new Array<Int>();
	static var _releaseNum:Int = 0;

	private static var _control:Hash<Array<Int>> = new Hash<Array<Int>>();

//	#if js
	public static function new(pRoot: Canvas)
//	#elseif flash
//	public static function new(pRoot: DisplayObjectContainer)
//	#end
	{
		_root = pRoot;
//		#if js
        Lib.document.body.onkeydown = onKeyDown;
        Lib.document.body.onkeyup = onKeyUp;
//		#elseif flash
//		_root.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//		_root.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
//		#end

        _root.onclick = onClick;
	}

    private static function onClick(pEvt: Event)
    {

    }
	
	private static function onKeyDown(pEvt: Event)
	{
		var code:Int = pEvt.keyCode;
		if (!_key[code])
		{
			_key[code] = true;
			_keyNum++;
			_press[_pressNum++] = code;
		}
	}
	
	private static function onKeyUp(pEvt: Event)
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
                if (v[i] < 0)
                {
                    if (_keyNum > 0) return true;
                    continue;
                }
                if (_key[v[i]] == true) return true;
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
			{
				if ((v[i] < 0) ? _pressNum != 0 : indexOf(_press, v[i]) >= 0) return true;
			}
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
			{
				if ((v[i] < 0) ? _releaseNum != 0 : indexOf(_release, v[i]) >= 0) return true;
			}
			return false;
		}
		return (input < 0) ? _releaseNum != 0 : indexOf(_release, input) >= 0;
	}

}
