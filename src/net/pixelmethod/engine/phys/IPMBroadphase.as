package net.pixelmethod.engine.phys {
	
	import net.pixelmethod.engine.model.PMCamera;
	
	public interface IPMBroadphase {
		
		// PUBLIC PROPERTIES
		function get p():PMVec2
		function get numRows():uint
		function get numCols():uint
		function get cellWidth():uint
		function get cellHeight():uint
		function get bounds():PMAABB
		
		// PUBLIC API
		function init( a_props:Object = null ):void
		function populate( a_physBodies:Array ):void
		function debugDraw( a_camera:PMCamera ):void
		
	}
	
}
