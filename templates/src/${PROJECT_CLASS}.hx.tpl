package;

import com.revolugame.age.core.Engine;

/**
 * ...
 * @author AGE project creator
 */
class ${PROJECT_CLASS} extends Engine 
{
	
	public function new () : Void
	{	
		super (${PROJECT_WIDTH}, ${PROJECT_HEIGHT}, new GameState());
	}
	
	public static function main () : Void
	{	
		new ${PROJECT_CLASS}();
	}	

}
