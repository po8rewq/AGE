package ;

import com.revolugame.age.display.Entity;
import com.revolugame.age.enums.DirectionsEnum;
import com.revolugame.age.system.Input;
import com.revolugame.age.system.Key;

/**
 * ...
 * @author Adrien Fischer
 */
class Ship extends Entity
{
	private var _tmpX : Float;
	private var _tmpY : Float;
	private var _destX : Float;
	private var _destY : Float;
	private var _needToMove : Bool;
	
	public function new (pX: Float, pY : Float) 
	{
		super(pX, pY);
		
		movable = true;
		handleMouseEvents = true;
		
		_destX = _destY = 0;
		_needToMove = false;
		
		loadGraphic("gfx/ship.png", 37, 29);
		scale.x = 1.8;
		scale.y = 1.8;
		
		_movement.moveSpeed = 3;
		_movement.maxVelocity.x = 5;
		_movement.maxVelocity.y = 5;
		_movement.friction.x = _movement.friction.y = 0.9;
		
		Input.define('left', [Key.LEFT, Key.A]);
		Input.define('right', [Key.RIGHT, Key.D]);
		Input.define('up', [Key.UP, Key.Q]);
		Input.define('down', [Key.DOWN, Key.E]);
	}
	
	public function moveTo(pX: Float, pY: Float)
	{// trace( _destX+'/'+_destY + ' => ' + x+'/'+y);
		_tmpX = _destX;
		_tmpY = _destY;
	
		_destX = pX - width / 2;
		_destY = pY - height / 2;
	}
	
	public function stopMovement()
	{
		_needToMove = false;
	}
	
	public override function update()
	{	
		//if(Input.check('right') )
		if(_destX > x + 4)
		{
			_movement.moveToDirection( DirectionsEnum.RIGHT );
		}
		//else if(Input.check('left') )
		else if(_destX < x - 4)
		{
			_movement.moveToDirection( DirectionsEnum.LEFT );
		}
		else
			_movement.stopMovementX(null);
		
		//if(Input.check('down') )
		if(_destY > y + 4)
		{
			_movement.moveToDirection( DirectionsEnum.DOWN );
		}
		//else if(Input.check('up') )
		else if(_destY < y - 4)
		{
			_movement.moveToDirection( DirectionsEnum.UP );
		}
		else
			_movement.stopMovementY(null);
		
		super.update();
	}

}
