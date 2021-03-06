package age.core;

import age.display.EntityContainer;
import js.html.CanvasRenderingContext2D;

interface IEntity
{
	var visible : Bool;
	var x : Int;
	var y : Int;

	var width : Int;
	var height : Int;

    var depth : Int;

	function update():Void;
	function render(pContext: CanvasRenderingContext2D):Void;
	function destroy():Void;
}