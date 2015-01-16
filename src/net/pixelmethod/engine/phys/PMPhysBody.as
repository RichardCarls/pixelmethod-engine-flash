package net.pixelmethod.engine.phys {
	
	import flash.display.Graphics;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.model.PMCamera;
	
	public class PMPhysBody implements IPMPhysBody {
		
		// PUBLIC PROPERTIES
		public function get p():PMVec2 { return _p; }
		public function get v():PMVec2 { return _v; }
		public function get a():PMVec2 { return _a; }
		public function get aabb():PMAABB { return _aabb; }
		public function get shapes():IPMShape { return _shapes; }
		
		public function get numShapes():uint { return _numShapes; }
		public function get isStatic():Boolean { return _isStatic; }
		
		// PRIVATE PROPERTIES
		private var _p:PMVec2;
		private var _v:PMVec2;
		private var _a:PMVec2;
		private var _aabb:PMAABB;
		private var _numShapes:uint;
		private var _isStatic:Boolean;
		
		private var _shapes:IPMShape;
		
		public function PMPhysBody() {
			_p = new PMVec2();
			_v = new PMVec2();
			_a = new PMVec2();
			_aabb = new PMAABB();
			_numShapes = 0;
			_shapes = null;
		}
		
		// PUBLIC API
		public function init( a_props:Object = null ):void {
			if ( !a_props ) { return; }
			if ( a_props.x != null ) { _p.x = a_props.x; }
			if ( a_props.y != null ) { _p.y = a_props.y; }
			if ( a_props.vx != null ) { _v.x = a_props.vx; }
			if ( a_props.vy != null ) { _v.y = a_props.vy; }
			if ( a_props.ax != null ) { _a.x = a_props.ax; }
			if ( a_props.ay != null ) { _a.y = a_props.ay; }
			if ( a_props.isStatic != null ) { _isStatic = a_props.isStatic; }
			
			if ( a_props.shapes ) {
				var shape:IPMShape;
				var props:Object;
				for ( var i:int = 0; i < a_props.shapes.length; i++ ) {
					switch( a_props.shapes[i].type ) {
						case "rect":
							props = a_props.shapes[i].props;
							shape = PMPoly.createRect(props.x, props.y, props.xw, props.yw);
							shape.body = this;
							break;
						case "rtri":
							props = a_props.shapes[i].props;
							shape = PMPoly.createRTri(props.x, props.y, props.hw, props.quad);
							shape.body = this;
							break;
						case "poly":
							props = a_props.shapes[i].props;
							shape = new PMPoly(props.x, props.y, props.verts);
							shape.body = this;
							break;
						default:
							break;
					}
					
					if ( !_shapes ) {
						_shapes = shape;
					} else {
						var sh:IPMShape = _shapes;
						while ( sh.next ) {
							sh = sh.next;
						}
						
						sh.next = shape;
					}
					_numShapes++;
				}
			}
			
			updateAABB();
		}
		
		public function updateAABB():void {
			var xmin:Number;
			var xmax:Number;
			var ymin:Number;
			var ymax:Number;
			
			var shape:IPMShape = _shapes;
			if ( !shape ) { return; }
			xmin = xmax = shape.p.x - shape.aabb.xw;
			ymin = ymax = shape.p.y - shape.aabb.yw;
			
			while ( shape ) {
				shape.updateAABB();
			
				if (( shape.p.x - shape.aabb.xw ) < xmin ) { xmin = ( shape.p.x - shape.aabb.xw ); }
				if (( shape.p.x + shape.aabb.xw ) > xmax ) { xmax = ( shape.p.x + shape.aabb.xw ); }
				if (( shape.p.y - shape.aabb.yw ) < ymin ) { ymin = ( shape.p.y - shape.aabb.yw ); }
				if (( shape.p.y + shape.aabb.yw ) > ymax ) { ymax = ( shape.p.y + shape.aabb.yw ); }
				shape = shape.next;
			}
			
			_aabb.xw = ( xmax - xmin ) * 0.5;
			_aabb.yw = ( ymax - ymin ) * 0.5;
		}
		
		public function addShape( a_shape:IPMShape ):void {
			var sh:IPMShape = _shapes;
			
			if ( !sh ) {
				_shapes = a_shape;
			} else {
				while ( sh.next ) {
					sh = sh.next;
				}
				
				sh.next = a_shape;
			}
			a_shape.body = this;
			_numShapes++;
			updateAABB();
		}
		
		public function ghost( a_body:IPMPhysBody ):void {
			_shapes = a_body.shapes;
		}
		
		public function debugDraw( a_camera:PMCamera ):void {
			if ( PMGameManager.instance.isDebugDrawEnabled ) {
				var dg:Graphics = PMGameManager.instance.getRenderTarget("mainRenderTarget").debugOverlay.graphics;
				
				// Cull Graphics
				if (( a_camera.p.y - a_camera.aabb.yw ) > ( p.y + aabb.yw )) { return; }
				if (( a_camera.p.y + a_camera.aabb.yw ) < ( p.y - aabb.yw )) { return; }
				if (( a_camera.p.x - a_camera.aabb.xw ) > ( p.x + aabb.xw )) { return; }
				if (( a_camera.p.x + a_camera.aabb.xw ) < ( p.x - aabb.xw )) { return; }
				
				// Draw AABB
				dg.lineStyle(0.5, 0xFFFF0000);
				dg.drawRect(
					( p.x - aabb.xw ) - ( a_camera.p.x - a_camera.aabb.xw ),
					( p.y - aabb.yw ) - ( a_camera.p.y - a_camera.aabb.yw ),
					aabb.xw * 2,
					aabb.yw * 2
				);
				
				dg.lineStyle();
				
				// Draw Shapes
				var sh:IPMShape = _shapes;
				while ( sh ) {
					sh.debugDraw( a_camera, _p );
					sh = sh.next;
				}
			}
		}
		
	}
}
