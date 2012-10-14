package com.revolugame.age.behaviors;

import com.revolugame.age.AgeData;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.display.BasicEntity;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;

class Box2dMovementBehavior extends BasicMovementBehavior
{
    private var _body : B2Body;
    private var _mToPx : Float; // Meters To Pixels
    private var _pxToM : Float; // Pixels To Meters
    
    public function new(pEntity: BasicEntity, pMToPx: Int = 20, pDynamicEntity: Bool = false)
	{
        super(pEntity);
        
        _mToPx = pMToPx;
        _pxToM = 1/pMToPx;
        
   //     trace('init pos: '+pEntity.x+', '+pEntity.y);
        
        var bodyDefinition = new B2BodyDef ();
		bodyDefinition.position.set(pEntity.x * _pxToM, pEntity.y * _pxToM);
		
		if(pDynamicEntity)
    		bodyDefinition.type = B2Body.b2_dynamicBody;
		
		var polygon = new B2PolygonShape ();
		polygon.setAsBox ((pEntity.width * 0.5) * _pxToM, (pEntity.height * 0.5) * _pxToM);
		
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = polygon;
		
		_body = AgeData.b2world.createBody (bodyDefinition);
		_body.createFixture (fixtureDefinition);
	}
	
	private var v : B2Vec2;
	public function setPos(pX: Float, pY : Float):Void
	{
	    if(v == null) 
	    {
	        v = new B2Vec2(pX * _pxToM, pY * _pxToM);
	    }
	    else
	    {
	        v.x = pX * _pxToM;
	        v.y = pY * _pxToM;
	    }
	    
	    _body.setPosition( v );
	}
	
	/**
	 * Update the position from those which are calculated by box2d
	 */
	public override function update():Void
	{
        _entity.x = _body.getPosition().x * _mToPx;
        _entity.y = _body.getPosition().y * _mToPx;
//        _entity.rotation = _redBall.getAngle() * RADIANS_TO_DEGREES;
        
//        trace('current pos: '+pEntity.x+', '+pEntity.y);
	}
    
    public override function destroy()
    {
		// TODO
		super.destroy();
    }

}
