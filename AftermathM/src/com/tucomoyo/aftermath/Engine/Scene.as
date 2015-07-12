package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.display.DisplayObject;
	import flash.system.System;
	import starling.animation.Tween;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Scene extends Sprite 
	{
		public var globalResources:GlobalResources;
		public var soundsScene:SoundManager;
		public var texturesScene:AssetManager;
		public var bitmapsScene:TextureManager;
		public var objetosScene:ObjetoManager;
		public var imageScene:ImageManager; 
		public var bodiesScene:BodyManager;
		public var tempData:Array = new Array();
		public var animationsTempData:Vector.<Tween> = new Vector.<Tween>;
		
		public function Scene(_resources:GlobalResources) 
		{
			super();
			globalResources = _resources;
			soundsScene = new SoundManager(globalResources.pref_url);
			texturesScene = new AssetManager(globalResources.pref_url, globalResources.loaderContext);
			imageScene = new ImageManager(globalResources.loaderContext);
			bitmapsScene = new TextureManager(globalResources.pref_url, globalResources.loaderContext);
			objetosScene = new ObjetoManager();
			bodiesScene = new BodyManager();
		}
		
		override public function dispose():void {
			
			this.removeEventListeners();
			this.removeChildren();
			
			globalResources = null;
			
			soundsScene.dispose();
			texturesScene.dispose();
			imageScene.dispose();
			bodiesScene.dispose();
			
			soundsScene = null;
			texturesScene = null;
			bodiesScene = null;
			
			for (var i:uint = 0; i < tempData.length;++i) {
				tempData[i].removeEventListeners();
				tempData[i].dispose();
				tempData[i] = null;
			}
			
			for (var j:uint = 0; j < animationsTempData.length; j++) {
				animationsTempData[j] = null;
			}
			
			tempData.splice(0, tempData.length);
			tempData = null;
			super.dispose();
			
		}
	}

}