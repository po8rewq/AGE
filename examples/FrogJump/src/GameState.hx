package ;

import com.revolugame.age.core.State;

/**
 * ...
 * @author Adrien Fischer
 */
class GameState extends State
{
	
	public override function create() 
	{		
		var frog : Frog = new Frog(150, 10);
		add(frog);
		frog.play('run');
		
		var frog2 : Frog = new Frog(10, 50);
		add(frog2);
		frog2.play('jump');
	}		

}
