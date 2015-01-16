package net.pixelmethod.engine.phys {
	// http://www.sevenson.com.au/actionscript/sat/
	import flash.display.Graphics;
	import flash.utils.Dictionary;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.PMCamera;
	
	public class PMUniformCellGrid implements IPMBroadphase {
		
		// PUBLIC PROPERTIES
		public function get p():PMVec2 { return _p; }
		public function get numRows():uint { return _numRows; }
		public function get numCols():uint { return _numCols; }
		public function get cellWidth():uint { return _cellWidth; }
		public function get cellHeight():uint { return _cellHeight; }
		public function get bounds():PMAABB { return _bounds; }
		
		[ArrayElementType('net.pixelmethod.engine.phys.PMCell')]
		public var cells:Array;
		
		// PRIVATE PROPERTIES
		private var _p:PMVec2;
		private var _numRows:uint;
		private var _numCols:uint;
		private var _cellWidth:uint;
		private var _cellHeight:uint;
		private var _bounds:PMAABB;
		
		private var cellShapes:Object;
		private var collisionTests:Dictionary;
		
		public function PMUniformCellGrid() {
			cells = [];
			
			_p = new PMVec2();
			_bounds = new PMAABB();
			
			cellShapes = {};
			collisionTests = new Dictionary(false);
		}
		
		// PUBLIC API
		public function init( a_props:Object = null ):void {
			if ( a_props.numRows ) { _numRows =  a_props.numRows; }
			if ( a_props.numCols ) { _numCols =  a_props.numCols; }
			if ( a_props.cellWidth ) { _cellWidth =  a_props.cellWidth; }
			if ( a_props.cellHeight ) { _cellHeight =  a_props.cellHeight; }
			
			_bounds.xw = ( _numCols * _cellWidth ) * 0.5;
			_bounds.yw = ( _numRows * _cellHeight ) * 0.5;
			
			// Initialize Cell Shapes
			var cellShape:PMPhysBody;
			if ( a_props.cellShapes ) {
				for ( var i:int = 0; i < a_props.cellShapes.length; i++ ) {
					cellShape = new PMPhysBody();
					cellShape.init(a_props.cellShapes[i]);
					cellShapes[a_props.cellShapes[i].id] = cellShape;
				}
			}
			
			// Initialize Cells
			var cell:PMCell;
			if ( a_props.cells ) {
				var cellX:int;
				var cellY:int = -_bounds.yw - ( _cellHeight * 0.5 );
				i = 0;
				for ( var r:int = 0; r < _numRows; r++ ) {
					cellX = -_bounds.xw - ( _cellWidth * 0.5 );
					cellY += _cellHeight;
					for ( var c:int = 0; c < _numCols; c++ ) {
						cellX += _cellWidth;
						cell = new PMCell(cellX, cellY, ( a_props.cells[i].cellShapeID ) ? cellShapes[a_props.cells[i].cellShapeID] : null);
						cells.push(cell);
						i++;
					}
				}
			}
		}
		
		public function populate( a_physBodies:Array ):void {
			clearCells();
			collisionTests = new Dictionary(false);
			
			// Assign each body to cells based on AABB
			for each ( var body:IPMPhysBody in a_physBodies ) {
				assignToCells(body);
			}
			
			// Iterate collision tests and prune
			for ( var key:Object in collisionTests ) {
				for ( var i:int = 0; i < collisionTests[key].length; i++ ) {
					var col:PMCollision = collisionTests[key][i];
					
					if ( !testAABBOverlap(col) ) {
						collisionTests[key].splice(i, 1);
					}
				}
				
				// Prioritize collision list
				collisionTests[key].sortOn("aabbOverlap", Array.NUMERIC);
				collisionTests[key].reverse();
				
				// Resolve collisions
				for ( i = 0; i < collisionTests[key].length; i++ ) {
					col = collisionTests[key][i];
					if ( col.shapeB.isStatic ) {
						resolveDynamicVsStatic(col);
					} else {
						resolveDynamicVsDynamic(col);
					}
				}
			
				// Collision handling
				
			}
		}
		
		public function getCellAtIndex( a_rowIndex:int, a_colIndex:int ):PMCell {
			if (( a_rowIndex >= _numRows ) || ( a_rowIndex < 0 )) { return null; }
			if (( a_colIndex >= _numCols ) || ( a_colIndex < 0 )) { return null; }
			
			return cells[( a_rowIndex * _numCols ) + a_colIndex];
		}
		
		public function debugDraw( a_camera:PMCamera ):void {
			if ( PMGameManager.instance.isDebugDrawEnabled ) {
				var dg:Graphics = PMGameManager.instance.getRenderTarget("mainRenderTarget").debugOverlay.graphics;
				
				// Draw Cell Grid
				if (( a_camera.p.y - a_camera.aabb.yw ) > ( p.y + bounds.yw )) { return; }
				if (( a_camera.p.y + a_camera.aabb.yw ) < ( p.y - bounds.yw )) { return; }
				if (( a_camera.p.x - a_camera.aabb.xw ) > ( p.x + bounds.xw )) { return; }
				if (( a_camera.p.x + a_camera.aabb.xw ) < ( p.x - bounds.xw )) { return; }
				
				var offsetX:Number = ( a_camera.p.x - a_camera.aabb.xw + bounds.xw ) % _cellWidth;
				var offsetY:Number = ( a_camera.p.y - a_camera.aabb.yw + bounds.yw ) % _cellHeight;
				var firstRowIndex:int = Math.floor(( a_camera.p.y - a_camera.aabb.yw + bounds.yw ) / _cellHeight );
				var firstColIndex:int = Math.floor(( a_camera.p.x - a_camera.aabb.xw + bounds.xw ) / _cellWidth );
				var numCellsWidth:int = Math.floor(( a_camera.aabb.xw * 2 ) / _cellWidth ) + 1;
				var numCellsHeight:int = Math.floor(( a_camera.aabb.yw * 2 ) / _cellHeight ) + 1;
				
				var renderX:Number;
				var renderY:Number;
				
				dg.lineStyle(0.5, 0xFFCCCCCC);
				var cell:PMCell;
				for ( var r:int = 0; r < numCellsHeight; r++ ) {
					renderY = ( firstRowIndex < 0 ) ? ( r * _cellHeight ) - ( offsetY + _cellHeight) : ( r * _cellHeight ) - offsetY;
					for ( var c:int = 0; c < numCellsWidth; c++ ) {
						renderX = ( firstColIndex < 0 ) ? ( c * _cellWidth ) - ( offsetX + _cellWidth ) : ( c * _cellWidth ) - offsetX;
						cell = getCellAtIndex(r + firstRowIndex, c + firstColIndex);
						if ( !cell ) { continue; }
						
						if ( cell.physShapes.length > 0 ) { dg.beginFill(0xFF00FF00, 0.5); }
						if ( cell.cellBody ) {
							dg.beginFill(0xFF00FF00, 0.5);
						}
						dg.drawRect(renderX, renderY, _cellWidth, _cellHeight);
						dg.endFill();
					}
				}
			}
		}
		
		// PRIVATE API
		private function clearCells():void {
			for each ( var cell:PMCell in cells ) {
				cell.physShapes = [];
			}
		}
		
		private function assignToCells( a_body:IPMPhysBody ):void {
			var firstCellRow:int;
			var firstCellCol:int;
			var lastCellRow:int;
			var lastCellCol:int;
			var r:int;
			var c:int;
			var i:int;
			var cell:PMCell;
			var cellGhost:PMPhysBody;
			var cellShape:IPMShape;
			
			var shape:IPMShape = a_body.shapes;
			while ( shape ) {
				firstCellRow = Math.floor((( a_body.p.y + shape.p.y ) - shape.aabb.yw + bounds.yw ) / _cellHeight );
				firstCellCol = Math.floor((( a_body.p.x + shape.p.x ) - shape.aabb.xw + bounds.xw ) / _cellWidth );
				lastCellRow = Math.floor((( a_body.p.y + shape.p.y ) + shape.aabb.yw + bounds.yw ) / _cellHeight );
				lastCellCol = Math.floor((( a_body.p.x + shape.p.x ) + shape.aabb.xw + bounds.xw ) / _cellWidth );
			
				for ( r = firstCellRow; r <= lastCellRow; r++ ) {
					for ( c = firstCellCol; c <= lastCellCol; c++ ) {
						cell = getCellAtIndex(r, c);
						if ( !cell ) { continue; }
					
						// Cell Geometry Tests
						if ( cell.cellBody ) {
							if ( !collisionTests[shape] ) { collisionTests[shape] = []; }
							cellGhost = new PMPhysBody();
							cellGhost.ghost(cell.cellBody);
							cellGhost.p.copy(cell.p);
							cellShape = cellGhost.shapes;
							while ( cellShape ) {
								collisionTests[shape].push(new PMCollision(a_body, shape, cellGhost, cellShape));
								cellShape = cellShape.next;
							}
						
						}
					
						// Other Dynamic / Static Geometry Tests
						for ( i = 0; i < cell.physShapes.length; i++ ) {
							if ( !collisionTests[cell.physShapes[i]] ) { collisionTests[cell.physShapes[i]] = []; }
							collisionTests[cell.physShapes[i]].push(new PMCollision(cell.physShapes[i].body, cell.physShapes[i].shape, a_body, shape));
						}
					
						cell.physShapes.push({ body: a_body, shape: shape });
					}
				}
				
				shape = shape.next;
			}
		}
		
		private function testAABBOverlap( a_collision:PMCollision ):Boolean {
			var bodyA:IPMPhysBody = a_collision.bodyA;
			var shapeA:IPMShape = a_collision.shapeA;
			var bodyB:IPMPhysBody = a_collision.bodyB;
			var shapeB:IPMShape = a_collision.shapeB;
			
			// Test y-axis
			var dy:Number = (( bodyA.p.y + shapeA.p.y ) - ( bodyB.p.y + shapeB.p.y ));
			var oy:Number = ( shapeA.aabb.yw + shapeB.aabb.yw ) - Math.abs(dy);
			if ( oy > 0 ) {
				
				// Test x-axis
				var dx:Number = (( bodyA.p.x + shapeA.p.x ) - ( bodyB.p.x + shapeB.p.x ));
				var ox:Number = ( shapeA.aabb.xw + shapeB.aabb.xw ) - Math.abs(dx);
				if ( ox > 0 ) {
					a_collision.aabbOverlap = ox * oy;
					return true;
				} else {
					return false;
				}
				
			} else {
				return false;
			}
			
			return false;
		}
		
		private function resolveDynamicVsStatic( a_collision:PMCollision ):void {
			
			// Recheck AABB overlap
			if ( !testAABBOverlap( a_collision ) ) { return; }
			
			// Test shapes for collision
			var bodyA:IPMPhysBody = a_collision.bodyA;
			var shapeA:IPMShape = a_collision.shapeA;
			var bodyB:IPMPhysBody = a_collision.bodyB;
			var shapeB:IPMShape = a_collision.shapeB;
			
			if (( shapeA.type == "poly" ) && ( shapeB.type == "poly" )) {
				if ( !collidePolyVsPoly(a_collision) ) { return; }
			} else {
				return;
			}
			
			// Find displacement normal
			var nd:PMVec2 = new PMVec2(
				( bodyB.p.x - bodyA.p.x ),
				( bodyB.p.y - bodyA.p.y )
			);
			nd.normalize();
			
			// Find MTD
			var n:PMVec2 = a_collision.overlappingAxis[0].n;
			var mtd:Number = a_collision.overlappingAxis[0].ol;
			for ( var i:int = 1; i < a_collision.overlappingAxis.length; i++ ) {
				if ( a_collision.overlappingAxis[i].ol <= mtd ) {
					// Ignore backfacing normals
					if ( a_collision.overlappingAxis[i].n.dot(nd) >= 0 ) {
						continue;
					}
					
					n = a_collision.overlappingAxis[i].n;
					mtd = a_collision.overlappingAxis[i].ol;
				}
			}
			
			var proj:PMVec2 = new PMVec2(n.x * mtd, n.y * mtd);
			
			// Project out of overlap
			bodyA.p.plusEq(proj);
			bodyA.updateAABB();
			
			// Apply normal force
			var fn:Number = n.dot(bodyA.v);
			bodyA.v.x -= ( n.x * fn );
			bodyA.v.y -= ( n.y * fn );
			
			
			//if ( n.x != 0 ) { bodyA.v.x = 0; bodyA.a.x = 0; }
			//if ( n.y != 0 ) { bodyA.v.y = 0; bodyA.a.y = 0; }
		}
		
		private function resolveDynamicVsDynamic( a_collision:PMCollision ):void {
			// ...
		}
		
		private function collidePolyVsPoly( a_collision:PMCollision ):Boolean {
			var bodyA:IPMPhysBody = a_collision.bodyA;
			var polyA:PMPoly = a_collision.shapeA as PMPoly;
			var bodyB:IPMPhysBody = a_collision.bodyB;
			var polyB:PMPoly = a_collision.shapeB as PMPoly;
			
			// Determine testable axis
			var ol:Number;
			for ( var a:int = 0; a < polyA.segments.length; a++ ) {
				main: for ( var b:int = 0; b < polyB.segments.length; b++ ) {
					ol = testAxis(a_collision, polyA.segments[a].n);
					if ( ol <= 0 ) { return false; }
					a_collision.overlappingAxis.push({ n: polyA.segments[a].n, ol: ol });
					
					// Test for mutual axis
					if ( polyA.segments[a].n == polyB.segments[b].n ) { continue; }
					for ( var i:int = 0; i < a_collision.overlappingAxis.length; i++ ) {
						if ( a_collision.overlappingAxis[i].n == polyB.segments[b].n ) { continue main; }
					}
					
					// Unique axis
					ol = testAxis(a_collision, polyB.segments[b].n);
					if ( ol <= 0 ) { return false; }
					a_collision.overlappingAxis.push({ n: polyB.segments[b].n, ol: ol });
				}
			}
			
			return true;
		}
		
		private function testAxis( a_collision:PMCollision, a_axis:PMVec2 ):Number {
			var shapeA:IPMShape = a_collision.shapeA;
			var shapeB:IPMShape = a_collision.shapeB;
			
			// Project shapeA onto normal
			var projA:Array = shapeA.project(a_collision.bodyA.p, a_axis);
			var projB:Array = shapeB.project(a_collision.bodyB.p, a_axis);
			
			var min:Number = ( projA[0] > projB[0] ) ? projA[0] : projB[0];
			var max:Number = ( projA[1] < projB[1] ) ? projA[1] : projB[1];
			return -( min - max );
		}
	}
	
}
