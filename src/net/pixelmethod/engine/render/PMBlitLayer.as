package net.pixelmethod.engine.render {
	
	import flash.display.BitmapData;
	
	public class PMBlitLayer {
		
		// PUBLIC PROPERTIES
		
		// PRIVATE PROPERTIES
		private var layerWidth:uint;
		private var layerHeight:uint;
		
		public var bitmapData:BitmapData;
		
		public function PMBlitLayer( a_width:uint, a_height:uint ) {
			bitmapData = new BitmapData(a_width, a_height, true, 0x00000000);
		}
		
		// PUBLIC API
		public function clear():void {
			bitmapData.fillRect(bitmapData.rect, 0x00000000);
		}
		
	}
}
