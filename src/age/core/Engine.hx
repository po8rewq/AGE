package age.core;

import age.core.Global;
import age.core.Input;
import age.display.State;

import haxe.Timer;

//#if js
import js.Dom;
import js.Lib;
//#elseif flash
//import flash.display.DisplayObjectContainer;
//import flash.events.Event;
//#end

#if debug
import age.debug.Stats;
#end

class Engine
{
	var _stageWidth : Int;
	var _stageHeight : Int;
	var _fps : Int;
	
	var _globalTimer : Timer;
//	#if js
//	var _stage : Body;
//	#elseif flash
//	var _stage : DisplayObjectContainer;
//	#end

	var _backgroundColor : String;

    var _last : Float;
    var _delta : Float;
    var _stepRate : Float;

    // --- Rendering ---
    var _canvas : Canvas; //HtmlDom;
    var _context : CanvasRenderingContext2D;

    // --- For pre-rendering ---
    var _offScreenCanvas : Canvas; //HtmlDom;
    var _offScreenContext : CanvasRenderingContext2D;

    #if debug
    var _stats : Stats;
    #end
	
	public function new(pWidth: Int, pHeight: Int, pFirstState: State, ?pFps: Int = 30, ?pBgColor: String = "")
	{
        Global.engine = this;

//		_stage = Lib.document.body;
		_backgroundColor = pBgColor;
	
		_stageWidth = pWidth;
		_stageHeight = pHeight;
		_fps = pFps;

        _last = Timer.stamp() * 1000;
        _delta = 0;
        _stepRate = 1000 / _fps;

		var doc = Lib.document;
		var body = doc.body;

//		#if js
		_canvas = cast doc.createElement('Canvas');
		_context = untyped _canvas.getContext('2d');
		body.appendChild( _canvas );

        _offScreenCanvas = cast doc.createElement('Canvas');
        _offScreenContext = untyped _offScreenCanvas.getContext('2d');

		// setup dimensions.
		_canvas.width = _offScreenCanvas.width = pWidth;
		_canvas.height = _offScreenCanvas.height = pHeight;
//		#elseif flash
//
//		#end

        new Input(_canvas);

		switchState(pFirstState);

        #if debug
        _stats = new Stats();
		_stats.setMode( 0 ); // 0 : fps, 1 : mem

		// Align top-left
		_stats.domElement.style.position = 'absolute';
		_stats.domElement.style.left = '0px';
		_stats.domElement.style.top = '0px';

		body.appendChild( _stats.domElement );
        #end
		
//		#if js
		var frequency = Std.int( _stepRate );
		_globalTimer = new Timer(frequency);
		_globalTimer.run = mainLoop;
//		#elseif flash
//		addEventListener(Event.ENTER_FRAME, mainLoop);
//		#end

        // force the 1st rendering, the browser will take the lead after that
        render();
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
//                #if debug
//                _stats.begin();
//                #end

                Input.update();

                _delta -= _stepRate;
                state.update();

//                #if debug
//                _stats.end();
//                #end
            }
        }
	}

    private function render()
    {
        #if debug
        _stats.begin();
        #end

        #if haxe3
        var w = js.Browser.window;
        #else
        var w = untyped Lib.window;
        #end
        w.requestAnimationFrame( render );

        if(_backgroundColor != "")
        {
            _offScreenContext.fillStyle = _backgroundColor;
            _offScreenContext.fillRect(0, 0, _stageWidth, _stageHeight);
        }
        else
        {
            _offScreenContext.clearRect(0, 0, _stageWidth, _stageHeight);
        }

        Global.currentState.render(_offScreenContext);

        // rendering
        _context.drawImage(_offScreenCanvas, 0, 0);

        #if debug
        _stats.end();
        #end
    }
	
}
