package net.pixelmethod.engine.model {
	
	import flash.display.Graphics;
	
	import net.pixelmethod.engine.PMGameManager;
	import net.pixelmethod.engine.phys.*;
	import net.pixelmethod.engine.render.PMTilemapRenderer;
	
	public class PMChunk {
		
		// PUBLIC PROPERTIES
		public function get chunkID():String { return _chunkID; }
		public function get p():PMVec2 { return _p; }
		public function get bounds():PMAABB { return _bounds; }
		public function get broadphase():IPMBroadphase { return _broadphase; }
		
		public function get tilemap():PMTilemap { return _tilemap; }
		
		[ArrayElementType('net.pixelmethod.engine.model.IPMEntitiy')]
		public var localEntities:Array;
		
		// PRIVATE PROPERTIES
		private var _chunkID:String;
		private var _p:PMVec2;
		private var _bounds:PMAABB;
		private var _broadphase:IPMBroadphase;
		
		private var _tilemap:PMTilemap;
		
		
		private var renderers:Array;
		
		public function PMChunk() {
			_p = new PMVec2();
			_bounds = new PMAABB();
			
			localEntities = [];
			
			renderers = [];
		}
		
		// PUBLIC API
		public function init( a_props:Object = null ):void {
			if ( a_props.id ) { _chunkID =  a_props.id; }
			if ( a_props.x ) { _p.x =  a_props.x; }
			if ( a_props.y ) { _p.y =  a_props.y; }
			if ( a_props.w ) { _bounds.xw =  a_props.w * 0.5; }
			if ( a_props.h ) { _bounds.yw =  a_props.h * 0.5; }
			
			// Initialize Broadphase
			if ( a_props.broadphase ) {
				switch ( a_props.broadphase.type ) {
					case "cells":
						_broadphase = new PMUniformCellGrid();
						_broadphase.init(a_props.broadphase);
						_broadphase.p.set(0, 0);
						break;
					default:
						break;
				}
			}
			
			// Initialize Renderers
			var renderer:*;
			if ( a_props.renderers ) {
				for ( var i:int = 0; i < a_props.renderers.length; i++ ) {
					switch ( a_props.renderers[i].type ) {
						case "tilemap":
							renderer = new PMTilemapRenderer();
							renderer.parent = this;
							renderer.tilemap = a_props.renderers[i].tilemap;
							renderers.push(renderer);
							break;
						default:
							break;
					}
				}
			}
		}
		
		public function update( a_elapsed:Number ):void {
			// Populate broadphase with local entities for collisions
			if ( _broadphase ) {
				_broadphase.populate(localEntities);
			}
		}
		
		public function render( a_camera:PMCamera ):void {
			for each ( var renderer:* in renderers ) {
				renderer.render(a_camera);
			}
			
			if ( _broadphase ) {
				_broadphase.debugDraw(a_camera);
			}
		}
		
	}
}
