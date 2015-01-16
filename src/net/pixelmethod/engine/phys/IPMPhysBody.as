package net.pixelmethod.engine.phys {
	
	import net.pixelmethod.engine.model.PMCamera;
	
	public interface IPMPhysBody {
		
		// PUBLIC PROPERTIES
		function get p():PMVec2
		function get v():PMVec2
		function get a():PMVec2
		function get aabb():PMAABB
		function get shapes():IPMShape
		
		function get numShapes():uint
		function get isStatic():Boolean
		
		// PUBLIC API
		function init( a_props:Object = null ):void
		function updateAABB():void
		function addShape( a_shape:IPMShape ):void
		function ghost( a_body:IPMPhysBody ):void
		
		function debugDraw( a_camera:PMCamera ):void
		
	}
	
}
