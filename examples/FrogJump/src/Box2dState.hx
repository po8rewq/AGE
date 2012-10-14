package ;

import com.revolugame.age.core.State;
import com.revolugame.age.display.Group;
import com.revolugame.age.AgeData;

/**
 * ...
 * @author Adrien Fischer
 */
class Box2dState extends State
{
	var _platforms : Array<B2Block>;
	var _platformsGroup : Group;
	
	public override function create() 
	{
		_platforms = new Array();
		_platformsGroup = new Group();
		add(_platformsGroup);
		
		var b : B2Block = new B2Block(100, 10, 150, 50);
		_platformsGroup.add(b);
		
		var ground : B2Block = new B2Block(0, 300, AgeData.stageWidth, 10, false);
		_platformsGroup.add(ground);
	}		

}
