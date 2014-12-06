package com.tucomoyo.aftermath.Engine 
{
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author predictivia
	 */
	public class ImageManager extends EventDispatcher
	{
		private static var imagePool:Dictionary;
		private var indexName:Vector.<String> = new Vector.<String>();
		private var contextResources:LoaderContext;
		
		public function ImageManager( _context:LoaderContext) 
		{
			contextResources = _context;
		}
		
		public function addImage(ImageName:String, url:String):void {
			
			if(imagePool[ImageName] == undefined){
				
				imagePool[ImageName] = new ImageLoader(url,this.contextResources);
				indexName.push(ImageName);
			}
			
		}
		
		public function getImage(ImageName:String):ImageLoader {
			
			if(imagePool[ImageName] != undefined){
				
				return imagePool[ImageName];
			}
			
			return null;
		}
		
		public function deleteImage(ImageName:String):void {
			
			imagePool[ImageName].dispose();
			delete(imagePool[ImageName]);
			indexName.splice(indexName.indexOf(ImageName), 1);
		}
		
		public function dispose():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var imageName:String = indexName[i];
				imagePool[imageName].dispose();
				imagePool[imageName] = null;
				delete(imagePool[imageName]);
				
			}
			
			indexName.splice(0, total_length);
			imageName = null;
			imagePool = null;
		}
		
	}

}