package com.tucomoyo.aftermath.Engine 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class ImageLoader extends Sprite 
	{
		public var texturesScene:AssetManager;
		public var imagen:Image;
		private var iWidth:int;
		private var iHeight:int;
		private var pivot:Boolean;
		public var _avatar:Loader = new Loader();
		private var imgData:Object;
		
		public function ImageLoader(img_url:String, _context:LoaderContext, _width:int = 0, _height:int = 0, _pivot:Boolean = false,_imgData:Object=null) 
		{
			super();
			
			iWidth = _width;
			iHeight = _height;
			pivot = _pivot;
			imgData = _imgData;
			var loaderContext:LoaderContext = _context;
			_avatar.load(new URLRequest(img_url+"?&t="+ int(new Date().time/86400000)), loaderContext);
			
			_avatar.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_avatar.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_avatar.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		public function onLoaded(e:Event):void {
			if (_avatar == null) return;
			_avatar.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			
			var loadedBitmap:Bitmap = e.currentTarget.loader.content as Bitmap;
			imagen =  new Image(Texture.fromBitmap(loadedBitmap));
			transform(imagen, iWidth, iHeight);
			if(pivot){
				imagen.pivotX = imagen.width * 0.5;
				imagen.pivotY = imagen.height * 0.5;
			}
			addChild(imagen);
		}
		
		public function transform(_fondo:Object, _width:int, _height:int):void{
			
			if (_width == 0 && _height == 0) return;
			_fondo.scaleX = _width/_fondo.width;
			_fondo.scaleY = _height/_fondo.height;
			//trace(_fondo.scaleX);
			
		}
		
		public function errorHandler(e:Event):void {
			if (imgData != null) 
			{
				//trace("Image Loader error"+imgData.atlas,imgData.texture);
				imagen = new Image(imgData.texturesScene.getAtlas(imgData.atlas).getTexture(imgData.texture));
				if(pivot){
					imagen.pivotX = imagen.width * 0.5;
					imagen.pivotY = imagen.height * 0.5;
				}
				addChild(imagen);
			}
			
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			this.removeChildren();
			if(imagen!=null)imagen.dispose();
			imagen = null;
			_avatar = null;
			if (imgData != null) 
			{
				imgData.textureScene = null;
				imgData = null;
			}

			super.dispose();
		}
		
	}

}