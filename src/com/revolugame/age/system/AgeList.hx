package com.revolugame.age.system;

import com.revolugame.age.display.IEntity;

/**
 * A miniature linked list class
 */
class AgeList
{
    /** Stores a reference to the next link in the list */
    public var next : AgeList;
    
    /** Stores a reference to the object */
    public var object : IEntity;

    public function new(?pObj: IEntity = null)
    {
        object = pObj;
        next = null;
    }
    
    public function destroy()
    {
        if(object != null) object.destroy();
        object = null;
        if(next != null) next.destroy();
        next = null;
    }

}
