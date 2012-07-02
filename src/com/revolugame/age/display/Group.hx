package com.revolugame.age.display;

import com.revolugame.age.system.AgePoint;
import com.revolugame.age.system.AgeList;

class Group implements IEntity
{
    private var _position : AgePoint;

    public var parent : Group;

	public var visible : Bool;
	public var dead : Bool;
	
	public var x : Float;
	public var y : Float;
	
	public var numChildren(default, null):Int;
	public var firstEntity(default, null) : AgeList; // ref vers la premiere entité ajoutée
	private var _lastEntity : AgeList; // On garde une ref vers le dernier pour pas avoir a tout reparcourir
	
	private var _drawingContext : DrawingContext; // NULL

	public function new()
	{
		visible = true;
		dead = false;
		x = 0;
		y = 0;
		numChildren = 0;
	}
	
	/**
     * Update all entities in the screen
     */
	public function update():Void
	{
        var entity = firstEntity;
        while(entity != null)
        {
            if(!dead)
            	entity.object.update();
            entity = entity.next;
        }
	}
	
	/**
	 * Render all the entities on screen
	 */
	public function render():Void
	{
        var entity = firstEntity;
        while(entity != null)
        {
	        if(visible && !dead)
	        	entity.object.render();
	        entity = entity.next;
	    }
	}
	
	/**
	 * Clear all data
	 */
	public function destroy() : Void
	{
        var entity = firstEntity;
        while(entity != null)
	        entity.object.destroy();
	    firstEntity.destroy();
	    firstEntity = null;
	    numChildren = 0;
	}
	
	/**
	 * Add the entity on the screen
	 * @param pEntity
	 */
	public function add(pEntity: IEntity):Void
	{
	    pEntity.parent = this;
	    
	    if(firstEntity == null)
	    {
	        firstEntity = new AgeList(pEntity);
	        _lastEntity = firstEntity;
	    }
	    else
	    {
	        _lastEntity.next = new AgeList(pEntity);
	        _lastEntity = _lastEntity.next; 
	    }
	    numChildren++;
	}
	
	/**
	 * Return the absolute position of this group
	 */
	public function getAbsolutePosition():AgePoint
	{
	    if(_position == null) 
    		_position = new AgePoint(0, 0);
        
        var p : AgePoint = null;
        if(parent != null) p = parent.getAbsolutePosition();
        
    	_position.x = x + (parent != null ? p.x : 0);
	    _position.y = y + (parent != null ? p.y : 0);
    	
    	return _position;
	}
	
	/**
	 * Remove the entity from the screen
	 * @param pEntity
	 */
	public function remove(pEntity: IEntity):Void
	{	    
	    var prev : AgeList = null;
	    var entity : AgeList = firstEntity;
	    while(entity != null)
	    {
	        if(entity.object == pEntity)
	        {
	            if(prev != null)
	            {
	                if(entity.next != null)
	                {   // cas classique avec un precédent et un suivant
    	                prev.next = entity.next;
    	            }
    	            else
    	            {   // cas du dernier
    	                _lastEntity = prev;
    	                prev.next = null;
    	            }
	            }
	            else
	            {   // On est dans le cas du #1 de la liste
	                firstEntity = entity.next;
	            }
	            break;
	        }
	        prev = entity;
	        entity = entity.next;
	    }
	    pEntity.destroy();
	    numChildren--;
	}

}
