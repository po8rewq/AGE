package com.revolugame.age.core;

import nme.Lib;
import nme.events.Event;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.FPS;

import com.revolugame.age.ui.Input;
import com.revolugame.age.core.Renderer;

class Engine extends Sprite
{
	// Gestion du rafraichissement
    private var _stepRate	: Float;
    private var _last		: Float;
    private var _now		: Float;
    private var _delta		: Float;

	public function new(pWidth: Int, pHeight: Int, pState: State):Void
	{
		super();
		
		AgeData.state = pState;
		AgeData.engine = this;
		
		AgeData.stageWidth = pWidth;
		AgeData.stageHeight = pHeight;
		
		Lib.current.addChild(this);
		
		if (stage != null) 
			create();
		else 
			addEventListener(Event.ADDED_TO_STAGE, create);
	}
	
	private function create(pEvt:Event = null):Void
    {
    	if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, create);
        
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        
        AgeData.stageHeight = stage.stageHeight; //pHeight;
		AgeData.stageWidth = stage.stageWidth; //pWidth;
        
        // Game start
        init();
        
        _stepRate = 1000 / stage.frameRate;
        _last = Lib.getTimer();
        _now = _last;
        _delta = 0;
        
        // Init and enable input
        Input.init(stage);

		// Initialisation des données de la camera
		AgeData.camera = new Camera(stage.stageWidth, stage.stageHeight);

		// Initialisation du premier ecran
        stage.addChild( AgeData.camera.screen );
        
        #if debug
		var fps:FPS = new FPS();
        stage.addChild(fps);
		fps.x = 10;
		fps.y = 10;
		fps.textColor = 0x000000;
		#end
		
		AgeData.renderer = new Renderer();

        // Initialisation du premier ecran
        AgeData.state.create();
        
        addEventListener(Event.ENTER_FRAME, loop);
    }
	
	/**
	 * Override this, called after Engine has been added to the stage.
	 */
	public function init() : Void { }

	/**
	 * Override this, called when game gains focus
	 */
	public function focusGained() : Void { }

	/**
	 * Override this, called when game loses focus
	 */
	public function focusLost() : Void { }

	/**
	 *
 	 * @param pState
	 */
	private function switchView(pState : State) : Void
	{
    	if(pState == AgeData.state) return;

	    if(AgeData.state != null)
	    {
	        // on met tout en pause
	        AgeData.state.destroy();
	    }
	
	    AgeData.state = pState;
	    pState.create();
    }

	/**
	 * Main loop
	 */
	public function loop(pEvt: Event) : Void
	{
		_now = Lib.getTimer();
		
		AgeData.elapsed = (_now - _last) / 1000;
		
	    _delta += _now - _last;
	    _last = _now;
	
	    AgeData.camera.lock();
	    
	    if(_delta >= _stepRate)
	    {
	        while(_delta >= _stepRate)
	        {
	            _delta -= _stepRate;
	            AgeData.state.update();
	        }
	    }
	    
	    AgeData.camera.clear();
	    
	    // update input
		Input.update();
	    
	    AgeData.state.render();
	    
	    AgeData.camera.unlock();
	}

}
