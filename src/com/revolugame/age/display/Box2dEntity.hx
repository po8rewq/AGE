package com.revolugame.age.display;

#if box2d
import com.revolugame.age.behaviors.Box2dMovementBehavior;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;

class Box2dEntity extends BasicEntity
{

    private var _b2dBehavior : Box2dMovementBehavior;

    /**
     * @param pX
     * @param pY
     * @param pMToPx meters to pixels
     * @param pDynamicEntity wheter the entity is dynamic or not
     */
    public function new(pX: Float = 0, pY: Float = 0, pMToPx:Int = 20, pDynamicEntity: Bool = false):Void
	{
		super(pX, pY);
		moveBy(pX, pY);
		
		// Init box2d stuff if needed
		if(AgeData.b2world == null)
		{
		    var gravity : B2Vec2 = new B2Vec2(0, 10.0);
    	    AgeData.b2world = new B2World (gravity, true);
		}
		
		_b2dBehavior = new Box2dMovementBehavior(this, pMToPx, pDynamicEntity);
		addBehavior(_b2dBehavior);
	}
	
	public override function moveBy(pX:Float, pY:Float, ?pSweep:Bool = false)
	{
	    if(_b2dBehavior != null)
	        _b2dBehavior.setPos(pX, pY);
	    super.moveBy(pX, pY, pSweep);
	}
	
	/**
	 * TODO drawdebug data
	 */
	//public override function makeGraphic(pWidth: UInt, pHeight: UInt, pColor: UInt):SpriteMap
	//{	
	//	return super.makeGraphic(pWidth, pHeight, pColor);
	//}

}
#end
