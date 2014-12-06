package com.tucomoyo.aftermath.Engine 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class TextureManager extends EventDispatcher 
	{
		private static var texturePool:Dictionary;
		private var indexName:Vector.<String> = new Vector.<String>();
		private var textureQueue:Vector.<Object> =  new Vector.<Object>();
		private var TextureFolder:String;
		private var pref_url:String = "graphics/";
		private var loaderTexture:Loader;
		private var urlResources:URLRequest;
		private var contextResources:LoaderContext;
		private var currentTextureName:String;
		
		public function TextureManager(_pref_url:String, _context:LoaderContext) 
		{
			super();
			
			texturePool = new Dictionary();
		  
			this.contextResources = _context;
			this.pref_url = _pref_url + pref_url;
			
		}
		
		public function addTexture(TextureName:String, _TextureFolder:String):void {
			
			var atlasVars:Object = new Object();
			atlasVars.tName = TextureName;
			atlasVars.tFolder = _TextureFolder;
			textureQueue.push(atlasVars);
			
		}
		
		public function loadTexture():void {
			
			if (textureQueue.length > 0) {
				
				var atlasVars:Object = textureQueue.shift();
				addPool(atlasVars.tName, atlasVars.tFolder);
				atlasVars = null;
				
			}else {
				textureQueue = null;
				loaderTexture = null;
				urlResources = null;
				contextResources = null;
				this.dispatchEvent(new GameEvents(GameEvents.TEXTURE_LOADED));
			}
			
		}
		
		private function addPool(TextureName:String, _TextureFolder:String):void {
			
			if(texturePool[TextureName] == undefined){
				
				currentTextureName = TextureName;
				indexName.push(TextureName);
				TextureFolder = _TextureFolder;
				
				loaderTexture = new Loader();				
				loaderTexture.contentLoaderInfo.addEventListener(Event.COMPLETE, onTexture);
				urlResources =  new URLRequest(pref_url + TextureFolder + "/" + currentTextureName + ".png?&t="+ int(new Date().time/86400000)); 
				loaderTexture.load(urlResources, contextResources);
				
			}
			else {
				loadTexture();
			}
			
		}
		
		public function getTexture(TextureName:String):Texture {
			
			if (texturePool[TextureName] != undefined) {
				
				return texturePool[TextureName];
				
			}
			
			return null;
		}
		
		public function deleteTexture(textureName:String):void {
			
			texturePool[textureName].dispose();
			delete(texturePool[textureName]);
			indexName.splice(indexName.indexOf(textureName), 1);
		}
		
		public function dispose():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var textureName:String = indexName[i];
				texturePool[textureName].dispose();
				texturePool[textureName] = null;
				delete(texturePool[textureName]);
				
			}
			
			indexName.splice(0, total_length);
			indexName = null;
			texturePool = null;
			
		}
		
		
		//EVENTS
		
		public function onTexture(e:Event):void {
			
			loaderTexture.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTexture);
			texturePool[currentTextureName] = Texture.fromBitmap(e.currentTarget.loader.content as Bitmap);
			
			loadTexture();
			
		}
		
		
	}

}