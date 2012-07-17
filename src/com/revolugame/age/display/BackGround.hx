package com.revolugame.age.display;

/**
 * A simple image used for background
 */
class BackGround extends Image
{

	var _repeatX : Bool;
	var _repeatY : Bool;

	/**
	 * @param pSrc : image source
	 * @param pRepeatX / pRepeatY : if the image has to be repeated
	 */
	public function new(pSrc:String, ?pRepeatX: Bool = false, ?pRepeatY: Bool = false)
	{
		super(0, 0);
		loadGraphic(pSrc);
	}
	
	public override function update()
	{
	
		super.update();
	}

}