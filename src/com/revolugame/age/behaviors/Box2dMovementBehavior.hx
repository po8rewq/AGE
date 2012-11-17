package com.revolugame.age.behaviors;

import com.revolugame.age.AgeData;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.managers.BehaviorsManager;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;

class Box2dMovementBehavior implements IBehavior
{
    private var _entity : BasicEntity;
    public var enabled(default, null) : Bool;

    private var _body : B2Body;
    private var _mToPx : Float; // Meters To Pixels
    private var _pxToM : Float; // Pixels To Meters
    
    //:://////////////////////////
    //::// For the main update
    //:://////////////////////////
    public static var b2world : B2World;
	public function globalUpdate():Void
	{
	    b2world.step (1 / 30, 6, 2);
	    b2world.clearForces ();
	}
    //:://////////////////////////
    
    /**
     *
     * @param pEntity
     * @param pMToPx
     * @param pDynamicEntity
     * @param pDensity : The density, usually in kg/m^2
     * @param pRestitution :  The restitution (elasticity) usually in the range [0,1]
     * @param pFriction :  The friction coefficient, usually in the range [0,1]
     */
    public function new(pEntity: BasicEntity, pMToPx: Int = 20, pDynamicEntity: Bool = false, ?pDensity: Float, ?pRestitution: Float, ?pFriction: Float)
	{        
        if(b2world == null)
		{
    		var gravity : B2Vec2 = new B2Vec2(0, 10.0); 
    	    b2world = new B2World (gravity, true);
    		BehaviorsManager.getInstance().registerUpdater(globalUpdate);
    	}
    
        _entity = pEntity;
        
        _mToPx = pMToPx;
        _pxToM = 1/pMToPx;
        
        var bodyDefinition = new B2BodyDef ();
		bodyDefinition.position.set( (pEntity.x + pEntity.halfWidth) * _pxToM, (pEntity.y + pEntity.halfHeight) * _pxToM);
		
		if(pDynamicEntity)
    		bodyDefinition.type = B2Body.b2_dynamicBody;
		
		var polygon = new B2PolygonShape ();
		polygon.setAsBox (pEntity.halfWidth * _pxToM, pEntity.halfHeight * _pxToM);
		
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.density = pDensity;
		fixtureDefinition.restitution = pRestitution;
		fixtureDefinition.friction = pFriction;
		fixtureDefinition.shape = polygon;
		
		_body = b2world.createBody (bodyDefinition);
		_body.createFixture (fixtureDefinition);
	}
	var v : B2Vec2;
	public function applyForce(pX: Float, pY: Float):Void
	{
	    if(v == null) v = new B2Vec2(pX * _mToPx, pY * _mToPx);
	    else
	    {
	        v.x = pX * _mToPx;
	        v.y = pY * _mToPx;
	    }
	    _body.applyForce(v, _body.getWorldCenter());
	}
	
	public function applyImpulse(pX: Float, pY: Float):Void
	{
	    if(v == null) v = new B2Vec2(pX * _mToPx, pY * _mToPx);
	    else
	    {
	        v.x = pX * _mToPx;
	        v.y = pY * _mToPx;
	    }
	    _body.applyImpulse(v, _body.getWorldCenter());
	}
	
	/**
	 * Update the position from those which are calculated by box2d
	 */
	public function update():Void
	{
	    #if cpp
        _entity.x = _body.getPosition().x * _mToPx;
        _entity.y = _body.getPosition().y * _mToPx;
        #else
        _entity.x = _body.getPosition().x * _mToPx - _entity.halfWidth;
        _entity.y = _body.getPosition().y * _mToPx - _entity.halfHeight;
        #end
        _entity.rotation = _body.getAngle() * 57.2957795;
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
		b2world.destroyBody(_body);
    }

}
