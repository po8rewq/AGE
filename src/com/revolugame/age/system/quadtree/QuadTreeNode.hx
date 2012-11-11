package com.revolugame.age.system.quadtree;

import com.revolugame.age.behaviors.CollisionBehavior;
import com.revolugame.age.display.ICollideEntity;
import com.revolugame.age.system.AgeList;

import nme.geom.Rectangle;

#if debug
import nme.display.Graphics;
#end

class QuadTreeNode
{
	/** The limit of nodes depth (to avoid infinite loop) */
	public static inline var MAX_DEPTH : Int = 5;

    //:://///////////////
    //::// Properties
    //:://///////////////
    
    public var exists : Bool;
    
    /** current depth */
    public var depth : Int;
    
    /** positions */
    public var x : Float;
    public var y : Float;
    public var width : Float;
    public var height : Float;
    
    /** puor eviter de calc ca a chaque fois */
    public var halfWidth : Float;
    public var halfHeight : Float;
    
    /** Potentials colliders */
    public var entities : List<QuadTreeObject>;
    
    /** The four nodes */
    public var tl : QuadTreeNode;
    public var tr : QuadTreeNode;
    public var bl : QuadTreeNode;
    public var br : QuadTreeNode;
    
    /**
     * Initializes a node
     */
    public function new(pX: Float, pY: Float, pWidth: Float, pHeight: Float, pDepth: Int):Void
    {
    	init(pX, pY, pWidth, pHeight, pDepth);
    }
    
    public function init(pX: Float, pY: Float, pWidth: Float, pHeight: Float, pDepth: Int):Void
    {
    	exists = true;
    
        x = pX;
        y = pY;
        width = pWidth;
        height = pHeight;
        depth = pDepth;
        
        entities = new List();
        
        halfWidth = width * 0.5;
        halfHeight = height * 0.5;
    }
    
    /**
     * Pushes an item in the tree down to the proper child node, 
     * returning success of the push. Used when item moves.
     */
    public function pushEntityDown(pEntity : QuadTreeObject):Bool
    {    
    	var rect        : Rectangle = pEntity.rect,
    	    onLeft 		: Bool = ( x + width ) - rect.right >= halfWidth,
    	    onTop 		: Bool = ( y + height ) - rect.bottom >= halfHeight,
    	    onRight 	: Bool = rect.left - x >= halfWidth,
    	    onBottom 	: Bool = rect.top - y >= halfHeight;
    	
    	// The entity is not completely in the node, so we do nothing
    	if( depth >= MAX_DEPTH || ( !onTop && !onBottom ) || ( !onLeft && !onRight ) )
	        return false;
    	
    	var newNode : QuadTreeNode = null;
	    if( onTop && onLeft )
	    {
	      	if( tl == null )
	      		tl = CachedQuadTreeNode.get( x, y, halfWidth, halfHeight, depth + 1 );
	      	newNode = tl;
	    }
	    else if( onTop && onRight )
	    {
	       	if( tr == null )
	       		tr = CachedQuadTreeNode.get( x + halfWidth, y, halfWidth, halfHeight, depth + 1 );
	       	newNode = tr;
	    }
	    else if( onBottom && onLeft )
	    {
 	      	if( bl == null )
	      		bl = CachedQuadTreeNode.get( x, y + halfHeight, halfWidth, halfHeight, depth + 1 );
	      	newNode = bl;
	    }
	    else if( onBottom && onRight )
	    {
	       	if( br == null )
	       		br = CachedQuadTreeNode.get( x + halfWidth, y + halfHeight, halfWidth, halfHeight, depth + 1 );
	       	newNode = br;
	    }
	    else
	    {
	    	throw('Something has gone wrong in the quadtree');
	    }
	    
	    // remove the entity from this node
    	entities.remove(pEntity);
    	
	    if(newNode.entities.length > 1)
	    {
	    	// push down entities in this node
	    	newNode.pushEntityDown(pEntity);
	    	for(entity in newNode.entities)
	    		newNode.pushEntityDown(entity);
	    }
	    else 
	    {
	    	// add the entity on this node
	    	newNode.entities.add(pEntity);
	    }
	    
    	return true;
    }
    
    /**
     * Removes an item from the node
     * @return true if the entity has been removed
     */
    public function remove(pEntity:QuadTreeObject):Bool
    {
    	if( !entities.remove(pEntity) )
    	{
    		var returnValue : Bool = false;
    		if( tl != null && tl.remove(pEntity) )
    		{
    			returnValue = true;
    		}
    		else if(tr != null && tr.remove(pEntity) )
    		{
    			returnValue = true;
    		}
    		else if( bl != null && bl.remove(pEntity) )
    		{
    			returnValue = true;
    		}
    		else if( br!= null && br.remove(pEntity) )
    		{
    			returnValue = true;
    		}
    		return returnValue;
    	}
    	
    	fix(); 
    	return true;
    }
    
    /**
     * Fix the tree by removing empty nodes
     */
    public function fix()
    {    
    	var numChildren : Int = getEntitiesInNode();
    
    	// Cas 1 : on a supprimé une entité qui etait seule
    	if( numChildren == 0 ) // rien en dessous
    	{
    		if(tl != null && tl.getEntitiesInNode() == 0) CachedQuadTreeNode.recycle(tl);
    		if(tr != null && tr.getEntitiesInNode() == 0) CachedQuadTreeNode.recycle(tr);
    		if(bl != null && bl.getEntitiesInNode() == 0) CachedQuadTreeNode.recycle(bl);
    		if(br != null && br.getEntitiesInNode() == 0) CachedQuadTreeNode.recycle(br);
    		
    		CachedQuadTreeNode.recycle(this);
    	}
    	else
    	{
    		var tlen : Int = (tl == null ? 0 : tl.entities.length ),
    			tren : Int = (tr == null ? 0 : tr.entities.length ),
    			blen : Int = (bl == null ? 0 : bl.entities.length ),
    			bren : Int = (br == null ? 0 : br.entities.length ),
    			nodeDirectChildren : Int = tlen + tren + blen + bren;
    	
    		// si dans ce noeud on a 0 entité, mais en dessous on en a 1, on la remonte d'un cran, puis on fix()
    		if(nodeDirectChildren == 1 && entities.length == 0)
    		{
    			var node : QuadTreeNode = null;
    			if(tlen == 1) node = tl;
    			else if(tren == 1) node = tr;
    			else if(blen == 1) node = bl;
    			else if(bren == 1) node = br;
    			
    			if(node != null && node.getEntitiesInNode() - node.entities.length == 0)
    			{
    				var en : QuadTreeObject = node.entities.first();
    				node.remove(en); // va s'occuper de fixer
    				CollisionBehavior.quadtree.insert(en);
    			}
    		}
    		
    		if( tl != null && tl.getEntitiesInNode() > 0 ) tl.fix();
    		if( tr != null && tr.getEntitiesInNode() > 0 ) tr.fix();
    		if( bl != null && bl.getEntitiesInNode() > 0 ) bl.fix();
    		if( br != null && br.getEntitiesInNode() > 0 ) br.fix();
    		
    	}
    }
    
    /**
     * Check entities for collisions detection
     * @param pRect : The rect we want to test collisions with
     * @param pColliders : List of potential colliders
     */
    public function getEntityInRect(pRect:Rectangle, pColliders:List<ICollideEntity>):List<ICollideEntity>
    {    	
    	if(!exists) return pColliders;
    
	    for(i in entities)
    	    pColliders.add(i.parent);
  
    	var onLeft : Bool = pRect.left < x + halfWidth,
    	    onRight: Bool = pRect.right > x + halfWidth,
    	    onTop : Bool = pRect.top < y + halfHeight,
    	    onBottom : Bool = pRect.bottom > y + halfHeight;
    
    	// check to know the position of the rect 
    	if( onTop && onLeft && tl != null && tl.exists )
    		tl.getEntityInRect(pRect, pColliders);
    	
    	if( onTop && onRight && tr != null && tr.exists )
    		tr.getEntityInRect(pRect, pColliders);
    	
    	if( onBottom && onLeft && bl != null && bl.exists )
    		bl.getEntityInRect(pRect, pColliders);
    	
    	if( onBottom && onRight && br != null && br.exists )
    		br.getEntityInRect(pRect, pColliders);
    	
    	return pColliders;
    }
   
    /**
     * Get recursively all the children of this node
     */
    public function getEntitiesInNode():Int
    {
    	if(!exists) return 0;
    	
    	return ( entities.length + 
    		(tl != null && tl.exists && tl != this ? tl.getEntitiesInNode() : 0) + 
    		(tr != null && tr.exists && tr != this ? tr.getEntitiesInNode() : 0) + 
    		(bl != null && bl.exists && bl != this ? bl.getEntitiesInNode() : 0) + 
    		(br != null && br.exists && br != this ? br.getEntitiesInNode() : 0)
    	);
    }    
    
    /**
     * Check if all entities are rightly at there place, if not return them
     *
     * @return all entities to insert again in the quad tree
     */
    public function reset( ?pCurrentList: List<QuadTreeObject> = null):List<QuadTreeObject>
    {    
    	if(pCurrentList == null) pCurrentList = new List();
    	
    	var rect : Rectangle,
    	    prev : Rectangle;
    	
    	var en : QuadTreeObject;
    	for(en in entities)
    	{
    		rect = en.rect;
    		prev = en.previousRect;
    	
    		// if the position is different than in the previous frame
    		if(rect.left != prev.left || rect.top != prev.top || rect.right != prev.right || rect.bottom != prev.bottom)
    		{
    			pCurrentList.add(en);
    			remove(en);
    		}
    		
    		// Update the entity position for the next frame
    		en.updatePosition();
    	}
    	
    	if(tl != null) tl.reset(pCurrentList);
    	if(tr != null) tr.reset(pCurrentList);
    	if(bl != null) bl.reset(pCurrentList);
    	if(br != null) br.reset(pCurrentList);
    	
    	return pCurrentList;
    }
    
    public function clear()
    {
    	entities = new List();
    	
    	x = 0;
    	y = 0;
    	width = 0;
    	height = 0;
    	halfWidth = 0;
    	halfHeight = 0;
    	
    	if(tl != null) 
    	{
    		CachedQuadTreeNode.recycle(tl);
    		tl = null;
    	}
    	if(tr != null)
    	{
    		CachedQuadTreeNode.recycle(tr);
    		tr = null;
    	}
    	if(bl != null) 
    	{
    		CachedQuadTreeNode.recycle(bl);
    		bl = null;
    	}
    	if(br != null)
    	{
 	 		CachedQuadTreeNode.recycle(br);
    		br = null;
    	}
    }
    
    #if debug
    /**
     * 
     */
    public function renderNode(graphics: Graphics)
    {
    	if( getEntitiesInNode() - entities.length > 0 )
    	{
	    	graphics.moveTo(x + halfWidth, y);
		    graphics.lineTo(x + halfWidth, y + height);
		    graphics.moveTo(x, y + halfHeight);
		    graphics.lineTo(x + width, y + halfHeight);
	    	    	
		    if(tl != null && tl.getEntitiesInNode() > 0) tl.renderNode(graphics);
		    if(tr != null && tr.getEntitiesInNode() > 0) tr.renderNode(graphics);
		    if(bl != null && bl.getEntitiesInNode() > 0) bl.renderNode(graphics);
		    if(br != null && br.getEntitiesInNode() > 0) br.renderNode(graphics);
	    }
    }
    #end

}

/**
 * Just to recycle nodes
 */
class CachedQuadTreeNode
{
	static var _list : List<QuadTreeNode>;
	static var _init : Bool = false;

	private static function init():Void
	{
		if(!_init)
		{
			_list = new List();
			_init = true;
		}
	}

	/**
	 * Recycle a node
	 */
	public static function recycle(node: QuadTreeNode):Void
	{
		if(!_init) init();
		
		if(node.exists)
		{
			node.exists = false;
			node.clear();
			_list.add(node);
		}
	}
	
	/**
	 * Get a cached node if possible
	 */
	public static function get(pX: Float, pY: Float, pWidth: Float, pHeight: Float, pDepth: Int):QuadTreeNode
	{
		if(!_init) init();
		
		var node : QuadTreeNode;
		if(_list.length > 0)
		{
			node = _list.pop();
			node.init(pX, pY, pWidth, pHeight, pDepth);
			node.exists = true;
		}
		else
		{
			node = new QuadTreeNode(pX, pY, pWidth, pHeight, pDepth);
		}
	
		return node;
	}
	
	/**
	 * Clear all the cached nodes
	 */
	public static function clear():Void
	{
		for(node in _list)
			node.clear();
		_list = new List();
	}

}
