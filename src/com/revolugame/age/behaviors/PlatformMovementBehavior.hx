package com.revolugame.age.behaviors;

import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.system.AgePoint;

class PlatformMovementBehavior extends BasicMovementBehavior
{
	/** Maximal number of jump (for example for a double jump) */
    private var _maxJump : Int;
    private var _currentJumpNumber : Int;
	
	public var gravity	: AgePoint;

	public var onGround(default, null): Bool;
	
	public function new(pEntity: BasicEntity, ?pGravityX:Float = 0.0, ?pGravityY:Float = 1.0, ?pMaxJump: Int = 1)
	{
		super(pEntity);
		_maxJump = pMaxJump;
		_currentJumpNumber = 0;
		
		gravity = new AgePoint(pGravityX, pGravityY);
		
		onGround = false;
	}
	
	private override function applyVelocity()
	{
		onGround = false;
		super.applyVelocity();
	}
	
	private function applyGravity()
	{
		//increase velocity based on gravity
		velocity.x += gravity.x;
		velocity.y += gravity.y;
	}
	
	public override function update()
	{
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;
		
		// On freine seulement si collision avec sol // TODO
		applyVelocity();
		applyGravity();
		checkMaxVelocity();
		
		// reset
		acceleration.x = acceleration.y = 0;
	}
	
	/**
	 *
	 */
    public function jump()
    {
		if(onGround && _currentJumpNumber < _maxJump)
		{
			acceleration.y = -AgeUtils.sign(gravity.y) * maxVelocity.y;
			_currentJumpNumber++;
		}
    }
	
	public override function stopMovementX()
	{
        velocity.x = 0;

		velocity.y *= friction.y;
		if (Math.abs(velocity.y) < 1) velocity.y = 0;
	}
	
	public override function stopMovementY()
	{
		if (velocity.y * AgeUtils.sign(gravity.y) > 0)
		{
			onGround = true;
			_currentJumpNumber = 0;
		}
		
		velocity.y = 0;

		velocity.x *= friction.x;
		if (Math.abs(velocity.x) < 0.5) velocity.x = 0;
	}	
	
	public override function idle():Bool
    {
		return onGround && super.idle();
    }
	
	public override function destroy()
	{
		// TODO
		super.destroy();
	}
	
}
