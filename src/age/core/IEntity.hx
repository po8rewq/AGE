package age.core;

interface IEntity
{
	var visible : Bool;
	var x : Float;
	var y : Float;

	var width : Int;
	var height : Int;

    var depth : Int;

	function update():Void;
	function render(pContext: CanvasRenderingContext2D):Void;
	function destroy():Void;
}