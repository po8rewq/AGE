package com.revolugame.age.behaviors;

import com.revolugame.age.display.Entity;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.system.AgePoint;

class MovementBehavior implements IBehavior
{
    private var _entity : Entity;
    public var enabled(default, null) : Bool;
    
    /** Maximal number of jump (for example for a double jump) */
    private var _maxJump : Int;
    private var _currentJumpNumber : Int;
    
    // Movement variables
    public var velocity		: AgePoint;
	public var acceleration	: AgePoint;
	public var friction		: AgePoint;
	public var maxVelocity	: AgePoint;
	public var gravity		: AgePoint;

	public var moveSpeed : Float;
	
	public var onGround(default, null): Bool;
	
    public function new(pEntity: Entity, ?pMaxJump: Int = 1):Void
    {
        _entity = pEntity;
        
        velocity = new AgePoint();
        acceleration = new AgePoint();
        friction = new AgePoint();
        maxVelocity = new AgePoint();
        gravity = new AgePoint();
        
        _maxJump = pMaxJump;
        _currentJumpNumber = 0;
        moveSpeed = 0;
        onGround = false;
    }
    
    public function update()
    {
    	// Apply acceleration and velocity
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;
		
		// Apply velocity
		onGround = false;
		_entity.moveBy( velocity.x, velocity.y, true);
		
		//increase velocity based on gravity
		velocity.x += gravity.x;
		velocity.y += gravity.y;
		
		// check for max velocity
		if (maxVelocity.x > 0 && Math.abs(velocity.x) > maxVelocity.x)
			velocity.x = maxVelocity.x * AgeUtils.sign(velocity.x);		
		if (maxVelocity.y > 0 && Math.abs(velocity.y) > maxVelocity.y)
			velocity.y = maxVelocity.y * AgeUtils.sign(velocity.y);
		
		// reset
		acceleration.x = acceleration.y = 0;
    }
    
    public function updatePosition(pX: Float, pY: Float)
    {
    	_entity.x += pX;
    	_entity.y += pY;
    }
    
    public function setPosition(pX: Float, pY: Float)
    {
    	_entity.x = pX;
    	_entity.y = pY;
    }
    
    public function moveTop():Void
    {
    	acceleration.y = -moveSpeed;
    }
    
    public function moveBottom():Void
    {
    	acceleration.y = moveSpeed;
    }
    
    public function moveLeft():Void
    {
    	acceleration.x = -moveSpeed;
    }
    
    public function moveRight()
    {
    	acceleration.x = moveSpeed;
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
    
    public function idle():Bool
    {
    	return velocity.x == 0 && onGround;
    }
    
    public function stopMovementY()
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

	public function stopMovementX()
	{		
		velocity.x = 0;

		velocity.y *= friction.y;
		if (Math.abs(velocity.y) < 1) velocity.y = 0;
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
    	velocity = null;
		acceleration = null;
		friction = null;
		maxVelocity = null;
		gravity = null;
    }

}
