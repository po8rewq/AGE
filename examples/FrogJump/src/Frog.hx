package ;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.system.Input;
import com.revolugame.age.system.Key;

/**
 * ...
 * @author Adrien Fischer
 */
class Frog extends Entity
{	
	public function new (pX: Int, pY: Int) 
	{
		super(pX, pY);
		
		loadGraphic("gfx/hero_0.png", 32, 32);		
	//	makeGraphic(32, 32, 0xFFFF0000);
		
		addAnimation('idle', [0]);
		addAnimation('run', [2, 3, 4], 5, true);
		addAnimation('jump', [0, 5], 4, false);
	
		_movement.moveSpeed = 0.8;
		_movement.maxVelocity.x = 0.8 * 4;
		_movement.maxVelocity.y = 15;
		_movement.friction.x = 0.82; // floor friction
		_movement.friction.y = 0.99; // wall friction
		_movement.gravity.y = 1.5;
	
		Input.define('left', [Key.LEFT, Key.A]);
		Input.define('right', [Key.RIGHT, Key.D]);
		Input.define("jump", [Key.UP, Key.W, Key.SPACE]);
		
		_collisions.enable();
		_movement.enable();
	}
	
	public override function update():Void
	{	
		if(Input.check('left'))
		{
			_movement.moveLeft();
//			mirrorX = true;
			play('run'); // TODO mirror + animation
		}
		else if(Input.check('right'))
		{
			_movement.moveRight();
//			mirrorX = false;
			play('run');
		}
	//	else
	//	{
	//		play('idle');
	//	}
	
		if (Input.pressed("jump"))
		{
			_movement.jump();
			play('jump');
		}
		
		if(_movement.idle())
			play('idle');
		
		super.update();
	}

}
