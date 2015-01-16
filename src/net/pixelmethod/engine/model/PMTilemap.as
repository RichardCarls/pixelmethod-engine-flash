package net.pixelmethod.engine.model {
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.PMTileset;
	import net.pixelmethod.engine.model.PMTile;
	
	public class PMTilemap {
		
		// PUBLIC PROPERTIES
		public function get numRows():uint { return _numRows; }
		public function get numCols():uint { return _numCols; }
		public function get tileWidth():uint { return _tileWidth; }
		public function get tileHeight():uint { return _tileHeight; }
		public function get renderTargetID():String { return _renderTargetID;}
		public function get layerID():String { return _layerID; }
		
		// PRIVATE PROPERTIES
		private var _numRows:uint;
		private var _numCols:uint;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		private var _renderTargetID:String;
		private var _layerID:String;
		
		[ArrayElementType('net.pixelmethod.engine.model.PMTileset')]
		private var tilesets:Array;
		
		[ArrayElementType('net.pixelmethod.engine.model.PMTile')]
		private var tiles:Array;
		
		public function PMTilemap() {
			tilesets = [];
			tiles = [];
		}
		
		// PUBLIC API
		public function init( a_props:Object = null ):void {
			if ( a_props.numRows ) { _numRows = a_props.numRows; }
			if ( a_props.numCols ) { _numCols = a_props.numCols; }
			if ( a_props.tileWidth ) { _tileWidth = a_props.tileWidth; }
			if ( a_props.tileHeight ) { _tileHeight = a_props.tileHeight; }
			if ( a_props.renderTarget ) { _renderTargetID = a_props.renderTarget; }
			if ( a_props.layer ) { _layerID = a_props.layer; }
			
			// Get Tileset Linkages
			if ( a_props.tilesets ) {
				for ( var i:int = 0; i < a_props.tilesets.length; i++ ) {
					tilesets.push(PMGameManager.instance.getTileset(a_props.tilesets[i]));
				}
			}
			
			// Create Tile References
			var tileset:PMTileset;
			var tile:PMTile;
			if ( a_props.tiles ) {
				for ( i = 0; i < a_props.tiles.length; i++ ) {
					tileset = tilesets[a_props.tiles[i].tilesetIndex];
					tile = tileset.tiles[a_props.tiles[i].tileIndex];
					tiles.push(tile);
				}
			}
		}
		
		public function getTilesetByIndex( a_tilesetIndex:int ):PMTileset {
			if ( tilesets[a_tilesetIndex] ) {
				return tilesets[a_tilesetIndex];
			}
			return null;
		}
		
		public function getTileByIndex( a_rowIndex:int, a_colIndex:int ):PMTile {
			if (( a_rowIndex >= _numRows ) || ( a_rowIndex < 0 )) { return null; }
			if (( a_colIndex >= _numCols ) || ( a_colIndex < 0 )) { return null; }
			if ( tiles[( a_rowIndex * _numCols ) + a_colIndex] ) {
				return tiles[( a_rowIndex * _numCols ) + a_colIndex];
			}
			return null;
		}
		
	}
}
