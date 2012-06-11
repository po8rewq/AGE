package ;

import com.revolugame.age.core.State;
import com.revolugame.age.AgeData;
import com.revolugame.age.display.Entity;

/**
 * ...
 * @author Adrien Fischer
 */
class GameState extends State
{
	
	public override function create() 
	{
		var frog : Frog;
		for(i in 0...1)
		{
	//		frog = new Frog( Math.round(Math.random() * AgeData.stageWidth), Math.round(Math.random() * AgeData.stageHeight) );
			frog = new Frog(50, 50);
	//		frog.play('run');
			
	//		frog.alpha = 0.4;
			
	//		frog.mirrorX = true;
	//		frog.mirrorY = true;
			
			add(frog);
		}
	
		var e : Entity;
		
		e = new Entity(30, 90);
		e.makeGraphic( 300, 20, 0xFFFF0000 );
		add(e);
		
		e = new Entity(230, 150);
		e.makeGraphic( 200, 20, 0xFFFF0000 );
		add(e);
	}		

}
