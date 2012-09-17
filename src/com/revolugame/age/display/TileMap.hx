package com.revolugame.age.display;

import com.revolugame.age.managers.AssetsManager;
import com.revolugame.age.display.ICollideEntity;
import com.revolugame.age.display.DrawingContext;
import com.revolugame.age.system.AgePoint;
import com.revolugame.age.system.quadtree.QuadTree;
import com.revolugame.age.system.quadtree.QuadTreeEntity;

#if cpp
import com.revolugame.age.managers.TileSheetManager;
#end

import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.geom.Point;

class TileMap extends Group, implements IDrawable
{
	private var _source : BitmapData;
	
	/** Tile size (pixels) */
	private var _tileWidth : Int;
	private var _tileHeight : Int;
	private var _mapWidth : Int;
	private var _mapHeight : Int;
	
	/** Tileset size */
	private var _tilesetWidth : Int;
	private var _tilesetHeight : Int;
	
	private var _tiles : Array<Tile>;
	
//	public var x : Float;
//	public var y : Float;
	
//	public var visible : Bool;
//	public var dead : Bool;
	
//	public var parent : Group;

    /** Scale  */
    public var scale : AgePoint;
    
    /** Angle */
	public var rotation : Float;
	
	/** Alpha */
	public var alpha : Float; // TODO flash

	private var _spriteMap : SpriteMap;
	private var _drawingContext : DrawingContext;

	public function new(pTileset: String, pTilesetWidth: Int, pTilesetHeight: Int, pTileWidth: Int, pTileHeight: Int)
	{		
		super();
		
		x = y = 0;
		visible = true;
		dead = false;
		
		scale = new AgePoint(1, 1);
        rotation = 0;
		alpha = 1.0;
	
		_tileWidth = pTileWidth;
		_tileHeight = pTileHeight;
		
		_tilesetWidth = pTilesetWidth;
		_tilesetHeight = pTilesetHeight;
		
		_source = AssetsManager.getBitmap(pTileset);
		
		_spriteMap = new SpriteMapExt();
		_drawingContext = new DrawingContext();
		
		#if cpp
		_spriteMap.loadGraphic(pTileset, pTileWidth, pTileHeight);
		#end
	}
	
	/** Just to be sure that nothing is really added on this fake group */
	public override function add(pEntity: IEntity):Void {}
	public override function remove(pEntity: IEntity, ?pDestroy: Bool = true):Void {}
	
	/**
	 * 
	 */
	public function loadFromArray(pData:Array<Array<Int>>)
	{
		_mapWidth = pData[0].length * _tileWidth;
		_mapHeight = pData.length * _tileHeight;
	
		#if flash
		_buffer = new BitmapData(_mapWidth, _mapHeight, true, 0xff0000);
		#end
	
		_tiles = new Array();
		
		for (y in 0...pData.length)
		{
			for (x in 0...pData[0].length)
			{
				setTile(x, y, pData[y][x]);
			}
		}
	}
	
	/**
	 * Sets the index of the tile at the position.
	 * @param	pCol		Tile column.
	 * @param	pRow		Tile row.
	 * @param	pIndex		Tile index.
	 */
	public function setTile(pCol:Int, pRow:Int, pIndex:Int)
	{
		var tile : Tile = new Tile(pIndex, pCol * _tileWidth, pRow * _tileHeight, _tileWidth, _tileHeight);
		tile.parent = this;
		_tiles.push( tile );
		entities.add(tile); // PAS COOL FIXME
	}
	
	public override function update(): Void {}
	
	#if flash
	private var _buffer : BitmapData;
	#end
	private function drawFrame()
	{
	    // Destination point
	    var destPoint : Point = new Point();
		var bounds : Rectangle;
	
		#if flash
		_buffer.lock();
				
		var bmpRect: Rectangle = new Rectangle(0, 0, _tileWidth, _tileHeight);
		#end
	
	    #if cpp
	    _drawingContext.data = new Array();
	    #end
		
		for(t in _tiles)
		{
		    #if flash
			bmpRect.x = t.id % _tilesetWidth * _tileWidth;
			bmpRect.y = Std.int(t.id / _tilesetWidth) * _tileHeight;
			#end
			
			bounds = t.getBounds();
			destPoint.x = bounds.x;
			destPoint.y = bounds.y;
			
			#if flash
			_buffer.copyPixels( _source, bmpRect, destPoint );
			#elseif cpp
			// Plutot que stocker dans un tableau et tout faire au moment du render, on s'en occupe ici ... FIXME
			_drawingContext.pushSingleContextData( x + destPoint.x, y + destPoint.y, t.id );
			#end
		}
		
		#if flash
		_buffer.unlock();
		
		_spriteMap.pixels = _buffer;
		#end
	}
	
	public override function render(): Void
	{
		if(visible && /*onScreen() &&*/ _spriteMap != null)
		{
			drawFrame();
			
			AgeData.renderer.prepareRendering();
            #if !cpp
			_drawingContext.addSingleContextData( x, y, scale.x, scale.y, rotation, alpha, false, false );
			#end
			AgeData.renderer.render( _spriteMap, _drawingContext);
		}
	}
	
	public override function destroy(): Void
	{
	    // TODO
	}
	
	/**
	 * Gets the index of a tile, based on its column and row in the tileset.
	 * @param	tilesColumn		Tileset column.
	 * @param	tilesRow		Tileset row.
	 * @return	Index of the tile.
	 */
	public function getIndex(pCol:Int, pRow:Int):Int
	{
		return (pRow % _mapHeight) * _mapWidth + (pCol % _mapWidth);
	}

}

class Tile implements IEntity, implements ICollideEntity
{
	public var id: Int;
	
	public var width: Int;
	public var height : Int;
	
	public var x : Float;
	public var y : Float;
	
	public var visible : Bool;
	public var dead : Bool;
	
	public var parent : Group;
	
    public var quadTreeEntity : QuadTreeEntity;
    
    public function new(pId:Int, pX:Int, pY:Int, pWidth:Int, pHeight:Int)
    {
    	visible = true;
    	dead = false;
    
    	id = pId;
    	width = pWidth;
    	height = pHeight;
    	x = pX;
    	y = pY;
    	
    	solid = true;
    }
    
    public var solid(getIsSolid, setIsSolid) : Bool;
    private function getIsSolid():Bool
    {
    	return id > 0;
    	// TODO : add a custom function to do this : Void->Bool
    }
    private function setIsSolid(val:Bool):Bool
    { 
    	if(id > 0)
    	{
	    	initQuadTree();
	    }
    	return val; 
    }
    
    /**
	 * Initialize the entity for collisions detection
	 */
	private function initQuadTree()
	{			
		// If this is the first time we are accessing the quad tree
		if(AgeData.quadtree == null)
			AgeData.quadtree = new QuadTree(AgeData.stageWidth, AgeData.stageHeight, 0);
		
		if(quadTreeEntity == null)
		{
			quadTreeEntity = new QuadTreeEntity(this);
			AgeData.quadtree.insert(quadTreeEntity);
		}
	}
    
    private var _bounds : Rectangle;    
    public function getBounds():Rectangle
    {
    	if(_bounds == null) _bounds = new Rectangle();
    	_bounds.x = x;
    	_bounds.y = y;
    	_bounds.width = width;
    	_bounds.height = height;
    	return _bounds;
    }
    
    public function update():Void{}
    public function render():Void{}
    public function destroy():Void
    {
    	// TODO
    }
}

class SpriteMapExt extends SpriteMap
{

	public function new()
	{
		super();
	}
	
	#if cpp
	/**
	 * Override the loadGraphic function to load the tileset
	 */
	public override function loadGraphic(pSrc: String, pWidth: Int = 0, pHeight: Int = 0):Void
	{
	    pixels = AssetsManager.getBitmap(pSrc);
		tilesheetdata = TileSheetManager.addTileSheet(pixels);
			
	    rects = new Array();
	    var i : Int = 0;
	    var x : Int;
	    var y : Int;
	    for(row in 0...1)
	    {
	        for(col in 0...5)
	        {
	            x = col * pWidth;
	            y = row * pHeight;
	            rects[i] = new Rectangle(x, y, pWidth, pHeight);
	            tilesheetdata.tilesheet.addTileRect( rects[i++] );
	        }
	    }
	}
	#end
	
	public override function getRect():Rectangle
	{
		return pixels.rect;
	}

}
