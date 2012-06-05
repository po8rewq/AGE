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
		trace('created');
		
		var frog : Frog = new Frog(50, 10);
		add(frog);
		frog.play('run');
		
		var frog2 : Frog = new Frog(10, 50);
		add(frog2);
		frog2.play('jump');
	}		

}
