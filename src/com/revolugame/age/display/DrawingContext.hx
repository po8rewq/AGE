package com.revolugame.age.display;

import flash.geom.Point;

#if flash
import flash.display.BitmapData;
#end

/**
 * Data needed for the IEntity to be rendered // TODO clean this
 */
class DrawingContext
{

    #if cpp
    public var data     : Array<Data>;
    #else
    public var data     : Data;
    public var buffer   : BitmapData;
    #end
    
    public function new()
    {
        #if cpp
        data = new Array();
        #end
    
        restore();
    }
    
    public function restore()
    {
        var initData : Data = {
            position: new Point(0, 0), 
            #if cpp
            frameId: 0,
            #end
            scaleX: 1, 
            scaleY: 1,
            rotation: 0,
            alpha: 1,
            mirrorX: false,
            mirrorY: false
        };
        
        #if cpp
        data = new Array();
        data[0] = initData;
        #else
        data = initData;
        #end
    }
    
    /**
     *
     */
    #if cpp
    public function addSingleContextData(pX: Float = 0, pY: Float = 0, pFrameId: Int = 0, pScaleX: Float = 1, pScaleY: Float = 1, pRotation: Float = 0, pAlpha: Float = 0, pMirrorX: Bool = false, pMirrorY : Bool = false)
    #else
    public function addSingleContextData(pX: Float = 0, pY: Float = 0, pScaleX: Float = 1, pScaleY: Float = 1, pRotation: Float = 0, pAlpha: Float = 0, pMirrorX: Bool = false, pMirrorY : Bool = false)
    #end
    {
        var currentData : Data;
        
        #if cpp
        currentData = data[0];
        currentData.frameId = pFrameId;
        #else
        currentData = data;
        #end
        
        currentData.position.x  = pX;
        currentData.position.y  = pY;
        currentData.scaleX      = pScaleX;
        currentData.scaleY      = pScaleY;
        currentData.rotation    = pRotation;
        currentData.alpha       = pAlpha;
        currentData.mirrorX     = pMirrorX;
        currentData.mirrorY     = pMirrorY;
    }
    
    /**
     * Add another context data (cpp only)
     */
     #if cpp
    public function pushSingleContextData(pX: Float = 0, pY: Float = 0, pFrameId: Int = 0)
    {
        var initData : Data = {
            position: new Point(pX, pY), 
            frameId: pFrameId,
            scaleX: 1, 
            scaleY: 1,
            rotation: 0,
            alpha: 1,
            mirrorX: false,
            mirrorY: false
        };
        data.push(initData);
    }
    #end

    public function toString():String
    {
        #if cpp
        return 'Not implemented yet';
        #else
        return '{x:'+data.position.x+', y:'+data.position.y+', scaleX:'+data.scaleX+', scaleY:'+data.scaleY+', rotation:'+data.rotation+'}';
        #end
    }

}

typedef Data = {
    var position    : Point;
    var scaleX      : Float;
    var scaleY      : Float;
    var rotation    : Float;
    var alpha       : Float;
    var mirrorX     : Bool;
    var mirrorY     : Bool;
    #if cpp
    var frameId     : Int;
    #end
}
