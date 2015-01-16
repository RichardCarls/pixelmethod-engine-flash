package net.pixelmethod.engine.phys {
	
	public class PMAABB {
		
		// PUBLIC PROPERTIES
		public var xw:Number;
		public var yw:Number;
		
		// PRIVATE PROPERTIES
		
		public function PMAABB() {
			//
		}
		
		// PUBLIC API
		public function toString( a_prec:uint = 3 ):String {
			return "[" + xw.toPrecision(a_prec) + ", " + yw.toPrecision(a_prec) + "]";
		}
		
	}
}
