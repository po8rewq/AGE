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
		var tempTileSheetData:TileSheetData;
		
		if (containsTileSheet(bitmapData))
		{
			tempTileSheetData = getTileSheet(bitmapData);
			return getTileSheet(bitmapData);
		}
		
		tempTileSheetData = new TileSheetData( new Tilesheet(bitmapData) );		
		tilesheetsData.push(tempTileSheetData);
		return (tilesheetsData[tilesheetsData.length - 1]);
	}
	
	/**
	 * Clears drawData arrays of all tileSheets
	 */
	public static function clearAllDrawData():Void
	{
		
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