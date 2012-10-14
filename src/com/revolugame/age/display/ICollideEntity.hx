package com.revolugame.age.display;

import com.revolugame.age.system.quadtree.QuadTreeObject;
import nme.geom.Rectangle;

/**
 * Must implement this interface to use the quad tree
 */
interface ICollideEntity
{
    var quadTreeObject : QuadTreeObject;
    var solid(getIsSolid, setIsSolid) : Bool;
    
    function getBounds():Rectangle;
}
