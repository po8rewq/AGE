package ;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.SpriteMap;
import com.revolugame.age.system.Input;
import com.revolugame.age.system.Key;

import flash.geom.Rectangle;

/**
 * ...
 * @author Adrien Fischer
 */
class Frog extends Entity
{	
	public function new (pX: Int, pY: Int) 
	{
		super(pX, pY);
		
		solid = true;
		movable = true;
		
		loadGraphic("gfx/hero_0.png", 32, 32);		
	//	makeGraphic(32, 32, 0xFFFF0000);
		
		addAnimation('idle', [0]);
		addAnimation('run', [2, 3, 4], 5, true);
		addAnimation('jump', [0, 5], 4, false);
	
	//	hitbox = new Rectangle(5,2,11,30);
		
		origin.x = 16;
		origin.y = 16;
	
		_movement.moveSpeed = 0.8;
		_movement.maxVelocity.x = 0.9 * 4;
		_movement.maxVelocity.y = 12;
		_movement.friction.x = 0.82; // floor friction
		_movement.friction.y = 0.99; // wall friction
		_movement.gravity.y = 1.0;
	
	    #if !mobile
		Input.define('left', [Key.LEFT, Key.A]);
		Input.define('right', [Key.RIGHT, Key.D]);
		Input.define("jump", [Key.UP, Key.W, Key.SPACE]);
		#end
	}
	
	public override function update():Void
	{	
	    #if !mobile
		if(Input.check('left'))
		{
			moveLeft();
		}
		else if(Input.check('right'))
		{
			moveRight();
		}
	
		if (Input.pressed("jump"))
		{
			jump();
		}
		#end
		
		if(_movement.idle())
			play('idle');
		
		super.update();
	}
	
	public function moveLeft() 
	{ 
    	_movement.moveLeft();
		mirrorX = true;
		play('run'); // TODO mirror + animation
	}
	
	public function moveRight() 
	{ 
	    _movement.moveRight();
		mirrorX = false;
		play('run');
	}
	
	public function jump() 
	{
	    _movement.jump();
	//	play('jump');
	}

}
