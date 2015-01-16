package net.pixelmethod.engine {
	
	import flash.events.KeyboardEvent;
	
	public class PMInputManager {
		
		// Singleton Instance Access
		public static function get instance():PMInputManager {
			if (_instance == null ) {
				_instance = new PMInputManager(new Enforcer());
			}
			return _instance;
		}
		private static var _instance:PMInputManager;
		
		// PUBLIC PROPERTIES
		
		// PRIVATE PROPERTIES
		private var _keysDown:Object;
		
		public function PMInputManager( a_enforcer:Enforcer ) {
			_keysDown = {};
		}
		
		// PUBLIC API
		public function isKeyPressed( a_keycode:int ):Boolean {
			if ( _keysDown[a_keycode] ) { return true; } else { return false; }
		}
		
		// HANDLERS
		public function onKeyUp( a_event:KeyboardEvent ):void {
			_keysDown[a_event.keyCode] = false;
		}
		
		public function onKeyDown( a_event:KeyboardEvent ):void {
			_keysDown[a_event.keyCode] = true;
		}
		
	}
}

internal class Enforcer {}
