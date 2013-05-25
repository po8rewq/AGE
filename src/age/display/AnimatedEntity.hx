/** 
 * Author: adrien
 * Date: 04/05/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.display;

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

    public function new(pSrc: String, pWidth: Int, pHeight : Int, pTotalFrames: Int, pFrameRate : Int)
    {
        super(pWidth, pHeight);

        addImage("anim", pSrc, true);

        _frames = pTotalFrames;
        _currentFrame = 0;

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
        if (_timer >= 1)
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
        pContext.drawImage(_image, _currentFrame * width, 0, width, height, x, y, width, height);
    }

}
