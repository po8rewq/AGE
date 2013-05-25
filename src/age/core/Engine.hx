package age.core;

import age.core.Global;
import age.core.Input;
import age.display.State;

import haxe.Timer;

#if js
import js.Dom;
import js.Lib;
#elseif flash
import flash.display.DisplayObjectContainer;
import flash.events.Event;
#end

class Engine
{
	var _stageWidth : Int;
	var _stageHeight : Int;
	var _fps : Int;
	
	var _globalTimer : Timer;
	#if js
	var _stage : Body;
	#elseif flash
	var _stage : DisplayObjectContainer;
	#end

	var _backgroundColor : String;

    var _last : Float;
    var _delta : Float;
    var _stepRate : Float;
	
	public function new(pWidth: Int, pHeight: Int, pFirstState: State, ?pFps: Int = 30, ?pBgColor: String = "")
	{		
		_stage = Lib.document.body;
		_backgroundColor = pBgColor;
	
		_stageWidth = pWidth;
		_stageHeight = pHeight;
		_fps = pFps;

        _last = Timer.stamp() * 1000;
        _delta = 0;
        _stepRate = 1000 / _fps;
		
		new Input(_stage);

		var doc = Lib.document;
		var body = doc.body;

		#if js
		Global.dom = doc.createElement('Canvas');
		var canvas: Canvas  = cast Global.dom;
		// grab the CanvasRenderingContext2D for drawing on
		Global.context = untyped canvas.getContext('2d');
		// style can be used for postioning/styling the div or canvas.
		var style = Global.dom.style;
		// add the canvas to the body of the document
		body.appendChild( Global.dom );
		// setup dimensions.
		canvas.width = pWidth;
		canvas.height = pHeight;
		#elseif flash
		
		#end

		switchState(pFirstState);
		
		#if js
		var frequency = Std.int( _stepRate );
		_globalTimer = new Timer(frequency);
		_globalTimer.run = mainLoop;
		#elseif flash
		addEventListener(Event.ENTER_FRAME, mainLoop);
		#end
	}

	public function switchState(pState: State)
	{
		if(Global.currentState != null)
            Global.currentState.destroy();

        pState.create();
        Global.currentState = pState;
	}
	
	#if flash
	private function mainLoop(pEvt: Event)
	#else
	private function mainLoop()
	#end
	{
        var state = Global.currentState;

        var now = Timer.stamp() * 1000;
        Global.elapsed = (now - _last) / 1000;
        _delta += now - _last;
        _last = now;

        if(_delta >= _stepRate)
        {
            while(_delta >= _stepRate)
            {
                _delta -= _stepRate;
                state.update();
            }
        }

        Input.update(); // voir si besoin de le passer dans la boucle

        if(_backgroundColor != "")
        {
            Global.context.fillStyle = _backgroundColor;
            Global.context.fillRect(0, 0, _stageWidth, _stageHeight);
        }
        else
        {
            Global.context.clearRect(0, 0, _stageWidth, _stageHeight);
        }
		state.render(Global.context);
	}
	
}
