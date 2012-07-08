package com.revolugame.age.system.quadtree;

import nme.geom.Rectangle;
import nme.display.Sprite;

import com.revolugame.age.system.quadtree.QuadTreeNode;
import com.revolugame.age.display.Group;
import com.revolugame.age.display.Entity;

class QuadTree extends QuadTreeNode
{
    /**
     * Initializes the head node and stores a little bit of information about the tree.
     */
    public function new(pInitW: Int, pInitH: Int, pDepth: Int)
    {
        super(0, 0, pInitW, pInitH, pDepth);
    }
    
    /**
     * Insert all entities in the tree
     */
    public function initChildren(pState: Group):Void
    {
    	insertGroup(pState);
    }
    
    private function insertGroup(pGroup:Group)
    {
    	for(en in pGroup.entities)
    	{
			if( Std.is(en, Entity) )
				insert( cast(en, Entity).quadTreeEntity);
			else if( Std.is(en, Group) )
				insertGroup( cast en );
		}
    }
    
    /**
     * Inserts an item in the node
     * Insertion is not recursive, to reduce function calls and make the tree faster.
     */
    public function insert(pEntity:QuadTreeEntity)
    {
        var entityRect : Rectangle = pEntity.rect;
        var current : QuadTreeNode = this;
        
        // On cherche la position
        var onLeft      : Bool;
        var onTop       : Bool;
        var onRight     : Bool;
        var onBottom    : Bool;
        
        var currentX : Float;
        var currentY : Float;
        
        var entities : List<QuadTreeEntity>;
    	while(true)
    	{
    		entities = current.entities;
    		
    		// If there is no one in this node, we just had the entity on it
    		if(current.depth >= QuadTreeNode.MAX_DEPTH || current.getEntitiesInNode() < 1)
    		{
    			entities.add( pEntity );
    			break;
    		}
    	
    		//trace(current.depth);
    		currentX = current.x;
    		currentY = current.y;
    	
    		onLeft = ( currentX + current.width ) - entityRect.right >= current.halfWidth;
    		onTop = ( currentY + current.height ) - entityRect.bottom >= current.halfHeight;
    		onRight = entityRect.left - currentX >= current.halfWidth;
    		onBottom = entityRect.top - currentY >= current.halfHeight;
    		
	        // if the entity is not completely in one of the 4 nodes 
	        if( ( !onTop && !onBottom ) || ( !onLeft && !onRight ) )
	        {
	            current.entities.add( pEntity );
			   		
			    // Push down entities from this zone
			    for(en in current.entities)
			       	current.pushEntityDown(en);
	            
	            break;
	        }
	        
	        var newNode : QuadTreeNode = null;
	        if( onTop && onLeft )
	        {
	        	if( current.tl == null )
	        		current.tl = CachedQuadTreeNode.get( currentX, currentY, current.halfWidth, current.halfHeight, current.depth + 1 );
	        	newNode = current.tl;
	        }
	        else if( onTop && onRight )
	        {
	        	if( current.tr == null )
	        		current.tr = CachedQuadTreeNode.get( currentX + current.halfWidth, currentY, current.halfWidth, current.halfHeight, current.depth + 1 );
	        	newNode = current.tr;
	        }
	        else if( onBottom && onLeft )
	        {
 	        	if( current.bl == null )
	        		current.bl = CachedQuadTreeNode.get( currentX, currentY + current.halfHeight, current.halfWidth, current.halfHeight, current.depth + 1 );
	        	newNode = current.bl;
	        }
	        else if( onBottom && onRight )
	        {
	        	if( current.br == null )
	        		current.br = CachedQuadTreeNode.get( currentX + current.halfWidth, currentY + current.halfHeight, current.halfWidth, current.halfHeight, current.depth + 1 );
	        	newNode = current.br;
	        }
	        	
		    // Push down entities from this zone
		    for(en in current.entities)
		        current.pushEntityDown(en);
	        
	        // go to child node
	        current = newNode;
        }
    }
    
    public override function clear()
    {
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
    	entities = new List();
    }

}