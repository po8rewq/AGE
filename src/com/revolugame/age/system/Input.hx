package com.revolugame.age.system;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

/**
 * From HaxePunk
 */
class Input
{
    public static var lastKey:Int;
   	public static var keyString:String = "";

    private static var _key:Array<Bool> = new Array<Bool>();
	private static var _keyNum:Int = 0;
	private static var _press:Array<Int> = new Array<Int>();
	private static var _pressNum:Int = 0;
	private static var _release:Array<Int> = new Array<Int>();
	private static var _releaseNum:Int = 0;
	private static var _control:Hash<Array<Int>> = new Hash<Array<Int>>();
	
	private static inline var kKeyStringMax = 100;

    public static function init(pStage: Stage)
    {
        pStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false,  2);
		pStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false,  2);
    }
    
    private static function onKeyDown(pEvt:KeyboardEvent)
    {
        var code:Int = lastKey = pEvt.keyCode;

		if (code == Key.BACKSPACE) 
		{
		    keyString = keyString.substr(0, keyString.length - 1);
		}
		else if ((code > 47 && code < 58) || (code > 64 && code < 91) || code == 32)
		{
			if (keyString.length > kKeyStringMax) keyString = keyString.substr(1);
			var char:String = String.fromCharCode(code);
        #if flash
			if (pEvt.shiftKey || Keyboard.capsLock) char = char.toUpperCase();
			else char = char.toLowerCase();
        #end
			keyString += char;
		}

		if (!_key[code])
		{
			_key[code] = true;
			_keyNum++;
			_press[_pressNum++] = code;
		}
    }
    
    private static function onKeyUp(pEvt:KeyboardEvent)
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
	 * Defines a new input.
	 * @param	name		String to map the input to.
	 * @param	keys		The keys to use for the Input.
	 */
	public static function define(name:String, keys:Array<Int>)
	{
		_control.set(name, keys);
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
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
			while (i-- > 0)
			{
				if (v[i] < 0)
				{
					if (_keyNum > 0) return true;
					continue;
				}
				if (_key[v[i]]) return true;
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
