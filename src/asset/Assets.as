package asset {
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.PMTileset;
	
	public class Assets {
		
		// EMBEDDED ASSETS
		
		// Tilesets
		[Embed('ts_flashman.xml', mimeType='application/octet-stream')]
		private static var TS_FLASHMAN_XML:Class;
		[Embed('ts_flashman.png')]
		private static var TS_FLASHMAN_BMP:Class;
		
		[Embed('ts_debug.xml', mimeType='application/octet-stream')]
		private static var TS_DEBUG_XML:Class;
		[Embed('ts_debug.png')]
		private static var TS_DEBUG_BMP:Class;
		
		public function Assets() {
			PMGameManager.instance.registerTileset(
				"ts_flashman",
				getTilesetFromAsset(new TS_FLASHMAN_XML(), Bitmap(new TS_FLASHMAN_BMP()).bitmapData)
			);
			PMGameManager.instance.registerTileset(
				"ts_debug",
				getTilesetFromAsset(new TS_DEBUG_XML(), Bitmap(new TS_DEBUG_BMP()).bitmapData)
			);
		}
		
		// PUBLIC API
		public function getTilesetFromAsset( a_xmlBytes:ByteArray, a_bitmapData:BitmapData):PMTileset {
			var tileset:PMTileset;
			var tsData:XML = new XML(a_xmlBytes.readUTFBytes(a_xmlBytes.length));
			var props:Object = {
				id: tsData.@id,
				tileWidth: tsData.@tileWidth,
				tileHeight: tsData.@tileHeight,
				bitmapData: a_bitmapData,
				tiles: []
			};
			
			// Get Tiles
			for each ( var tile:XML in tsData.tiles[0].tile ) {
				props.tiles.push({
					xClip: tile.@xClip,
					yClip: tile.@yClip,
					next: tile.attribute("next")
				});
			}
			
			tileset = new PMTileset();
			tileset.init(props);
			
			return tileset;
		}
		
	}
	
}
