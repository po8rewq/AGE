package ;

import com.revolugame.age.core.State;
import com.revolugame.age.display.Group;
import com.revolugame.age.AgeData;
import flash.Lib;

/**
 * ...
 * @author Adrien Fischer
 */
class Box2dState extends State
{
	var _platforms : Array<B2>;
	var _platformsGroup : Group;
	
	public override function create() 
	{
		_platforms = new Array();
		_platformsGroup = new Group();
		add(_platformsGroup);
		
		var top : B2Wall = new B2Wall(0, 0, AgeData.stageWidth, 10, false);
		_platformsGroup.add(top);
		
		var leftWall : B2Wall = new B2Wall(0, 10, 10, AgeData.stageHeight - 20, false);
		_platformsGroup.add(leftWall);
		
		var rightWall : B2Wall = new B2Wall(AgeData.stageWidth - 10, 10, 10, AgeData.stageHeight - 20, false);
		_platformsGroup.add(rightWall);
		
		var ground : B2Wall = new B2Wall(0, AgeData.stageHeight - 10, AgeData.stageWidth, 10, false);
		_platformsGroup.add(ground);
		
		prevTimer = Lib.getTimer();
	}
	
	private function addBlock(pX, pY):B2Img
	{
		var b : B2Img = new B2Img(pX, pY, 40, 40);
		_platformsGroup.add(b);
		return b;
	}
	
	var prevTimer : Float;
	public override function update()
	{
		if(_platformsGroup.entities.length < 40) 
		{
			var currentTimer : Float = Lib.getTimer();
			if(currentTimer - prevTimer > 300)
			{
				var b  = addBlock(10, 10);
				b.throwMe();
				prevTimer = currentTimer;
			} 
		}
		
		super.update();
	}

}
