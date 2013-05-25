/** 
 * Author: adrien
 * Date: 04/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.geom;

#if flash
typedef Point2D = flash.geom.Point;
#else
typedef Point2D = {
    var x : Float;
    var y : Float;
}
#end
