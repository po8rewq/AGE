package com.revolugame.age.core;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.IEntity;

interface IBehavior
{
	var entity : Entity;
	var enabled : Bool;
	
	function update():Void;
	function collide(pWidth: IEntity, pType: String):Void;
	
	function enable():Void;
	function disable():Void;
}