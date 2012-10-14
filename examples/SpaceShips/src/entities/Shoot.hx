package entities;

import com.revolugame.age.display.QuadTreeEntity;
import com.revolugame.age.enums.DirectionsEnum;
import com.revolugame.age.AgeData;

import managers.ShootManager;

/**
 * ...
 * @author Adrien Fischer
 */
class Shoot extends QuadTreeEntity
{
	
	public function new (pX: Float, pY: Float) 
	{
		super(pX, pY);
		
		movable = true;
//		solid = true;
		
		_movement.moveSpeed = 3;
		_movement.maxVelocity.x = 4;
		_movement.maxVelocity.y = 4;
		
		loadGraphic("gfx/shoot.png");		
	}
	
	public override function update()
	{
		// if hors screen on destroy
		if( x > AgeData.stageWidth ) 
		{
			ShootManager.getInstance().remove(this);
		}
		else
		{
			_movement.moveToDirection( DirectionsEnum.RIGHT );
			super.update();
		}
	}

}
