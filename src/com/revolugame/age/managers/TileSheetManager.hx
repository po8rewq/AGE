package com.revolugame.age.managers;

import com.revolugame.age.system.TileSheetData;

class TileSheetManager
{

	public static var tileSheetData:Array<TileSheetData> = new Array<TileSheetData>();

	/**
	 * Adds new tileSheet to manager and returns it
	 * If manager already contains tileSheet with the same bitmapData then it returns this tileSheetData object 
	 */
	public static function addTileSheet(bitmapData:BitmapData, ?isTilemap:Bool = false):TileSheetData
	{
		var tempTileSheetData:TileSheetData;
		
		if (containsTileSheet(bitmapData))
		{
			tempTileSheetData = getTileSheet(bitmapData);
			return getTileSheet(bitmapData);
		}
		
		tempTileSheetData = new TileSheetData(new Tilesheet(bitmapData), isTilemap);
		tileSheetData.push(tempTileSheetData);
		return (tileSheetData[tileSheetData.length - 1]);
	}
	
	/**
	 * Clears drawData arrays of all tileSheets
	 */
	public static function clearAllDrawData():Void
	{
		var numCameras:Int = FlxG.cameras.length;
		
		for (dataObject in tileSheetData)
		{
			dataObject.clearDrawData();
			if (dataObject.drawData.length < numCameras)
			{
				var diff:Int = numCameras - dataObject.drawData.length;
				for (i in 0...(diff))
				{
					dataObject.drawData.push(new Array<Float>());
				}
			}
		}
	}
	
	public static function renderAll():Void
	{
		var numCameras:Int = FlxG.cameras.length;
		for (dataObject in tileSheetData)
			dataObject.render(numCameras);
	}
	
	public static function containsTileSheet(bitmapData:BitmapData):Bool
	{
		for (tsd in tileSheetData)
			if (tsd.tileSheet.nmeBitmap == bitmapData)
				return true;		
		return false;
	}

}