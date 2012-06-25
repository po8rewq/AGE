package ;

import com.revolugame.age.core.State;
import com.revolugame.age.AgeData;
import com.revolugame.age.AgeUtils;
import com.revolugame.age.display.Entity;
import com.revolugame.age.display.TileMap;
import com.revolugame.age.display.Group;

/**
 * ...
 * @author Adrien Fischer
 */
class GameState extends State
{
	#if mobile
    var _top : TouchKey;
    var _left : TouchKey;
    var _right : TouchKey;
    #end
    
    var _frog : Frog;
//    var _map : TileMap;

	var _platforms : Array<Block>;
	var _platformsGroup : Group;
	
	var _uiGroup : Group;
	
	// Spawn data
    private static inline var _maxJumpWidth   : Int = 140;
    private static inline var _maxJumpHeight  : Int = 40;
    private static inline var _minJumpHeight  : Int = 30;
	
	public override function create() 
	{
		_platforms = new Array();
		_platformsGroup = new Group();
		add(_platformsGroup);
	
		_frog = new Frog(0, 0);
		
		initLevel();
		
		_uiGroup = new Group();
		add(_uiGroup);
		#if mobile
		_top = new TouchKey(AgeData.stageWidth - 50 - 30, AgeData.stageHeight - 50 * 2 - 10); _top.name = 'top';
		_uiGroup.add(_top);
		
		_left = new TouchKey(AgeData.stageWidth - 50 * 2 - 10, AgeData.stageHeight - 50); _left.name = 'left';
		_uiGroup.add(_left);
		
		_right = new TouchKey( AgeData.stageWidth - 50, AgeData.stageHeight - 50); _right.name = 'right';
		_uiGroup.add(_right);
		#end
	}
	
	private function initLevel()
	{
		fillStageWithPlatforms();
		add(_frog);
	}
	
	/**
     * Rempli tout l'ecran avec des plates formes générées aléatoirement
     */
    private function fillStageWithPlatforms():Void
    {
       	var nextOne : Block;
       
       	if(_platforms.length == 0)
       	{
       		// The floor platform
            var floor : Block = new Block(0, 0, AgeData.stageWidth, 10);
            floor.y = AgeData.stageHeight - floor.height;
            floor.x = 0;
            _platformsGroup.add(floor);
            _platforms.push(floor);
            nextOne = floor;
       	}
       	else
       	{
       		var pos : Int = _platforms.length - 1;
            do
            {
                nextOne = _platforms[ pos ];
                pos--;
            }
            while(pos >= 0);
        }
        
        // While we have a platform with a y position < 0, we create an other
		while( nextOne.y > 0 ) // TODO
		{
			nextOne = generatePlatformFrom(nextOne);
            _platformsGroup.add(nextOne);
            _platforms.push(nextOne);
		}
    }
    
    /**
     * Generate a new platform from a platform position and return it
     * @param pPrev
     * @return
     */
	private function generatePlatformFrom(pPrev: Block):Block
	{
        var nextPl : Block = new Block(0, 0, AgeUtils.rand(30, 100), 10);
        
        var minValueX : Int = Math.round( Math.max(0, pPrev.x - _maxJumpWidth - nextPl.width) );
        var maxValueX : Int = Math.round( Math.min(pPrev.x + pPrev.width + _maxJumpWidth, AgeData.stageWidth - nextPl.width) );
        nextPl.x = AgeUtils.rand(minValueX, maxValueX);

        var minValueY : Int = Math.round( pPrev.y - nextPl.height - _maxJumpHeight );
        var maxValueY : Int = Math.round( pPrev.y - nextPl.height - _minJumpHeight );
        nextPl.y = AgeUtils.rand(minValueY, maxValueY);
        
        return nextPl;
	}
	
	public override function update()
	{
		#if mobile
	    if(_top.mouseDown)
	    { 
	        _frog.jump();
	    }
	    
	    if(_left.mouseDown)
	    {
	        _frog.moveLeft();
	    }
	    if(_right.mouseDown)
	    {
	        _frog.moveRight();
	    }
	    #end
	        
	    super.update();
	}

}
