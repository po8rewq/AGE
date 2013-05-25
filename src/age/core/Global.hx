package age.core;

import age.display.State;
import js.Dom.HtmlDom;

class Global
{

	public static var dom : HtmlDom;
	public static var context : CanvasRenderingContext2D;
    public static var currentState : State;

    public static var elapsed : Float;

	public static function collide(pEntity: IEntity, pX: Float, pY: Float):Bool
	{
		if(pX >= pEntity.x && pX <= pEntity.x + pEntity.width && pY >= pEntity.y && pY <= pEntity.y + pEntity.height)
			return true;
		return false;
	}

}
