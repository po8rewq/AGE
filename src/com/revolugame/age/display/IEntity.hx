package com.revolugame.age.display;

interface IEntity
{
	var visible : Bool;
	var exists: Bool;
	var x : Int;
	var y : Int;
	
	function update(): Void;
	function render(): Void;
	function destroy(): Void;
}