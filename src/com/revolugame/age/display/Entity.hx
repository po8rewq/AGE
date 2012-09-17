package com.revolugame.age.display;

import com.revolugame.age.behaviors.BasicMovementBehavior;
import com.revolugame.age.behaviors.CollisionBehavior;
import com.revolugame.age.core.IBehavior;
import com.revolugame.age.display.ICollideEntity;
import com.revolugame.age.enums.CollisionsEnum;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.system.quadtree.QuadTree;
import com.revolugame.age.system.quadtree.QuadTreeEntity;

import flash.geom.Rectangle;

/**
 * Graphical element with collisions detection and behaviors
 */
class Entity extends Image, implements ICollideEntity
{	
	/** All the behaviors of the actor */
    private var _behaviors : List<IBehavior>;
    
    /** Default behaviors */
    var _movement : BasicMovementBehavior;
	var _collisions : CollisionBehavior;
	
	/** For the collisions detection */
	public var solid(getIsSolid, setIsSolid) : Bool;
	
	/** For the movements */
	public var movable(getIsMovable, setIsMovable) : Bool;
	
	/** */
	public var hitbox : Rectangle;
	
	/** Necessaire pour la gestion des collisions */
	public var quadTreeEntity : QuadTreeEntity;
    
    public function new(pX: Float = 0, pY: Float = 0):Void
	{
		super(pX, pY);
		
		_behaviors = new List();
	}
	
	public override function update():Void
	{
		for(b in _behaviors)
			if(b.enabled)
				b.update();
		super.update();
	}
	
	/**
     * Add a specific behavior
     */
	public function addBehavior(b: IBehavior, ?pEnable: Bool = true):Void
	{
		_behaviors.push(b);
		if(pEnable)
			b.enable();
	}
	
	public function hasBehavior(pBehavior : IBehavior):Bool
	{
	    for(b in _behaviors)
	        if(b == pBehavior)
	            return true;
	    return false;
	}
	
	/**
    * Delete a behavior
     */
    public function removeBehavior(b: IBehavior):Void
    {
        b.disable();
        _behaviors.remove( b );
    }
    
    public override function getBounds():Rectangle
    {
    	if(_bounds == null) 
    		_bounds = new Rectangle(0, 0, 0, 0);
    	
    	var p : AgePoint = null;
        if(parent != null) p = parent.getAbsolutePosition();
    	
    	if(hitbox != null)
    	{
    		_bounds.x = x + hitbox.x + (parent != null ? p.x : 0);
	    	_bounds.y = y + hitbox.y + (parent != null ? p.y : 0);
	    	_bounds.width = hitbox.width * scale.x;
	    	_bounds.height = hitbox.height * scale.y;
    	}
    	else
    	{
	        _bounds.x = x + (parent != null ? p.x : 0);
    	    _bounds.y = y + (parent != null ? p.y : 0);
	    	_bounds.width = width * scale.x;
	    	_bounds.height = height * scale.y;
    	}
    	return _bounds;
    }
    
    /**
	 * Moves the Entity by the amount, retaining integer values for its x and y.
	 * @param	pX		Horizontal offset.
	 * @param	pY		Vertical offset.
	 * @param	pType	An optional collision type to stop flush against upon collision.
	 * @param	pSweep	If sweeping should be used (prevents fast-moving objects from going through solidType).
	 */
    public function moveBy(pX:Float, pY:Float, ?pSweep:Bool = false)
    {
    	if(!movable) return;
    
    	// destination point
	    var moveX : Int = Math.round(pX),
	        moveY : Int = Math.round(pY),
    	    sign : Int,
    	    e : ICollideEntity,
    	    from : Int; // from where the entity is coming
    		
    	if( moveX != 0 )
    	{
    	    sign = AgeUtils.sign(pX);
    	    from = (sign > 0 ? CollisionsEnum.LEFT : CollisionsEnum.RIGHT);
    		if( _collisions != null && _collisions.enabled && (pSweep || _collisions.collideWith(x + moveX, y, from) != null) )
    		{
    			while(moveX != 0)
    			{
    				if( (e = _collisions.collideWith(x + sign, y, from )) != null )
    				{
    					_movement.stopMovementX();
    					break;
    				}
    				else
    				{
    					x += sign;
    					moveX -= sign;
    				}
    			}
    		}
    		else
    		{
    			x += pX;
    		}
    	}
    		
    	if( moveY != 0 )
    	{ 
    	    sign = AgeUtils.sign(moveY);
    	    from = (sign > 0 ? CollisionsEnum.UP : CollisionsEnum.DOWN);
    		if( _collisions != null && _collisions.enabled && (pSweep || _collisions.collideWith(x, y + moveY, from) != null) )
    		{
    			while(moveY != 0)
    			{
    				if( (e = _collisions.collideWith(x, y + sign, from )) != null )
    				{
    					_movement.stopMovementY();
    					break;
    				}
    				else
    				{
    					y += sign;
    					moveY -= sign;
    				}
    			}
    		}
    		else
    		{
    			y += pY;
    		}
    	}
    }
	
	public override function destroy():Void
	{
		for(b in _behaviors)
			b.destroy();
			
		if(quadTreeEntity != null)
		{
		    quadTreeEntity.destroy();
		    quadTreeEntity = null;
		}
		
		super.destroy();
	}
	
	/** 
	 * Getters / Settesr for the default behaviors
	 */
	private function getIsSolid():Bool
	{
		return _collisions != null && _collisions.enabled;
	}
	
	private function setIsSolid(val:Bool):Bool
	{
		if(_collisions == null)
		{
			_collisions = new CollisionBehavior(this);
			addBehavior(_collisions);
			
			initQuadTree();
		}
		else if(val && !_collisions.enabled)
		{
			_collisions.enable();
			
			initQuadTree();
		}
		else if(!val && _collisions.enabled)
		{
			_collisions.disable();
			if(quadTreeEntity != null)
				AgeData.quadtree.remove(quadTreeEntity);
		}
		else if(val && quadTreeEntity != null)
		{
			if(AgeData.quadtree.remove(quadTreeEntity))
    		{	// just in case ...
	   			AgeData.quadtree.insert(quadTreeEntity);
	   		}
		}
		
		return val;
	}
	
	/**
	 * Initialize the entity for collisions detection
	 */
	private function initQuadTree()
	{			
		// If this is the first time we are accessing the quad tree
		if(AgeData.quadtree == null)
			AgeData.quadtree = new QuadTree(AgeData.stageWidth, AgeData.stageHeight, 0);
		
		if(quadTreeEntity == null)
		{
			quadTreeEntity = new QuadTreeEntity(this);
			AgeData.quadtree.insert(quadTreeEntity);
		}
	}
	
	private function getIsMovable():Bool
	{
		return _movement != null && _movement.enabled;
	}
	
	public function setMovementBehavior(b: BasicMovementBehavior)
	{
	    _movement = b;
	    addBehavior(_movement);
	}
	
	private function setIsMovable(val:Bool):Bool
	{
		if(_movement == null)
		{
			_movement = new BasicMovementBehavior(this);
			addBehavior(_movement);
		}
		else if(val && (!_movement.enabled || !hasBehavior(_movement)) )
		{
			_movement.enable();
		}
		else if(!val && _movement.enabled)
		{
			_movement.disable();
		}
		return val;
	}
}
