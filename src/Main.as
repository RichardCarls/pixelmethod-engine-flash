package {
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import asset.Assets;
	import net.pixelmethod.engine.*;
	import net.pixelmethod.engine.render.PMRenderTarget;
	
	[SWF(backgroundColor = '#FFFFFF', frameRate = '24', width = '160', height = '160')]
	public class Main extends PMGame {
		
		// PUBLIC PROPERTIES
		public var logWindow:TextField;
		public var mainScreen:Bitmap;
		public var mainRenderTarget:PMRenderTarget;
		
		// PRIVATE PROPERTIES
		
		public function Main() {
			super();
		}
		
		// PUBLIC API
		override public function init( a_event:Event = null ):void {
			super.init();
			
			// Initialize Game Manager
			PMGameManager.instance.metersToPixels = 6;
			
			// Initialize Render Targets
			mainRenderTarget = new PMRenderTarget(160, 160, 0xFF000000);
			mainRenderTarget.addLayer("background");
			PMGameManager.instance.registerRenderTarget("mainRenderTarget", mainRenderTarget);
			
			// Set Rendering Framerate
			renderPeriod = 25;
			
			// Main Screen Turn On!
			mainScreen = new Bitmap(mainRenderTarget.screenBuffer);
			addChild(mainScreen);
			
			// Add Debug Overlay
			//PMGameManager.instance.toggleDebugDraw();
			addChild(mainRenderTarget.debugOverlay);
			addChild(mainRenderTarget.overlayMask);
			
			// Add Log Window
			logWindow = new TextField();
			logWindow.background = true;
			logWindow.backgroundColor = 0x000000;
			logWindow.textColor = 0xFFFFFF;
			logWindow.mouseWheelEnabled = true;
			logWindow.multiline = true;
			logWindow.wordWrap = true;
			logWindow.styleSheet = new StyleSheet();
			logWindow.htmlText = PMGameManager.instance.log.fieldText;
			logWindow.x = 0;
			logWindow.y = 0;
			logWindow.width = 160;
			logWindow.height = 40;
			addChild(logWindow);
			
			// Load Game Assets
			new Assets();
			
			// Load Game Data
			PMGameManager.instance.registerWorld(FlashmanWorld);
			
			// Start Logic Loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// Load Entry Point
			PMGameManager.instance.loadWorld(FlashmanWorld);
			
		}
		
		// HANDLERS
		private function onEnterFrame( a_event:Event = null ):void {
			if ( PMGameManager.instance.currentWorld ) {
				if ( !renderTimer ) {
					renderTimer = new Timer(renderPeriod, 1);
					renderTimer.addEventListener(TimerEvent.TIMER, render);
					renderTimer.start();
				}
				
				// Update World
				PMGameManager.instance.currentWorld.update(( getTimer() - lastUpdate ) * 0.001);
				lastUpdate = getTimer();
			}
			
			// Log Window Key Listener
			if ( PMInputManager.instance.isKeyPressed(192) ) {
				if ( logWindow.stage ) { removeChild(logWindow); } else { addChild(logWindow); }
			}
			
			// Update Log Window
			logWindow.htmlText = PMGameManager.instance.log.fieldText;
		}
		
		override protected function render( a_event:TimerEvent ):void {
			mainRenderTarget.screenBuffer.lock();
			mainRenderTarget.clear();
			
			if ( PMGameManager.instance.currentWorld ) {
				PMGameManager.instance.currentWorld.render();
			}
			
			mainRenderTarget.flipScreen();
			mainRenderTarget.screenBuffer.unlock();
			
			renderTimer.reset();
			renderTimer.start();
			
			lastRender = getTimer();
			a_event.updateAfterEvent();
		}
		
		
	}
}
