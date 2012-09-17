package com.revolugame.age.enums;

class CollisionsEnum
{

	public static inline var LEFT	: Int = 0x0001;
	public static inline var RIGHT	: Int = 0x0010;
	public static inline var UP		: Int = 0x0100;
	public static inline var DOWN 	: Int = 0x1000;
	public static inline var NONE 	: Int = 0;
	public static inline var ANY 	: Int = LEFT | RIGHT | UP | DOWN;
	
}
