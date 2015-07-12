package com.tucomoyo.aftermath.Engine 
{
	import flash.utils.Dictionary;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	/**
	 * ...
	 * @author predictivia
	 */
	public class BodyManager 
	{
		private var bodyPool:Dictionary;
		public var space:Space;
		private var indexName:Vector.<String> = new Vector.<String>();
		
		public function BodyManager() 
		{
			bodyPool = new Dictionary();
			space = new Space(new Vec2(0, 0));
		}
		
		public function addBody(bodyName:String, _body:Body):void {
			
			if(bodyPool[bodyName] == undefined){
				_body.space =  this.space;
				bodyPool[bodyName] = _body;
				indexName.push(bodyName);
			}
			
		}
		
		public function getBody(bodyName:String):Body {
			
			if (bodyPool[bodyName] != undefined) {
				
				return bodyPool[bodyName];
			}
			
			return null;
		}
		
		public function activateBody(bodyName:String):void {
			
			if (bodyPool[bodyName] != undefined) {
				
				bodyPool[bodyName].space = this.space;
			}
			
		}
		
		public function diactivateBody(bodyName:String):void {
			
			if (bodyPool[bodyName] != undefined) {
				
				bodyPool[bodyName].space = null;
			}
			
		}
		
		public function activateAll():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var bodyName:String = indexName[i];
				bodyPool[bodyName].space = this.space;
				
			}
			
			
		}
		
		public function diactivateAll():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var bodyName:String = indexName[i];
				bodyPool[bodyName].space = null;
				
			}
			
		}
		
		public function deleteBody(bodyName:String):void {
			
			bodyPool[bodyName].clear();
			bodyPool[bodyName] = null;
			delete(bodyPool[bodyName]);
			indexName.splice(indexName.indexOf(bodyName), 1);
		}
		
		public function dispose():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var bodyName:String = indexName[i];
				bodyPool[bodyName].clear();
				bodyPool[bodyName] = null;
				delete(bodyPool[bodyName]);
				
			}
			
			indexName.splice(0, total_length);
			indexName = null;
			bodyPool = null;
			
		}
	
	}

}