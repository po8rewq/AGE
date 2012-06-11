package com.revolugame.age.display;

interface IEntity
{
	var visible : Bool;
	var dead : Bool;
	
	var x : Float;
	var y : Float;
	
	function update(): Void;
	function render(): Void;
	function destroy(): Void;
}