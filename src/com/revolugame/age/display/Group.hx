package com.revolugame.age.display;

import nme.geom.Rectangle;

class Group implements IEntity
{
    private var _bounds : Rectangle;

    public var parent : Group;

	public var visible : Bool;
	public var dead : Bool;
	
	public var x : Float;
	public var y : Float;
	
	public var entities(default, null) : Array<IEntity>;
	
	private var _drawingContext : DrawingContext; // NULL

	public function new()
	{
		entities = new Array();
		visible = true;
		dead = false;
		x = 0;
		y = 0;
	}
	
	/**
     * Update all entities in the screen
     */
	public function update():Void
	{
		var i : Int = 0;
        var entity : IEntity;
        
        // permet de re evaluer la longueur du tableau a chaque boucle et eviter une exception
        while(i < entities.length) 
        {
            entity = entities[i];
            if(!dead)
            	entity.update();
            ++i;
        }
	}
	
	/**
	 * Render all the entities on screen
	 */
	public function render():Void
	{
		var i : Int = 0;
	    var len : Int = entities.length;
	    var entity : IEntity;
	    while(i < len)
	    {
	        entity = entities[i];
	        if(visible && !dead)
	        	entity.render();
	        ++i;
	    }
	}
	
	/**
	 * Clear all data
	 */
	public function destroy() : Void
	{
	    var entity : IEntity;
	    while(entities.length > 0)
	    {
	        entity = entities.pop();
	        entity.destroy();
	    }
	}
	
	/**
	 * Add the entity on the screen
	 * @param pEntity
	 */
	public function add(pEntity: IEntity):Void
	{
	    entities.push(pEntity);
	    pEntity.parent = this;
	}
	
	public function getBounds():Rectangle
	{
	    if(_bounds == null) 
    		_bounds = new Rectangle(0, 0, 0, 0);
        
        var p : Rectangle = null;
        if(parent != null) p = parent.getBounds();
        
    	_bounds.x = x + (parent != null ? p.x : 0);
	    _bounds.y = y + (parent != null ? p.y : 0);
    	
    	return _bounds;
	}
	
	/**
	 * Remove the entity from the screen
	 * @param pEntity
	 */
	public function remove(pEntity: IEntity):Void
	{
	    entities.remove(pEntity);
	    pEntity.destroy();
	}
	
	public var numChildren(getNumChildren, null):Int;
	private function getNumChildren():Int
	{
	    return entities.length;
	}

}
