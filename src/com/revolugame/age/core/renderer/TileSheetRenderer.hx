package com.revolugame.age.core.renderer;

import com.revolugame.age.AgeData;
import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.display.DrawingContext;
import com.revolugame.age.system.TileSheetData;

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
			
		/** Reset drawing data */
		ts.resetData();
			
        /** Position */
        ts.setPosition( context.position.x, context.position.y );
            
        /** Set current frame id */
        ts.setFrameId( spritemap.getFrameId() );
            
        /** Scale && rotation */
		ts.setTransform(context.scaleX, context.scaleY, context.rotation, context.mirrorX, context.mirrorY);
            
        /** rgb */
//		ts.setRGB( _red, _green, _blue );
            
        /** alpha */
      ts.setAlpha(context.alpha);
            
        ts.render();
	}

}
