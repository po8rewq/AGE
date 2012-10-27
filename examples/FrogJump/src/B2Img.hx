package ;

/**
 * ...
 * @author Adrien Fischer
 */
class B2Img extends B2
{
	
	public function new(pX: Int, pY: Int, pWidth : Int, pHeight: Int, ?pDynamicBody: Bool = true):Void
	{
		super(pX, pY);
		handleMouseEvents = true;
		loadGraphic("gfx/testOrange.png", 24, 25);		
		initBox2dStuff(30, pDynamicBody, 2, 0.4, 0.5);
	}

}