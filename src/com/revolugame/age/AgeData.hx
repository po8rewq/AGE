package com.revolugame.age;

import com.revolugame.age.core.Engine;
import com.revolugame.age.core.State;
import com.revolugame.age.core.Camera;
import com.revolugame.age.core.Renderer;
import com.revolugame.age.system.quadtree.QuadTree;

class AgeData implements haxe.Public
{
	/**
	 * Time elapsed since the last frame
	 */
	static var elapsed : Float = 0;

	/**
	 * The AGE major version.
	 */
	static inline var VERSION : String = "0.3.0";

	static var engine : Engine;
	
	static var state : State;
	
	static var camera : Camera;
	static var renderer : Renderer;
	
	static var stageWidth : Int;
	static var stageHeight : Int;
	
	// Pour le quadtree .... remove from here ??
	static var quadtree : QuadTree;

}
