package ;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.SpriteMap;

/**
 * ...
 * @author Adrien Fischer
 */
class Frog extends Entity
{
	
	public function new (pX: Int, pY: Int) 
	{
		super(pX, pY);
		
	//	loadGraphic("assets/hero_0.png", 32, 32);		
		makeGraphic(32, 32, 0xFFFF0000);
		
	//	addAnimation('run', [2, 3, 4], 5, true);
	//	addAnimation('jump', [0, 5], 4, true);
	}
	
	public function play(n: String)
	{
		_spriteMap.play(n);
	}
	
	public override function update():Void
	{
		super.update();
	}

}
