package com.revolugame.age.enums;

enum CollisionsType
{
    LEFT;
    RIGHT;
    UP;
    DOWN;
    NONE;
    ANY;
}

class CollisionsEnum
{
	
	public static function getIntValue(val: CollisionsType):Int
	{
		return switch(val)
		{
			case CollisionsType.LEFT    : 0x0001;
			case CollisionsType.RIGHT   : 0x0010;
			case CollisionsType.UP      : 0x0100;
			case CollisionsType.DOWN    : 0x1000;
			case CollisionsType.NONE    : 0;
			case CollisionsType.ANY     : 1;
		}
	}
	
}
