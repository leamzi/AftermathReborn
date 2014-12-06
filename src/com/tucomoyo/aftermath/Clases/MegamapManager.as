package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import com.tucomoyo.aftermath.Screens.MegaMap;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MegamapManager extends Sprite 
	{
		private var textureScenes:AssetManager;
		private var globalResources:GlobalResources;
		private var soundsScene:SoundManager;
		private var megamapsInfo:Vector.<Object>;
		
		private var megamapCurrentImg:Image;
		private var predictviaImg:Image;
		private var mapTargetImg:Image;
		
		private var currentScale:Number;
		
		private var infoDescription:TextField;
		private var infoDescription2:TextField;
		private var mapTitle:TextField;
		private var mapDescription:TextField;
		
		private var closeWindowBtn:Button;
		private var goBackBtn:Button;
		private var goToMapBtn:Button;
		
		private var megamapInfoSprite:Sprite = new Sprite();
		private var targetsSprite:Sprite = new Sprite();
		
		private var tween:Tween;
		
		[Embed(source="../../../../../media/graphics/Backgrounds/GlobalMap.png")]
		public static const globalMap:Class;
		
		public function MegamapManager(_globalResources:GlobalResources, _textureScene:AssetManager, _soundScene:SoundManager, _megamapInfo:Vector.<Object>) 
		{
			super();
			
			globalResources = _globalResources;
			textureScenes = _textureScene;
			soundsScene = _soundScene;
			megamapsInfo = _megamapInfo;
			
			currentScale = 1.0 / 0.37;
			drawMegamapSelection();
		}
		
		private function drawMegamapSelection():void
		{
			megamapCurrentImg = new Image(Texture.fromBitmap(new globalMap()));
			megamapCurrentImg.scaleX = 1.0 / currentScale;
			megamapCurrentImg.scaleY = 1.0 / currentScale;
			megamapCurrentImg.alignPivot();
			megamapCurrentImg.x = 380;
			megamapCurrentImg.y = 190;
			addChild(megamapCurrentImg);
			
			var dialogMask:Image = new Image(textureScenes.getAtlas("Gui").getTexture("guiMap"));
			addChild(dialogMask);
			
			predictviaImg = new Image(textureScenes.getAtlas("Botones").getTexture("comlink"));
			predictviaImg.scaleX = 1.2;
			predictviaImg.scaleY = 1.2;
			predictviaImg.x = 10;
			predictviaImg.y = 270;
			addChild(predictviaImg);
			
			infoDescription2 = new TextField(620, 44, "SELECT YOUR MAP", globalResources.fontName, 24, 0xFFFFFF);
			infoDescription2.autoScale = true;
			infoDescription2.x = 120;
			infoDescription2.y = 296;
			infoDescription2.hAlign = "left";
			infoDescription2.vAlign = "top";
			addChild(infoDescription2);
			
			infoDescription = new TextField(420, 50, "In This Screen you can choose to travel between worlds", globalResources.fontName, 24, 0xFFFFFF);
			infoDescription.autoScale = true;
			infoDescription.x = 120;
			infoDescription.y = 340;
			infoDescription.hAlign = "left";
			infoDescription.vAlign = "top";
			addChild(infoDescription);
			
			closeWindowBtn = new Button(textureScenes.getAtlas("Botones").getTexture("btnDecline"));
			closeWindowBtn.x = 610;
			closeWindowBtn.y = 335;
			closeWindowBtn.addEventListener(Event.TRIGGERED, closeWindow);
			addChild(closeWindowBtn);
			
			for (var i:int = 0; i < megamapsInfo.length; i++) 
			{
				if (megamapsInfo[i].available == true) 
				{
					mapTargetImg = new Image(textureScenes.getAtlas("Botones").getTexture("target_01"));
					mapTargetImg.x = megamapsInfo[i].posX;
					mapTargetImg.y = megamapsInfo[i].posY;
					mapTargetImg.useHandCursor = true;
					mapTargetImg.name = megamapsInfo[i].name;
					mapTargetImg.addEventListener(TouchEvent.TOUCH, onTargetClick);
					targetsSprite.addChild(mapTargetImg);
					mapTargetImg = null;
					
					mapTitle = new TextField(620, 38, "", globalResources.fontName, 22, 0xFFFFFF);
					mapTitle.autoScale = true;
					mapTitle.text = megamapsInfo[i].name + " World";
					mapTitle.name = megamapsInfo[i].name;
					mapTitle.x = 120;
					mapTitle.y = 296;
					mapTitle.hAlign = "left";
					mapTitle.vAlign = "top";
					mapTitle.visible = false;
					megamapInfoSprite.addChild(mapTitle);
					mapTitle = null;
					
					mapDescription = new TextField(420, 50, "", globalResources.fontName, 24, 0xFFFFFF);
					mapDescription.name = megamapsInfo[i].name;
					mapDescription.text = megamapsInfo[i].description;
					mapDescription.autoScale = true;
					mapDescription.x = 120;
					mapDescription.y = 340;
					mapDescription.hAlign = "left";
					mapDescription.vAlign = "top";
					mapDescription.visible = false;
					megamapInfoSprite.addChild(mapDescription);
					mapDescription = null;
					
					goBackBtn = new Button(textureScenes.getAtlas("Botones").getTexture("btnBack"));
					goBackBtn.name = megamapsInfo[i].name;
					goBackBtn.x = 560;
					goBackBtn.y = 335;
					goBackBtn.visible = false;
					goBackBtn.addEventListener(Event.TRIGGERED, onBackClick);
					megamapInfoSprite.addChild(goBackBtn);
					goBackBtn = null;
					
					goToMapBtn = new Button(textureScenes.getAtlas("Botones").getTexture("btnAccept"));
					goToMapBtn.name = megamapsInfo[i].name;
					goToMapBtn.x = 660;
					goToMapBtn.y = 335;
					goToMapBtn.visible = false;
					goToMapBtn.addEventListener(Event.TRIGGERED, goToMegamap);
					megamapInfoSprite.addChild(goToMapBtn);
					goToMapBtn = null;
				}
				
			}
			
			addChild(targetsSprite);
			addChild(megamapInfoSprite);
		}
		
		public function onTargetClick(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch == null) {
				return;
			}
			if (touch.phase == TouchPhase.BEGAN) {
				soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
				targetsSprite.visible = false;
				infoDescription.visible = false;
				infoDescription2.visible = false;
				closeWindowBtn.visible = false;
				
				if (tween != null) {
					Starling.juggler.remove(tween);
					tween = null;
				}
				
				tween = new Tween(megamapCurrentImg, 0.5, Transitions.EASE_IN);
				tween.scaleTo(1);
				//tween.moveTo( ((380 - (targetsSprite.getChildByName((e.currentTarget as DisplayObject).name).x )) * currentScale) + megamapCurrentImg.x , (190 - (targetsSprite.getChildByName((e.currentTarget as DisplayObject).name).y) * currentScale) + megamapCurrentImg.y);
				Starling.juggler.add(tween);
				
				trace((380 - (targetsSprite.getChildByName((e.currentTarget as DisplayObject).name).x )) * currentScale, 190 - (targetsSprite.getChildByName((e.currentTarget as DisplayObject).name).y) * currentScale);
				
				for (var i:int = 0; i < megamapInfoSprite.numChildren ; i++) 
				{
					if (megamapInfoSprite.getChildAt(i).name == (e.currentTarget as DisplayObject).name) 
					{
						megamapInfoSprite.getChildAt(i).visible = true;
					}
				}
			}
			
		}
		
		public function onBackClick(e:Event):void 
		{
			targetsSprite.visible = true;
			infoDescription.visible = true;
			infoDescription2.visible = true;
			closeWindowBtn.visible = true;
			
			soundsScene.getSound("Gui_Button_denied").play(globalResources.volume);
			
			if (tween != null) {
				Starling.juggler.remove(tween);
				tween = null;
			}
			
			trace("Pos: "+megamapCurrentImg.x, megamapCurrentImg.y);
			tween = new Tween(megamapCurrentImg, 0.5, Transitions.EASE_IN);
			tween.scaleTo(0.37);
			//tween.moveTo(380, 190);
			Starling.juggler.add(tween);
			
			for (var i:int = 0; i < megamapInfoSprite.numChildren ; i++) 
			{
				if (megamapInfoSprite.getChildAt(i).name == (e.currentTarget as DisplayObject).name) 
				{
					megamapInfoSprite.getChildAt(i).visible = false;
				}
			}
		}
		
		public function goToMegamap(e:Event):void 
		{
			soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
			//(this.parent as MegaMap).updateLastMegamap(2);
		}
		
		public function closeWindow(e:Event):void 
		{
			soundsScene.getSound("Gui_Button_denied").play(globalResources.volume);
			this.visible = false;
		}
		
	}

}