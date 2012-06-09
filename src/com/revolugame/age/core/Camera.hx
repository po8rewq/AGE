package com.revolugame.age.core;

/**
 * ...
 * @author Adrien Fischer
 */

#if (cpp || neko)
typedef Camera = SpriteCamera;
#else
typedef Camera = BitmapCamera;
#end
