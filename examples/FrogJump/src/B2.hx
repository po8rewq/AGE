package ;

import com.revolugame.age.display.Box2dEntity;
import com.revolugame.age.AgeUtils;

/**
 * ...
 * @author Adrien Fischer
 */
class B2 extends Box2dEntity {
	
	public function new (pX: Int, pY: Int) {
		
		super(pX, pY);
		
	}	
	
	public function throwMe()
	{
		_b2dBehavior.applyImpulse(AgeUtils.rand(2, 5), AgeUtils.rand(2, 5));
	}
	
	public override function update():Void
	{
		if(justPressed)
		{
			throwMe();
		}
		super.update();
	}

}
