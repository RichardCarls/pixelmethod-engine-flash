package net.pixelmethod.engine.phys {
	
	public class PMCollision {
		
		// PUBLIC PROPERTIES
		public var bodyA:IPMPhysBody
		public var shapeA:IPMShape;
		public var bodyB:IPMPhysBody
		public var shapeB:IPMShape;
		public var overlappingAxis:Array;
		public var mtd:PMVec2;
		
		public var aabbOverlap:Number;		// Overlap of shapes' AABBs for prioritization
		
		// PRIVATE PROPERTIES
		
		public function PMCollision( a_bodyA:IPMPhysBody, a_shapeA:IPMShape, a_bodyB:IPMPhysBody, a_shapeB:IPMShape ) {
			bodyA = a_bodyA;
			shapeA = a_shapeA;
			bodyB = a_bodyB;
			shapeB = a_shapeB;
			overlappingAxis = [];
		}
		
	}
	
}
