package com.revolugame.age.system.quadtree;

import com.revolugame.age.display.Entity;

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
    public var entities : List<QuadTreeEntity>;
    
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
    public function pushEntityDown(pEntity : QuadTreeEntity):Bool
    {    
    	var rect = pEntity.rect;
    	
    	var onLeft 		: Bool = ( x + width ) - rect.right >= halfWidth;
    	var onTop 		: Bool = ( y + height ) - rect.bottom >= halfHeight;
    	var onRight 	: Bool = rect.left - x >= halfWidth;
    	var onBottom 	: Bool = rect.top - y >= halfHeight;
    	
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
     * Pushes an item up to the parent node. Used when item goes out of range.
     */
    public function pushItemUp():Bool
    {
    	return true;
    }
    
    /**
     * Removes an item from the node (cleans up references to items).
     * @return true if the entity has been removed
     */
    public function remove(pEntity:QuadTreeEntity):Bool
    {
    	if( !entities.remove(pEntity) )
    	{
    		if(!tl.remove(pEntity) && !tr.remove(pEntity) && !bl.remove(pEntity) && !br.remove(pEntity))
    			return false;
    		return true;
    	}
    	return true;
    }
    
    /**
     * Check entities for collisions detection
     * @param pRect : The rect we want to test collisions with
     * @param pColliders : List of potential colliders
     */
    public function getEntityInRect(pRect:Rectangle, pColliders:List<QuadTreeEntity>):List<QuadTreeEntity>
    {
	    for(i in entities)
	    	pColliders.add(i);
  
    	var onLeft : Bool = pRect.left < x + halfWidth;
    	var onRight: Bool = pRect.right > x + halfWidth;
    	var onTop : Bool = pRect.top < y + halfHeight;
    	var onBottom : Bool = pRect.bottom > y + halfHeight;
    
    	// check to know the position of the rect 
    	if( onTop && onLeft && tl != null )
    		tl.getEntityInRect(pRect, pColliders);
    	
    	if( onTop && onRight && tr != null )
    		tr.getEntityInRect(pRect, pColliders);
    	
    	if( onBottom && onLeft && bl != null )
    		bl.getEntityInRect(pRect, pColliders);
    	
    	if( onBottom && onRight && br != null )
    		br.getEntityInRect(pRect, pColliders);
    	
    	return pColliders;
    }
    
    /**
     * Destroy the node itself
     *
    public function destroy()
    {
        if(tl != null) tl.destroy();
        if(tr != null) tr.destroy();
        if(bl != null) bl.destroy();
        if(br != null) br.destroy();
        
        entities = new List();
    }
    */
    /**
     * Get recursively all the children of this node
     */
    public function getEntitiesInNode():Int
    {
    	return ( entities.length + 
    		(tl != null ? tl.getEntitiesInNode() : 0) + 
    		(tr != null ? tr.getEntitiesInNode() : 0) + 
    		(bl != null ? bl.getEntitiesInNode() : 0) + 
    		(br != null ? br.getEntitiesInNode() : 0)
    	);
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
		
		node.clear();
		_list.add(node);
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
		}
		else
			node = new QuadTreeNode(pX, pY, pWidth, pHeight, pDepth);
	
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