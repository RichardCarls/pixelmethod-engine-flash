package net.pixelmethod.engine.phys {
	
	public class PMCell {
		
		// PUBLIC PROPERTIES
		public function get p():PMVec2 { return _p; }
		
		[ArrayElementType('net.pixelmethod.engine.phys.IPMShape')]
		public var physShapes:Array;
		public var cellBody:IPMPhysBody;
		
		// PRIVATE PROPERTIES
		private var _p:PMVec2;
		
		public function PMCell( a_x:Number, a_y:Number, a_cellBody:IPMPhysBody = null ) {
			_p = new PMVec2(a_x, a_y);
			cellBody = a_cellBody;
			
			physShapes = [];
		}
		
		// PUBLIC API
		
	}
}
