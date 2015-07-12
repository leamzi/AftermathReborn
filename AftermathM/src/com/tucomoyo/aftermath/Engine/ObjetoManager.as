package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.Clases.Objetos;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class ObjetoManager extends Sprite 
	{
		private static var objetosPool:Dictionary;
		public var indexName:Vector.<String> = new Vector.<String>;
		
		
		public function ObjetoManager() 
		{
			super();
			objetosPool = new Dictionary();
		}
		
		public function addObjeto(objetoName:String, objeto:Objetos):void {
			if (objetosPool[objetoName] == undefined) {
				objetosPool[objetoName] = objeto;
				indexName.push(objetoName);
			}
		}
		
		public function getObjeto(objetoName:String):Objetos {
			
			if (objetosPool[objetoName] != undefined) {
				return objetosPool[objetoName];
			}
			return null;
		}
		
		public function deleteObjeto(objetoName:String, dispose: Boolean = true):void {
			if (objetosPool[objetoName]!=null) 
			{
				if (dispose)objetosPool[objetoName].dispose();
				objetosPool[objetoName] = null;
				delete(objetosPool[objetoName]);
				indexName.splice(indexName.indexOf(objetoName), 1);
			}
		}
		
		override public function dispose():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var objetoName:String = indexName[i];
				objetosPool[objetoName].dispose();
				objetosPool[objetoName] = null;
				delete(objetosPool[objetoName]);
				
			}
			
			indexName.splice(0, total_length);
			indexName = null;
			objetosPool = null;
		}
	}

}