package com.tucomoyo.aftermath.Engine 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Predictvia
	 */
	public class AssetManager extends starling.events.EventDispatcher
	{
		private static var texturePool:Dictionary;
		private var indexName:Vector.<String> = new Vector.<String>();
		private var textureQueue:Vector.<Object> =  new Vector.<Object>();
		private var TextureFolder:String;
		private var pref_url:String = "graphics/";
		private var loaderResources:Loader;
		private var loaderXmlResources:URLLoader;
		private var urlResources:URLRequest;
		private var contextResources:LoaderContext;
		private var currentXml:XML;
		private var currentTextureName:String;
		
		public function AssetManager(_pref_url:String, _context:LoaderContext) 
		{
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
		
		public function loadTextureAtlas():void {
			
			if (textureQueue.length > 0) {
				
				var atlasVars:Object = textureQueue.shift();
				addAtlas(atlasVars.tName, atlasVars.tFolder);
				atlasVars = null;
				
			}else {
				textureQueue = null;
				loaderResources = null;
				loaderXmlResources = null;
				urlResources = null;
				contextResources = null;
				currentXml = null;
				this.dispatchEvent(new GameEvents(GameEvents.TEXTURE_LOADED));
			}
			
		}
		
		private function addAtlas(TextureName:String, _TextureFolder:String):void {
			
			if(texturePool[TextureName] == undefined){
				
				currentTextureName = TextureName;
				indexName.push(TextureName);
				TextureFolder = _TextureFolder;
				
				loaderResources = new Loader();
				loaderXmlResources = new URLLoader();
				loaderXmlResources.addEventListener(Event.COMPLETE, onXml);
				urlResources =  new URLRequest(pref_url + TextureFolder + "/" + TextureName + ".xml?&t="+ int(new Date().time/86400000));
				loaderXmlResources.load(urlResources);
				
			}else {
				loadTextureAtlas();
				
			}
			
			
		}
		
		public function getAtlas(TextureName:String):TextureAtlas {
			
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
		
		public function onXml(e:Event):void {
			
			loaderXmlResources.removeEventListener(Event.COMPLETE, onXml);
			currentXml =  new XML(e.target.data);
			
			loaderResources.contentLoaderInfo.addEventListener(Event.COMPLETE, onTexture);
			urlResources =  new URLRequest(pref_url + TextureFolder + "/" + currentTextureName + ".png?&t="+ int(new Date().time/86400000));
			loaderResources.load(urlResources, contextResources);
			
		}
		
		public function onTexture(e:Event):void {
			
			loaderResources.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTexture);
			var textureAuxiliar:Texture = Texture.fromBitmap(e.currentTarget.loader.content as Bitmap);
			texturePool[currentTextureName] = new TextureAtlas(textureAuxiliar, currentXml);
			textureAuxiliar = null;
			loadTextureAtlas();
			
		}
		
	}

}