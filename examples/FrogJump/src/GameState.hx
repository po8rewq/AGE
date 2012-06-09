package ;

import com.revolugame.age.core.State;
import com.revolugame.age.AgeData;

/**
 * ...
 * @author Adrien Fischer
 */
class GameState extends State
{
	
	public override function create() 
	{
		var frog : Frog;
		for(i in 0...500)
		{
			frog = new Frog( Math.round(Math.random() * AgeData.stageWidth), Math.round(Math.random() * AgeData.stageHeight) );
	//		frog.play('run');
			
	//		frog.alpha = 0.4;
			
	//		frog.mirrorX = true;
	//		frog.mirrorY = true;
			
			add(frog);
		}
	}		

}
