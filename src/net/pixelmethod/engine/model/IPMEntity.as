package net.pixelmethod.engine.model {
	
	import net.pixelmethod.engine.render.PMRenderTarget;
	import net.pixelmethod.engine.phys.IPMPhysBody;
	
	public interface IPMEntity extends IPMPhysBody {
		
		// PUBLIC PROPERTIES
		function get parent():IPMEntity
		
		// PUBLIC API
		function update( a_elapsed:Number ):void
		function render( a_camera:PMCamera ):void
		
	}
	
}
