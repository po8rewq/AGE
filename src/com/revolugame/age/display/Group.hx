package com.revolugame.age.display;

import com.revolugame.age.system.AgePoint;
import nme.geom.Rectangle;

class Group implements IEntity
{
    private var _position : AgePoint;

    public var parent : Group;

	public var visible : Bool;
	public var dead : Bool;
	
	public var x : Float;
	public var y : Float;
	
	public var entities : List<IEntity>;

	public function new()
	{
		visible = true;
		dead = false;
		x = 0;
		y = 0;
		entities = new List();
	}
	
	/**
     * Update all entities in the screen
     */
	public function update():Void
	{
        for(entity in entities)
            if(!dead)
            	entity.update();
	}
	
	/**
	 * Render all the entities on screen
	 */
	public function render():Void
	{
        for(entity in entities)
	        if(visible && !dead)
	        	entity.render();
	}
	
	/**
	 * Clear all data
	 */
	public function destroy() : Void
	{
        for(entity in entities)
	        entity.destroy();
	}
	
	/**
	 * Add the entity on the screen
	 * @param pEntity
	 */
	public function add(pEntity: IEntity):Void
	{
	    pEntity.parent = this;
	    entities.add(pEntity);
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
	 * @param pDestroy if you want to destroy this entity, and not just remove it from the stage
	 */
	public function remove(pEntity: IEntity, ?pDestroy: Bool = true):Void
	{	    
	    entities.remove(pEntity);
	    if(pDestroy)
    	    pEntity.destroy();

   	    if(AgeData.quadtree != null && Std.is(pEntity, QuadTreeEntity) && cast(pEntity, QuadTreeEntity).solid)
	    	AgeData.quadtree.remove( cast(pEntity, QuadTreeEntity).quadTreeObject );
	}
	
	public function getBounds():Rectangle { return null; }

}
