package com.revolugame.age.core.renderer;

import com.revolugame.age.AgeData;
import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.display.DrawingContext;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Matrix;
import flash.geom.Rectangle;

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
	
	private var zeroPoint : Point;
	public function render(spritemap: SpriteMap, context: DrawingContext):Void
	{		
	    var data : Data = context.data;
	
	    var rect : Rectangle = spritemap.getRect();
	
		if(data.scaleX != 1 || data.scaleY != 1 || data.rotation != 0 || data.mirrorX || data.mirrorY)
		{
			_matrix.identity();
			
			if(data.rotation != 0)
			{
			    _matrix.translate( -spritemap.width*.5, -spritemap.height*.5);
				_matrix.rotate(data.rotation * 0.017453293);
				_matrix.translate( spritemap.width*.5, spritemap.height*.5);
			}
				
			// mirror
			var sclX : Float = data.scaleX * (data.mirrorX ? -1 : 1);
			var sclY : Float = data.scaleY * (data.mirrorY ? -1 : 1);
			if(sclX != 1 || sclY != 1)
			{
				_matrix.scale(sclX, sclY);
			}
				
/*			
			var buffer : BitmapData = new BitmapData( cast rect.width, cast rect.height, true, 0xffffffff);
			buffer.draw(spritemap.pixels, _matrix, null, null, null, AgeData.camera.antialiasing);
			
			if(zeroPoint == null) zeroPoint = new Point();
			AgeData.camera.copyPixels( buffer, buffer.rect, data.position, null, null, true );
			
		    buffer.dispose();
*/

			_matrix.translate(data.position.x, data.position.y);
			AgeData.camera.draw(spritemap.pixels, _matrix, null, null, null, AgeData.camera.antialiasing);			

		}
		else
		{
			AgeData.camera.copyPixels( spritemap.pixels, rect, data.position, null, null, true );
	    }
	}
	
	#if debug
	var pt : Point; // TEMPORARY FOR DEBUG
	var buffer : BitmapData;
	public function renderDebugData(spr:Sprite)
	{	
	if(spr == null || spr.width == 0 || spr.height == 0) return;
	
		if(pt == null) pt = new Point();
		if(buffer == null) buffer = new BitmapData( Math.round(spr.width), Math.round(spr.height), true, 0xff0000 );
		else buffer.fillRect( buffer.rect, 0x000000 );
	
		if(spr != null && spr.width > 0 && spr.height > 0)
		{
			buffer.draw(spr);
		
			AgeData.camera.copyPixels( buffer, buffer.rect, pt, null, null, true);
		}
	}
	#end

}
