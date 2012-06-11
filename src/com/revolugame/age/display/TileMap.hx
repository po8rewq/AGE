package com.revolugame.age.display;

class TileMap extends Group
{

	public function new()
	{
		super();
	}
	
	/**
	 * Load the tilemap with string data and a tile graphic. 
	 * @param pData CSV
	 * @param pSrc
	 * @param pTileWidth
	 * @param pTileHeight
	 */
	public function loadMap(pData: String, pSrc: Dynamic, pTileWidth: Int, pTileHeight: Int)
	{
		
	}
	
	/**
	 * Converts a one-dimensional array of tile data to a comma-separated string.
	 * @param	Data		An array full of integer tile references.
	 * @param	Width		The number of tiles in each row.
	 * @return	A comma-separated string containing the level data in a <code>FlxTilemap</code>-friendly format.
	 */
	static public function arrayToCSV(pData:Array<Int>, pWidth:Int):String
	{
		var row : Int = 0;
		var column : Int;
		var csv : String = "";
		var pHeight : Int = Std.int(pData.length / pWidth);
		var index : Int;
		while(row < pHeight)
		{
			column = 0;
			while(column < pWidth)
			{
				index = pData[row * pWidth + column];				
				if(column == 0)
				{
					if (row == 0)
						csv += index;
					else
						csv += "\n" + index;
				}
				else
				{
					csv += ", "+index;
				}
				column++;
			}
			row++;
		}
		return csv;
	}

}