package age;

import js.html.Image;
import haxe.Json;
import age.geom.Rectangle;

class TexturePacker
{

	/**
	 * the image texture itself
	 */
	var _texture : Image;
	
	/**
	 * the atlas dictionnary
	 */
	var _spriteAtlas : Map<String, Frame>;
	var _clipAtlas : Map<String, Map<Int, Frame>>;

	/**
	 *
	 */
	public function new(pAtlasFile: String, pTextureSrc: String)
	{
		_spriteAtlas = new Map();
		_clipAtlas = new Map();
	
		// if json
		var json = Json.parse(pAtlasFile);
		var frames = Reflect.field(json, "frames");
		var frame : Frame;
		for(frameData in frames)
		{
			frame = {
				filename: Reflect.field(frameData, "filename"),
				rotated: Reflect.field(frameData, "rotated"),
				trimmed: Reflect.field(frameData, "trimmed"),
				source: {
					x: Reflect.field(frameData, ""), 
					y: Reflect.field(frameData, ""),
					width: Reflect.field(frameData, ""),
					height: Reflect.field(frameData, "")
				}
			}
		}
	}
	
	public function getSpriteRegion(pName: String): Frame
	{
		return _spriteAtlas.get(pName);
	}

	public function getClipRegion(pName: String): Map<Int, Frame>
	{
		return _clipAtlas.get(pName);	
	}

}

typedef Frame = {
	var filename : String;
	var rotated : Bool;
	var trimmed : Bool;
	var source : Rectangle;
}
