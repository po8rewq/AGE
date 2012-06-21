package com.revolugame.age.display;

import com.revolugame.age.managers.AssetsManager;
import flash.display.BitmapData;

class TileMap extends Group
{
	private var _data : Array<Int>;
	private var _source : BitmapData;
	private var _tileWidth : Int;
	private var _tileHeight : Int;
	
	private var _tiles : Array<Tile>;

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
		_data = new Array();
	
		var rows : Array<String> = pData.split("\n");
		var cols : Array<String>;
		var row : Int = 0;
		var col : Int = 0;
		var totalRows : Int = rows.length;
		var totalCols : Int = 0;
		while(row < totalRows)
		{
			cols = rows[row++].split(",");
			if(cols.length <= 1)
			{
				totalRows--;
				continue;
			}
			if (totalCols == 0)
			{
				totalCols = cols.length;
			}
			col = 0;
			while (col < totalCols)
			{
				_data.push(Std.parseInt(cols[col++]));
			}
		}
		
		_tileWidth = pTileWidth;
		_tileHeight = pTileHeight;
		
		_source = AssetsManager.getBitmap(pSrc);
		
		_tiles = new Array();
		var i : Int = 0;
		var len : Int = Math.floor(_source.width / _tileWidth * _source.height / _tileHeight);
		
		while(i < len)
		{
			_tiles[i] = new Tile(i, _tileWidth, _tileHeight, true);
			i++;
		}
	}
	
	public override function render()
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