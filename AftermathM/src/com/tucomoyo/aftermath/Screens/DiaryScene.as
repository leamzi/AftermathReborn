package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.ExternalAssets;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class DiaryScene extends Scene 
	{
		public var nextBtn:Button;
		
		public var connect:Connection;
		
		public var fullImage:ImageLoader;
		public var backgroundImage:ImageLoader;
		private var textNumber:int;
		public var currentScene:int;
		public var typeFade:int = 0;
		
		public var loadingMov:MovieClip;
		
		public var comicData:Object;
		public var comicText:Object;
		
		public var  loadingSprite:Sprite = new Sprite();
		public var  comicSprite:Sprite = new Sprite();
		
		private var title:TextField;
		public var tween:Tween;
		public var tween2:Tween;
		public var tween3:Tween;
		
		private var textQuad:Quad;
		
		public var currentText:TextField;
		
		
		public function DiaryScene(_resources:GlobalResources, _params:Object = null) 
		{
			super(_resources);
			
			globalResources = _resources;
			comicData = _params;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAdded);
			trace("comic megatile id: "+comicData.nextSceneData.megatile_id);
			connect = new Connection();
		}
		
		public function onAdded(e:starling.events.Event):void 
		{
            
            this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAdded);
            
			soundsScene.addSound("comicScene_BGM", -1);
			soundsScene.addSound("comicPageFlip01", 0);
			soundsScene.addSound("comicPageFlip02", 0);
			
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, generateText);
			texturesScene.addTexture("Botones", "Buttons");
			texturesScene.loadTextureAtlas();
		}
		 
		private function generateText():void 
		{
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveText);
			connect.loadComicsLanguage(globalResources.pref_url,comicData.name);
		}
		
		private function onReciveText(e:GameEvents):void 
		{
			
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveText);
			comicText = e.params;
			
			comicSprite.addEventListener(TouchEvent.TOUCH, onSkipText);
			
			fullImage = new ImageLoader("https://s3.amazonaws.com/tucomoyo-games/aftermath/external_images/Comics/" + comicData.name +"/"+ comicData.name+".jpg", globalResources.loaderContext, 760, 400);
			fullImage.alpha = 0.5;
			comicSprite.addChild(fullImage);
			fullImage._avatar.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, firstScene);
			
			var quad2:Quad = new Quad(760, 400, 0x000000);
			addChild(quad2);
			
			var quad:Quad = new Quad(760, 400, 0x000000);
			loadingSprite.addChild(quad);
			
			loadingMov = new MovieClip(texturesScene.getAtlas("Botones").getTextures("comic_loader"), 8);
			loadingMov.x = 300;
			loadingMov.y = 150;
			loadingMov.setFrameDuration(5, 1);
			Starling.juggler.add(loadingMov);
			loadingSprite.addChild(loadingMov);
			
			var exitComic2:Button = new Button(texturesScene.getAtlas("Botones").getTexture("guiClose"));
			exitComic2.x = 720;
			exitComic2.y = 10;
			exitComic2.addEventListener(starling.events.Event.TRIGGERED, exitComic);
			tempData.push(exitComic2);
			
			
			addChild(comicSprite);
			loadingSprite.visible = false;
			addChild(exitComic2);
			addChild(loadingSprite);
			
		}
		
		public function firstScene(e:flash.events.Event):void 
		{	
			//trace("first Scene");
			soundsScene.getSound("comicScene_BGM").play(globalResources.volume);
			
			fullImage._avatar.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, firstScene);
			fullImage = null;
			
			title = new TextField(760, 400, comicText[globalResources.idioma][comicData.name].title, globalResources.fontName, 32, 0xFFFFFF, true);
			title.alpha = 0;
			title.vAlign = "center";
			title.hAlign = "center";
			comicSprite.addChild(title);
			
			tween = new Tween(title, 2);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
			tween.repeatDelay = 2;
			tween.repeatCount = 2;
			tween.reverse = true;
			tween.onComplete = fadeSprite;
			
			globalResources.deactivateSplash();
		}
		
		public function fadeSprite(e:flash.events.Event = null) :void
		{
			trace("fade");
			switch (typeFade) 
			{
				case 0://Fade Out
					//trace("fade out");
					currentScene += 1;
					
					if (tween2 != null) {
					Starling.juggler.remove(tween2);
					tween2 = null;
					}
			
					tween2 = new Tween(comicSprite, 1);
					tween2.fadeTo(0);
					Starling.juggler.add(tween2);
					tween2.onComplete = loaderBar;
					comicSprite.removeChildren();
					if (backgroundImage != null) backgroundImage.dispose();
				break;
				case 1://Fade in
					//trace("fade in");
					loadingSprite.visible = false;
					
					if (tween2 != null) {
					Starling.juggler.remove(tween2);
					tween2 = null;
					}
					
					tween2 = new Tween(comicSprite, 2);
					tween2.fadeTo(1);
					Starling.juggler.add(tween2);
					tween2.onComplete = onNextPage;
				break;
			}
			
		}
		
		public function loaderBar():void 
		{
			loadingSprite.visible = true;
			
			trace("loading");
			if (tween != null) {
				Starling.juggler.remove(tween);
				tween = null;
			}
			if (tween2 != null) {
				Starling.juggler.remove(tween2);
				tween2 = null;
			}
			
			if (title != null) {
				title.visible = false;
				title = null;
			}
			
			nextBtn = new Button(texturesScene.getAtlas("Botones").getTexture("btnAccept"));
			nextBtn.x = 670;
			nextBtn.y = 340;
			nextBtn.addEventListener(starling.events.Event.TRIGGERED, onButtonClick);
			nextBtn.visible = false;
			
			typeFade = 1;
			trace("https://s3.amazonaws.com/tucomoyo-games/aftermath/external_images/Comics/" + comicData.name +"/"+ comicData.name + currentScene + ".jpg");
			backgroundImage = new ImageLoader("https://s3.amazonaws.com/tucomoyo-games/aftermath/external_images/Comics/" + comicData.name +"/"+ comicData.name + currentScene + ".jpg", globalResources.loaderContext, 1520, 400);
			backgroundImage._avatar.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, fadeSprite);
			
			comicSprite.addChild(backgroundImage);
			comicSprite.addChild(nextBtn);
		}
		
		public function onNextPage():void
		{
			trace("nextPage");
			textNumber++;
			
			textQuad = new Quad(720, 120, 0x000000);
			textQuad.alpha = 0.5;
			textQuad.x = 20;
			textQuad.y = 280;
			comicSprite.addChild(textQuad);
			
			currentText = new TextField(720, 120, comicText[globalResources.idioma][comicData.name]["text"+textNumber], globalResources.fontName, 16, 0xFFFFFF);
			currentText.autoScale = true;
			currentText.hAlign = "center";
			currentText.vAlign = "center";
			currentText.name = "First"; 
			currentText.alpha = 0;
			currentText.x = 20;
			currentText.y = 280;
			currentText.touchable = false;
			comicSprite.addChild(currentText);
			fadeInText(0);
			loopBackground();
		}
		
		public function fadeInText(type:int):void 
		{
			//trace("Text Fade");
			if (tween != null) {
				Starling.juggler.remove(tween);
				tween = null;
			}
			tween = new Tween(currentText, 5);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
			tween.repeatCount = 2;
			tween.repeatDelay = 5;
			tween.reverse = true;
			if (type == 0) tween.onComplete = onNextText;
			if (type == 1) tween.onComplete = showNextButton;
			
		}
		
		public function onNextText():void 
		{	
			//trace("nextText");
			currentText = null;
			textNumber++;
			currentText = new TextField(720, 120, comicText[globalResources.idioma][comicData.name]["text"+textNumber], globalResources.fontName, 16, 0xFFFFFF);
			currentText.autoScale = true;
			currentText.hAlign = "center";
			currentText.vAlign = "center";
			currentText.name = "Last"; 
			currentText.alpha = 0;
			currentText.x = 20;
			currentText.y = 280;
			currentText.touchable = false;
			addChild(currentText);
			
			fadeInText(1);
		}
		
		public function showNextButton():void 
		{	
			//trace("next button available");
			//trace("Scene: " + currentScene);
			if (currentScene == comicData.numScenes) 
			{
				//trace("exit");
				textQuad.visible = false;
				textQuad = null;
				
				var exitBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("btnRight"));
				exitBtn.x = 760 - exitBtn.width;
				exitBtn.y = 340;
				exitBtn.addEventListener(starling.events.Event.TRIGGERED, exitComic);
				comicSprite.addChild(exitBtn);
			} else {
				if (textQuad != null) 
				{
					textQuad.visible = false;
					textQuad = null;
					nextBtn.visible = true;
				}
			}
			
		}
		
		private function onSkipText(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) 
			{
				return;
			}
			if (touch.phase == TouchPhase.BEGAN) 
			{
				//trace("click");
				if (tween != null && currentText != null) 
				{
					currentText.visible = false;
					Starling.juggler.remove(tween);
					tween = null;
					
					if (currentText.name == "First") 
					{
						trace("skip en primer texto");
						onNextText();
						
					} else {
						
						trace("skip en segundp texto");
						showNextButton();
					
					}
					//trace("no hay texto");
				}
			}
		}
		
		public function loopBackground():void 
		{
			//trace("background tween");
			if (tween2 != null) {
				Starling.juggler.remove(tween2);
				tween2 = null;
			}
			if (tween3 != null) {
				Starling.juggler.remove(tween3);
				tween3 = null;
			}
			
			backgroundImage.x = 0;
			trace("background tween x: " + backgroundImage.x);
			
			tween3 = new Tween(backgroundImage, 0.5);
			tween3.fadeTo(1);
			Starling.juggler.add(tween3);
			tween3.nextTween = tween2;
			
			tween2 = new Tween(backgroundImage, 15);
			tween2.moveTo(-760, backgroundImage.y);
			Starling.juggler.add(tween2);
			tween2.onComplete = loopBackgroundReset;
		}
		
		public function loopBackgroundReset():void 
		{
			trace("background loop: "+ backgroundImage.x);
			
			if (tween2 != null) {
				Starling.juggler.remove(tween2);
				tween2 = null;
			}
			
			tween2 = new Tween(backgroundImage, 1);
			tween2.fadeTo(0);
			Starling.juggler.add(tween2);
			tween2.onComplete = loopBackground;
		}
		
		
		
		public function onButtonClick():void 
		{
			soundsScene.getSound("comicPageFlip02").play(globalResources.volume);
			
			typeFade = 0;
			fadeSprite();
		}
		
		public function exitComic(e:starling.events.Event):void 
		{
			trace("sali de comic para: "+comicData.nextSceneData.type);
			switch (comicData.nextSceneData.type) 
			{
				case "gamePlayTutorial":
					this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:comicData.nextSceneData.type,  data: { missionId: comicData.nextSceneData.missionId, src:comicData.nextSceneData.src }}, true));
				break;
				case "missionScreen":
					this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"missionScreen", megatile_id: comicData.nextSceneData.megatile_id}));
				break;
			}
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			
			if (tween != null) {
				Starling.juggler.remove(tween);
				tween = null;
			}
			if (tween2 != null) {
				Starling.juggler.remove(tween2);
				tween2 = null;
			}
			if (tween3 != null) {
				Starling.juggler.remove(tween3);
				tween3 = null;
			}
			super.dispose();
			
		}
		
	}

}