package com.revolugame.age.core;

import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.display.IEntity;

interface IBehavior
{
	private var _entity : BasicEntity;
	var enabled(default, null): Bool;
	
	function update():Void;
	//function collide(pWidth: IEntity, pType: String):Void;
	
	function enable():Void;
	function disable():Void;
	
	function destroy():Void;
}
