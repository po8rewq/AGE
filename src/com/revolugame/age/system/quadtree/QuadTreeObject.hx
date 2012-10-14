package com.revolugame.age.system.quadtree;

import nme.geom.Rectangle;
import com.revolugame.age.display.ICollideEntity;

/**
 * Objects contains in the quad tree nodes
 */
class QuadTreeObject
{

    public var rect : Rectangle;
    public var previousRect : Rectangle; // previous position of the entity
    
    public var parent : ICollideEntity;
    
    public function new(pParent:ICollideEntity)
    {
        parent = pParent;
        rect = pParent.getBounds().clone(); // on ne prend pas les données direct, juste un clone
        previousRect = rect.clone();
    }
    
    public function updatePosition():Void
    {
    	previousRect = rect.clone();
    	rect = parent.getBounds().clone();
    }
    
    public function destroy()
    {
    	parent = null;
    	rect = null;
    	previousRect = null;
    }

}
