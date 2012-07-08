package com.revolugame.age.system.quadtree;

import nme.geom.Rectangle;
import com.revolugame.age.display.Entity;

/**
 * Objects contains in the quad tree nodes
 */
class QuadTreeEntity
{

    public var rect : Rectangle;
    public var parent : Entity;
    
    public function new(pParent:Entity)
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
