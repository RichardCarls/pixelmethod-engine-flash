package net.pixelmethod.engine.util {
	
	public class PMLog {
		
		public static var STAMP_COLOR:String = "#0000FF";
		public static var STAMP_SIZE:uint = 4;
		public static var DEFAULT_SIZE:uint = 6;
		
		// PUBLIC PROPERTIES
		public function get fieldText():String { return head(maxLines); }
		
		public var maxLines:uint;
		
		// PRIVATE PROPERTIES
		private var lines:Array;
		
		public function PMLog() {
			maxLines = 60;
			
			lines = [];
			log("Logging started.");
		}
		
		// PUBLIC API
		public function log( a_line:String ):void {
			lines.unshift( "<p><font size=\"" + DEFAULT_SIZE + "\">" + stamp() + "&gt; " + a_line + "</font></p>");
			truncate();
		}
		
		public function head( a_numLines:uint = 60 ):String {
			var result:String = "";
			
			for ( var i:int = a_numLines; i >= 0; i-- ) {
				if ( !lines[i] ) { continue; }
				result = result.concat(lines[i]);
			}
			
			return result;
		}
		
		public function tail( a_numLines:uint = 3 ):String {
			var result:String = "";
			
			for ( var i:int = 0; i < a_numLines; i++ ) {
				if ( !lines[i] ) { break; }
				result = result.concat(lines[i]);
			}
			
			return result;
		}
		
		// PRIVATE API
		private function truncate():void {
			if ( lines.length > maxLines ) {
				lines.splice(maxLines - 1, int.MAX_VALUE);
			}
		}
		
		private function stamp():String {
			return "<font color=\"" + STAMP_COLOR + "\" size=\"" + STAMP_SIZE + "\">[" +  new Date().toLocaleString() + "]</font>";
		}
		
	}
	
}
