package net.pixelmethod.engine.render {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.*;
	
	public class PMTilemapRenderer {
		
		public static const POINT:Point = new Point(0, 0);
		
		// PUBLIC PROPERTIES
		public function get tileWidth():uint { return tilemap.tileWidth; }
		public function get tileHeight():uint { return tilemap.tileHeight; }
		
		public var parent:PMChunk;
		public var tilemap:PMTilemap;
		
		// PRIVATE PROPERTIES
		private var mapBuffer:BitmapData;
		private var prevRowIndex:uint = uint.MAX_VALUE;
		private var prevColIndex:uint = uint.MAX_VALUE;
		
		public function PMTilemapRenderer() {
			//
		}
		
		// PUBLIC API
		public function render( a_camera:PMCamera ):void {
			if ( !tilemap ) { return; }
			
			if ( performCulling(a_camera) ) {
				var layer:BitmapData = PMGameManager.instance.getRenderTarget(tilemap.renderTargetID).getLayerByID(tilemap.layerID).bitmapData;
				var bufferOffsetX:Number = ( a_camera.p.x - a_camera.aabb.xw + parent.bounds.xw ) % tileWidth + tileWidth;
				var bufferOffsetY:Number = ( a_camera.p.y - a_camera.aabb.yw + parent.bounds.yw ) % tileHeight + tileHeight;
				
				bufferOffsetX = ( bufferOffsetX >= tileWidth ) ? bufferOffsetX : bufferOffsetX + tileWidth;
				bufferOffsetY = ( bufferOffsetY >= tileHeight ) ? bufferOffsetY : bufferOffsetY + tileHeight;
				
				var clipRect:Rectangle = new Rectangle(
					bufferOffsetX,
					bufferOffsetY,
					layer.width,
					layer.height);
				
				// Flip to renderTarget
				layer.copyPixels(mapBuffer, clipRect, POINT, null, null, true);
			}
		}
		
		// PRIVATE API
		private function performCulling( a_camera:PMCamera ):Boolean {
			// Set convenience vars
			var camX:Number = a_camera.p.x;
			var camY:Number = a_camera.p.y;
			var camXW:Number = a_camera.aabb.xw;
			var camYW:Number = a_camera.aabb.yw;
			
			// Clear/Resize mapBuffer
			var bufferTileWidth:uint = Math.floor(( camXW * 2 ) / tileWidth ) + 2;
			var bufferTileHeight:uint = Math.floor(( camYW * 2 ) / tileHeight ) + 2;
			var bufferWidth:uint = bufferTileWidth * tileWidth;
			var bufferHeight:uint = bufferTileHeight * tileHeight;
			
			if ( !mapBuffer || mapBuffer.width != bufferWidth || mapBuffer.height != bufferHeight ) {
				mapBuffer = new BitmapData(bufferWidth, bufferHeight, true, 0x00000000);
			}
			
			// Test for visibility
			if (( a_camera.p.x - a_camera.aabb.xw ) > ( parent.p.x + parent.bounds.xw )) {
				return false;
			}
			if (( a_camera.p.x + a_camera.aabb.xw ) < ( parent.p.x - parent.bounds.xw )) {
				return false;
			}
			if (( a_camera.p.y - a_camera.aabb.yw ) > ( parent.p.y + parent.bounds.yw )) {
				return false;
			}
			if (( a_camera.p.y + a_camera.aabb.yw ) < ( parent.p.y - parent.bounds.yw )) {
				return false;
			}
			
			// Determine visible tiles
			var firstRowIndex:int = Math.floor((( camY - camYW + parent.bounds.yw ) / tileHeight ) - 1 );
			var firstColIndex:int = Math.floor((( camX - camXW + parent.bounds.xw ) / tileWidth ) - 1 );
			
			if (( firstRowIndex == prevRowIndex ) && ( firstColIndex == prevColIndex )) {
				return true;
			}
			
			prevRowIndex = firstRowIndex;
			prevColIndex = firstColIndex;
			
			// Blit to buffer
			var renderPoint:Point = new Point();
			var clipRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
			var currentTile:PMTile;
			
			mapBuffer.fillRect(mapBuffer.rect, 0x00000000);
			for ( var r:int = 0; r < bufferTileHeight; r++ ) {
				renderPoint.y = r * tileHeight;
				for ( var c:int = 0; c < bufferTileWidth; c++ ) {
					renderPoint.x = c * tileWidth;
					currentTile = tilemap.getTileByIndex(r + firstRowIndex, c + firstColIndex);
					if ( !currentTile ) { continue; }
					clipRect.x = currentTile.xClip;
					clipRect.y = currentTile.yClip;
					mapBuffer.copyPixels(
						currentTile.tileset.bitmapData,
						clipRect, renderPoint, null, null, true
					);
				}
			}
			
			return true;
		}
		
	}
}
