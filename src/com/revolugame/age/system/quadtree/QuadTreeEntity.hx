package com.revolugame.age.system.quadtree;

import nme.geom.Rectangle;
import com.revolugame.age.display.ICollideEntity;

/**
 * Objects contains in the quad tree nodes
 */
class QuadTreeEntity
{

    public var rect : Rectangle;
    public var parent : ICollideEntity;
    
    public function new(pParent:ICollideEntity)
    {
        parent = pParent;
        rect = pParent.getBounds();
    }
    
    public function destroy()
    {
    	parent = null;
    	rect = null;
    }

}
