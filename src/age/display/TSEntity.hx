package age.display;

import age.geom.Rectangle;
import js.html.CanvasRenderingContext2D;
import age.display.TSContainer;

class TSEntity extends Entity
{
	var _frame : FrameData;
	var _layer : TSContainer;

	public function new(pCtr: TSContainer, pImgName: String)
	{			
		_layer = pCtr;
		changeImage(pImgName);
		super(_frame.rect.width, _frame.rect.height);		
	}

	public function changeImage(pImgName: String)
	{
		_frame = _layer.getFrame(pImgName);
	}

	public override function render(pContext: CanvasRenderingContext2D)
	{		
		pContext.save();

		pContext.drawImage( _layer.getTilesheet(), 
			_frame.rect.x, 
			_frame.rect.y, 
			_frame.rect.width, 
			_frame.rect.height, 
			x, y, 
			_frame.rect.width, _frame.rect.height);

		pContext.restore();
	}

	public override function destroy()
	{
		_frame = null;
		_layer = null;
		super.destroy();
	}
	
}
