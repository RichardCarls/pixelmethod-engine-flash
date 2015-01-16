package net.pixelmethod.engine {
	
	import flash.utils.Dictionary;
	
	import net.pixelmethod.engine.model.*;
	import net.pixelmethod.engine.render.PMRenderTarget;
	import net.pixelmethod.engine.util.PMLog;
	
	public class PMGameManager {
		
		// Singleton Instance Access
		public static function get instance():PMGameManager {
			if (_instance == null ) {
				_instance = new PMGameManager(new Enforcer());
			}
			return _instance;
		}
		private static var _instance:PMGameManager;
		
		// PUBLIC PROPERTIES
		public function get log():PMLog { return _gameLog; }
		public function get isDebugDrawEnabled():Boolean { return _isDebugDrawEnabled; }
		public function get currentWorld():PMWorld { return _currentWorld; }
		
		public var metersToPixels:Number;
		
		// PRIVATE PROPERTIES
		private var _isDebugDrawEnabled:Boolean;
		private var _currentWorld:PMWorld;
		
		private var _gameLog:PMLog;
		private var renderTargets:Object;
		private var tilesets:Object;
		private var worlds:Dictionary;
		
		public function PMGameManager( a_enforcer:Enforcer ) {
			_isDebugDrawEnabled = true;
			
			_gameLog = new PMLog();
			renderTargets = {};
			tilesets = {};
			worlds = new Dictionary(false);
			
			metersToPixels = 10;
		}
		
		// PUBLIC API
		public function toggleDebugDraw():void {
			( _isDebugDrawEnabled ) ? _isDebugDrawEnabled = false : _isDebugDrawEnabled = true;
		}
		
		public function registerRenderTarget( a_renderTargetID:String, a_renderTarget:PMRenderTarget ):void {
			renderTargets[a_renderTargetID] = a_renderTarget;
		}
		
		public function registerTileset( a_id:String, a_tileset:PMTileset ):void {
			tilesets[a_id] = a_tileset;
		}
		
		public function registerWorld( a_worldClass:Class, a_worldState:Object = null ):void {
			worlds[a_worldClass] = a_worldState;
		}
		
		public function getRenderTarget( a_renderTargetID:String ):PMRenderTarget {
			if ( renderTargets[a_renderTargetID] ) { return renderTargets[a_renderTargetID]; }
			return null;
		}
		
		public function getTileset( a_tilesetID:String ):PMTileset {
			if ( tilesets[a_tilesetID] ) { return tilesets[a_tilesetID]; }
			return null;
		}
		
		public function loadWorld( a_worldClass:Class ):void {
			_currentWorld = new a_worldClass();
			_currentWorld.init(worlds[a_worldClass]);
		}
		
	}
}

internal class Enforcer {}
