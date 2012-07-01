package com.revolugame.age.managers;

import com.revolugame.age.system.TileSheetData;

import nme.display.Graphics;
import nme.display.BitmapData;
import nme.display.Tilesheet;

class TileSheetManager
{

	public static var tilesheetsData : Array<TileSheetData> = new Array<TileSheetData>();

	/**
	 * Adds new tileSheet to manager and returns it
	 * If manager already contains tileSheet with the same bitmapData then it returns this tileSheetData object 
	 */
	public static function addTileSheet(bitmapData:BitmapData):TileSheetData
	{
		if (containsTileSheet(bitmapData))
			return getTileSheet(bitmapData);
		
		var tempTileSheetData : TileSheetData = new TileSheetData( new Tilesheet(bitmapData) );		
		tilesheetsData.push(tempTileSheetData);
		
		return (tilesheetsData[tilesheetsData.length - 1]);
	}
	
	public static function removeTileSheet(data: TileSheetData):Void
	{
		for (tsd in tilesheetsData)
		{
			if(tsd == data)
			{
				tsd.destroy();
				tilesheetsData.remove(tsd);
				tsd = null;
				return;
			}
		}
	}
	
	public static function containsTileSheet(bitmapData:BitmapData):Bool
	{
		for (tsd in tilesheetsData)
			if (tsd.tilesheet.nmeBitmap == bitmapData)
				return true;		
		return false;
	}
	
	public static function getTileSheet(bitmapData:BitmapData):TileSheetData
	{
		for (tsd in tilesheetsData)
			if (tsd.tilesheet.nmeBitmap == bitmapData)
				return tsd;		
		return null;
	}

}
