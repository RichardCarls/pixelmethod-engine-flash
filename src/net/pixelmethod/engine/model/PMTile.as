package net.pixelmethod.engine.model {
	
	public class PMTile {
		
		// PUBLIC PROPERTIES
		public var tileset:PMTileset;
		public var xClip:uint;
		public var yClip:uint;
		public var nextTile:uint;
		
		// PRIVATE PROPERTIES
		
		public function PMTile( a_tileset:PMTileset, a_xClip:uint, a_yClip:uint, a_nextTile:uint = NaN ) {
			tileset = a_tileset;
			xClip = a_xClip;
			yClip = a_yClip;
			nextTile = a_nextTile;
		}
		
		// PUBLIC API
		
	}
}
