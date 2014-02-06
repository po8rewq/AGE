/** 
 * Author: adrien
 * Date: 04/08/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.display.ui;

import age.display.text.TextBaselineEnum.TextBaseline;
import age.display.text.TextAlignEnum.TextAlign;
import age.core.Input;
import age.display.text.BasicText;

import js.html.CanvasRenderingContext2D;
import js.html.MouseEvent;

class Button extends EntityContainer
{
    var text : BasicText;

    var _borderColor : String;
    var _backgroundColor : String;

    var _currentState : StateEnum;

    var _callback : Void->Void;

    public function new(pX: Int, pY: Int, pWidth: Int, pHeight: Int, pText: String, ?pCallback: Void->Void = null)
    {
        super();

        x = pX;
        y = pY;

        width = pWidth;
        height = pHeight;

        _callback = pCallback;

        _currentState = StateEnum.NORMAL;
        _backgroundColor = "";
        _borderColor = "";

        var textX : Int = Math.round(pX + pWidth*.5);
        var textY : Int = Math.round(pY + pHeight*.5);

        text = new BasicText(pText, textX, textY);
        text.setStyle("pixelade", 25, "#0000FF", false, TextAlign.CENTER);
        text.textBaseline = TextBaseline.MIDDLE;

        if(_callback != null)
            Input.registerGlobalClickHandler(onClick);

        add(text);
    }

    public override function render(pContext: CanvasRenderingContext2D)
    {
        if(_backgroundColor != "" || _borderColor != "")
        {
            // draw background
            pContext.beginPath();
            pContext.rect(x, y, width, height);

            if(_backgroundColor != "")
            {
                pContext.fillStyle = _backgroundColor;
                pContext.fill();
            }

            if(_borderColor != "")
            {
                pContext.lineWidth = 2;
                pContext.strokeStyle = _borderColor;
                pContext.stroke();
            }
        }

        super.render(pContext);
    }

    public override function update()
    {
        _currentState = StateEnum.NORMAL;

        var mouse = Input.mousePosition;
        if(mouse.x >= x && mouse.x <= x + width
           && mouse.y >= y && mouse.y <= y + height)
        {
            _currentState = StateEnum.OVER;
        }

        switch(_currentState)
        {
            case StateEnum.NORMAL:
                text.color = "#0000FF";
                _backgroundColor = "#FFF";

            case StateEnum.OVER:
                text.color = "#FF0000";
                _backgroundColor = "#000";
        }

        super.update();
    }

    private function onClick(pEvt:MouseEvent)
    {
        var bounds = Input.getCanvasBounds();
        var mouseX = pEvt.clientX - bounds.left;
        var mouseY = pEvt.clientY - bounds.top;

        if(mouseX >= x && mouseX <= x + width
           && mouseY >= y && mouseY <= y + height)
        {
            _callback();
        }
    }

    public override function destroy()
    {
        Input.removeGlobalClickHandler(onClick);
    }

}

enum StateEnum {
    NORMAL;
    OVER;
}