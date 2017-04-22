/** 
 * Author: adrien
 * Date: 27/07/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.utils;

import js.Browser;
import js.html.Gamepad;

/**
http://www.raymondcamden.com/index.cfm/2012/8/1/Got-a-new-Chrome-Got-a-joystick-Check-out-the-Gamepad-API
https://wiki.mozilla.org/GamepadAPI
*/
class GamepadSupport
{
    public static var enabled(default, null): Bool;

    /**  */    
    private static var _buttons : Map<Int, Map<Int, GamePadState>>;
    private static var _axes : Map<Int, AxesData>;

    // TODO : gerer le branchement/debranchement des pads en cours de jeu
    private static var _pads : Map<Int, String>; // id -> nom
    public static var NB_PAD : Int;

    public static var GAMEPAD_SENSITIVITY : Float = 0.5;

    public static function init()
    {
        _buttons = new Map();
        _axes = new Map();
        _pads = new Map();

        NB_PAD = 0;

        enabled = HtmlUtils.loadExtension("GetGamepads", Browser.navigator).value != null;

//        "MozGamepadConnected"
//        Browser.window.addEventListener('gamepadconnected',function(pEvt:js.html.Event){
//                                                                                         trace('ongamepadconnected');
//                                                    }, false);

        trace("GamePad support : " + enabled);
    }

    public static function update()
    {
        if(!enabled || _buttons == null) return;

        NB_PAD = 0;
        var t = Browser.navigator;

        var gamepads = t.getGamepads(); //t.webkitGetGamepads();
        if(gamepads != null)
        {
            var pad : Gamepad;
            for(i in 0...gamepads.length)
            {
                NB_PAD++;
				pad = gamepads[i]; 
//                pad = gamepads[i];        // TODO
                if(pad != null)
                {
                    if(!_pads.exists(i))
                    {
                        _pads.set(i, pad.id);
//                        trace('Ajout du pad ' + pad.id);
                    }

                    // Buttons handler
                    var currentPadButtons : Map<Int, GamePadState>;
                    if(_buttons.exists(i))
                    {
                        currentPadButtons = _buttons.get(i);
                    }
                    else
                    {
                        currentPadButtons = new Map();
                        _buttons.set(i, currentPadButtons);
                    }

                    var btnIndex : Int = 0;
                    for(b in pad.buttons)
                    {
                        if(currentPadButtons.exists(btnIndex) && b.value == 1 && b.pressed)
                        {
                            var state = currentPadButtons.get(btnIndex);
                            if( state == GamePadState.OFF )
                                currentPadButtons.set(btnIndex, GamePadState.PRESSED);
                        }
                        else
                        {
                            currentPadButtons.set(btnIndex, (b.value == 1 && b.pressed) ? GamePadState.PRESSED : GamePadState.OFF);
                        }
                        btnIndex++;
                    }

                    // Axes handler
                    var currentPadAxes : AxesData;
                    if(_axes.exists(i))
                        currentPadAxes = _axes.get(i);
                    else
                    {
                        currentPadAxes = {
                            leftStick_right: false,
                            leftStick_left: false,
                            leftStick_up: false,
                            leftStick_down: false,
                            rightStick_right: false,
                            rightStick_left: false,
                            rightStick_up: false,
                            rightStick_down: false
                        };
                        _axes.set(i, currentPadAxes);
                    }

                    currentPadAxes.leftStick_right = pad.axes[0] > GAMEPAD_SENSITIVITY;
                    currentPadAxes.leftStick_left = pad.axes[0] < -GAMEPAD_SENSITIVITY;
                    currentPadAxes.leftStick_up = pad.axes[1] > GAMEPAD_SENSITIVITY;
                    currentPadAxes.leftStick_down = pad.axes[1] < -GAMEPAD_SENSITIVITY;

                    currentPadAxes.rightStick_right = pad.axes[2] > GAMEPAD_SENSITIVITY;
                    currentPadAxes.rightStick_left = pad.axes[2] < -GAMEPAD_SENSITIVITY;
                    currentPadAxes.rightStick_up = pad.axes[3] > GAMEPAD_SENSITIVITY;
                    currentPadAxes.rightStick_down = pad.axes[3] < -GAMEPAD_SENSITIVITY;
                }
            }
        }
    }

    public static function pressed(pPadId: Int, pBtn : Int): Bool
    {
        if(_buttons != null && _buttons.exists(pPadId))
        {
            var state = _buttons.get(pPadId).get(pBtn);
            if( state == GamePadState.PRESSED )
            {
                _buttons.get(pPadId).set(pBtn, GamePadState.ON);
                return true;
            }
        }
        return false;
    }

    public static function check(pPadId: Int, pBtn : Int): Bool
    {
        if(_buttons != null && _buttons.exists(pPadId))
            return _buttons.get(pPadId).get(pBtn) != GamePadState.OFF;
        return false;
    }

    /**
     *
     * @param pPadId :
     * @param pDirection
     * @param pStick : 0 : left, 1 : right
     **/
    public static function direction(pPadId: Int, pDirection: GamePadAxes, ?pStick: Int = 0): Bool
    {
        if(_axes != null && _axes.exists(pPadId))
        {
            var padAxes : AxesData = _axes.get(pPadId);
            switch(pDirection)
            {
                case GamePadAxes.LEFT :
                    return pStick == 0 ? padAxes.leftStick_left : padAxes.rightStick_left;
                case GamePadAxes.RIGHT :
                    return pStick == 0 ? padAxes.leftStick_right : padAxes.rightStick_right;
                case GamePadAxes.UP :
                    return pStick == 0 ? padAxes.leftStick_up : padAxes.rightStick_up;
                case GamePadAxes.DOWN :
                    return pStick == 0 ? padAxes.leftStick_down : padAxes.rightStick_down;
            }
        }
        return false;
    }

}

enum GamePadAxes {
    LEFT;
    RIGHT;
    UP;
    DOWN;
}

enum GamePadState {
    PRESSED;
    ON;
    OFF;
}

typedef AxesData = {
    var leftStick_left   : Bool;
    var leftStick_right  : Bool;
    var leftStick_up     : Bool;
    var leftStick_down   : Bool;

    var rightStick_left  : Bool;
    var rightStick_right : Bool;
    var rightStick_up    : Bool;
    var rightStick_down  : Bool;
}