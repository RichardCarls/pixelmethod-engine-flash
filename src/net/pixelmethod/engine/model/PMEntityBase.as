package net.pixelmethod.engine.model {
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.PMInputManager;
	import net.pixelmethod.engine.phys.PMPhysBody;
	
	public class PMEntityBase extends PMPhysBody implements IPMEntity {
		
		// PUBLIC PROPERTIES
		public function get parent():IPMEntity { return ( _parent ) ? _parent : null }
		
		// PRIVATE PROPERTIES
		private var _parent:IPMEntity;
		
		private var entFlags:Object;
		
		public function PMEntityBase() {
			super();
			
			entFlags = {};
		}
		
		// PUBLIC API
		override public function init( a_props:Object = null ):void {
			super.init(a_props);
			
			if ( a_props.entFlags ) {
				for ( var i:int = 0; i < a_props.entFlags.length; i++ ) {
					setFlag(a_props.entFlags[i]);
				}
			}
		}
		
		public function update( a_elapsed:Number ):void {
			// Apply Input
			if ( getFlag("hasInput") ) {
				// LEFT / RIGHT
				if ( PMInputManager.instance.isKeyPressed(37) ) {
					a.x = -2;
				} else if ( PMInputManager.instance.isKeyPressed(39) ) {
					a.x = 2;
				} else {
					a.x = 0;
				}
				
				// UP / DOWN
				if ( PMInputManager.instance.isKeyPressed(38) ) {
					a.y = -2;
				} else if ( PMInputManager.instance.isKeyPressed(40) ) {
					a.y = 2;
				} else {
					a.y = 0;
				}
			}
			
			// Apply Acceleration
			v.x += a.x * a_elapsed * PMGameManager.instance.metersToPixels;
			v.y += a.y * a_elapsed * PMGameManager.instance.metersToPixels;
			
			// Apply Velocity
			p.x += v.x * a_elapsed * PMGameManager.instance.metersToPixels;
			p.y += v.y * a_elapsed * PMGameManager.instance.metersToPixels;
		}
		
		public function render( a_camera:PMCamera ):void {
			// ...
			
			
			debugDraw(a_camera);
		}
		
		public function setFlag( a_flag:String, a_value:Boolean = true ):void {
			entFlags[a_flag] = a_value;
		}
		
		public function getFlag( a_flag:String ):Boolean {
			if ( entFlags[a_flag] != null ) { return entFlags[a_flag]; }
			return false;
		}
		
	}
}
