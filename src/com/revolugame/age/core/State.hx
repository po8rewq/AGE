package com.revolugame.age.core;

import com.revolugame.age.display.Group;
import com.revolugame.age.AgeUtils;
import com.revolugame.age.display.IEntity;
import com.revolugame.age.display.Image;

import flash.geom.Rectangle;

class State extends Group
{

	public function new()
	{
		super();
	}
	
	public function create() { }
	
	public function handleMouseDown(pX: Float, pY: Float)
	{
		var i : Int = 0;
	    var len : Int = entities.length;
	    var entity : Image;
	    while(i < len)
	    {
	    	if(Std.is(entities[i], Image))
	    	{
	        	entity = cast entities[i];
	        
	        	if( AgeUtils.pointInRect( Math.round(pX), Math.round(pY), entity.getBounds()) )
	        	{
	        		entity.mouseDown = true;	// TODO : stop propagation
	        	}
	        }
	        ++i;
	    }
	}
	
	public function handleMouseUp()
	{
		var i : Int = 0;
	    var len : Int = entities.length;
	    var entity : Image;
	    while(i < len)
	    {
	    	if(Std.is(entities[i], Image))
	    	{
	        	entity = cast entities[i];
	        	entity.mouseDown = false;
	        }
	        ++i;
		}
	}

}