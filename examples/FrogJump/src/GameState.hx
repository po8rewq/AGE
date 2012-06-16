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
    var _top : TouchKey;
    var _left : TouchKey;
    var _right : TouchKey;
    
    var _frog : Frog;
	
	public override function create() 
	{
		_frog = new Frog(50, 50);
		add(_frog);
	
		var e : Block;		
		e = new Block(30, 90, 300, 20);
		add(e);
		
		e = new Block(230, 150, 200, 20 );
		add(e);
		
		e = new Block(0, AgeData.stageHeight - 10, AgeData.stageWidth, 10 );
		add(e);
		
		_top = new TouchKey(AgeData.stageWidth - 50 - 30, AgeData.stageHeight - 50 * 2 - 10);
		add(_top);
		
		_left = new TouchKey(AgeData.stageWidth - 50 * 2 - 10, AgeData.stageHeight - 50);
		add(_left);
		
		_right = new TouchKey( AgeData.stageWidth - 50, AgeData.stageHeight - 50);
		add(_right);
	}
	
	public override function update()
	{
	    if(_top.mouseDown)
	        _frog.jump();
	    
	    if(_left.mouseDown)
	        _frog.moveLeft();
	    else if(_right.mouseDown)
	        _frog.moveRight();
	        
	    super.update();
	}

}
