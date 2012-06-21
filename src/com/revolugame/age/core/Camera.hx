package com.revolugame.age.core;

/**
 * ...
 * @author Adrien Fischer
 */

#if (cpp || neko)
import com.revolugame.age.core.camera.SpriteCamera;
typedef Camera = SpriteCamera;
#else
import com.revolugame.age.core.camera.BitmapCamera;
typedef Camera = BitmapCamera;
#end