package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.system.System;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MissionHUD extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		
		public var cargoClicked:Boolean = false;
		public var corrotion_text:TextField;
		public var objects_text:TextField;
		public var cargo_text:TextField;
		public var timer_text:TextField;
		public var missionInventory:MissionInventory;
		private var tempData:Array = new Array();
		public var picked_total:int = 0;
		public var cargoTotal:int = 0;
		public var objectTotal:int = 0;
		public var cryoMeter:MeterBar;
		public var fuelMeter:MeterBar;
		
		public var pickupImage:Image;
		public var cryogelImage:Image;
		public var fuelImage:Image;
		public var boxXray:Image;
		public var boxBomb:Image;
		
		public var dialogoFadeOut:Dialogs;
		
		public var dialogSprite: Sprite = new Sprite();
		
		public var invisibleQuad:Quad;
		public var blackQuad:Quad;
		
		public var hurtImage:Image;
		
		public var timerSecs:int;
		public var timerMin:int;
		public var timerHour:int;
		
		public function MissionHUD(_globalResources:GlobalResources, _texturesScene:AssetManager) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			
			//hurtImage = new Image(texturesScene.getAtlas("screens").getTexture("hit"));
			//hurtImage.alpha = 0;
			//hurtImage.touchable = false;
			//tempData.push(hurtImage);
			//addChild(hurtImage);
			
			pickupImage = new Image(texturesScene.getAtlas("worldObjects").getTexture("Box"));
			pickupImage.scaleX = 0.75;
			pickupImage.scaleY = 0.75;
			pickupImage.pivotX = pickupImage.width / 2;
			pickupImage.pivotY = pickupImage.height / 2;
			pickupImage.visible = false;
			tempData.push(pickupImage);
			addChild(pickupImage);
			
			cryogelImage = new Image(texturesScene.getAtlas("worldObjects").getTexture("Cgel"));
			cryogelImage.visible = false;
			tempData.push(cryogelImage);
			addChild(cryogelImage);
			
			fuelImage = new Image(texturesScene.getAtlas("worldObjects").getTexture("Fuel"));
			fuelImage.visible = false;
			tempData.push(fuelImage);
			addChild(fuelImage);
			
			boxBomb = new Image (texturesScene.getAtlas("worldObjects").getTexture("Box_Explosive"));
			boxBomb.pivotX=Math.ceil(boxBomb.width/2);
			boxBomb.pivotY=Math.ceil(boxBomb.height/2)-10;
			boxBomb.scaleX = 0.75;
			boxBomb.scaleY = 0.75;
			boxBomb.visible = false;
			addChild(boxBomb);
			
			var HudMeterBack:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("barBg"));
			HudMeterBack.x = 15;
			HudMeterBack.y = 215;
			tempData.push(HudMeterBack);
			addChild(HudMeterBack);
			HudMeterBack = null;
			
			fuelMeter = new MeterBar(0);
			fuelMeter.x=24;
			fuelMeter.y = 228;
			tempData.push(fuelMeter);
			addChild(fuelMeter);
			
			var HudFuelFront:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("barFuel"));
			HudFuelFront.x = 15;
			HudFuelFront.y = 215;
			tempData.push(HudFuelFront);
			addChild(HudFuelFront);
			HudFuelFront = null;
			
			HudMeterBack = new Image(texturesScene.getAtlas("worldObjects").getTexture("barBg"));
			HudMeterBack.x = 15;
			HudMeterBack.y = 30;
			tempData.push(HudMeterBack);
			addChild(HudMeterBack);
			HudMeterBack = null;
			
			cryoMeter = new MeterBar(1);
			cryoMeter.x=24;
			cryoMeter.y = 40;
			tempData.push(cryoMeter);
			addChild(cryoMeter);
			
			var HudCryoFront:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("barCgel"));
			HudCryoFront.x = 15;
			HudCryoFront.y = 30;
			tempData.push(HudCryoFront);
			addChild(HudCryoFront);
			HudCryoFront = null;
			
			var trophiesCount:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("hudTrophies"));
			trophiesCount.x = 506;
			trophiesCount.y = 8;
			tempData.push(trophiesCount);
			addChild(trophiesCount);
			trophiesCount = null;
			
			var CrystalCount:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("hudCrystals"));
			CrystalCount.x = 555;
			CrystalCount.y = 8;
			tempData.push(CrystalCount);
			addChild(CrystalCount);
			CrystalCount = null;
			
			var cargo:Button = new Button(texturesScene.getAtlas("worldObjects").getTexture("hudCargo_00"),"",texturesScene.getAtlas("worldObjects").getTexture("hudCargo_01"));
			cargo.x=684;
			cargo.y = 336;
			tempData.push(cargo);
			addChild(cargo);
			cargo.addEventListener(Event.TRIGGERED, onButtonClicked);
			
			var miniMapFrame:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("minimapBgFrame"));
			miniMapFrame.x = 620;
			miniMapFrame.y = 10;
			tempData.push(miniMapFrame);
			addChild(miniMapFrame);
			miniMapFrame = null;
			
			var HudTimer:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("timerHud"));
			HudTimer.x = 260;
			HudTimer.y = 8;
			HudTimer.scaleX = 1.3;
			tempData.push(HudTimer);
			addChild(HudTimer);
			HudTimer = null;
			
			corrotion_text = new TextField(50, 100, "%" , globalResources.fontName, 14, 0xFFFFFF);
			corrotion_text.vAlign = "top";
			corrotion_text.hAlign = "center";
			corrotion_text.x = 560;
			corrotion_text.y = 38;
			tempData.push(corrotion_text);
			addChild(corrotion_text);
			
			cargo_text = new TextField(50, 50, cargoTotal+ "/4" , globalResources.fontName, 14, 0xFFFFFF);
			cargo_text.vAlign = "top";
			cargo_text.hAlign = "center";
			cargo_text.x = 690;
			cargo_text.y = 342;
			cargo_text.touchable = false;
			tempData.push(cargo_text);
			addChild(cargo_text);
			
			missionInventory = new MissionInventory(globalResources, texturesScene);
			missionInventory.x = 360;
			missionInventory.y = (missionInventory.height-globalResources.stageHeigth);
			tempData.push(missionInventory);
			addChild(missionInventory);
			
			timer_text = new TextField(150, 30, "00:00:00", "LVDCD", 16, 0xFFFFFF);
			timer_text.x = 275;
			timer_text.y = 8;
			//timer_text.border = true;
			timer_text.hAlign = "left";
			timer_text.vAlign = "top";
			timer_text.scaleY = 1.5;
			addChild(timer_text);
			
			invisibleQuad = new Quad(globalResources.stageWidth, globalResources.stageHeigth, 0x000000);
			invisibleQuad.alpha = 0;
			invisibleQuad.visible = false;
			tempData.push(invisibleQuad);
			addChild(invisibleQuad);
			
			blackQuad = new Quad(globalResources.stageWidth, globalResources.stageHeigth, 0x000000);
			blackQuad.alpha = 0.75;
			blackQuad.visible = false;
			tempData.push(blackQuad);
			addChild(blackQuad);
			
			tempData.push(dialogSprite)
			addChild(dialogSprite);
			
		}
		
		public function addObject(_objeto:Objetos):Boolean{
			
			var chopFull:Boolean = false;
			chopFull = missionInventory.add_objeto(_objeto);
			if (!chopFull) {
				objects_text.text = ++picked_total + "/" + objectTotal;
			}
			return (chopFull);
		}
		
		public function activateObjectCount(_cont:int):void{	
			objectTotal = _cont;
			objects_text = new TextField(50, 100, picked_total + "/" + objectTotal , globalResources.fontName, 14, 0xFFFFFF);
			objects_text.vAlign = "top";
			objects_text.hAlign = "center";
			objects_text.x = 508;
			objects_text.y = 38;
			this.addChild(objects_text);
		}
		
		public function updateScore(num:int = 0, den:int = 0):void {
			picked_total -= num;
			objectTotal -= den;
			objects_text.text = picked_total + "/" + objectTotal;
		}
		
		public function updateCargo(num:int = 0, type:String = ""):void {
			if (type == "sum") cargoTotal += num;
			if (type == "res") cargoTotal -= num;
			cargo_text.text = cargoTotal + "/4";
		}
		
		public function onButtonClicked():void
		{
			var tween:Tween;
			if (!cargoClicked) {
				globalResources.trackEvent("Shoot-Pickup", "user: " + globalResources.user_id, "btn_cargo");
				this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gamePause", pauseId:2},true));
				missionInventory.onVisible();
				cargoClicked = true;
				tween = new Tween(missionInventory, 0.20, Transitions.EASE_IN);
				tween.moveTo(350, 380);
				Starling.juggler.add(tween);
			}else {
				globalResources.trackEvent("Shoot-Pickup", "user: " + globalResources.user_id, "btn_closeCargo");
				tween = new Tween(missionInventory, 0.20, Transitions.EASE_OUT);
				tween.moveTo(350, 480);
				Starling.juggler.add(tween);
				
				this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gameResume", resumeId:2},true));
				missionInventory.onInvisible();
				cargoClicked = false;
			}
		}

		public function update_meters(fuel:Number, cryogel:Number):void{
			fuelMeter.update_meter(fuel);
			cryoMeter.update_meter(cryogel);
		}
		
		public function disposeAnimation(objeto:Objetos, worldX:int, worldY:int):void {
			var tween:Tween
			
			switch (objeto.type) 
			{
				case 1:
					pickupImage.alpha = 1;
					pickupImage.x = objeto.x + worldX;
					pickupImage.y = objeto.y + worldY;
					pickupImage.visible = true;
					
					tween = new Tween(pickupImage, 1, Transitions.EASE_OUT);
					tween.moveTo(508,10);
					tween.fadeTo(0);
					Starling.juggler.add(tween);
					break;
				
				case 3:
					cryogelImage.alpha = 1;
					cryogelImage.x = objeto.x + worldX;
					cryogelImage.y = objeto.y + worldY;
					cryogelImage.visible = true;
					
					tween = new Tween(cryogelImage, 1, Transitions.EASE_OUT);
					tween.moveTo(15,180);
					tween.fadeTo(0);
					Starling.juggler.add(tween);
					break;
				case 4:
					fuelImage.alpha = 1;
					fuelImage.x = objeto.x + worldX;
					fuelImage.y = objeto.y + worldY;
					fuelImage.visible = true;
					
					tween = new Tween(fuelImage, 1, Transitions.EASE_OUT);
					tween.moveTo(15,340);
					tween.fadeTo(0);
					Starling.juggler.add(tween);
					break;
			}
		}
		
		public function updateHurtImage(num:Number):void {
			
			num = 1 - num;
			hurtImage.alpha = num;
			
		}
		
		public function updateTimer(_seconds:int):void
		{
			timerSecs = _seconds;
			if (timerSecs == 60) 
			{
				timerMin++;
				timerSecs = 00;
			}
			
			if (timerMin == 60) 
			{
				timerHour++;
				timerMin = 00;
			}
			
			if (timerMin>9) 
			{
				timer_text.text = "0" + timerHour + ":" + timerMin + ":" + timerSecs;
				return;
			}
			
			if (timerSecs>9) 
			{
				timer_text.text = "0" + timerHour + ":0" + timerMin + ":" + timerSecs;
				return;
			}
			
			timer_text.text = "0" + timerHour + ":0" + timerMin + ":0" + timerSecs;
			
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			this.removeChildren();
			
			globalResources = null;
			texturesScene = null;
			
			if(tempData !=null){
				for (var i:uint = 0; i < tempData.length;++i) {
					tempData[i].removeEventListeners();
					tempData[i].dispose();
					tempData[i] = null;
				}
				tempData.splice(0, tempData.length);
				tempData = null;
			}
			
			if (dialogSprite != null) {
				dialogSprite.removeChildren();
				dialogSprite = null;
			}
			
			super.dispose();
			
		}
		
	}

}