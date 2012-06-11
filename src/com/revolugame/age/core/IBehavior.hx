package com.revolugame.age.core;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.IEntity;

interface IBehavior
{
	private var _entity : Entity;
	var enabled(default, null): Bool;
	
	function update():Void;
	//function collide(pWidth: IEntity, pType: String):Void;
	
	function enable():Void;
	function disable():Void;
	
	function destroy():Void;
}