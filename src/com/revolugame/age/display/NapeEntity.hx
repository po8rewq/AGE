package com.revolugame.age.display;

import com.revolugame.age.display.BasicEntity;
import com.revolugame.age.behaviors.NapeMovementBehavior;

import nme.display.BitmapData;

/**
 * ...
 * @author Adrien Fischer
 */
class NapeEntity extends BasicEntity 
{
	
	private var _napeBehavior : NapeMovementBehavior;
	
	public function new (pX: Float = 0, pY: Float = 0):Void
	{
		super(pX, pY);
	}
	
	public function initNapeStuff(pDynamic: Bool/*, graphics: BitmapData*/)
	{
		_napeBehavior = new NapeMovementBehavior(this, pDynamic/*, graphics*/);
		addBehavior(_napeBehavior);
	}

}
