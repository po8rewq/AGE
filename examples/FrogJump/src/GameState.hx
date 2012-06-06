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
		
		frog = new Frog(10, 50);
		add(frog);
		frog.play('jump');
		
		frog = new Frog(90, 50);
		add(frog);
		frog.play('jump');
		frog.angle =  90;
		
		frog = new Frog(150, 50);
		add(frog);
		frog.play('run');
		frog.alpha = 0.7;
	}		

}
