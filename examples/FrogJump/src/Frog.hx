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
		
		_spriteMap = new SpriteMap("assets/hero_0.png", 32, 32);
		_spriteMap.add('run', [2, 3, 4], 5, true);
		_spriteMap.add('jump', [0, 5], 4, true);
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
