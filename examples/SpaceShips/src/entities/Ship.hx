package entities;

import com.revolugame.age.display.QuadTreeEntity;
import com.revolugame.age.enums.DirectionsEnum;
import com.revolugame.age.ui.Input;
import com.revolugame.age.ui.Key;
import com.revolugame.age.AgeData;

import nme.Lib;

import managers.ShootManager;

/**
 * ...
 * @author Adrien Fischer
 */
class Ship extends QuadTreeEntity
{
	private var _tmpX : Float;
	private var _tmpY : Float;
	private var _destX : Float;
	private var _destY : Float;
	
	private var _canMove : Bool;
	
	private static var SHOOT_TIMER : Int = 100;
	private var _lastShoot : Float;
	
	public function new (pX: Float, pY : Float) 
	{
		super(pX, pY);
		
		movable = true;
		handleMouseEvents = true;
		
		_destX = _destY = 0;
		_canMove = false;
		
	//	loadGraphic("gfx/ship.png", 37, 29);
	//	scale.x = 1.8;
	//	scale.y = 1.8;
	
		loadGraphic("gfx/chopper.png", 104, 72);
		addAnimation('fly', [0, 1, 2, 3, 4], 15, true);
		
		_movement.moveSpeed = 3;
		_movement.maxVelocity.x = 5;
		_movement.maxVelocity.y = 5;
		_movement.friction.x = _movement.friction.y = 0.9;
		
		Input.define('left', [Key.LEFT, Key.A]);
		Input.define('right', [Key.RIGHT, Key.D]);
		Input.define('up', [Key.UP, Key.Q]);
		Input.define('down', [Key.DOWN, Key.E]);
		
		/** */
		_lastShoot = 0;
		
		solid = true;
	}
	
	public function moveTo(pX: Float, pY: Float)
	{// trace( _destX+'/'+_destY + ' => ' + x+'/'+y);
		_tmpX = _destX;
		_tmpY = _destY;
	
		_destX = pX - width / 2;
		_destY = pY - height / 2;
	}
	
	public function canMove(val:Bool)
	{
		_canMove = val;
	}
	
	public override function update()
	{	
		play('fly');
	
		if(_canMove) 
		{
	
			autoFire();
	
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
				_movement.stopMovementX();
			
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
				_movement.stopMovementY();
			
			}
		
		super.update();
	}
	
	private function autoFire():Void
	{
		var now : Float = Lib.getTimer();
		if(now - _lastShoot > SHOOT_TIMER)
		{
			_lastShoot = now;
			
			ShootManager.getInstance().add(AgeData.state, x + width*.5, y + height*.5);
		}
	}

}
