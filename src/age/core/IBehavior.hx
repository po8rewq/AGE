package age.core;

import age.display.Entity;

interface IBehavior
{
	var entity: Entity;
	var activated : Bool;
	
	function update():Void;
	function destroy():Void;
}
