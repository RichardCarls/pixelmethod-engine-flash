package net.pixelmethod.engine.phys {
	
	public class PMContact {
		
		public var shapeA:IPMShape;
		public var shapeB:IPMShape;
		public var d:PMVec2;
		public var mtd:PMVec2;
		
		public function PMContact( a_shapeA:IPMShape, a_shapeB:IPMShape ) {
			shapeA = a_shapeA;
			shapeB = a_shapeB;
		}
		
	}
	
}
