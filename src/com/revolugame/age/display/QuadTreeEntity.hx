package com.revolugame.age.display;

import com.revolugame.age.behaviors.BasicMovementBehavior;
import com.revolugame.age.behaviors.CollisionBehavior;
import com.revolugame.age.display.ICollideEntity;
import com.revolugame.age.enums.CollisionsEnum;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.system.quadtree.QuadTree;
import com.revolugame.age.system.quadtree.QuadTreeObject;

import flash.geom.Rectangle;

/**
 * Graphical element with collisions detection and behaviors
 */
class QuadTreeEntity extends BasicEntity, implements ICollideEntity
{	    
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
	public var quadTreeObject : QuadTreeObject;
    
    public function new(pX: Float = 0, pY: Float = 0):Void
	{
		super(pX, pY);
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
    public override function moveBy(pX:Float, pY:Float, ?pSweep:Bool = false)
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
		if(quadTreeObject != null)
		{
		    quadTreeObject.destroy();
		    quadTreeObject = null;
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
			if(quadTreeObject != null)
				AgeData.quadtree.remove(quadTreeObject);
		}
		else if(val && quadTreeObject != null)
		{
			if(AgeData.quadtree.remove(quadTreeObject))
    		{	// just in case ...
	   			AgeData.quadtree.insert(quadTreeObject);
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
		
		if(quadTreeObject == null)
		{
			quadTreeObject = new QuadTreeObject(this);
			AgeData.quadtree.insert(quadTreeObject);
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
