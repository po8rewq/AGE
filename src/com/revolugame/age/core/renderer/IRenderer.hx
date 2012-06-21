package com.revolugame.age.core.renderer;

import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.display.DrawingContext;

interface IRenderer
{

    /**
     * If there is something to do before rendering
     */
	function prepareRendering():Void;
	
	/**
	 *
	 */
	function render(spritemap: SpriteMap, context: DrawingContext):Void;

}
