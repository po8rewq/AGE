package com.revolugame.age.behaviors;

import com.revolugame.age.core.IBehavior;
import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.enums.DirectionsEnum;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.AgeUtils;

class BasicMovementBehavior implements IBehavior
{
	private var _entity : BasicEntity;
    public var enabled(default, null) : Bool;
	
	/** Movement varaibles */
	public var acceleration	: AgePoint;
	public var moveSpeed    : Float;
	public var velocity	    : AgePoint;
	public var maxVelocity	: AgePoint;
	public var friction		: AgePoint;
	
	public function new(pEntity: BasicEntity)
	{
		_entity = pEntity;
		
		acceleration = new AgePoint();		
		velocity = new AgePoint();
		maxVelocity = new AgePoint();
		friction = new AgePoint();
		moveSpeed = 0;
	}
	
	public function update()
	{
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;
		
		if (velocity.x != 0 || velocity.y != 0)
		{
			applyVelocity();
			checkMaxVelocity();
		}
		
		// On freine si on a pas de deplacement
		if (acceleration.x == 0)
			velocity.x *= friction.x;
		if (acceleration.y == 0)
			velocity.y *= friction.y;
		
		// reset
		acceleration.x = acceleration.y = 0;
	}
	
	/**
	 * Stop the movement on the Y axe
	 * @param	pE
	 */
	public function stopMovementY()
	{
		velocity.y = 0;
	}
	
	/**
	 * Stop the movement on the X axe
	 * @param	pE
	 */
	public function stopMovementX()
	{
		velocity.x = 0;
	}
	
	/**
	 * Move the entity to a specified direction
	 * @param	pDir
	 */
	public function moveToDirection( pDir: DirectionsEnum )
	{
		switch(pDir)
		{
			case DirectionsEnum.UP      : acceleration.y = -moveSpeed;
			case DirectionsEnum.DOWN    : acceleration.y = moveSpeed;
			case DirectionsEnum.LEFT    : acceleration.x = -moveSpeed;
			case DirectionsEnum.RIGHT   : acceleration.x = moveSpeed;
		}
	}
	
	/**
	 * 
	 */
	private function applyVelocity()
	{
		_entity.moveBy( velocity.x, velocity.y, true);
	}
	
	/**
	 * 
	 */
	private function checkMaxVelocity()
	{
		if (maxVelocity.x > 0 && Math.abs(velocity.x) > maxVelocity.x)
			velocity.x = maxVelocity.x * AgeUtils.sign(velocity.x);

		if (maxVelocity.y > 0 && Math.abs(velocity.y) > maxVelocity.y)
			velocity.y = maxVelocity.y * AgeUtils.sign(velocity.y);
	}
	
	public function idle():Bool
    {
		return velocity.x == 0;
    }
	
	public function enable()
    {
		enabled = true;
    }
    
    public function disable()
    {
		enabled = false;
    }
    
    public function destroy()
    {
		// TODO
    }
	
}
