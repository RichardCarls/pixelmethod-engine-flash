package net.pixelmethod.engine.phys {
	
	import net.pixelmethod.engine.model.PMCamera;
	
	public interface IPMShape {
		
		// PUBLIC PROPERTIES
		function get type():String
		function get body():IPMPhysBody
		function set body( a_value:IPMPhysBody ):void
		function get p():PMVec2
		function get aabb():PMAABB
		function get isStatic():Boolean
		
		function get next():IPMShape
		function set next( a_shape:IPMShape ):void
		
		// PUBLIC API
		function updateAABB():void
		function debugDraw( a_camera:PMCamera, a_offset:PMVec2 ):void
		
		function clone():IPMShape
		function project( a_offset:PMVec2, a_vector:PMVec2 ):Array
		
	}
	
}
