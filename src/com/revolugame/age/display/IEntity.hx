package com.revolugame.age.display;

interface IEntity
{
    private var _drawingContext : DrawingContext;

	var visible : Bool;
	var dead : Bool;
	
	var x : Float;
	var y : Float;
	
	var parent : Group;
	
	function update(): Void;
	function render(): Void;
	function destroy(): Void;
}
