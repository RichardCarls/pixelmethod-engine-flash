package net.pixelmethod.engine.render {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PMRenderTarget {
		
		public static const POINT:Point = new Point(0,0);
		public static var newID:int = -1;
		
		// PUBLIC PROPERTIES
		public function get numLayers():uint { return layers.length; }
		
		public var backgroundColor:uint;
		public var screenBuffer:BitmapData;
		public var debugOverlay:Sprite;
		public var overlayMask:Sprite;
		
		// PRIVATE PROPERTIES
		private var layerWidth:uint;
		private var layerHeight:uint;
		
		[ArrayElementType('net.pixelmethod.engine.render.PMBlitLayer')]
		private var layers:Array;
		private var layersIndex:Object;
		
		public function PMRenderTarget( a_layerWidth:uint, a_layerHeight:uint, a_backgroundColor:uint = 0xFF000000 ) {
			backgroundColor = a_backgroundColor;
			screenBuffer = new BitmapData(a_layerWidth, a_layerHeight, true, a_backgroundColor);
			debugOverlay = new Sprite();
			overlayMask = new Sprite();
			overlayMask.graphics.beginFill(0xFF000000);
			overlayMask.graphics.drawRect(0, 0, a_layerWidth, a_layerHeight);
			overlayMask.graphics.endFill();
			debugOverlay.mask = overlayMask;
			
			layerWidth = a_layerWidth;
			layerHeight = a_layerHeight;
			
			layers = [];
			layersIndex = {};
		}
		
		// PUBLIC API
		public function addLayer( a_layerID:String = null ):void {
			addLayerAt(a_layerID, layers.length);
		}
		
		public function addLayerAt( a_layerID:String, a_index:uint ):void {
			var layer:PMBlitLayer;
			
			if ( a_layerID == null ) { a_layerID = "layer " + newID++; }
			
			layer = new PMBlitLayer(layerWidth, layerHeight);
			layers.splice(a_index, 0, layer);
			layersIndex[a_layerID] = a_index;
		}
		
		public function getLayerByIndex( a_index:uint ):PMBlitLayer {
			return layers[a_index];
		}
		
		public function getLayerByID( a_layerID:String ):PMBlitLayer {
			if ( layersIndex[a_layerID] != null ) {
				return layers[layersIndex[a_layerID]];
			}
			return null;
		}
		
		public function clear():void {
			screenBuffer.fillRect(screenBuffer.rect, backgroundColor);
			debugOverlay.graphics.clear();
			
			for ( var i:int = 0; i < layers.length; i ++ ) {
				layers[i].clear();
			}
		}
		
		public function flipScreen():void {
			for ( var i:int = 0; i < layers.length; i ++ ) {
				screenBuffer.copyPixels(layers[i].bitmapData, layers[i].bitmapData.rect, POINT, null, null, true);
			}
			
			//screenBuffer.draw(debugOverlay);
		}
		
		// PRIVATE API
		private function mergeColor32( a_bottomColor:uint, a_topColor:uint ):uint {
			// Bottom Color Components
			var aB:uint = a_bottomColor >>> 24;
			var rB:uint = ( a_bottomColor >>> 16 & 0xFF ) * ( aB / 0xFF );
			var gB:uint = ( a_bottomColor >>> 8 & 0xFF ) * ( aB / 0xFF );
			var bB:uint = ( a_bottomColor  & 0xFF ) * ( aB / 0xFF );
			
			// Top Color Components
			var aT:uint = a_topColor >>> 24;
			var rT:uint = ( a_topColor >>> 16 & 0xFF ) * ( aT / 0xFF );
			var gT:uint = ( a_topColor >>> 8 & 0xFF ) * ( aT / 0xFF );
			var bT:uint = ( a_topColor  & 0xFF ) * ( aT / 0xFF );
			
			var showThru:Number = ( 0xFF - aT ) / 0xFF;
			
			// Merged Color Components
			var aN:uint = Math.min(aB + aT, 0xFF);
			var rN:uint = Math.min(( rB * showThru ) + rT, 0xFF);
			var gN:uint = Math.min(( gB * showThru ) + gT, 0xFF);
			var bN:uint = Math.min(( bB * showThru ) + bT, 0xFF);
			
			return ( aN << 24 | rN << 16 | gN << 8 | bN );
		}
		
	}
}
