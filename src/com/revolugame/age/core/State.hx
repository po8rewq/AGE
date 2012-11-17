package com.revolugame.age.core;

import com.revolugame.age.display.Group;
import com.revolugame.age.AgeUtils;
import com.revolugame.age.display.Image;
import com.revolugame.age.managers.BehaviorsManager;

#if cpp
#if box2d
import com.revolugame.age.display.Box2dEntity;
#elseif nape
import com.revolugame.age.display.NapeEntity;
#end
#end

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
	    for(entity in pParent.entities)
	    {
	    	if(Std.is(entity, Image))
	    	{
	    	    img = cast entity;
	        	if(img.handleMouseEvents 
	        	    && !img.mouseDown) {
	        	    
	        	    var bounds = img.getBounds();
	        	    
	        	    // Hack car le positionnement est pas tout a fait pareil entre cpp et flash et en passant par box2d
	        	    #if cpp
	        	    #if box2d
	        	    if(Std.is(entity, Box2dEntity))
	        	    #elseif nape
	        	    if(Std.is(entity, NapeEntity))
	        	    #end
	        	    {
	        	        bounds.x -= img.halfWidth;
	        	        bounds.y -= img.halfHeight;
	        	    }
	        	    #end
	        	     
	        	    if( AgeUtils.pointInRect( Math.round(pX), Math.round(pY), bounds) )
	        	{
	        		img.mouseDown = true;
	        		img.justPressed = true;
	        		img.justReleased = false;
	        		img.touchID = pTouchId;
	        		return;
	        	} }
	        }
	        else if(Std.is(entity, Group))
	        {
	        	handleMouseDown(cast entity, pX, pY, pTouchId);
	        }
	    }
	}
	
	public function handleMouseUp(pParent:Group, pTouchId:Int)
	{
		var img : Image;
		for(entity in pParent.entities)
		{
			if(Std.is(entity, Image))
	    	{
	    		img = cast entity;
	    		if(img.mouseDown && img.touchID == pTouchId)
	    		{
	        		img.mouseDown = false;
	        		img.justPressed = false;
	        		img.justReleased = true;
	        		return;
	        	}
	        }
	        else if(Std.is(entity, Group))
	        {
	        	handleMouseUp(cast entity, pTouchId);
	        }
		}
	}
	
	public override function update()
	{
	    BehaviorsManager.getInstance().update();
		super.update();
	}
	
	public override function render()
	{
		super.render();
	}
		
	#if android
	public function handleBackButton():Void
	{
		// to override
		Lib.exit ();
	}
	#end

}
