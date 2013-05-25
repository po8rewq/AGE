/** 
 * Author: adrien
 * Date: 25/05/13
 *
 * Copyright 2013 - RevoluGame.com
 *
 * https://github.com/mrdoob/stats.js/
 */

package age.debug;

import js.Dom;

@:native("Stats")
extern class Stats
{
    public var domElement : HtmlDom; // if haxe3 => js.html.Element
    public function new() : Void;
    public function setMode(m:Int) : Void;
    public function begin() : Void;
    public function end() : Void;
    public function update() : Void;
}
