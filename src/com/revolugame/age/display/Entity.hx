package com.revolugame.age.display;

import com.revolugame.age.core.IBehavior;
import com.revolugame.age.behaviors.MovementBehavior;
import com.revolugame.age.behaviors.CollisionBehavior;

import flash.geom.Rectangle;

/**
 * Graphical element with collisions detection and behaviors
 */
class Entity extends Image
{	
	/** All the behaviors of the actor */
    private var _behaviors : List<IBehavior>;
    
    /** Default behaviors */
    var _movement : MovementBehavior;
	var _collisions : CollisionBehavior;
	
	/** For the collisions detection */
	public var isSolid : Bool;
	
	/** */
	var _bounds : Rectangle;
    
    public function new(pX: Float = 0, pY: Float = 0):Void
	{
		super(pX, pY);
		
		_behaviors = new List();		
		addDefaultBehaviors();
		
		isSolid = true;
	}	
	
	private function addDefaultBehaviors():Void
	{
		/** Movements */
		_movement = new MovementBehavior(this);
		addBehavior(_movement, false);
		
		/** Collisions detections */
		_collisions = new CollisionBehavior(this);
		addBehavior(_collisions, false);
	}
	
	public override function update():Void
	{
		for(b in _behaviors)
			if(b.enabled)
				b.update();
		super.update();
	}
	
	/**
     * Add a specific behavior
     */
	public function addBehavior(b: IBehavior, ?pEnable: Bool = true):Void
	{
		_behaviors.push(b);
		if(pEnable)
			b.enable();
	}
	
	/**
    * Delete a behavior
     */
    public function removeBehavior(b: IBehavior):Void
    {
        b.disable();
        _behaviors.remove( b );
    }
    
    public function getBounds():Rectangle
    {
    	if(_bounds == null) 
    	{
    		_bounds = new Rectangle(x, y, width, height); 
    	}
    	else
    	{
    		_bounds.x = x;
    		_bounds.y = y;
    		_bounds.width = width;
    		_bounds.height = height;
    	}
    	return _bounds;
    }
    
    /**
	 * Moves the Entity by the amount, retaining integer values for its x and y.
	 * @param	pX		Horizontal offset.
	 * @param	pY		Vertical offset.
	 * @param	pType	An optional collision type to stop flush against upon collision.
	 * @param	pSweep	If sweeping should be used (prevents fast-moving objects from going through solidType).
	 */
    public function moveBy(pX:Float, pY:Float, ?pType: Dynamic = null, ?pSweep:Bool = false)
    {
    	if(pType != null)
    	{
    		// destination point
	    	var moveX : Float = Math.round(pX);
	    	var moveY : Float = Math.round(pY);
    	
    		var sign : Int;
    		var e : Entity;
    		
    		if( moveX != 0 )
    		{
    			if( _collisions.enabled && (pSweep || _collisions.collideWith(pType, x + moveX, y) != null) )
    			{
    				sign = AgeUtils.sign(pX);
    				while(moveX != 0)
    				{
    					if( (e = _collisions.collideWith(pType, x + sign, y)) != null )
    					{
    						_movement.stopMovementX(e);
    						break;
    					}
    					else
    					{
    						_movement.updatePosition(sign, 0);
    						moveX -= sign;
    					}
    				}
    			}
    			else
    			{
    				_movement.updatePosition(pX, 0);
    			}
    		}
    		
    		if( moveY != 0 )
    		{ 
    			if( _collisions.enabled && (pSweep || _collisions.collideWith(pType, x, y + moveY) != null) )
    			{
    				sign = AgeUtils.sign(moveY);
    				while(moveY != 0)
    				{
    					if( (e = _collisions.collideWith(pType, x, y + sign)) != null )
    					{
    						_movement.stopMovementY(e);
    						break;
    					}
    					else
    					{
    						_movement.updatePosition(0, sign);
    						moveY -= sign;
    					}
    				}
    			}
    			else
    			{
    				_movement.updatePosition(0, pY);
    			}
    		}
    	}
    	else
    	{
    		_movement.updatePosition(pX, pY);
    	}
    }
	
	public override function destroy():Void
	{
		for(b in _behaviors)
			b.destroy();
		super.destroy();
	}
}
