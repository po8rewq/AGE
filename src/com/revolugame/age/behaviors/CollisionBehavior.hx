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
    			if(entity.isSolid && collide(_entity, entity))
    			{
    				_entity.x = tmpX; _entity.y = tmpY;
    				return entity;
    			}
    		}
    	}
    	_entity.x = tmpX; _entity.y = tmpY;
    	return null;
    }
    
    public function collide(pEntity1: Entity, pEntity2: Entity):Bool
    {
    	return ( collidePoint(pEntity1.x, pEntity1.y, pEntity2.getBounds()) ||
    			 collidePoint(pEntity1.x + pEntity1.width, pEntity1.y, pEntity2.getBounds() ) ||
    			 collidePoint(pEntity1.x, pEntity1.y + pEntity1.height, pEntity2.getBounds() ) ||
    			 collidePoint(pEntity1.x + pEntity1.width, pEntity1.y + pEntity1.height, pEntity2.getBounds() ) );
    }
    
    public function collidePoint(pX1: Float, pY1: Float, pRect: Rectangle):Bool
    {
    	return (pX1 >= pRect.x && pX1 <= pRect.x + pRect.width && pY1 >= pRect.y && pY1 <= pRect.y + pRect.height);
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
