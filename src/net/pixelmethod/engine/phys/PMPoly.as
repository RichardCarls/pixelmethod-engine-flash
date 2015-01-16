package net.pixelmethod.engine.phys {
	
	import flash.display.Graphics;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.PMCamera;
	
	public class PMPoly implements IPMShape {
		
		// SPECIAL CONSTRUCTORS
		public static function createRect( a_localX:Number, a_localY:Number, a_xw:Number, a_yw:Number ):PMPoly {
			var poly:PMPoly = new PMPoly(a_localX, a_localY);
			
			poly.vertices = [
				new PMVec2(-a_xw, -a_yw),
				new PMVec2(-a_xw, a_yw),
				new PMVec2(a_xw, a_yw),
				new PMVec2(a_xw, -a_yw)
			];
			
			poly.segments = [
				new PMSeg2(poly.vertices[0], poly.vertices[1], PMSeg2.AXIS_XMINUS),
				new PMSeg2(poly.vertices[1], poly.vertices[2], PMSeg2.AXIS_YPLUS),
				new PMSeg2(poly.vertices[2], poly.vertices[3], PMSeg2.AXIS_XPLUS),
				new PMSeg2(poly.vertices[3], poly.vertices[0], PMSeg2.AXIS_YMINUS)
			];
			
			poly.updateAABB();
			
			return poly;
		}
		
		public static function createRTri( a_localX:Number, a_localY:Number, a_hw:Number, a_quadrant:uint ):PMPoly {
			var poly:PMPoly = new PMPoly(a_localX, a_localY);
			
			switch ( a_quadrant ) {
				case 0:
					poly.vertices = [new PMVec2(-a_hw, -a_hw), new PMVec2(-a_hw, a_hw), new PMVec2(a_hw, a_hw)];
					poly.segments = [
						new PMSeg2(poly.vertices[0], poly.vertices[1], PMSeg2.AXIS_XMINUS),
						new PMSeg2(poly.vertices[1], poly.vertices[2], PMSeg2.AXIS_YPLUS),
						new PMSeg2(poly.vertices[2], poly.vertices[0], PMSeg2.AXIS_Q0_45)
					];
					break;
				case 1:
					poly.vertices = [new PMVec2(-a_hw, a_hw), new PMVec2(a_hw, a_hw), new PMVec2(a_hw, -a_hw)];
					poly.segments = [
						new PMSeg2(poly.vertices[0], poly.vertices[1], PMSeg2.AXIS_YPLUS),
						new PMSeg2(poly.vertices[1], poly.vertices[2], PMSeg2.AXIS_XPLUS),
						new PMSeg2(poly.vertices[2], poly.vertices[0], PMSeg2.AXIS_Q1_45)
					];
					break;
				case 2:
					poly.vertices = [new PMVec2(-a_hw, -a_hw), new PMVec2(a_hw, a_hw), new PMVec2(a_hw, -a_hw)];
					poly.segments = [
						new PMSeg2(poly.vertices[0], poly.vertices[1], PMSeg2.AXIS_Q2_45),
						new PMSeg2(poly.vertices[1], poly.vertices[2], PMSeg2.AXIS_XPLUS),
						new PMSeg2(poly.vertices[2], poly.vertices[0], PMSeg2.AXIS_YMINUS)
					];
					break;
				case 3:
					poly.vertices = [new PMVec2(-a_hw, -a_hw), new PMVec2(-a_hw, a_hw), new PMVec2(a_hw, -a_hw)];
					poly.segments = [
						new PMSeg2(poly.vertices[0], poly.vertices[1], PMSeg2.AXIS_XMINUS),
						new PMSeg2(poly.vertices[1], poly.vertices[2], PMSeg2.AXIS_Q3_45),
						new PMSeg2(poly.vertices[2], poly.vertices[0], PMSeg2.AXIS_YMINUS)
					];
					break;
				default:
					break;
			}
			
			poly.updateAABB();
			
			return poly;
		}
		
		// PUBLIC PROPERTIES
		public function get type():String { return "poly"; }
		public function get body():IPMPhysBody { return _body; }
		public function set body( a_value:IPMPhysBody ):void { _body = a_value; }
		public function get p():PMVec2 { return _p; }
		public function get aabb():PMAABB { return _aabb; }
		public function get isStatic():Boolean { return _body.isStatic; }
		
		public function get next():IPMShape { return _next; }
		public function set next( a_shape:IPMShape ):void {
			var temp:IPMShape = _next;
			_next = a_shape;
			a_shape.next = temp;
		}
		
		[ArrayElementType('net.pixelmethod.engine.phys.PMSeg')]
		public var segments:Array;
		
		[ArrayElementType('net.pixelmethod.engine.phys.PMVec2')]
		public var vertices:Array;
		
		// PRIVATE PROPERTIES
		private var _body:IPMPhysBody
		private var _p:PMVec2;
		private var _aabb:PMAABB;
		private var _next:IPMShape;
		
		public function PMPoly( a_localX:Number, a_localY:Number, a_verts:Array = null ) {
			_p = new PMVec2(a_localX, a_localY);
			_aabb = new PMAABB();
			
			vertices = [];
			segments = [];
			if ( a_verts ) {
				for ( var i:int = 0; i < a_verts.length; i++ ) {
					vertices.push(new PMVec2(a_verts[i].x, a_verts[i].y));
				}
				
				var next:int = 0;
				for ( i = 0; i < vertices.length; i++ ) {
					( next == ( vertices.length - 1 )) ? next = 0 : next++;
					segments.push(new PMSeg2(vertices[i], vertices[next]));
				}
			}
			
			updateAABB();
		}
		
		// PUBLIC API
		public function updateAABB():void {
			var xmin:Number;
			var xmax:Number;
			var ymin:Number;
			var ymax:Number;
			
			if ( !vertices[0] ) { return; }
			
			xmin = xmax = vertices[0].x;
			ymin = ymax = vertices[0].y;
			
			for ( var i:int = 1; i < vertices.length; i++ ) {
				if ( vertices[i].x < xmin ) { xmin = vertices[i].x; }
				if ( vertices[i].x > xmax ) { xmax = vertices[i].x; }
				if ( vertices[i].y < ymin ) { ymin = vertices[i].y; }
				if ( vertices[i].y > ymax ) { ymax = vertices[i].y; }
			}
			
			_aabb.xw = ( xmax - xmin ) * 0.5;
			_aabb.yw = ( ymax - ymin ) * 0.5;
		}
		
		public function debugDraw( a_camera:PMCamera, a_offset:PMVec2 ):void {
			var dg:Graphics = PMGameManager.instance.getRenderTarget("mainRenderTarget").debugOverlay.graphics;
			
			// Draw Segments
			dg.lineStyle(0.5, 0xFF000099);
			dg.beginFill(0xFF000099, 0.3);
			dg.moveTo(
					( _p.x + a_offset.x + segments[0].b.x ) - ( a_camera.p.x - a_camera.aabb.xw ),
					( _p.y + a_offset.y + segments[0].b.y ) - ( a_camera.p.y - a_camera.aabb.yw )
				);
			for ( var i:int = 0; i < segments.length; i++ ) {
				dg.lineTo(
					( _p.x + a_offset.x + segments[i].b.x ) - ( a_camera.p.x - a_camera.aabb.xw ),
					( _p.y + a_offset.y + segments[i].b.y ) - ( a_camera.p.y - a_camera.aabb.yw )
				);
			}
			dg.endFill();
			dg.lineStyle();
			
			// Draw Vertices
			for ( i = 0; i < vertices.length; i++ ) {
				dg.beginFill(0xFF0000FF);
				dg.drawRect(
					( _p.x + a_offset.x + vertices[i].x ) - ( a_camera.p.x - a_camera.aabb.xw ) - 1,
					( _p.y + a_offset.y + vertices[i].y ) - ( a_camera.p.y - a_camera.aabb.yw ) - 1,
					2,
					2
				);
				dg.endFill();
			}
		}
		
		public function clone():IPMShape {
			var clonePoly:PMPoly = new PMPoly(_p.x, _p.y);
			for ( var i:int = 0; i < vertices.length; i++ ) {
				clonePoly.vertices[i].copy(vertices[i]);
			}
			var next:int = 0;
			for ( i = 0; i < clonePoly.vertices.length; i++ ) {
				( next == ( vertices.length - 1 )) ? next = 0 : next++;
				clonePoly.segments[i] = new PMSeg2(clonePoly.vertices[i], clonePoly.vertices[next]);
			}
			clonePoly.updateAABB();
			
			return clonePoly;
		}
		
		public function project( a_offset:PMVec2, a_vector:PMVec2 ):Array {
			var min:Number;
			var max:Number;
			var gVert:PMVec2;
			var pn:Number;
			
			gVert = new PMVec2(( a_offset.x + vertices[0].x ), ( a_offset.y + vertices[0].y ));
			min = max = a_vector.dot(gVert);
			for ( var i:int = 1; i < vertices.length; i++ ) {
				gVert.set(( a_offset.x + vertices[i].x ), ( a_offset.y + vertices[i].y ));
				pn = a_vector.dot(gVert);
				if ( pn < min ) { min = pn; }
				if ( pn > max ) { max = pn; }
			}
			
			return [min, max];
		}
		
	}
	
}
