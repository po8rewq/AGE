package com.revolugame.age.behaviors;

import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.display.ICollideEntity;
import com.revolugame.age.display.Group;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.AgeData;
import com.revolugame.age.system.AgeList;
import com.revolugame.age.enums.CollisionsEnum;
import com.revolugame.age.system.quadtree.QuadTreeObject;

import nme.geom.Rectangle;
import com.revolugame.age.enums.CollisionsEnum;

class CollisionBehavior implements IBehavior
{
    private var _entity : BasicEntity;
    public var enabled(default, null) : Bool;
    
    /** Collisions type */
    public var type : Int; // use CollisionsEnum.getIntValue()
    
    /** Helper to store colliders during a check */
    private var _colliders : List<ICollideEntity>;
    
    public function new(pEntity: BasicEntity)
    {
        _entity = pEntity;
        type = CollisionsEnum.ANY;
    }
    
    public function update() {}
    
    /**
     * @param pX, pY : where to check
     * @param pDirection : from where the entity is colliding
     */
    public function collideWith(pX: Float, pY: Float, pDirection : Int):ICollideEntity
    {    	
    	var tmpX : Float = _entity.x,
    		tmpY : Float = _entity.y;
    	
    	// change the position just for collisions detection
    	_entity.x = pX;
    	_entity.y = pY;
    	
    	var en : ICollideEntity = null;
  
  		// Create or clear the potential colliders list
  		if(_colliders == null) _colliders = new List();
  		else _colliders.clear();

		// get potential colliders
    	AgeData.quadtree.getEntityInRect( _entity.getBounds(), cast _colliders );
  		
  		var tmp : ICollideEntity;
    	// Check if the entity is colliding with one of the entity in the list
    	for(entity in _colliders)
    	{
    		tmp = cast _entity;
    		if(tmp != entity && collide(tmp, entity))
    			en = entity;
    	}
    	
    	_entity.x = tmpX; _entity.y = tmpY;
    	return en;
    }
    
    /**
     * @return true if pEntity1 collide with pEntity2
     */
    public function collide(pEntity1: ICollideEntity, pEntity2: ICollideEntity):Bool
    {
        var p1 : Rectangle = pEntity1.getBounds(),
        	p2 : Rectangle = pEntity2.getBounds();
        
        // cas any
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
