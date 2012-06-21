package com.revolugame.age.core;

/**
 * ...
 * @author Adrien Fischer
 */

#if (cpp || neko)
import com.revolugame.age.core.renderer.TileSheetRenderer;
typedef Renderer = TileSheetRenderer;
#else
import com.revolugame.age.core.renderer.BitmapRenderer;
typedef Renderer = BitmapRenderer;
#end
