package {
	
	import flash.utils.ByteArray;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.*;
	import net.pixelmethod.engine.phys.*;
	
	public class FlashmanWorld extends PMWorld {
		// Chunks
		[Embed('asset/cnk_flashman_0.xml', mimeType='application/octet-stream')]
		private static var CNK_FLASHMAN_0:Class;
		
		// Tilemaps
		[Embed('asset/tm_flashman_0.xml', mimeType='application/octet-stream')]
		private static var TM_FLASHMAN_0:Class;
		
		// PUBLIC PROPERTIES
		
		// PRIVATE PROPERTIES
		
		public function FlashmanWorld() {
			super();
		}
		
		// PUBLIC API
		override public function init( a_state:Object = null ):void {
			
			// Load Tilemap XML
			var xmlBytes:ByteArray = new TM_FLASHMAN_0();
			var tmData:XML = new XML(xmlBytes.readUTFBytes(xmlBytes.length));
			
			var tmProps:Object = {
				numRows: tmData.@numRows,
				numCols: tmData.@numCols,
				tileWidth: tmData.@tileWidth,
				tileHeight: tmData.@tileHeight,
				renderTarget: tmData.tiles[0].@renderTarget,
				layer: tmData.tiles[0].@layer,
				tilesets: [],
				tiles: []
			}
			
			// Get Tileset Linkages
			for each ( var tileset:XML in tmData.tilesets[0].tileset ) {
				tmProps.tilesets.push(tileset.@id);
			}
			
			// Get Tiles
			for each ( var row:XML in tmData.tiles[0].row ) {
				for each ( var tile:XML in row.tile ) {
					tmProps.tiles.push({ tilesetIndex: tile.@ts, tileIndex: tile.@tileIndex });
				}
			}
			
			// Initialize First Chunk
			xmlBytes = new CNK_FLASHMAN_0();
			var cnkData:XML = new XML(xmlBytes.readUTFBytes(xmlBytes.length));
			var props:Object = {
				id: cnkData.@id,
				x: cnkData.@x,
				y: cnkData.@y,
				w: cnkData.@w,
				h: cnkData.@h,
				broadphase: {},
				renderers: []
			};
			
			// Get Broadphase Props
			var bpData:XML = cnkData.broadphase[0];
			props.broadphase.type = String(bpData.@type);
			switch( props.broadphase.type ) {
				case "cells":
					props.broadphase.numRows = bpData.cells[0].@numRows;
					props.broadphase.numCols = bpData.cells[0].@numCols;
					props.broadphase.cellWidth = bpData.cells[0].@cellWidth;
					props.broadphase.cellHeight = bpData.cells[0].@cellHeight;
					props.broadphase.cellShapes = [];
					props.broadphase.cells = [];
					
					// Get Cell Shapes
					var i:int = 0;
					for each ( var cellShape:XML in bpData.cellShapes[0].cellShape ) {
						props.broadphase.cellShapes[i] = { id: cellShape.@id, isStatic: true, shapes: [] };
						for each ( var shape:XML in cellShape.elements() ) {
							switch ( String(shape.name()) ) {
								case "rect":
									props.broadphase.cellShapes[i].shapes.push({
										type: "rect",
										props: { x: shape.@x, y: shape.@y, xw: shape.@xw, yw: shape.@yw }
									});
									break;
								case "rtri":
									props.broadphase.cellShapes[i].shapes.push({
										type: "rtri",
										props: { x: shape.@x, y: shape.@y, hw: shape.@hw, quad: shape.@quad }
									});
									break;
								default:
									break;
							}
						}
						i++;
					}
					
					// Get Cells
					for each ( var cell:XML in bpData.cells[0].cell ) {
						props.broadphase.cells.push({
							cellShapeID: cell.attribute("cellShapeID")
						});
					}
					
					break;
				default:
					break;
			}
			
			
			
			// Get Renderer Props
			var rData:XML = cnkData.renderers[0];
			var tilemap:PMTilemap;
			for each ( var renderer:XML in rData.renderer ) {
				switch ( String(renderer.@type) ) {
					case "tilemap":
						tilemap = new PMTilemap();
						tilemap.init(tmProps);
						props.renderers.push({ type: String(renderer.@type), tilemap: tilemap });
						break;
					default:
						break;
				}
			}
			
			var chunk:PMChunk = new PMChunk();
			chunk.init(props);
			
			activeChunks.push(chunk);
			
			// Initialize World Entities
			var testBox:IPMEntity;
			testBox = new PMEntityBase();
			testBox.init({
				x: 0, y: 0,
				shapes: [{ type: "rect", props: { x: 0, y: 0, xw: 8, yw:8 } }],
				entFlags: ["hasInput"]
			});
			entities.push(testBox);
			
			
			var slopeTest:IPMEntity;
			slopeTest = new PMEntityBase();
			slopeTest.init({
				x: 32, y: 0,
				shapes: [{ type: "poly", props: { x: 0, y: 0, verts: [
					{ x: -8, y: 8 },
					{ x: 8, y: 8 },
					{ x: 8, y: -8 }
				] } }],
				isStatic: true
			});
			entities.push(slopeTest);
			
			
			// Initialize Chunk Entities
			// ...
			
			// Initialize Cameras
			var cam:PMCamera;
			
			cam = new PMCamera();
			cam.init({
				x: 0, y: 0,
				shapes: [{ type: "rect", props: { x: 0, y: 0, xw: 80, yw: 80 } }],
				follow: testBox
			});
			cameras.push(cam);
		}
		
	}
}
