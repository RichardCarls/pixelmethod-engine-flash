package net.pixelmethod.engine.phys {
	
	public class PMSeg2 {
		
		// Major Axis Normals
		public static const AXIS_XMINUS:PMVec2 = new PMVec2(-1, 0);
		public static const AXIS_XPLUS:PMVec2 = new PMVec2(1, 0);
		public static const AXIS_YMINUS:PMVec2 = new PMVec2(0, -1);
		public static const AXIS_YPLUS:PMVec2 = new PMVec2(0, 1);
		public static const AXIS_Q0_45:PMVec2 = new PMVec2(1, -1);
		public static const AXIS_Q1_45:PMVec2 = new PMVec2(-1, -1);
		public static const AXIS_Q2_45:PMVec2 = new PMVec2(-1, 1);
		public static const AXIS_Q3_45:PMVec2 = new PMVec2(1, 1);
		
		// PUBLIC PROPERTIES
		public var a:PMVec2;
		public var b:PMVec2;
		public var n:PMVec2;
		
		// PRIVATE PROPERTIES
		
		public function PMSeg2( a_pointA:PMVec2, a_pointB:PMVec2, a_normal:PMVec2 = null ) {
			a = a_pointA;
			b = a_pointB;
			if ( a_normal ) {
				n = a_normal;
			} else {
				// Check against major axis normals
				if ( a.x == b.x ) { ( a.y < b.y ) ? n = AXIS_XMINUS : n = AXIS_XPLUS; return; }
				if ( a.y == b.y ) { ( a.x < b.x ) ? n = AXIS_YPLUS : n = AXIS_YMINUS; return; }
				
				n = new PMVec2( -( b.y - a.y ), ( b.x - a.x ));
				n.normalize();
			}
		}
		
		// PUBLIC API
		public function clone():PMSeg2 {
			return new PMSeg2(a.clone(), b.clone());
		}
		
		public function toString():String {
			return "a: " + a.toString() + ", b: " + b.toString() + ", n: " + n.toString();
		}
		
	}
}
