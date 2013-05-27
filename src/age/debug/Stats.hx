/** 
 * Author: adrien
 * Date: 25/05/13
 *
 * Copyright 2013 - RevoluGame.com
 *
 * https://github.com/mrdoob/stats.js/
 */

package age.debug;

@:native("Stats")
extern class Stats
{
    public var domElement : js.html.Element;
    public function new() : Void;
    public function setMode(m:Int) : Void;
    public function begin() : Void;
    public function end() : Void;
    public function update() : Void;
}
