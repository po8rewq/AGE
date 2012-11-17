package com.revolugame.age.display;

#if box2d
import com.revolugame.age.behaviors.Box2dMovementBehavior;

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
    public function new(pX: Float = 0, pY: Float = 0):Void
	{
		super(pX, pY);
		moveBy(pX, pY);
	}
	
	public function initBox2dStuff(pMToPx:Int = 20, pDynamicEntity: Bool = false, ?pDensity: Float, ?pRestitution: Float, ?pFriction: Float)
	{
		_b2dBehavior = new Box2dMovementBehavior(this, pMToPx, pDynamicEntity, pDensity, pRestitution, pFriction);
		addBehavior(_b2dBehavior);
	}
	
	public override function moveBy(pX:Float, pY:Float, ?pSweep:Bool = false)
	{
	 //   if(_b2dBehavior != null)
	 //       _b2dBehavior.setPos(pX, pY);
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
