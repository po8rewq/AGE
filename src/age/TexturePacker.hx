package age;

import js.Dom;

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
	var _atlas : Hash<Frame>;

	/**
	 *
	 */
	public function new(pAtlasFile: String, pTextureSrc: String)
	{
		_atlas = new Hash();
	
		// if json
		var json = JSON.parse(pAtlasFile);
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
	
	public function getRegion(pName): Frame
	{
		return _atlas.get(pName);
	}
	
	public function createAnimationFromName(pName)
	{
		// TODO
	}

}

typedef Frame = {
	var filename : String;
	var rotated : Bool;
	var trimmed : Bool;
	var source : Rectangle;
}
