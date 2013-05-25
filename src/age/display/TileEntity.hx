package age.display;

import age.geom.Rectangle;

class TileEntity extends Entity
{
	var _zone : Rectangle;
	
	public function new(pZone: Rectangle)
	{	
		super(pZone.width, pZone.height);
		
		_zone = pZone;
		
		// TODO
	}	
	
}
