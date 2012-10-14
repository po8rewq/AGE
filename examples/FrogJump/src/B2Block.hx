package ;

import com.revolugame.age.display.Box2dEntity;

/**
 * ...
 * @author Adrien Fischer
 */
class B2Block extends Box2dEntity
{
	
	public function new(pX: Int, pY: Int, pWidth : Int, pHeight: Int, ?pDynamicBody: Bool = true):Void
	{
		super(pX, pY, 20, pDynamicBody);
		makeGraphic( pWidth, pHeight, 0xFFFF0000 );
	}		

}
