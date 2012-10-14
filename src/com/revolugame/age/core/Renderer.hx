package com.revolugame.age.core;

/**
 * ...
 * @author Adrien Fischer
 */

#if (cpp || neko)
import com.revolugame.age.core.renderer.TileSheetRenderer;
typedef Renderer = TileSheetRenderer;
#elseif html
import com.revolugame.age.core.renderer.Html5Renderer;
typedef Renderer = Html5Renderer;
#elseif flash11
import com.revolugame.age.core.renderer.Stage3DRenderer;
typedef Renderer = Stage3DRenderer;
#else
import com.revolugame.age.core.renderer.BitmapRenderer;
typedef Renderer = BitmapRenderer;
#end
