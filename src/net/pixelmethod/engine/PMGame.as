package net.pixelmethod.engine {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import net.pixelmethod.engine.util.PMLog;
	
	public class PMGame extends Sprite {
		
		// PUBLIC PROPERTIES
		public var gameLog:PMLog;
		
		[ArrayElementType('net.pixelmethod.engine.PMRenderTarget')]
		public var renderTargets:Array;
		
		public var renderTimer:Timer;
		public var renderPeriod:int;
		public var lastUpdate:int;
		public var lastRender:int;
		
		// PRIVATE PROPERTIES
		
		public function PMGame() {
			super();
			
			renderTargets = [];
			
			renderPeriod = 25;
			lastUpdate = 0;
			lastRender = 0;
			
			if (stage) { init(); }
			else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		// PUBLIC API
		public function init( a_event:Event = null ):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Initialize Input Manager
			stage.addEventListener(KeyboardEvent.KEY_UP, PMInputManager.instance.onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, PMInputManager.instance.onKeyDown);
		}
		
		// HANDLERS
		protected function render( a_event:TimerEvent ):void {
			//
		}
		
	}
}
