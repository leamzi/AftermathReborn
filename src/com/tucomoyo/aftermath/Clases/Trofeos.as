package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.Engine.TextureManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Trofeos extends Sprite 
	{
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		public static const imgURL:String = "";
		public var imgTrophy:ObjetoAsset;
		public var dialogVote:ObjectVote;
		public var objectData:Object;
		public var Odialog:Dialogs;
		public var vote:String;
		public var genere:int;
		private var hoverFilter:ColorMatrixFilter;
		private var hoverBoolean:Boolean;
		
		public function Trofeos(_texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, _objectData:Object, _vote:String, _genere:int = 1 ) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			soundsScene = _soundsScene;
			objectData = _objectData;
			vote = _vote;
			genere = _genere;
			
			addEventListener(TouchEvent.TOUCH, onTrophyClick);
			drawTrophies();

		}
		
		public function drawTrophies():void {
			
			hoverFilter = new ColorMatrixFilter();
			
			dialogVote = new ObjectVote(globalResources, texturesScene, objectData, vote, genere);
			dialogVote.visible = false;
			addChild(dialogVote);
			
			imgTrophy = new ObjetoAsset(objectData.id, texturesScene, globalResources.loaderContext, genere);
			imgTrophy.filter = hoverFilter;
			addChild(imgTrophy);
			imgTrophy.addEventListener(TouchEvent.TOUCH, onTrophyClick);
			
			Odialog = new Dialogs(globalResources, texturesScene, soundsScene, -25, -10);
			Odialog.linesDialog(objectData.name, 1);
			Odialog.x -= ((Odialog.width * 0.5) - 25);
			Odialog.y -= 60;
			Odialog.visible = false;
			addChild(Odialog);
			
		}
		
		public function onTrophyClick(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) {
				hoverFilter.reset();
				hoverBoolean = false;
				Odialog.visible = false;
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN) {
				
				if (touch.tapCount == 2) {
					Odialog.visible = false;
					dialogVote.visible = true;
				}
			}
			if (touch.phase == TouchPhase.HOVER) {
				if (!hoverBoolean)hoverFilter.adjustBrightness(0.2);
				hoverBoolean = true;
				Odialog.visible = true;
			}
			
		}
		
		override public function dispose():void {
			
			this.removeChildren();
			this.removeEventListeners();
			
			globalResources = null;
			texturesScene = null;
			soundsScene = null;
			
			if (imgTrophy != null) {
				
				imgTrophy.removeEventListeners();
				imgTrophy.dispose();
				imgTrophy = null;
			}
		
			objectData = null;
			
			super.dispose();
		}
		
	}

}