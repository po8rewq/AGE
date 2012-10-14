package com.revolugame.age.system.quadtree;

import nme.geom.Rectangle;
import nme.display.Sprite;

import com.revolugame.age.AgeUtils;
import com.revolugame.age.display.ICollideEntity;
import com.revolugame.age.display.Group;
import com.revolugame.age.system.AgeList;
import com.revolugame.age.system.quadtree.QuadTreeNode;

class QuadTree extends QuadTreeNode
{

    /**
     * Initializes the head node and stores a little bit of information about the tree.
     */
    public function new(pInitW: Int, pInitH: Int, pDepth: Int)
    {
        super(0, 0, pInitW, pInitH, pDepth);
    }
    
    #if debug
    public var spr : Sprite; // TEMPORARY FOR DEBUG
    public function renderDebug()
    {   
    	if(spr == null) spr = new Sprite();
    	spr.graphics.clear();
    	spr.graphics.lineStyle(2, 0x000000);
    	renderNode(spr.graphics);
    	AgeData.renderer.renderDebugData( spr );
    }
    #end
    
    /**
     * Inserts an item in the node
     * Insertion is not recursive, to reduce function calls and make the tree faster.
     *
     * TODO : a déplacer vers la classe QuadTreeNode ??
     */
    public function insert(pEntity:QuadTreeObject)
    {
        var entityRect  : Rectangle = pEntity.rect,
            current     : QuadTreeNode = this,
            onLeft      : Bool,
            onTop       : Bool,
            onRight     : Bool,
            onBottom    : Bool,
            currentX    : Float,
            currentY    : Float,
            entities    : List<QuadTreeObject>;
        
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
	            entities.add( pEntity );
			   		
			    // Push down entities from this zone
			    for(en in entities)
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
