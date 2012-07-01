package com.revolugame.age.system;

#if (cpp || neko)
import nme.display.Tilesheet;
import nme.display.Graphics;

import com.revolugame.age.AgeData;
import com.revolugame.age.enums.DirectionsEnum;

/**
 * ...
 * @author Adrien Fischer
 */
class TileSheetData 
{
	/** */
	public var tilesheet : Tilesheet;
	
	/** Drawing data */
	private var data : Array<Float>;
	
	/** Drawing flags */
	private var flags : Int;
	
	/** Index in data */
	private var _currentIndex : Int;
	
	/** */
	private var useAdditive : Bool;
	
	public function new (pTilesheet: Tilesheet, ?pUseAdditive: Bool = false) 
	{
		tilesheet = pTilesheet;	
		useAdditive = pUseAdditive;
	}
	
	public function resetData()
	{
		data = new Array();
		flags = 0;
		_currentIndex = 0;
	}
	
	public function setPosition(pX: Float, pY: Float)
	{
		data[_currentIndex++] = pX;
		data[_currentIndex++] = pY;
	}
	
	public function setFrameId(id: Int)
	{
		data[_currentIndex++] = id;
	}

	public function setRGB(pRed: Float, pGreen: Float, pBlue: Float)
	{
		if(pRed != 1 || pGreen != 1 || pBlue != 1)
		{            
			flags |= Graphics.TILE_RGB;
	      	data[_currentIndex++] = pRed; 
			data[_currentIndex++] = pGreen;
			data[_currentIndex++] = pBlue;
		}
	}
	
	public function setAlpha(pAlpha: Float)
	{
		if(pAlpha != 1)
        {
          	flags |= Graphics.TILE_ALPHA;
	        data[_currentIndex++] = pAlpha;
	    }
	}
	
	public function setTransform(pScaleX: Float, pScaleY: Float, pRotation: Float, pMirrorX: Bool, pMirrorY: Bool):Void
	{
		flags |= Graphics.TILE_TRANS_2x2;
	
		var dirX:Int = pMirrorX ? -1 : 1;
		var dirY:Int = pMirrorY ? -1 : 1;
			
		if(pRotation != 0)
		{
			var cos : Float = Math.cos(-pRotation);
			var sin : Float = Math.sin(-pRotation);
			data[_currentIndex++] = dirX * cos * pScaleX;
			data[_currentIndex++] = dirY * sin * pScaleY;
			data[_currentIndex++] = -dirX * sin * pScaleX;
			data[_currentIndex++] = dirY * cos * pScaleY;
		}
		else
		{
			data[_currentIndex++] = dirX * pScaleX;
			data[_currentIndex++] = 0;
			data[_currentIndex++] = 0;
			data[_currentIndex++] = dirY * pScaleY;
		}
	}
	
	public function render()
	{
	    if(useAdditive)
			flags |= Graphics.TILE_BLEND_ADD;
	
		var cameraGraphics : Graphics = AgeData.camera.screen.graphics;		
		tilesheet.drawTiles( cameraGraphics, data, AgeData.camera.antialiasing, flags );
	}
	
	public function destroy()
	{ // FIXME : if there is multiple Entity using the same tilesheet ...
	//	tilesheet.nmeBitmap = null;
	//	tilesheet = null;
		data = null;
	}

}
#end
