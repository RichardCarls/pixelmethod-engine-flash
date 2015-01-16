package net.pixelmethod.engine.model {
	
	import net.pixelmethod.engine.render.PMRenderTarget;
	
	public class PMWorld {
		
		// PUBLIC PROPERTIES
		public var activeChunks:Array;
		public var entities:Array;
		public var cameras:Array;
		
		// PRIVATE PROPERTIES
		
		public function PMWorld() {
			activeChunks = [];
			entities = [];
			cameras = [];
		}
		
		// PUBLIC API
		public function init( a_state:Object = null ):void {
			//
		}
		
		public function update( a_elapsed:Number ):void {
			// Update Entities
			for each ( var ent:IPMEntity in entities ) {
				ent.update(a_elapsed);
			}
			
			// Update Cameras
			for each ( var cam:PMCamera in cameras ) {
				cam.update(a_elapsed);
			}
			
			// Update Chunks
			for each ( var chunk:PMChunk in activeChunks ) {
				// Assign entities
				chunk.localEntities = [];
				for each ( ent in entities ) {
					if (( ent.p.x - ent.aabb.xw ) > ( chunk.p.x + chunk.bounds.xw )) { continue; }
					if (( ent.p.x + ent.aabb.xw ) < ( chunk.p.x - chunk.bounds.xw )) { continue; }
					if (( ent.p.y - ent.aabb.yw ) > ( chunk.p.y + chunk.bounds.yw )) { continue; }
					if (( ent.p.y + ent.aabb.yw ) < ( chunk.p.y - chunk.bounds.yw )) { continue; }
					
					chunk.localEntities.push(ent);
				}
				
				chunk.update(a_elapsed);
			}
		}
		
		public function render():void {
			for each ( var cam:PMCamera in cameras ) {
				// Render Self
				// ..
				
				// Render Chunks
				for each ( var chunk:PMChunk in activeChunks ) {
					chunk.render(cam);
				}
				
				// Render Entities
				for each ( var ent:IPMEntity in entities ) {
					ent.render(cam);
				}
				
				//cam.render(null);
			}
		}
		
	}
}
