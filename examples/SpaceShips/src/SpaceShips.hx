package;

import com.revolugame.age.core.Engine;

/**
 * ...
 * @author Adrien Fischer
 */
class SpaceShips extends Engine 
{
	
	public function new () 
	{	
		super (800, 600, new GameState());
		
	}
	
	public static function main () 
	{	
		new SpaceShips();
	}	

}