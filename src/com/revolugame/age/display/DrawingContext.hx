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

    public var position     : Point;
    public var scaleX       : Float;
    public var scaleY       : Float;
    public var rotation     : Float;
    public var alpha        : Float;
    public var mirrorX      : Bool;
    public var mirrorY      : Bool;
    
    #if flash
    public var buffer : BitmapData;
    #end
    
    public function new()
    {
        position = new Point();
        updateValue(0, 0, 1, 1, 0, 0, false, false);
    }
    
    public function updateValue(pX: Float = 0, pY: Float = 0, pScaleX: Float = 1, pScaleY: Float = 1, pRotation: Float = 0, pAlpha: Float = 0, pMirrorX: Bool = false, pMirrorY : Bool = false)
    {
        position.x = pX;
        position.y = pY;
        scaleX = pScaleX;
        scaleY = pScaleY;
        rotation = pRotation;
        alpha = pAlpha;
        mirrorX = pMirrorX;
        mirrorY = pMirrorY;
    }

    public function toString():String
    {
        return '{x:'+position.x+', y:'+position.y+', scaleX:'+scaleX+', scaleY:'+scaleY+', rotation:'+rotation+'}';
    }

}
