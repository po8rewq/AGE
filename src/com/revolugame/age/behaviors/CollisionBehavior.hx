package com.revolugame.age.behaviors;

import com.revolugame.age.display.Entity;
import com.revolugame.age.display.IEntity;
import com.revolugame.age.display.Group;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.AgeData;
import com.revolugame.age.system.AgeList;

import com.revolugame.age.enums.CollisionsEnum;
import com.revolugame.age.system.quadtree.QuadTreeEntity;

import flash.geom.Rectangle;

class CollisionBehavior implements IBehavior
{
    private var _entity : Entity;
    public var enabled(default, null) : Bool;
    
    public function new(pEntity: Entity)
    {
        _entity = pEntity;
    }
    
    public function update() {}
     
    private var _colliders : List<QuadTreeEntity>;   
    public function collideWith(pType: Dynamic, pX: Float, pY: Float):Entity
    {
    	if( AgeData.state == null ) return null;
    	
    	var tmpX : Float = _entity.x;
    	var tmpY : Float = _entity.y;
    	
    	// change the position just for collisions detection
    	_entity.x = pX;
    	_entity.y = pY;
    	
    	var en : Entity = null;
  
  		// Create or clear the potential colliders list
  		if(_colliders == null) _colliders = new List();
  		else _colliders.clear();
  
    	AgeData.quadtree.getEntityInRect( _entity.getBounds(), _colliders );
  		
    	var collideEntity : Entity;
    	// Check if the entity is colliding with one of te entity in the list
    	for(entity in _colliders)
    	{
    		collideEntity = entity.parent;
    		if(_entity != collideEntity && collide(_entity, collideEntity))
    			en = collideEntity;
    	}
    	_entity.x = tmpX; _entity.y = tmpY;
    	return en;
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
    	_entity = null;
    }
    
}
