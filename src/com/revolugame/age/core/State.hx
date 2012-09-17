package com.revolugame.age.core;

import com.revolugame.age.display.Group;
import com.revolugame.age.AgeUtils;
import com.revolugame.age.display.IEntity;
import com.revolugame.age.display.Entity;
import com.revolugame.age.display.Image;
import com.revolugame.age.system.quadtree.QuadTreeEntity;

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
	        	    && !img.mouseDown 
	        	    && AgeUtils.pointInRect( Math.round(pX), Math.round(pY), img.getBounds()) )
	        	{
	        		img.mouseDown = true;
	        		img.justPressed = true;
	        		img.touchID = pTouchId;
	        		return;
	        	}
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
		// clear the quad tree, and add all children to it for new positions
		if(AgeData.quadtree != null)
		{ 
		
//trace('Quadtree: '+AgeData.quadtree.getEntitiesInNode());
		
			var list : List<QuadTreeEntity> = AgeData.quadtree.reset();
			if(list.length > 0)
			{
				for(l in list)
					AgeData.quadtree.insert(l);
			}
			
		}
						
		super.update();
	}
	
	public override function render()
	{
		super.render();
		#if debug
//		if(AgeData.quadtree != null)
//			AgeData.quadtree.renderDebug();
		#end
	}
		
	#if android
	public function handleBackButton():Void
	{
		// to override
		Lib.exit ();
	}
	#end

}
