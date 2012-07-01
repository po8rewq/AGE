package ;

import com.revolugame.age.core.State;
import com.revolugame.age.AgeData;
import com.revolugame.age.display.Group;

/**
 * ...
 * @author Adrien Fischer
 */
class GameState extends State
{
	var _game : Group;
	var _ship : Ship;
	
	public override function create() 
	{
		_game = new Group();
		add(_game);
	
		_ship = new Ship( AgeData.stageWidth / 2, AgeData.stageHeight / 2 );
		_game.add(_ship);
	}
	
	public override function update()
	{
//		if( _ship.mouseDown )
//		{
			_ship.moveTo( AgeData.engine.mouseX, AgeData.engine.mouseY );
//		}
//		else
//		{
//			_ship.stopMovement();
//		}
	
		super.update();		
	}

}
