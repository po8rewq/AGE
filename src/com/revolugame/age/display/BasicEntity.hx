package com.revolugame.age.display;

import com.revolugame.age.core.IBehavior;

class BasicEntity extends Image
{
   	/** All the behaviors of the actor */
    private var _behaviors : List<IBehavior>;
    
    public function new(pX: Float = 0, pY: Float = 0):Void
    {
        super(pX, pY);
		_behaviors = new List();
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
	
	public function hasBehavior(pBehavior : IBehavior):Bool
	{
	    for(b in _behaviors)
	        if(b == pBehavior)
	            return true;
	    return false;
	}
	
	/**
    * Delete a behavior
     */
    public function removeBehavior(b: IBehavior):Void
    {
        b.disable();
        _behaviors.remove( b );
    }
    
    public override function destroy():Void
    {
		for(b in _behaviors)
			b.destroy();
		super.destroy();
    }
    
    public function moveBy(pX:Float, pY:Float, ?pSweep:Bool = false)
    {
        x = pX;
        y = pY;
    }

}
