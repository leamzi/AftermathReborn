package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Clases.PageFlip;
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class ComicScene extends Scene 
	{
		private var nextText:Boolean = false;
		
		private var exitComic:Button;
		private var exitComic2:Button;
		private var rightBtn:Button; 
		private var leftBtn:Button; 
		
		private var connect:Connection = new Connection();
		
		public var currentComicPage:Image;
		private var currentSprite:int = 0;
		private var currentPage:int = 1;
		
		public var comicData:Object;
		private var comicTextLanguage:Object;
		
		public var coverQuad:Quad;
		
		private var nextTransition:String;
		
		private var fadeInTween:Tween;
		private var fadeOutTween:Tween;
		private var ComicTween:Tween;
		public var comicText:TextField;
		
		private var spritesVec:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		private var imagesVec:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		
		private var pageFlipContainer:PageFlip;
		
		public function ComicScene(_globalResources:GlobalResources, params:Object = null) 
		{
			super(_globalResources);
			globalResources = _globalResources;
			comicData = params;
			comicTextLanguage = new Object();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		 public function onAdded(e:Event):void {
            
            this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            
			soundsScene.addSound("comicScene_BGM", -1);
			soundsScene.addSound("comicPageFlip01", 0);
			soundsScene.addSound("comicPageFlip02", 0);
			
            texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, generateSprites);
            texturesScene.addTexture("Comics", "Comics");
            texturesScene.addTexture("Botones", "Buttons");
            texturesScene.loadTextureAtlas();
            
        }
		
		private function generateSprites(e:GameEvents):void 
		{
			var newSprite:Sprite;
			
			texturesScene.removeEventListener(GameEvents.TEXTURE_LOADED, generateSprites);
			trace("Comic num Images: " + comicData.numImages);
			
				for (var i:int = 0; i < comicData.numImages; i++) 
				{
					newSprite = new Sprite();
					spritesVec.push(newSprite);
					newSprite = null;
				}
				
			generateText();
		}
		
		private function generateText():void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveText);
			connect.loadComicsLanguage(globalResources.pref_url,comicData.name);
		}
		
		private function onReciveText(e:GameEvents):void 
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveText);
			
			comicTextLanguage = e.params;
			
			drawComics();
		}
		
		public function drawComics():void {
		   var count:int = 0;
		   var fondo:Quad = new Quad(760, 400, 0x000000);
		   addChild(fondo);
		   
			trace("Imagen Actual: " + (currentSprite));
            for (var i:int = 0; i <spritesVec.length ; i++) 
			{
				// Pagina 1
				
				count++;
				currentComicPage = new Image (texturesScene.getAtlas("Comics").getTexture(comicData.name + "_00" + i));
				//currentComicPage.x = 100;
				//(spritesVec[i] as Sprite).addChild(currentComicPage);
				tempData.push(currentComicPage);
				imagesVec.push(currentComicPage);
				
				currentComicPage = null;
				
				coverQuad = new Quad  (285, 400, 0x000000);
				coverQuad.x = 380;
				coverQuad.alpha = 0.8;
				tempData.push(coverQuad);
				(spritesVec[i] as Sprite).addChild(coverQuad);
				coverQuad = null;
				
				comicText = new TextField (245, 370, "", globalResources.fontName, 16, 0xFFFFFF);
				comicText.x = 392;
				comicText.y = 14;
				comicText.text = comicTextLanguage[globalResources.idioma][comicData.name]["text" + count];
				comicText.hAlign = "center";
				comicText.vAlign = "top";
				tempData.push(comicText);
				(spritesVec[i] as Sprite).addChild(comicText);
				comicText = null;
				
				//Pagina 2
				
				count++;
				
				comicText = new TextField (245, 370, "", globalResources.fontName, 16, 0xFFFFFF);
				comicText.x = 120;
				comicText.y = 11;
				comicText.text = comicTextLanguage[globalResources.idioma][comicData.name]["text" + count];
				comicText.hAlign = "center";
				comicText.vAlign = "top";
				comicText.visible = false;
				tempData.push(comicText);
				(spritesVec[i] as Sprite).addChild(comicText);
				comicText = null;
				
			}
			
			leftBtn = new Button(texturesScene.getAtlas("Botones").getTexture("guiArrow"));
			leftBtn.x = 18;
			leftBtn.y = 190;
			leftBtn.visible = false;
			leftBtn.addEventListener(Event.TRIGGERED, onPreviousPage);
			tempData.push(leftBtn);
			addChild(leftBtn);
				
			rightBtn = new Button(texturesScene.getAtlas("Botones").getTexture("guiArrow"));
			rightBtn.x = 720;
			rightBtn.y = 190;
			rightBtn.alignPivot();
			rightBtn.rotation = 3.14;
			rightBtn.addEventListener(Event.TRIGGERED, onNextPage);
			tempData.push(rightBtn);
			addChild(rightBtn);
			
			pageFlipContainer = new PageFlip(imagesVec, 574, 400);
			pageFlipContainer.x = 100;
			addChild(pageFlipContainer);
			
			exitComic = new Button(texturesScene.getAtlas("Botones").getTexture("btnAccept"));
			exitComic.x = 670;
			exitComic.y = 335;
			exitComic.visible = false;
			exitComic.addEventListener(Event.TRIGGERED, onExitComic);
			tempData.push(exitComic);
			addChild(exitComic);
			
			exitComic2 = new Button(texturesScene.getAtlas("Botones").getTexture("guiClose"));
			exitComic2.x = 680;
			exitComic2.y = 10;
			exitComic2.addEventListener(Event.TRIGGERED, onExitComic);
			tempData.push(exitComic2);
			addChild(exitComic2);
			
			addChild(spritesVec[currentSprite] as Sprite);
			globalResources.deactivateSplash();
			
			soundsScene.getSound("comicScene_BGM").play(globalResources.volume);
		}
		
		private function onNextPage():void
		{
			exitComic.visible = false;
			
			if ( currentPage % 2 == 0) 
			{
				soundsScene.getSound("comicPageFlip02").play(globalResources.volume);
				
				ChangePage("Next");
				
				pageFlipContainer.turnToNextPage();
				
				
			}else 
			{
				hideRight();
			}
			currentPage++;
			leftBtn.visible = true;
			
			if (currentSprite == (spritesVec.length - 1 ) && currentPage == ( (spritesVec.length) * 2 ) ) {
				rightBtn.visible = false;
				exitComic.visible = true;
			}
		}
		
		private function onPreviousPage():void
		{
			exitComic.visible = false;
			
			if ( currentPage % 2 != 0) 
			{
				soundsScene.getSound("comicPageFlip02").play(globalResources.volume);

				ChangePage("Previous");
				
				pageFlipContainer.turnToPreviousPage()
			}else 
			{
				hideLeft();
			}
			currentPage--;
			rightBtn.visible = true;
			if (currentSprite == 0 && currentPage == 1) leftBtn.visible = false;
		}
		
		private function hideRight():void {
			
			soundsScene.getSound("comicPageFlip01").play(globalResources.volume);
			nextText = true;
			
			ComicTween = new Tween((spritesVec[currentSprite] as Sprite).getChildAt(0), 0.5,Transitions.EASE_IN);
			//ComicTween = new Tween((spritesVec[currentSprite] as Sprite).getChildAt(1), 0.5,Transitions.EASE_IN);
			ComicTween.moveTo(95, 0);
			Starling.juggler.add(ComicTween);
			ComicTween.onComplete = showText;
			ComicTween = null;
			
			(spritesVec[currentSprite] as Sprite).getChildAt(1).visible = false;
			//(spritesVec[currentSprite] as Sprite).getChildAt(2).visible = false;

		}
		
		private function hideLeft():void {
			
			soundsScene.getSound("comicPageFlip01").play(globalResources.volume);
			nextText = false;
			
			ComicTween = new Tween((spritesVec[currentSprite] as Sprite).getChildAt(0), 0.5,Transitions.EASE_IN);
			//ComicTween = new Tween((spritesVec[currentSprite] as Sprite).getChildAt(1), 0.5,Transitions.EASE_IN);
			ComicTween.moveTo(380, 0);
			ComicTween.onComplete = showText;
			Starling.juggler.add(ComicTween);
			ComicTween = null;
			
			(spritesVec[currentSprite] as Sprite).getChildAt(2).visible = false;
			//(spritesVec[currentSprite] as Sprite).getChildAt(3).visible = false;
		}
		
		private function showText():void {
			if (nextText) {
				(spritesVec[currentSprite] as Sprite).getChildAt(2).visible = true;
				//(spritesVec[currentSprite] as Sprite).getChildAt(3).visible = true;
			}else{
				(spritesVec[currentSprite] as Sprite).getChildAt(1).visible = true;
				//(spritesVec[currentSprite] as Sprite).getChildAt(2).visible = true;
			}
		}
		
		private function fadeIn():void {
			
			(spritesVec[currentSprite] as Sprite).alpha = 0;
			addChild(spritesVec[currentSprite] as Sprite);
			
			fadeInTween = new Tween( spritesVec[currentSprite], 0.7, Transitions.EASE_IN);
			fadeInTween.fadeTo(1);
			Starling.juggler.add(fadeInTween);
			fadeInTween = null;
			
			rightBtn.touchable = true;
			leftBtn.touchable = true;
		}
		
		private function ChangePage(_type:String):void {
			
			nextTransition = _type;
			leftBtn.touchable = false;
			rightBtn.touchable = false;
			
			fadeOutTween = new Tween( spritesVec[currentSprite], 0.7, Transitions.EASE_OUT);
			fadeOutTween.fadeTo(0);
			fadeOutTween.onComplete = removeSprite;
			Starling.juggler.add(fadeOutTween);
			fadeOutTween = null;
		}
		
		private function removeSprite():void {
			
			removeChild(spritesVec[currentSprite] as Sprite);
			
			if (nextTransition == "Next") currentSprite++;
			if (nextTransition == "Previous") currentSprite--;

			fadeIn();
		}
		
		private function onExitComic():void {
			switch (comicData.nextSceneData.type) 
			{
				case "gamePlayTutorial":
					this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:comicData.nextSceneData.type,  data: { missionId: comicData.nextSceneData.missionId, src:comicData.nextSceneData.src }}, true));
				break;
				case "missionScreen":
					this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"missionScreen", megatile_id: 0}));
				break;
			}
		}
		
		override public function dispose():void 
		{
			
			super.dispose();
		}
	}

}