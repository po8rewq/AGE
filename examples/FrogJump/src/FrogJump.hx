package;

import com.revolugame.age.core.Engine;

/**
 * ...
 * @author Adrien Fischer
 */
class FrogJump extends Engine 
{
	
	public function new () 
	{	
//		super (800, 600, new GameState());
		super (800, 600, new Box2dState());
	}
	
	public static function main () 
	{	
		new FrogJump();
	}	

}
