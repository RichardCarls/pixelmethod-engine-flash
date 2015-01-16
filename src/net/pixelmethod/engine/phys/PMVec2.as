package net.pixelmethod.engine.phys {
	
	public class PMVec2 {
		
		// PUBLIC PROPERTIES
		public var x:Number;
		public var y:Number;
		
		// PRIVATE PROPERTIES
		
		public function PMVec2( a_x:Number = 0, a_y:Number = 0 ) {
			x = a_x;
			y = a_y;
		}
		
		// PUBLIC API
		public function clone():PMVec2 {
			return new PMVec2(x, y);
		}
		
		public function copy( a_vec:PMVec2 ):void {
			x = a_vec.x;
			y = a_vec.y;
		}
		
		public function set( a_x:Number, a_y:Number ):void {
			x = a_x;
			y = a_y;
		}
		
		public function plusEq( a_vec:PMVec2 ):void {
			x += a_vec.x;
			y += a_vec.y;
		}
		
		public function normalize():void {
			var mag:Number = Math.sqrt( x * x ) + Math.sqrt( y * y );
			
			if ( mag == 0 ) {
				x = y = 0;
				return;
			}
			x = x / mag;
			y = y / mag;
		}
		
		public function dot( a_vec:PMVec2 ):Number {
			return (( x * a_vec.x ) + ( y * a_vec.y ));
		}
		
		public function toString( a_prec:uint = 3 ):String {
			return "(" + x.toPrecision(a_prec) + ", " + y.toPrecision(a_prec) + ")";
		}
		
	}
}
