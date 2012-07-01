package com.revolugame.age.core;

import com.revolugame.age.display.Group;
import com.revolugame.age.AgeUtils;
import com.revolugame.age.display.IEntity;
import com.revolugame.age.display.Image;

import flash.geom.Rectangle;

import nme.Lib;

class State extends Group
{

	public function new()
	{
		super();
		parent = null;
	}
	
	public function create() { }
	
	public function handleMouseDown(pParent:Group, pX: Float, pY: Float, pTouchId:Int)
	{
		var i : Int = 0;
	    var len : Int = pParent.entities.length;
	    var entity : Image;
	    while(i < len)
	    {
	    	if(Std.is(pParent.entities[i], Image))
	    	{
	        	entity = cast pParent.entities[i];	        
	        	if(entity.handleMouseEvents 
	        	    && !entity.mouseDown 
	        	    && AgeUtils.pointInRect( Math.round(pX), Math.round(pY), entity.getBounds()) )
	        	{
	        		entity.mouseDown = true;
	        		entity.justPressed = true;
	        		entity.touchID = pTouchId;
	        		return;
	        	}
	        }
	        else if(Std.is(pParent.entities[i], Group))
	        {
	        	handleMouseDown(cast pParent.entities[i], pX, pY, pTouchId);
	        }
	        ++i;
	    }
	}
	
	public function handleMouseUp(pParent:Group, pTouchId:Int)
	{
		var i : Int = 0;
	    var len : Int = pParent.entities.length;
	    var entity : Image;
	    while(i < len)
	    {
	    	if(Std.is(pParent.entities[i], Image))
	    	{
	    		entity = cast pParent.entities[i];
	    		if(entity.mouseDown && entity.touchID == pTouchId)
	    		{
	        		entity.mouseDown = false;
	        		entity.justPressed = false;
	        		return;
	        	}
	        }
	        else if(Std.is(pParent.entities[i], Group))
	        {
	        	handleMouseUp(cast pParent.entities[i], pTouchId);
	        }
	        ++i;
		}
	}
	
	#if android
	public function handleBackButton():Void
	{
		// to override
		Lib.exit ();
	}
	#end

}
