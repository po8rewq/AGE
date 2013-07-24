package age.display;

import js.html.Image;
import age.Assets;
import age.geom.Rectangle;
import haxe.Json;

class TSContainer extends EntityContainer
{
	var _tilesheet : Image;
	var _description : Map<String, FrameData>;

	/**
	 * @param pTilesheet : image source path
	 * @param pDescription : json texture packer file descriptor
	 */
	public function new(pTilesheet: String, pDescription: String, pFormat: TileSheetFormat)
	{
		super();

		_tilesheet = Assets.getImage(pTilesheet);
		
		switch(pFormat)
		{
			case SPARROW:
				parseSparrowXml(Assets.getText("knl"));
			case TEXTURE_PACKER_JSON:
				parseTexturePackerJson(Assets.getText('data'));
		}		
	}

	/**
	 * Texture packer json file
	 */
	private function parseTexturePackerJson(pText: String)
	{
		_description = new Map();

		var data = Json.parse( pText );
		var frame : FrameData;
		var rect : Dynamic;
		var name : String;

		var frames : Array<Dynamic> = Reflect.field(data, "frames");
		for(f in frames)
		{
			rect = Reflect.field(f, "frame");
			name = Reflect.field(f, "filename");

			frame = {
				name: name,
				rotated: Reflect.field(f, "rotated"),
				trimmed: Reflect.field(f, "trimmed"),
				rect: {
					x: Reflect.field(rect, "x"),
					y: Reflect.field(rect, "y"),
					width: Reflect.field(rect, "w"),
					height: Reflect.field(rect, "h")
				}
			}
			_description.set(name, frame);
		}
	}

	/**
	 * Texture Atlas from the Sparrow framework
	 * cf : http://doc.starling-framework.org/core/starling/textures/TextureAtlas.html	 
	 */
	private function parseSparrowXml(pText: String)
	{
		_description = new Map();

		var frame : FrameData;
		var name : String;

		var xml = Xml.parse( pText );
		var fast = new haxe.xml.Fast(xml.firstElement());

		for(st in fast.nodes.SubTexture)
		{
			name = st.att.name;
			frame = {
				name: name,
				rect: {
					x: Std.parseInt(st.att.x),
					y: Std.parseInt(st.att.y),
					width: Std.parseInt(st.att.width),
					height: Std.parseInt(st.att.height)
				}
			};
			_description.set(name, frame);
		}
	}

	public function getFrame(pName: String): FrameData
	{
		return _description.get(pName);
	}

	public function getTilesheet(): Image
	{
		return _tilesheet;
	}
}

typedef FrameData = {
	var name : String;
	var rect : Rectangle;
	@:optional var rotated : Bool;
	@:optional var trimmed : Bool; // not supported for now	
}

enum TileSheetFormat {
	SPARROW;
	TEXTURE_PACKER_JSON;
}