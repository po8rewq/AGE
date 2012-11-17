package com.revolugame.age.behaviors;

import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.managers.BehaviorsManager;
import com.revolugame.age.core.IBehavior;
import nape.space.Space;
import nape.geom.Vec2;
import nape.util.ShapeDebug;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.geom.AABB;
import nape.geom.MarchingSquares;
import nape.constraint.PivotJoint;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;

class NapeMovementBehavior implements IBehavior
{
    private var _entity : BasicEntity;
    public var enabled(default, null) : Bool;
    
    public static var world : Space;
    public static var hand : PivotJoint;
    
    #if debug
//    public static var debug : ShapeDebug;
    #end
    
    public function globalUpdate():Void
	{
	    hand.anchor1.setxy(AgeData.engine.mouseX, AgeData.engine.mouseY);
	
	    #if debug
//	    debug.clear();
	    #end
	    world.step(1/30,10,10);
	    #if debug
//	    debug.draw(world);
//		debug.flush();
		#end
	}
	
	private var _body : Body;
	public function new(pEntity: BasicEntity, pDynamic:Bool/*, pGraphics:BitmapData*/)
	{
	    if(world == null)
	    {
	        world = new Space( new Vec2(0, 500) );
	        #if debug
//	        debug = new ShapeDebug(AgeData.stageWidth, AgeData.stageHeight, 0x00ff00);
	        #end
//	        nme.Lib.current.addChild(debug.display);
	        
	        hand = new PivotJoint(world.world,null,new Vec2(),new Vec2());
            hand.active = false;
            hand.stiff = false;
            hand.space = world;
	        
	        BehaviorsManager.getInstance().registerUpdater(globalUpdate);
	    }	    

	    _body = new Body( (pDynamic ? BodyType.DYNAMIC : BodyType.STATIC), 
	                    new Vec2(pEntity.x + pEntity.halfWidth, pEntity.y + pEntity.halfHeight)
	                   );
	    
	    var block:Polygon = new Polygon(Polygon.box(pEntity.width,pEntity.height));
	    
		_body.shapes.add(block);
		_body.align();
				
		_body.space = world;
	
//	    _body.graphic = pGraphics;
//      _body.graphicUpdate = updateGraphics;
	
        _entity = pEntity;
	}
	
	public function applyForce(pX: Float, pY: Float):Void
	{ // TODO
	}
	
	public function applyImpulse(pX: Float, pY: Float):Void
	{
	    var v : Vec2 = new Vec2(pX, pY);
	    _body.applyLocalImpulse(v);
	}
	
	public function moveWithHand()
	{
	    if(_body.isDynamic())
	    {
	        var mp = new Vec2(AgeData.engine.mouseX, AgeData.engine.mouseY);
	        
            hand.body2 = _body;
            hand.anchor2 = _body.worldToLocal(mp);
            hand.active = true;
        }
	}
	
	public function stopMovement()
	{
	    hand.active = false;
	}
	
	public function update():Void
	{
    	// TODO uniformiser tout ca
	    #if cpp
        _entity.x = _body.position.x;
        _entity.y = _body.position.y;
        #else
        _entity.x = _body.position.x - _entity.halfWidth;
        _entity.y = _body.position.y - _entity.halfHeight;
        #end
        
        _entity.rotation = _body.rotation * 57.2957795;
	}

    public function enable()
    {
		enabled = true;
    }
    
    public function disable()
    {
		enabled = false;
    }

    public function destroy():Void
    {
        world.bodies.remove(_body);
    }
	
}
