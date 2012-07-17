package com.revolugame.age.display;

import nme.geom.Rectangle;

interface IEntity
{
	var visible : Bool;
	var dead : Bool;
	
	var x : Float;
	var y : Float;
	
	var parent : Group;
	
	function getBounds():Rectangle;
	function update(): Void;
	function render(): Void;
	function destroy(): Void;
}
