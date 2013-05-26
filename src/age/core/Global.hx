package age.core;

import age.display.State;
import js.Dom.HtmlDom;

class Global
{
    public static var engine : Engine;

    public static var currentState : State;
    public static var elapsed : Float;

    /**
     * N'a rien a foutre la
     **/
	public static function collide(pEntity: IEntity, pX: Float, pY: Float):Bool
	{
		if(pX >= pEntity.x && pX <= pEntity.x + pEntity.width && pY >= pEntity.y && pY <= pEntity.y + pEntity.height)
			return true;
		return false;
	}

}
