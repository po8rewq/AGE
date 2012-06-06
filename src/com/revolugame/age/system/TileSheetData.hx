package com.revolugame.age.system;

#if (cpp || neko)
import nme.display.Tilesheet;
import nme.display.Graphics;

import com.revolugame.age.AgeData;

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
	
	public function new (pTilesheet: Tilesheet) 
	{
		tilesheet = pTilesheet;		
	}
	
	public function resetData()
	{
		data = new Array();
		flags = 0;
		_currentIndex = 0;
	}
	
	public function setPosition(pX: Int, pY: Int)
	{
		data[_currentIndex++] = pX;
		data[_currentIndex++] = pY;
	}
	
	public function setFrameId(id: Int)
	{
		data[_currentIndex++] = id;
	}
	
	public function setScale(scaleX: Float, scaleY: Float)
	{
	 	if(scaleX != 1)
        {
        	flags |= Graphics.TILE_SCALE;
	        data[_currentIndex++] = scaleX;
		}
	}
	
	public function setRotation(pAngle : Float)
	{
		if(pAngle != 0)
		{
			flags |= Graphics.TILE_ROTATION;
			data[_currentIndex++] = -pAngle * 0.017453293;
		}
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
	
	public function render()
	{
		AgeData.camera.screen.graphics.drawTiles( tilesheet, data, AgeData.camera.antialiasing, flags );
	}

}
#end