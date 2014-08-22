/** 
 * Author: adrien
 * Date: 04/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.display;

import js.html.CanvasRenderingContext2D;
import age.core.Global;
import age.geom.Rectangle;

class AnimatedEntity extends Entity
{
    var _frames : Int;
    var _currentFrame : Int;
    var _frameRate : Int;

    var _timer : Float;

    var _loop: Bool;
    var _complete : Bool;
    var _pauseAnim : Bool;

    public function new(pWidth: Int, pHeight : Int, pSrc: String, pTotalFrames: Int, pFrameRate : Int)
    {
        super(pWidth, pHeight);

        addImage("default", pSrc, true);

        _frames = pTotalFrames;
        _currentFrame = 0;
        _pauseAnim = false;

        _frameRate = pFrameRate;

        _timer = 0;
        _loop = true;
        _complete = false;
    }

    private function onAnimationComplete()
    {
        // to override if needed
    }

    public override function update()
    {
        if(_complete) return;

        var oldIndex : Int = _currentFrame;

        _timer += _frameRate * Global.elapsed;
        if (_timer >= 1 && !_pauseAnim)
        {
            while (_timer >= 1)
            {
                _timer --;
                _currentFrame++;
                if(_currentFrame >= _frames)
                {
                    if (_loop)
                    {
                        _currentFrame = 0;
                    }
                    else
                    {
                        _currentFrame = _frames - 1;
                        _complete = true;
                        onAnimationComplete();
                        break;
                    }

                }
            }
        }
        
        super.update();
    }

    public override function render(pContext: CanvasRenderingContext2D)
    {
        pContext.save();

        if(mirror)
        {
            var decX : Int = Std.int( x + width * .5 );
            var decY : Int = Std.int( y + height * .5 );

            pContext.translate(decX, decY);
            pContext.scale(-1, 1);
            pContext.translate(-decX, -decY );
        }

        if(rotation != 0)
        {
            var decX : Int = Std.int( x + width * .5 );
            var decY : Int = Std.int( y + height * .5 );

            pContext.translate(decX, decY);
            pContext.rotate(rotation * Math.PI/180);
            pContext.translate(-decX, -decY );
        }        

        var globalAlpha = pContext.globalAlpha;

        if(alpha < 1 && alpha >= 0)
            pContext.globalAlpha = alpha;

        pContext.drawImage(_image, _currentFrame * width, 0, width, height, x, y, width, height);

        pContext.globalAlpha = globalAlpha;

        pContext.restore();

        #if debug
        drawDebug(pContext);
        #end
    }

}
