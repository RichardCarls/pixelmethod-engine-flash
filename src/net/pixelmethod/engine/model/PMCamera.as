package net.pixelmethod.engine.model {
	
	import net.pixelmethod.engine.phys.IPMPhysBody;
	import net.pixelmethod.engine.phys.PMVec2;
	
	public class PMCamera extends PMEntityBase {
		
		// PUBLIC PROPERTIES
		public var followTarget:IPMPhysBody;
		
		// PRIVATE PROPERTIES
		
		
		public function PMCamera() {
			super();
		}
		
		// PUBLIC API
		override public function init( a_props:Object = null ):void {
			super.init(a_props);
			
			if ( a_props.follow ) { followTarget = a_props.follow; }
		}
		
		override public function update( a_elapsed:Number ):void {
			if ( followTarget ) {
				p.copy(followTarget.p);
			}
			
			super.update(a_elapsed);
		}
	}
}
