package age.core;

import age.utils.HtmlUtils;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Event;
import age.core.Global;
import age.core.Input;
import age.display.State;

import haxe.Timer;

//#if js

//#elseif flash
//import flash.display.DisplayObjectContainer;
//import flash.events.Event;
//#end

#if debug
import age.debug.Stats;
#end

class Engine
{
    public var stageWidth(default, null) : Int;
	public var stageHeight(default, null) : Int;

    public var stageScaleX(default, null) : Float;
    public var stageScaleY(default, null) : Float;

	var _fps : Int;
	
	var _globalTimer : Timer;

	var _backgroundColor : String;

    var _last : Float;
    var _delta : Float;
    var _stepRate : Float;

    // --- Rendering ---
    var _canvas : CanvasElement;
    var _context : CanvasRenderingContext2D;

    // --- For pre-rendering ---
    var _offScreenCanvas : CanvasElement;
    var _offScreenContext : CanvasRenderingContext2D;

    #if debug
    var _stats : Stats;
    #end

    var _animFunction: Dynamic;
	
	public function new(pWidth: Int, pHeight: Int, pFirstState: State, ?pKeepRatio: Bool = true, ?pFps: Int = 30, ?pBgColor: String = "", ?pDivContainer: String = "")
	{
        Global.engine = this;

//		_stage = Lib.document.body;
		_backgroundColor = pBgColor;
	
		stageWidth = pWidth;
		stageHeight = pHeight;
		_fps = pFps;

        _last = Timer.stamp() * 1000;
        _delta = 0;
        _stepRate = 1000 / _fps;

		var doc = js.Browser.document;
		var container = null;

//		#if js
		_canvas = cast doc.createElement('Canvas');
		_context = untyped _canvas.getContext('2d');

        if(pDivContainer != "")
		    container = doc.getElementById(pDivContainer);
        else
            container = doc.body;
        container.appendChild( _canvas );

        _offScreenCanvas = cast doc.createElement('Canvas');
        _offScreenContext = untyped _offScreenCanvas.getContext('2d');

		// setup dimensions.
		_canvas.width = _offScreenCanvas.width = pWidth;
		_canvas.height = _offScreenCanvas.height = pHeight;
        
        if(pKeepRatio)
            untyped _canvas.style.imageRendering  = "auto"; //"-webkit-optimize-contrast";

        new Input(_canvas);

		switchState(pFirstState);

        #if debug
        _stats = new Stats();
		_stats.setMode( 0 ); // 0 : fps, 1 : mem

		// Align top-left
		_stats.domElement.style.position = 'absolute';
		_stats.domElement.style.left = '0px';
		_stats.domElement.style.top = '0px';

		container.appendChild( _stats.domElement );
        #end
		
        var requestAnimFrame = HtmlUtils.loadExtension("requestAnimationFrame");
        if(requestAnimFrame != null)
        {
            _animFunction = requestAnimFrame.value;

            // force the 1st rendering, the browser will take the lead after that
            mainLoop();
        }
        else
        {
            trace("No requestAnimationFrame support, falling back to setInterval");
            var frequency = Std.int( _stepRate );
            _globalTimer = new Timer(frequency);
            _globalTimer.run = mainLoop;
        }

        // force the 1st rendering, the browser will take the lead after that
        mainLoop();

        js.Browser.window.onresize = onResizeEvent;
        onResizeEvent(null);
	}

    /**
     * Calcul du scale de l'ecran
     */
    private function onResizeEvent(pEvt: Event)
    { // SCALE REMOVED !!
        var scaleX = 1; //js.Browser.window.innerWidth / stageWidth;
        var scaleY = 1; //js.Browser.window.innerHeight / stageHeight;

        var scale = Math.min(scaleX, scaleY); // trace(scale);

        var stgWidth = stageWidth * scale;
        var stgHeight = stageHeight * scale;

        _canvas.style.width = Std.string(stgWidth) + "px";
        _canvas.style.height = Std.string(stgHeight) + "px";

        stageScaleX = 1; //stageWidth / stgWidth;
        stageScaleY = 1; //stageHeight / stgHeight;
    }

	public function switchState(pState: State)
	{
		if(Global.currentState != null)
            Global.currentState.destroy();

        pState.create();
        Global.currentState = pState;
	}
	
	private function mainLoop()
	{
        var state = Global.currentState;

        var now = Timer.stamp() * 1000;
        Global.elapsed = (now - _last) / 1000;
        _delta += now - _last;
        _last = now;

        if(_delta >= _stepRate)
        {
            if(_delta > 50)
            {   // pause
                _delta = _stepRate;
            }

            while(_delta >= _stepRate)
            {
                #if debug
                _stats.begin();
                #end

                _delta -= _stepRate;
                state.update();

                if(_backgroundColor != "")
                {
                    _offScreenContext.fillStyle = _backgroundColor;
                    _offScreenContext.fillRect(0, 0, stageWidth, stageHeight);
                }
                else
                {
                    _offScreenContext.clearRect(0, 0, stageWidth, stageHeight);
                }

                Global.currentState.render(_offScreenContext);

                // rendering
                _context.clearRect(0, 0, stageWidth, stageHeight);
                _context.drawImage(_offScreenCanvas, 0, 0);

                #if debug
                _stats.end();
                #end
            }
        }

        Input.update();

        if( _animFunction != null )
            Reflect.callMethod( js.Browser.window, _animFunction, [mainLoop] );
	}
	
}
