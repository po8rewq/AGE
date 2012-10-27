package ;

/**
 * ...
 * @author Adrien Fischer
 */
class B2Wall extends B2
{
	
	public function new(pX: Int, pY: Int, pWidth : Int, pHeight: Int, ?pDynamicBody: Bool = true):Void
	{
		super(pX, pY);
		makeGraphic( pWidth, pHeight, 0xFFFF0000 );
		initBox2dStuff(30, pDynamicBody, 2, 0.4, 0.5);
	}

}