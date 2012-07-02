package com.revolugame.age.behaviors;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.IEntity;
import com.revolugame.age.display.Group;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.AgeData;
import com.revolugame.age.system.AgeList;

import com.revolugame.age.enums.CollisionsEnum;

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
    	// change the position juste to check collisions
    	_entity.x = pX;
    	_entity.y = pY;
    	
    	var entity : Entity;
    	var list : AgeList = AgeData.state.firstEntity;
        while(list != null)
    	{
    		entity = handleGroupCollisions(list.object);
    		if(entity != null)
    		{
    		 	_entity.x = tmpX; _entity.y = tmpY;
    		 	return entity;
    		}
    		list = list.next;
    	}
    	_entity.x = tmpX; _entity.y = tmpY;
    	return null;
    }
    
    /**
     * Internal function to handle collisions between groups recursively
     */
    private function handleGroupCollisions(e:IEntity):Entity
    {
    	var entity : Entity; // valeur de retour
    	if( e != _entity && Std.is(e, Entity) )
    	{
    		entity = cast e;
    		if(entity.solid && collide(_entity, entity))
    			return entity;
    	}/*
    	else if( Std.is(e, Group) )
    	{
    	//	var entities : List<IEntity> = cast(e, Group).entities;
    	//	for(e2 in entities)
    	    var list : AgeList = cast(e, Group).firstEntity;
    	    while(list != null)
    		{
    			entity = handleGroupCollisions(list.object);
    			if(entity != null) return entity;
    			list = list.next;
    		}
    	}*/
    	return null;
    }
    
    /**
     * @return true if pEntity1 collide pEntity2
     */
    public function collide(pEntity1: Entity, pEntity2: Entity):Bool
    {
        var p1 : Rectangle = pEntity1.getBounds();
        var p2 : Rectangle = pEntity2.getBounds();
        
        return (pEntity1.solid && pEntity2.solid 
                && p1.x + p1.width > p2.x
                && p1.y + p1.height > p2.y
                && p1.x < p2.x + p2.width
                && p1.y < p2.y + p2.height);
        
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
