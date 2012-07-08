package com.revolugame.age.core.renderer;

import com.revolugame.age.AgeData;
import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.display.DrawingContext;

import flash.geom.Matrix;


import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Point;

/**
 * Renderer used by flash
 */
class BitmapRenderer implements IRenderer
{
    var _matrix : Matrix;

	public function new()
	{
	    _matrix = new Matrix();
	}
	
	public function prepareRendering():Void
	{
        
	}
	
	public function render(spritemap: SpriteMap, context: DrawingContext):Void
	{		
		if( context.scaleX != 1 || context.scaleY != 1 || context.rotation != 0 || context.mirrorX || context.mirrorY)
		{
			_matrix.identity();
			
			if(context.rotation != 0)
				_matrix.rotate(context.rotation * 0.017453293);
				
			// mirror
			var sclX : Float = context.scaleX * (context.mirrorX ? -1 : 1);
			var sclY : Float = context.scaleY * (context.mirrorY ? -1 : 1);
			if(sclX != 1 || sclY != 1)
			{
				_matrix.scale(sclX, sclY);
			}
				
			_matrix.translate(context.position.x, context.position.y);
				
			AgeData.camera.draw( context.buffer, _matrix, null, null, null, AgeData.camera.antialiasing );
		}
		else
		{
			AgeData.camera.copyPixels( spritemap.pixels, spritemap.getRect(), context.position, null, null, true );
	    }
	}

}
