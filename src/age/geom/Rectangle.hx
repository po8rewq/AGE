/** 
 * Author: adrien
 * Date: 04/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.geom;

#if flash
typedef Rectangle = flash.geom.Rectangle;
#else
typedef Rectangle = {
    > Point2D,
    var width : Int;
    var height : Int;
}
#end
