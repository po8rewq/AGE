package com.revolugame.age.behaviors;

import com.revolugame.age.display.Entity;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.AgeData;

import flash.geom.Rectangle;

class CollisionBehavior implements IBehavior
{
    private var _entity : Entity;
    public var enabled(default, null) : Bool;
    
    public function new(pEntity: Entity)
    {
        _entity = pEntity;
    }
    
    public function update()
    {
    
    }
        
    public function collideWith(pType: Dynamic, pX: Float, pY: Float):Entity
    {
    	if( AgeData.state == null ) return null;
    	
    	var tmpX : Float = _entity.x;
    	var tmpY : Float = _entity.y;
    	
    	_entity.x = pX;
    	_entity.y = pY;
    	
    	var entity : Entity;
    	for(e in AgeData.state.entities)
    	{
    		if( e != _entity && Std.is(e, Entity) )
    		{
    			entity = cast e;
    			if(entity.solid && collide(_entity, entity))
    			{
    				_entity.x = tmpX; _entity.y = tmpY;
    				return entity;
    			}
    		}
    	}
    	_entity.x = tmpX; _entity.y = tmpY;
    	return null;
    }
    
    /**
     * @return true if pEntity1 collide pEntity2
     */
    public function collide(pEntity1: Entity, pEntity2: Entity):Bool
    {
    	return pEntity1.getBounds().intersects( pEntity2.getBounds() );
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
    
    }
    
}
