package net.pixelmethod.engine.model {
	
	import flash.display.BitmapData;
	
	import net.pixelmethod.engine.phys.*;
	
	public class PMTileset {
		
		// PUBLIC PROPERTIES
		public function get tilesetID():String { return _tilesetID; }
		public function get numRows():uint { return _numRows; }
		public function get numCols():uint { return _numCols; }
		public function get tileWidth():uint { return _tileWidth; }
		public function get tileHeight():uint { return _tileHeight; }
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		[ArrayElementType('net.pixelmethod.engine.model.PMTile')]
		public var tiles:Array;
		
		// PRIVATE PROPERTIES
		private var _tilesetID:String;
		private var _numRows:uint;
		private var _numCols:uint;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		private var _bitmapData:BitmapData;
		
		public function PMTileset() {
			tiles = [];
		}
		
		// PUBLIC API
		public function init( a_props:Object ):void {
			if ( a_props.id ) { _tilesetID = a_props.id; }
			if ( a_props.tileWidth ) { _tileWidth = a_props.tileWidth; }
			if ( a_props.tileHeight ) { _tileHeight = a_props.tileHeight; }
			if ( a_props.bitmapData ) { _bitmapData = a_props.bitmapData; }
			
			_numRows = _bitmapData.height / _tileHeight;
			_numCols = _bitmapData.width / _tileWidth;
			
			// Create Tiles
			var tile:PMTile;
			if ( a_props.tiles ) {
				for ( var i:int = 0; i < a_props.tiles.length; i++ ) {
					tile = new PMTile(
						this,
						a_props.tiles[i].xClip,
						a_props.tiles[i].yClip,
						a_props.tiles[i].next
					);
					tiles.push(tile);
				}
			}
		}
		
	}
}
