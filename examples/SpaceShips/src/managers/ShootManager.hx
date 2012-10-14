package managers;

import entities.Shoot;

import com.revolugame.age.display.Group;

/**
 * ...
 * @author Adrien Fischer
 */
class ShootManager 
{
	//::///////////////////
	//::// Static data
	//::///////////////////

	private static var _self : ShootManager;
	
	public static function getInstance():ShootManager
	{
		if(_self == null) _self = new ShootManager();
		return _self;
	}
	
	//::///////////////////
	//::// 
	//::///////////////////
	
	private var _init : Bool;
	
	private var _pool : List<Shoot>;
			
	private function new () 
	{
		_init = false;
		_pool = new List();
	}
	
	public function add(pStage:Group, pX:Float, pY:Float)
	{
		var shoot : Shoot;
		if(_pool.length > 0)
		{
			shoot = _pool.pop();
			shoot.x = pX;
			shoot.y = pY;
		}
		else
		{
		   	shoot = new Shoot(pX, pY);
		}
		pStage.add(shoot);
	}
	
	public function remove(pShoot: Shoot):Void
	{
		pShoot.parent.remove(pShoot, false);
	
		_pool.add(pShoot);
	}

}
