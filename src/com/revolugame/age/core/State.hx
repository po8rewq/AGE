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
	    var img : Image;
	    var entity = pParent.firstEntity;
//        for(entity in pParent.entities)
        while(entity != null)
	    {
	    	if(Std.is(entity.object, Image))
	    	{
	    	    img = cast entity.object;
	        	if(img.handleMouseEvents 
	        	    && !img.mouseDown 
	        	    && AgeUtils.pointInRect( Math.round(pX), Math.round(pY), img.getBounds()) )
	        	{
	        		img.mouseDown = true;
	        		img.justPressed = true;
	        		img.touchID = pTouchId;
	        		return;
	        	}
	        }
	        else if(Std.is(entity.object, Group))
	        {
	        	handleMouseDown(cast entity.object, pX, pY, pTouchId);
	        }
	        
	        entity = entity.next;
	    }
	}
	
	public function handleMouseUp(pParent:Group, pTouchId:Int)
	{
	    var img : Image;
        var entity = pParent.firstEntity;
//        for(entity in pParent.entities)
        while(entity != null)
	    {
	    	if(Std.is(entity.object, Image))
	    	{
	    		img = cast entity.object;
	    		if(img.mouseDown && img.touchID == pTouchId)
	    		{
	        		img.mouseDown = false;
	        		img.justPressed = false;
	        		return;
	        	}
	        }
	        else if(Std.is(entity.object, Group))
	        {
	        	handleMouseUp(cast entity.object, pTouchId);
	        }
	        entity = entity.next;
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
