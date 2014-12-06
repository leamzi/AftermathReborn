package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class FacebookImage extends Sprite 
	{
		private var facebookId:int;
		private var facebookAvatar:ImageLoader;
		private var noImage:Image;
		private var connect:Connection;
		private var url:String;
		
		public function FacebookImage(_globalResources:GlobalResources, _facebookId:String, _texturesScene:AssetManager) 
		{
			url = "https://graph.facebook.com/"+ _facebookId +"/picture";
			//trace("URL " + url);
			
			noImage = new Image(_texturesScene.getAtlas("Gui").getTexture("noImage"));
			addChild(noImage);
			
			var userImage:ImageLoader = new ImageLoader (url, _globalResources.loaderContext, 50, 50);
			addChild(userImage);
		}
		
	}

}