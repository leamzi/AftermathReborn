package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import com.tucomoyo.aftermath.Clases.FacebookImage;
	import flash.net.URLLoader;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class FacebookFriendListBox extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		public var data:Object;
		private var avatar:FacebookImage;
		private var fondoImg:Image;
		public var check:Image;
		private var nameText:TextField;
		private var checkBool:Boolean = false;
		//private var loader:URLLoader= new URLLoader;
		
		public function FacebookFriendListBox(_globalResources:GlobalResources, _texturesScene:AssetManager, _data:Object) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene
			data = _data;
			this.alpha = 0.7;
			
			avatar = new FacebookImage (globalResources, data.id , texturesScene);
			avatar.x = 7;
			avatar.y = 7;
			addChild(avatar);
			
			fondoImg = new Image(texturesScene.getAtlas("Gui").getTexture("facebookFriend_Box"));
			addChild(fondoImg);
			
			nameText = new TextField(105, 30, data.name, globalResources.fontName, 14, 0x000000);
			nameText.hAlign = "left";
			nameText.vAlign = "top";
			nameText.x = 62;
			nameText.y = 16;
			nameText.touchable = false;
			addChild(nameText);
			
			check = new Image(texturesScene.getAtlas("Botones").getTexture("checkmark"));
			check.scaleX = 0.5;
			check.scaleY = 0.5;
			check.x = 181;
			check.y = 20;
			check.visible = false;
			addChild(check);
			
			
			this.addEventListener(TouchEvent.TOUCH, onTouchFriend);
		}
		
		public function onTouchFriend(e:TouchEvent):void
		{    
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) 
			{
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN) 
			{
				checkBool = !checkBool;
				checkFriend(checkBool);
			}
			
		}
		
		public function checkFriend(bool:Boolean):void
		{
			if (bool) 
				{
					this.alpha = 1;
					check.visible = true;
					check.touchable = false;
				}else {
					this.alpha = 0.7;
					check.visible = false;
				}
		}
		
	}

}