package com.revolugame.age.core.renderer;

import com.revolugame.age.AgeData;
import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.display.DrawingContext;
import com.revolugame.age.system.TileSheetData;

#if debug
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.display.Sprite;
#end

import flash.geom.Matrix;

/**
 * Renderer used by c++
 */
class TileSheetRenderer implements IRenderer
{

	public function new()
	{
	    
	}
	
	public function prepareRendering():Void
	{
    
	}
	
	public function render(spritemap: SpriteMap, context: DrawingContext):Void
	{
	    var ts : TileSheetData = spritemap.tilesheetdata;
	    
	    if(ts == null || ts.tilesheet == null) return;
			
		/** Reset drawing data */
		ts.resetData();
		
		for(data in context.data) 
		{			
	        /** Position */
	        ts.setPosition( data.position.x, data.position.y );
	            
	        /** Set current frame id */
	        //ts.setFrameId( spritemap.getFrameId() );
	        ts.setFrameId( data.frameId );
	            
	        /** Scale && rotation */
	//		ts.setTransform(data.scaleX, data.scaleY, data.rotation, data.mirrorX, data.mirrorY);
	            
	        /** rgb */
	//		ts.setRGB( data.red, data.green, data.blue );
	            
	        /** alpha */
	//        ts.setAlpha(data.alpha);            
        }
            
        ts.render();
	}

    #if debug
    public function renderDebugData(spr:Sprite)
    { // OSEF 
    }
    #end

}
