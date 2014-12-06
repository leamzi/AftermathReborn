package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.scrollBar;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import com.tucomoyo.aftermath.Screens.MegaMap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Dialogs extends Sprite 
	{
		public static const ButtonsAssets:String = "Botones";
		public static const TutorialAssets:String = "Game_objectives";
		
		private var globalResources:GlobalResources;
		private var soundsScene:SoundManager;
		private var texturesScene:AssetManager;
		
		private var tempData:Array = new Array();
		public var objectDialog:Vector.<Sprite> = new Vector.<Sprite>;
		public var tutorialDialogs:Vector.<Sprite> = new Vector.<Sprite>;
		public var windowsVec:Vector.<Sprite> = new Vector.<Sprite>;
		private var mission:Object;
		private var targetObject:Objetos;
		private var comicInfo:Vector.<Object>;
		public var direction:int;
		public var currentPauseId:int;
		public var isInTutorial:Boolean = false;
		public var volumeBar:scrollBar;
		
		private var completeVector:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		private var missionCompleteInd:int = 0;
		private var missionCompleteTween:Tween;
		private var myTrophiesMeter:objectsCounterMeter;
		private var myJunksMeter:objectsCounterMeter;
		private var trophiesCount:int;
		private var junkCount:int;
		private var retryOrSaveCount:int;
		
		private var currentScore:int;
		public var scoreCounter:int = 0;
		private var scoreText:TextField;
		
		private var labScreen:Image;
		
		public var megatile_id:int;
		
		public function Dialogs(_globalResources:GlobalResources, _texturesScene:AssetManager, _soundsScene:SoundManager, _x:int = 0, _y:int = 0) 
		{
			super();
			this.x = _x;
			this.y = _y;
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			soundsScene = _soundsScene;
		}
		
		public function linesDialog(_text:String, _factor:Number):void {
			
			var factor:Number= 1/_factor;

			var a_text:TextField = new TextField(200, 50, "", globalResources.fontName, 12, 0xffffff);
			a_text.text = _text;
			a_text.width = (_text.length * 12 * factor);
			a_text.height = (25 * _factor);
			a_text.border = true;
			a_text.hAlign = "center";
			
			var quad:Quad=new Quad(a_text.width,a_text.height,0x000000);
			quad.alpha = 0.75;
			
			tempData.push(quad);
			addChild(quad);
			tempData.push(a_text);
			addChild(a_text);
		}
		
		public function createComicList(_comicInfo:Vector.<Object>):void {
			
			var subFrame:Image;
			var comicImg:ImageLoader;
			var text:TextField;
			var playComicBtn:Button;
			
			var marcoFondo:Image = new Image (texturesScene.getAtlas("Gui").getTexture("guiFrame01"));
			addChild(marcoFondo);
			
			var titulo:TextField = new TextField(486, 30, "Comic List", globalResources.fontName, 22, 0xFFFFFF);
			titulo.x = 10;
			titulo.y = 10;
			addChild(titulo);
			
			comicInfo = _comicInfo;
			
			for (var i:int = 0; i < _comicInfo.length; i++) 
			{
				subFrame = new Image (texturesScene.getAtlas("Gui").getTexture("guiSubframe02"));
				subFrame.x = 20;
				//subFrame.y = 56;
				subFrame.y = 56 + (i * 85);
				addChild(subFrame);
				subFrame = null;
				
				comicImg = new ImageLoader(_comicInfo[i].imageUrl, globalResources.loaderContext, 80, 80);
				comicImg.x = 20;
				comicImg.y =  56 + (i * 85);
				//comicImg.y = 56;
				addChild(comicImg);
				comicImg = null;
				
				text = new TextField(280, 64, _comicInfo[i].name, globalResources.fontName, 22, 0xFFFFFF);
				text.x = 100;
				//text.y = 56
				text.y = 56 + (i * 85);
				addChild(text);
				text = null;
				
				playComicBtn = new Button(texturesScene.getAtlas("Botones").getTexture("guiPlayBtn"));
				playComicBtn.scaleX = 0.44;
				playComicBtn.scaleY = 0.44;
				playComicBtn.x = 382;
				playComicBtn.y =  56 + (i * 85);
				//playComicBtn.y = 56;
				playComicBtn.addEventListener(Event.TRIGGERED, onComicScene);
				addChild(playComicBtn);
				playComicBtn = null;
			}
		}
		
		private function onComicScene(e:Event):void
		{
			soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
			var indice : int = ((e.currentTarget as DisplayObject).y -56) / 85;
			trace("Comic: " + indice);
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:"newComic",  data: { numScenes: comicInfo[indice].numImages, name:comicInfo[indice].name, nextSceneData: {type: "missionScreen", megatile_id: megatile_id}}}, true));
		}
		
		public function createMissionTargetDialog(_mission:Object):void {
			
			mission = _mission;
			
			var extras:Object = (mission.extras != "")?JSON.parse(mission.extras):{picked:"?",total:"?",crystal:100};
			
			var marcoFondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrame01"));
			addChild(marcoFondo);
			
			var marcoSketchs:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiSubframe01"));
			marcoSketchs.y = 111;
			addChild(marcoSketchs);
			
			var missioName:TextField = new TextField(558,30,"",globalResources.fontName,24,0xffffff);
			missioName.y = 15;
			missioName.hAlign = "center";
			missioName.text = mission.name;
			tempData.push(missioName);
			addChild(missioName);
			
			var comlink:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
			comlink.x = 25;
			comlink.y = 50;
			tempData.push(comlink);
			addChild(comlink);
			comlink = null;
			
			var missioDescription:TextField = new TextField(100,100,mission.missionDescription,globalResources.fontName,10,0xffffff);
			missioDescription.hAlign = "left";
			missioDescription.vAlign = "top";
			missioDescription.x = 23;
			missioDescription.y = 140;
			missioDescription.kerning = false;
			tempData.push(missioDescription);
			addChild(missioDescription);
			
			var missionImage:ImageLoader = new ImageLoader(mission.missionImage, globalResources.loaderContext,240,180);
			missionImage.x = 148;
			missionImage.y = 60;
			tempData.push(missionImage);
			addChild(missionImage);
			
			var playMissionBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("guiPlayBtn"));
			playMissionBtn.x = 300;
			playMissionBtn.y = 60;
			playMissionBtn.scaleWhenDown = 0.95;
			playMissionBtn.addEventListener(Event.TRIGGERED, MissionBtnClick);
			tempData.push(playMissionBtn);
			addChild(playMissionBtn);
			
			var hudCristal:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("hudCrystals"));
			hudCristal.x = 80;
			hudCristal.y = 255;
			tempData.push(hudCristal);
			addChild(hudCristal);
			hudCristal = null;
			
			var hudTrophies:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("hudTrophies"));
			hudTrophies.x = 20;
			hudTrophies.y = 255;
			tempData.push(hudTrophies);
			addChild(hudTrophies);
			hudTrophies = null;
			
			var scoreStar:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("hub-new"));
			scoreStar.x = 350;
			scoreStar.y = 256;
			tempData.push(scoreStar);
			addChild(scoreStar);
			scoreStar = null;
			
			var missionTrophies:TextField = new TextField(30,15,extras.picked+"/"+extras.total,globalResources.fontName,14,0xffffff);
			missionTrophies.hAlign = "left";
			//missionTrophies.border = true;
			missionTrophies.vAlign = "top";
			missionTrophies.x = 32;
			missionTrophies.y = 286;
			tempData.push(missionTrophies);
			addChild(missionTrophies);
			
			var missionCrystals:TextField = new TextField(35,15,extras.crystal+"%",globalResources.fontName,14,0xffffff);
			missionCrystals.hAlign = "left";
			missionCrystals.vAlign = "top";
			//missionCrystals.border = true;
			missionCrystals.x = 92;
			missionCrystals.y = 286;
			tempData.push(missionCrystals);
			addChild(missionCrystals);
			
			var missionScore:TextField = new TextField(120,40,_mission.mission_score,globalResources.fontName,36,0xffffff);
			missionScore.hAlign = "right";
			missionScore.vAlign = "top";
			//missionScore.autoScale = true;
			//missionScore.border = true;
			missionScore.x = 410;
			missionScore.y = 265;
			tempData.push(missionScore);
			addChild(missionScore);
			
			var closeDialogBtn:Button = new Button (texturesScene.getAtlas(ButtonsAssets).getTexture("guiClose"));
			closeDialogBtn.addEventListener(Event.TRIGGERED, closeBtnClick);
			closeDialogBtn.x = 507;
			closeDialogBtn.y = 12;
			tempData.push(closeDialogBtn);
			addChild(closeDialogBtn);
			
		}
		
				private function MissionBtnClick():void
				{
					soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
					globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Mission Screen: btn_startmission-" + mission.mission_id);
					if (mission.missionID == "1") 
					{
						trace("mission tutorial");
						this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:"gamePlayTutorial", data: { missionId: mission.mission_id, src:mission.source }}, true));
						
					}else {
						trace("mission normal");
						this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:"gamePlayScreen", data: { missionId: mission.mission_id, src:mission.source, mission_user_id: mission.id,  megatile_id: mission.megatile_id, missionCompleted: mission.missionCompleted, vehicleData:mission.vehicleData}}, true));
					}
				}
				private function closeBtnClick():void
				{
					soundsScene.getSound("Gui_Button_denied").play(globalResources.volume);
					this.visible = false;
				}
				
				private function closeBtnClickNewMegatile():void
				{
					trace("cerrar");
					soundsScene.getSound("Gui_Button_denied").play(globalResources.volume);
					this.dispatchEvent(new GameEvents(GameEvents.TILE_UNLOCK, { type:"tile_unlock"}, true));
					this.visible = false;
				}
				
				public function missionSelectedPlay():void{
					soundsScene.getSound("mission_selected").play(globalResources.volume);
				}
				public function missionSelectedStop():void{
					soundsScene.getSound("mission_selected").stop();
					//(this.parent as mission_targets).dialogoStatus = false;
				}
	
		public function fadeOutAlerts(message:String, comlinkOn:Boolean = false ):void {
			var a_text:TextField;
			var fadeOutTimer:Timer = new Timer (4000, 1);
			var fondo:Image = new Image (texturesScene.getAtlas("Gui").getTexture("guiFrameOption"));
			fondo.scaleY = 0.45;
			fondo.scaleX = 0.8;
			tempData.push(fondo);
			
			
			fadeOutTimer.start();
			fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeOutTimerComplete);
			
			if (comlinkOn) {
				addChild(fondo);
				
				var comlink:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
				comlink.x = 10;
				comlink.y = 10;
				tempData.push(comlink);
				addChild(comlink);
				comlink = null;
			}else {
				fondo.scaleX = 0.8;
				addChild(fondo);
				
				var musicNote:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("music_note"));
				musicNote.scaleX = 1.5;
				musicNote.scaleY = 1.5;
				musicNote.x = 30;
				musicNote.y = 20;
				tempData.push(musicNote);
				addChild(musicNote);
				musicNote = null;
			}
			
			a_text = new TextField(200, 70, "", globalResources.fontName, 14, 0xFFFFFF);
			a_text.x = 100;
			a_text.y = 10;
			a_text.width = 250;
			a_text.height = 80;
			a_text.hAlign = "left";
			a_text.vAlign = "top";
			a_text.text = message;
			tempData.push(a_text);
			addChild(a_text);
		}
		
		public function successAlert():void {
			var fadeOutTimer:Timer = new Timer (2000, 1);
			
			fadeOutTimer.start();
			fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeOutTimerComplete);

			var succes:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("success"));
			succes.x = -150;
			succes.y= -150;
			tempData.push(succes);
			addChild(succes);
			succes = null;
			
			soundsScene.getSound("success").play(globalResources.volume);
			
		}
		
		public function alertDialog(_type:String, objectContextualMenu:Objetos = null, missionData:Object = null):void{
			
			var a_text:TextField;
			var fadeOutTimer:Timer = new Timer (4000, 1);
			var type:String;
			var pag:int = 0;
			var invisible_quad:Quad = new Quad (760,400,0x000000);
			
			type = _type;
			var fondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrameOption"));
			tempData.push(fondo);
			
			a_text = new TextField(500, 70, "", globalResources.fontName, 14, 0xFFFFFF);
			tempData.push(a_text);
			//fadeOutTimer.start();
			
			switch(type) {
				
				case "reminder":
					//fondo.height 150;
					//addChild(fondo);
					invisible_quad.visible = false;
					a_text.text = globalResources.fontName;
					a_text.width = 290;
					a_text.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.RescueObject;
					a_text.x = 5;
					a_text.y = -15;
					addChild(a_text);
					var miMundo:Image = new Image(texturesScene.getAtlas(ButtonsAssets).getTexture("myWorld"));
					//miMundo.x = 130;
					//miMundo.y = 60;
					miMundo.scaleX = 0.75;
					miMundo.scaleY = 0.75;
					tempData.push(miMundo);
					addChild(miMundo);
					miMundo = null;
					break;
				case "leaveMission":
					currentPauseId = missionData.pauseId;
					isInTutorial = missionData.tutorial;
					
					fondo.scaleX = 0.8;
					fondo.scaleY = 0.5;
					addChild(fondo);
					
					a_text.x = 80;
					a_text.width = 290;
					a_text.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.OpenHatch;
					addChild(a_text);
					
					var comlink:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					comlink.x = 10;
					comlink.y = 10;
					tempData.push(comlink);
					addChild(comlink);
					comlink = null;
					
					var acceptBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnAccept"));
					acceptBtn.x = 220;
					acceptBtn.y = 60;
					acceptBtn.addEventListener(Event.TRIGGERED, leaveMissionSave);
					tempData.push(acceptBtn);
					addChild(acceptBtn);
					acceptBtn = null;
					
					var cancelBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnBack"));
					cancelBtn.x = 120;
					cancelBtn.y = 60;
					cancelBtn.addEventListener(Event.TRIGGERED, disposeElement);
					tempData.push(cancelBtn);
					addChild(cancelBtn);
					cancelBtn = null;
					break;
				case "missionComplete":
					var count:int = 0;
					var imagePickups:ImageLoader;
					var imageDestroyed:ImageLoader;
					var overlayGreen:Image;
					var overlayRed:Image;
					var marco:Image;
					var line2:Image;
					
					var fondoComplete:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrame01"));
					tempData.push(fondoComplete);
					addChild(fondoComplete);
					fondoComplete = null;
					
					var completeFondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiMissionComplete"));
					completeFondo.x = 9;
					completeFondo.y = 30;
					tempData.push(completeFondo);
					addChild(completeFondo);
					completeFondo = null;
					
					a_text.x = 0;
					a_text.y = 5;
					a_text.fontSize = 32;
					a_text.hAlign = "center";
					a_text.vAlign = "top";
					a_text.width = 600;
					a_text.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag1;
					tempData.push(a_text);
					addChild(a_text);
					
					var crystalText:TextField = new TextField(250, 100, "100%", globalResources.fontName, 48, 0xFFFFFF);
					crystalText.x = 116;
					crystalText.y = 240;
					crystalText.hAlign = "left";
					crystalText.vAlign = "top";
					tempData.push(crystalText);
					addChild(crystalText);
					
					var bigCrystal:Image = new Image (texturesScene.getAtlas("worldObjects").getTexture("Crystals_01"));
					bigCrystal.x = 40;
					bigCrystal.y = 234;
					bigCrystal.scaleX = 0.5;
					bigCrystal.scaleY = 0.5;
					tempData.push(bigCrystal);
					addChild(bigCrystal);
					bigCrystal = null;
					
					var pickupText:TextField = new TextField(250, 70, "", globalResources.fontName, 16, 0xFFFFFF);
					pickupText.x = 30;
					pickupText.y = 57;
					pickupText.hAlign = "left";
					pickupText.vAlign = "top";
					pickupText.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag2;
					tempData.push(pickupText);
					addChild(pickupText);
					
					var pickupDestroyedText:TextField = new TextField(250, 70, ":", globalResources.fontName, 16, 0xFFFFFF);
					pickupDestroyedText.x = 30;
					pickupDestroyedText.y = 142;
					pickupDestroyedText.hAlign = "left";
					pickupDestroyedText.vAlign = "top";
					pickupDestroyedText.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag3;
					tempData.push(pickupDestroyedText);
					addChild(pickupDestroyedText);
					
					var endBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnAccept"));
					endBtn.x= 430;
					endBtn.y = 238;
					endBtn.addEventListener(Event.TRIGGERED, leaveMissionSave);
					tempData.push(endBtn);
					addChild(endBtn);
					endBtn = null;
					
					//trace("Pickups: "+missionData.pickupsId.length);
					//trace("Destroyed: " + missionData.destroyPickupsId.length);
					
					for (var i:int = 0; i < missionData.destroyPickupsId.length; i++) 
					{
						count += 1;
						
						imageDestroyed = ((missionData.dictionary[missionData.destroyPickupsId[i]]) as Objetos).objectImage;
						imageDestroyed.x = ((20 * (count % 10)) + ((count % 10) * 30)) - 13;
						imageDestroyed.y = ((20 * (Math.floor(count / 10))) + (Math.floor(count / 10) * 60)) + 170;
						imageDestroyed.scaleX = 0.6;
						imageDestroyed.scaleY = 0.6;
						tempData.push(imageDestroyed);
						
						marco = new Image (texturesScene.getAtlas("Botones").getTexture("objectBox"));
						marco.x = (imageDestroyed.x) - 7;
						marco.y = (imageDestroyed.y) - 8;
						tempData.push(marco);
						
						//overlayRed = new Image (texturesScene.getAtlas("Botones").getTexture("hate_overlay"));
						//overlayRed.x = (imageDestroyed.x)-10;
						//overlayRed.y = (imageDestroyed.y)-10;
						//tempData.push(overlayRed);
						
						addChild(marco);
						addChild(imageDestroyed);
						//addChild(overlayRed);
						
						marco = null;
						overlayRed = null;
						imageDestroyed = null;
						
					}
					
					count = 0;
					
					for (var j:int = 0; j < missionData.pickupsId.length; j++) 
					{
						count += 1;
						imagePickups = ((missionData.dictionary[missionData.pickupsId[j]]) as Objetos).objectImage;
						imagePickups.x = ((20 * (count % 10)) + ((count % 10) * 30)) - 13;
						imagePickups.y = ((20 * (Math.floor(count / 10))) + (Math.floor(count / 10) * 60)) + 85;
						imagePickups.scaleX = 0.6;
						imagePickups.scaleY = 0.6;
						tempData.push(imagePickups);
						
						marco = new Image (texturesScene.getAtlas("Botones").getTexture("objectBox"));
						marco.x = (imagePickups.x) - 7;
						marco.y = (imagePickups.y) - 8;
						tempData.push(marco);
						
						//overlayGreen = new Image (texturesScene.getAtlas("Botones").getTexture("love_overlay"));
						//overlayGreen.x = (imagePickups.x) - 10;
						//overlayGreen.y = (imagePickups.y) - 10;
						//tempData.push(overlayGreen);
						
						addChild(marco);
						addChild(imagePickups);
						//addChild(overlayGreen);
						
						marco = null;
						overlayGreen = null;
						imagePickups = null;
					}
					
					globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Gameplay:Mission Complete");
					break;
				case "missionFailed":
					mission = missionData;
					
					fondo.scaleX = 0.8;
					fondo.scaleY = 0.5;
					addChild(fondo);
					
					a_text.x = 25;
					a_text.y = 10;
					a_text.width = 290;
					a_text.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Explode;
					a_text.vAlign = "top";
					a_text.hAlign = "center";
					tempData.push(a_text);
					addChild(a_text);
					
					var retryBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnAccept"));
					retryBtn.x = 180;
					retryBtn.y = 50;
					retryBtn.addEventListener(Event.TRIGGERED, retryMission);
					tempData.push(retryBtn);
					addChild(retryBtn);
					retryBtn = null;
					
					var endBtn2:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnDecline"));
					endBtn2.x = 80;
					endBtn2.y = 50;
					endBtn2.addEventListener(Event.TRIGGERED, leaveMission);
					tempData.push(endBtn2);
					addChild(endBtn2);
					endBtn2 = null;
					
					break;
				case "vehicleFull":
					var fadeOut:Timer = new Timer (2000, 1);
					fadeOut.start();
					fadeOut.addEventListener(TimerEvent.TIMER_COMPLETE, fadeOutTimerComplete);
					
					var vehicleFull:MovieClip = new MovieClip(texturesScene.getAtlas("chooperFull").getTextures("00-chopper"),26);
					vehicleFull.visible = true;
					vehicleFull.x = -200;
					vehicleFull.y= -300;
					Starling.juggler.add(vehicleFull);
					//vehicleFull.stop();
					tempData.push(vehicleFull);
					addChild(vehicleFull);
					vehicleFull = null;
					globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Gameplay:Cargo Full");
					break;
				case "explotionAlert":
					targetObject = objectContextualMenu;
					
					fondo.scaleX = 0.8;
					fondo.scaleY = 0.5;
					addChild(fondo);
					
					a_text.fontSize = 12;
					a_text.x = 100;
					a_text.y = 15;
					a_text.width = 230;
					a_text.height = 80;
					a_text.text = "PELIGO! DISPOSITIVO EXPLOSIVO";
					a_text.hAlign = "left";
					a_text.vAlign = "top";
					tempData.push(a_text);
					addChild(a_text);
					
					var objectImage2:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					objectImage2.x = 10;
					objectImage2.y = 10;
					tempData.push(objectImage2);
					addChild(objectImage2);
					objectImage2 = null;
					
					var closeInfoBtn2:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("guiClose"));
					closeInfoBtn2.x = fondo.width - closeInfoBtn2.width;
					//closeInfoBtn2.y = -closeInfoBtn2.height;
					tempData.push(closeInfoBtn2);
					closeInfoBtn2.addEventListener(Event.TRIGGERED, onVisibleFalse);
					addChild(closeInfoBtn2);
					break;
					
				case "infoObject":
					targetObject = objectContextualMenu;
					
					fondo.scaleX = 0.9;
					fondo.scaleY = 0.6;
					addChild(fondo);
					
					a_text.fontSize = 14;
					a_text.x = 115;
					a_text.y = 35;
					a_text.width = 260;
					a_text.height = 100;
					
					if (targetObject.objectData.objectInfo.sources.length >0) {
						a_text.text = targetObject.objectData.objectInfo.sources[0].summary;
					}else{
						a_text.text = "No hay información disponible para este objeto"
					}
					a_text.hAlign = "left";
					a_text.vAlign = "top";
					tempData.push(a_text);
					addChild(a_text);
					
					var name_text:TextField = new TextField(260, 70, "", globalResources.fontName, 16, 0xFFFFFF);
					name_text.x = 40;
					name_text.y = 8;
					name_text.hAlign = "center"; 
					name_text.vAlign = "top";
					name_text.text = targetObject.objectData.objectInfo.name;
					tempData.push(name_text);
					addChild(name_text);
					name_text = null;
					
					var objectImage:ImageLoader = new ImageLoader(targetObject.objectData.objectInfo.media[0].src, globalResources.loaderContext, 84, 84);
					objectImage.x = 15;
					objectImage.y = 38;
					tempData.push(objectImage);
					addChild(objectImage);
					objectImage = null;
					
					var closeInfoBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("guiClose"));
					closeInfoBtn.x = (fondo.width - (closeInfoBtn.width + 2)) - 10;
					closeInfoBtn.y = 5;
					tempData.push(closeInfoBtn);
					closeInfoBtn.addEventListener(Event.TRIGGERED, onVisibleFalse);
					addChild(closeInfoBtn);
					break;
				case "objectMenu":
					var closeBtn2:ContextualMenu;
					var useBtn:ContextualMenu;
					var pickupBtn:ContextualMenu;
					var shootBtn:ContextualMenu;
					var infoBtn:ContextualMenu;
					
					fondo.visible = false;
					addEventListener(TouchEvent.TOUCH, onObjectZones);
						
					targetObject = objectContextualMenu;
					
					useBtn = new ContextualMenu(texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_use_00"), texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_use_01"));
					useBtn.x = useBtn.width * 0.5;
					useBtn.y = useBtn.height * 0.5;
					useBtn.pivotX = useBtn.width * 0.5;
					useBtn.pivotY = useBtn.height * 0.5;
					useBtn.visible = false;
					objectDialog.push(useBtn);
					tempData.push(useBtn);
					addChild(useBtn);
					
					pickupBtn = new ContextualMenu(texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_pickup_00"), texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_pickup_01"));
					pickupBtn.x = pickupBtn.width * 0.5;
					pickupBtn.y = pickupBtn.height * 0.5;
					pickupBtn.pivotX = pickupBtn.width * 0.5;
					pickupBtn.pivotY = pickupBtn.height * 0.5;
					objectDialog.push(pickupBtn);
					tempData.push(pickupBtn);
					addChild(pickupBtn);
					
					shootBtn = new ContextualMenu(texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_shoot_00"), texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_shoot_01"));
					shootBtn.x = shootBtn.width * 0.5;
					shootBtn.y = shootBtn.height * 0.5;
					shootBtn.pivotX = shootBtn.width * 0.5;
					shootBtn.pivotY = shootBtn.height * 0.5;
					shootBtn.visible = false;
					objectDialog.push(shootBtn);
					tempData.push(shootBtn);
					addChild(shootBtn);
					
					infoBtn = new ContextualMenu(texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_info_00"), texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_info_01"));
					infoBtn.x = infoBtn.width * 0.5;
					infoBtn.y = infoBtn.height * 0.5;
					infoBtn.pivotX = infoBtn.width * 0.5;
					infoBtn.pivotY = infoBtn.height * 0.5;
					objectDialog.push(infoBtn);
					tempData.push(infoBtn);
					addChild(infoBtn);
					
					closeBtn2 = new ContextualMenu(texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_info_01"), texturesScene.getAtlas(ButtonsAssets).getTexture("radial_menu_btn_info_01"));
					closeBtn2.x = closeBtn2.width * 0.5;
					closeBtn2.y = closeBtn2.height * 0.5;
					closeBtn2.pivotX = closeBtn2.width * 0.5;
					closeBtn2.pivotY = closeBtn2.height * 0.5;
					objectDialog.push(closeBtn2);
					tempData.push(closeBtn2);
					//addChild(closeBtn2);
					
					break;
				
			}
			//if (type != "tutorial") fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeOutTimerComplete);
			
		}
		
					private function disposeElement():void
					{
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Gameplay Screen: btnBackToMission");
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gameResume", resumeId:currentPauseId }, true));
						
						if (currentPauseId == 5) 
						{
							var tween:Tween = new Tween(this, 0.20, Transitions.EASE_OUT);
							tween.moveTo(180, globalResources.stageHeigth);
							Starling.juggler.add(tween);
						}else {
							soundsScene.getSound("Gui_Button_denied").play(globalResources.volume);
							this.visible = false;
						}
						
					}
					
					private function fadeOutTimerComplete(event:TimerEvent):void
					{
						var tween:Tween = new Tween(this, 2.0, Transitions.EASE_OUT);
						tween.fadeTo(0);
						Starling.juggler.add(tween);
						
					}
					
					private function leaveMissionSave():void {
						soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Mission Screen: btn_leaveMission");
						if (!isInTutorial) {
							this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type: "saveState", complete: false}, true));
						} else {
							this.dispatchEvent(new GameEvents(GameEvents.EXIT_TUTORIAL,{},true));
						}
					}
					
					private function saveAndComplete():void {
						soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type: "saveState", complete: true}, true));
					}
					
					private function leaveMission():void {
						soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
						//this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type: "saveState" }, true));
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Mission Screen: btn_leaveMission");
						this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type: "missionScreen", megatile_id:mission.megatile_id }, true));
					}
					private function retryMission():void {
						soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Mission Screen: btn_restartMission");
						this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type:"gamePlayScreen",data:mission},true));
						//this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen"}, true));
					}
					
					private function retryAndCleanMission():void {
						soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"cleanAndRetry"},true));
					}
					
					public function onVisibleFalse():void {
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gameResume", resumeId:3},true));
						this.visible = false;
					}
		
		//Object context menu
		public function onObjectZones(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			var pickUpRec:Rectangle = new Rectangle (52, 0, 52, 52);
			var shootRec:Rectangle = new Rectangle (103, 52, 52, 52);
			var infoRec:Rectangle = new Rectangle (51, 124, 52, 52);
			var useRec:Rectangle = new Rectangle (0, 52, 52, 52);
			var closeRec:Rectangle = new Rectangle (52,52,52,52);
			var tween:Tween;
			
			if (touch == null){
				return;
			}
			if (touch.phase == TouchPhase.HOVER){
				var pos:Point = this.globalToLocal(new Point(touch.globalX, touch.globalY));
				
				if(objectDialog.length <1)return;
				(objectDialog[0] as ContextualMenu).DownState.visible = false;
				(objectDialog[1] as ContextualMenu).DownState.visible = false;
				(objectDialog[2] as ContextualMenu).DownState.visible = false;
				(objectDialog[3] as ContextualMenu).DownState.visible = false;
				(objectDialog[4] as ContextualMenu).DownState.visible = false;
				if (useRec.containsPoint(pos)){
					(objectDialog[0] as ContextualMenu).DownState.visible = true;
					direction = 1;
				}
				if (pickUpRec.containsPoint(pos)) {
					(objectDialog[1] as ContextualMenu).DownState.visible = true;
					direction = 2;
				}
				if (shootRec.containsPoint(pos)){
					(objectDialog[2] as ContextualMenu).DownState.visible = true;
					direction=3;
				}
				if (infoRec.containsPoint(pos)) {
					(objectDialog[3] as ContextualMenu).DownState.visible = true;
					direction=4;
				}
				if (closeRec.containsPoint(pos)){
					(objectDialog[4] as ContextualMenu).DownState.visible = true;
					direction=5;
				}
			}
			if (touch.phase == TouchPhase.BEGAN) {
				switch (direction) {
					case 1:
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gameResume", resumeId:3},true));
						this.visible = false;
						break;
					case 3:
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gameResume", resumeId:3},true));
						this.visible = false;
						break;
				    case 4:
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Gameplay:Object Info");
						this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"objectInfo", objetox:targetObject }, true));
						this.visible = false;
						break;
					case 2:
						this.dispatchEvent(new GameEvents(GameEvents.PICK_OBJECT,{type: "pickObject", obj:targetObject}, true));
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gameResume", resumeId:3},true));
						globalResources.trackEvent("Button-Triggered", "user :" + globalResources.user_id, "Gameplay:Object Pickup");
						this.visible = false;
						break;
					case 5:
						this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE,{type:"gameResume", resumeId:3},true));
						tween=new Tween(this,0.15);
						tween.scaleTo(0);
						starling.core.Starling.juggler.add(tween);
						break;
				}
				
			}
		}//End of Object context menu
		
		public function tutoDialogs(_type:String, missionData:Object = null, thirdPage:Boolean = false):void 
		{
			var closeBtn:Button = new Button (texturesScene.getAtlas(ButtonsAssets).getTexture("guiClose"));
			var nextBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("guiArrow"));
			var title:TextField = new TextField(526, 60, "", globalResources.fontName, 24, 0xFFFFFF);
			var a_text:TextField = new TextField(400, 54, "", globalResources.fontName, 14, 0xFFFFFF);
			var pag1:Sprite = new Sprite();
			var pag2:Sprite = new Sprite();
			var pag3:Sprite = new Sprite();
			var comlink:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
			var dialogImage:Image;
			
			var fondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrame01"));
			tempData.push(fondo);
			addChild(fondo);
			
			var fondoSkin:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiSubframeTuto"));
			fondoSkin.x = 5;
			fondoSkin.y = 45;
			tempData.push(fondoSkin);
			addChild(fondoSkin);
			
			currentPauseId = missionData.pauseId;
			
			switch (_type) 
			{
				default:
					comlink.x = 15;
					comlink.y = 200;
					tempData.push(comlink);
					pag1.addChild(comlink);
					comlink = null;
					
					title.text = globalResources.textos[globalResources.idioma].Screens.Tutorial[_type].title;
					title.hAlign = "center";
					title.vAlign = "center";
					pag1.addChild(title);
					title = null;
					
					a_text.text = globalResources.textos[globalResources.idioma].Screens.Tutorial[_type].pag1;
					a_text.x = 126;
					a_text.y = 246;
					a_text.hAlign = "left";
					a_text.vAlign = "top";
					pag1.addChild(a_text);
					a_text = null;
					
					dialogImage = new Image(texturesScene.getAtlas("tutorial").getTexture(_type+"_01"));
					dialogImage.x = 181;
					dialogImage.y = 55;
					tempData.push(dialogImage);
					pag1.addChild(dialogImage);
					dialogImage = null;
					
					nextBtn.x = 510;
					nextBtn.y = 145;
					nextBtn.rotation = 3.14;
					nextBtn.alignPivot();
					nextBtn.addEventListener(Event.TRIGGERED, onNext);
					tempData.push(nextBtn);
					pag1.addChild(nextBtn);
					nextBtn = null;
					
					comlink = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					comlink.x = 15;
					comlink.y = 200;
					pag2.addChild(comlink);
					comlink = null;
					
					title = new TextField(526, 60, "", globalResources.fontName, 24, 0xFFFFFF);
					title.text = globalResources.textos[globalResources.idioma].Screens.Tutorial[_type].title;
					title.hAlign = "center";
					title.vAlign = "center";
					pag2.addChild(title);
					title = null;
					
					a_text = new TextField(400, 54, "", globalResources.fontName, 14, 0xFFFFFF);
					a_text.text = globalResources.textos[globalResources.idioma].Screens.Tutorial[_type].pag2;
					a_text.x = 126;
					a_text.y = 246;
					a_text.hAlign = "left";
					a_text.vAlign = "top";
					pag2.addChild(a_text);
					a_text = null;
					
					if (texturesScene.getAtlas("tutorial").getTexture(_type + "_02") == null) {
						dialogImage = new Image(texturesScene.getAtlas("tutorial").getTexture(_type+"_01"));
					}else {
						dialogImage = new Image(texturesScene.getAtlas("tutorial").getTexture(_type+"_02"));
					}
					dialogImage.x = 181;
					dialogImage.y = 55;
					pag2.addChild(dialogImage);
					dialogImage = null;
					if (thirdPage) 
					{
						nextBtn = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("guiArrow"));
						nextBtn.x = 510;
						nextBtn.y = 145;
						nextBtn.rotation =3.14 ;
						nextBtn.alignPivot();
						nextBtn.addEventListener(Event.TRIGGERED, onNext2);
						tempData.push(nextBtn);
						pag2.addChild(nextBtn);
						nextBtn = null;
						
						comlink = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
						comlink.x = 15;
						comlink.y = 200;
						pag3.addChild(comlink);
						comlink = null;
						
						title = new TextField(526, 60, "", globalResources.fontName, 24, 0xFFFFFF);
						title.text = globalResources.textos[globalResources.idioma].Screens.Tutorial[_type].title;
						title.hAlign = "center";
						title.vAlign = "center";
						pag3.addChild(title);
						title = null;
						
						a_text = new TextField(400, 54, "", globalResources.fontName, 14, 0xFFFFFF);
						a_text.text = globalResources.textos[globalResources.idioma].Screens.Tutorial[_type].pag3;
						a_text.x = 126;
						a_text.y = 246;
						a_text.hAlign = "left";
						a_text.vAlign = "top";
						pag3.addChild(a_text);
						a_text = null;
						
						dialogImage = new Image(texturesScene.getAtlas("tutorial").getTexture(_type+"_03"));
						dialogImage.x = 181;
						dialogImage.y = 55;
						tempData.push(dialogImage);
						pag3.addChild(dialogImage);
						dialogImage = null;
						
						closeBtn.x = 497;
						closeBtn.y = 132;
						closeBtn.addEventListener(Event.TRIGGERED, disposeElement);
						tempData.push(closeBtn);
						pag3.addChild(closeBtn);
						closeBtn = null;
					}else {
						closeBtn.x = 497;
						closeBtn.y = 132;
						closeBtn.addEventListener(Event.TRIGGERED, disposeElement);
						tempData.push(closeBtn);
						pag2.addChild(closeBtn);
						closeBtn = null;
					}
					
				break;

			}
			
			tutorialDialogs.push(pag1);
			tutorialDialogs.push(pag2);
			tutorialDialogs.push(pag3);
			
			addChild(tutorialDialogs[0] as Sprite);
		}
		
					private function onNext():void
					{
						soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
						(tutorialDialogs[0] as Sprite).visible = false;
						addChild(tutorialDialogs[1] as Sprite);
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Tutorial: btn_tutorialnext");
					}
					
					private function onNext2():void
					{
						soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
						(tutorialDialogs[1] as Sprite).visible = false;
						addChild(tutorialDialogs[2] as Sprite);
						globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Tutorial: btn_tutorialnext");
					}
					
		public function multiDialog(_numDialog:int, _dialogData:Object = null):void 
		{
			var closeBtn:Button = new Button (texturesScene.getAtlas(ButtonsAssets).getTexture("btnDecline"));
			var nextBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnRight"));
			var a_text:TextField = new TextField(250, 300, "", globalResources.fontName, 14, 0xFFFFFF);
			var pag1:Sprite = new Sprite();
			var pag2:Sprite = new Sprite();
			var pag3:Sprite = new Sprite();
			var comlink:Image = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
			var dialogData:Object;
			var tween2:Tween;
			var tween:Tween;
			
			dialogData = _dialogData;
			if (_dialogData != null) dialogData.pauseId;
			
			var fondo:Image = new Image (texturesScene.getAtlas("Gui").getTexture("guiFrameOption"));
			fondo.scaleX = 0.8;
			fondo.scaleY = 0.7;
			tempData.push(fondo);
			addChild(fondo);
			
			
			switch (_numDialog) 
			{
				case 2:
					removeChild(fondo);
					
					labScreen = new Image(texturesScene.getAtlas("Gui").getTexture("guiLabScreen"));
					labScreen.x = 0;
					labScreen.y = 0 - labScreen.height;
					addChild(labScreen);
					
					comlink.x = 50;
					comlink.y = 115;
					comlink.scaleX = 1.1;
					comlink.scaleY = 1.1;
					tempData.push(comlink);
					pag1.addChild(comlink);
					comlink = null;
					
					a_text.width = 350
					a_text.text = globalResources.textos[globalResources.idioma].Screens.TrophyRoom.FirtsTime.pag1;
					a_text.hAlign = "left";
					//a_text.hAlign = "center";
					a_text.vAlign = "top";
					a_text.x = 150;
					a_text.y = 100;
					pag1.addChild(a_text);
					a_text = null;
					
					nextBtn.x = 430;
					nextBtn.y = 200;
					nextBtn.addEventListener(Event.TRIGGERED, nextWindow);
					tempData.push(nextBtn);
					pag1.addChild(nextBtn);
					nextBtn = null;
					
					comlink = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					comlink.x = 50;
					comlink.y = 115;
					comlink.scaleX = 1.1;
					comlink.scaleY = 1.1;
					pag2.addChild(comlink);
					
					a_text = new TextField(350, 300, "", globalResources.fontName, 14, 0xFFFFFF);
					a_text.text = globalResources.textos[globalResources.idioma].Screens.TrophyRoom.FirtsTime.pag2;
					a_text.hAlign = "left";
					a_text.vAlign = "top";
					a_text.x = 150;
					a_text.y = 100;
					pag2.addChild(a_text);
					a_text = null;
					
					closeBtn.x = 430;
					closeBtn.y = 200;
					closeBtn.addEventListener(Event.TRIGGERED, labScreenOut);
					tempData.push(closeBtn);
					pag2.addChild(closeBtn);
					closeBtn = null;
					
					pag1.alpha = 0;
					
					windowsVec.push(pag1);
					windowsVec.push(pag2);
					
					tween = new Tween(labScreen, 1.5,Transitions.EASE_IN_BOUNCE)
					tween.moveTo(0, 0);
					tween.nextTween = tween2;
					Starling.juggler.add(tween);
					
					tween2 = new Tween(windowsVec[0], 1)
					tween2.delay = 1.5;
					tween2.fadeTo(1);
					Starling.juggler.add(tween2);
					
					soundsScene.getSound("pulldownScreen").play(globalResources.volume);
					soundsScene.getSound("lab_message").play(globalResources.volume);
					
				break;
				case 3:
					comlink.x = 10;
					comlink.y = 10;
					tempData.push(comlink);
					pag1.addChild(comlink);
					comlink = null;
					
					a_text.text = dialogData.text1;
					a_text.x = 100;
					a_text.y = -100;
					pag1.addChild(a_text);
					a_text = null;
					
					nextBtn.x = 250;
					nextBtn.y = 100;
					nextBtn.addEventListener(Event.TRIGGERED, nextWindow);
					tempData.push(nextBtn);
					pag1.addChild(nextBtn);
					nextBtn = null;
					
					comlink = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					comlink.x = 10;
					comlink.y = 10;
					pag2.addChild(comlink);
					
					a_text = new TextField(250, 300, "", globalResources.fontName, 14, 0xFFFFFF);
					a_text.text = dialogData.text2;
					a_text.x = 100;
					a_text.y = -100;
					pag2.addChild(a_text);
					a_text = null;
					
					nextBtn = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btnRight"));
					nextBtn.x = 250;
					nextBtn.y = 100;
					nextBtn.addEventListener(Event.TRIGGERED, nextWindow2);
					tempData.push(nextBtn);
					pag2.addChild(nextBtn);
					nextBtn = null;
					
					comlink = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					comlink.x = 10;
					comlink.y = 10;
					pag3.addChild(comlink);
					
					a_text = new TextField(250, 300, "", globalResources.fontName, 14, 0xFFFFFF);
					a_text.text = dialogData.text3;
					a_text.x = 100;
					a_text.y = -100;
					pag3.addChild(a_text);
					a_text = null;
					
					closeBtn.x = 240;
					closeBtn.y = 100;
					closeBtn.addEventListener(Event.TRIGGERED, closeBtnClick);
					tempData.push(closeBtn);
					pag3.addChild(closeBtn);
					closeBtn = null;
					
					windowsVec.push(pag1);
					windowsVec.push(pag2);
					windowsVec.push(pag3);
				break;
				case 4:
					comlink.x = 10;
					comlink.y = 10;
					tempData.push(comlink);
					pag1.addChild(comlink);
					comlink = null;
					
					a_text.width = 250;
					a_text.text = globalResources.textos[globalResources.idioma].Screens.Megamap.megatileUnlock.pag1;
					a_text.hAlign = "center";
					a_text.vAlign = "top";
					a_text.x = 100;
					a_text.y = 20;
					pag1.addChild(a_text);
					a_text = null;
					
					nextBtn.x = 240;
					nextBtn.y = 100;
					nextBtn.addEventListener(Event.TRIGGERED, nextWindow);
					tempData.push(nextBtn);
					pag1.addChild(nextBtn);
					nextBtn = null;
					
					comlink = new Image (texturesScene.getAtlas(ButtonsAssets).getTexture("comlink"));
					comlink.x = 10;
					comlink.y = 10;
					pag2.addChild(comlink);
					
					a_text = new TextField(250, 200, "", globalResources.fontName, 14, 0xFFFFFF);
					a_text.text = globalResources.textos[globalResources.idioma].Screens.Megamap.megatileUnlock.pag2;
					a_text.hAlign = "center";
					a_text.vAlign = "top";
					a_text.x = 100;
					a_text.y = 20;
					pag2.addChild(a_text);
					a_text = null;
					
					closeBtn.x = 240;
					closeBtn.y = 100;
					closeBtn.addEventListener(Event.TRIGGERED, closeBtnClickNewMegatile);
					tempData.push(closeBtn);
					pag2.addChild(closeBtn);
					closeBtn = null;
					
					windowsVec.push(pag1);
					windowsVec.push(pag2);
					
				break;
			}
			
			addChild(windowsVec[0] as Sprite);
		}
		
		private function nextWindow():void
		{
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			(windowsVec[0] as Sprite).visible = false;
			addChild(windowsVec[1] as Sprite);
		}
		
		private function nextWindow2():void
		{
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			(windowsVec[1] as Sprite).visible = false;
			addChild(windowsVec[2] as Sprite);
		}
		
		private function labScreenOut():void 
		{
			var tween:Tween;
			var tween2:Tween;
			
			tween = new Tween(windowsVec[1], 0.5);
			tween.fadeTo(0);
			Starling.juggler.add(tween);
			tween.nextTween = tween2;
			
			tween2 = new Tween(labScreen, 1.5, Transitions.EASE_OUT_BOUNCE)
			tween2.moveTo(0, 0 - labScreen.height);
			tween2.delay = 0.5;
			Starling.juggler.add(tween2);
			tween2.onComplete = visibleFalse;
			
			soundsScene.getSound("pullupScreen").play(globalResources.volume);
		}
		
		private function visibleFalse():void 
		{
			this.visible = false;
		}
		
		public function createOptionScreen(_dialogData:Object = null):void {
			
			var marcoFondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrameOption"));
			tempData.push(marcoFondo);
			addChild(marcoFondo);
			marcoFondo = null;
			
			var titulo:TextField = new TextField(390, 30, "", globalResources.fontName, 24, 0xFFFFFF);
			titulo.x = 18;
			titulo.y = 14;
			titulo.vAlign = "top";
			titulo.hAlign = "center";
			titulo.text = globalResources.textos[globalResources.idioma].Screens.Megamap.dialogOp.title;
			tempData.push(titulo);
			addChild(titulo);
			titulo = null;
			
			var volume:TextField = new TextField(390, 30, "", globalResources.fontName, 18, 0xFFFFFF);
			volume.x = 20;
			volume.y = 70;
			volume.vAlign = "top";
			volume.hAlign = "left";
			volume.useHandCursor = true;
			volume.text = globalResources.textos[globalResources.idioma].Screens.Megamap.dialogOp.volume;
			tempData.push(volume);
			addChild(volume);
			volume = null;
			
			var volMute:Button = new Button(texturesScene.getAtlas("Botones").getTexture("volMute"));
			volMute.x = 115;
			volMute.y = 65;
			volMute.addEventListener(Event.TRIGGERED, volumeMute);
			volMute.useHandCursor = true;
			tempData.push(volMute);
			addChild(volMute);
			volMute = null;
			
			volumeBar = new scrollBar(globalResources, 200, 0xFFFFFF, 10, 0xFFFFFF, true, soundsScene);
			volumeBar.x = 166;
			volumeBar.y = 80;
			tempData.push(volumeBar);
			addChild(volumeBar);
			
			
			var volFull:Button = new Button(texturesScene.getAtlas("Botones").getTexture("volOn"));
			volFull.x = 372;
			volFull.y = 61;
			volFull.addEventListener(Event.TRIGGERED, volumeFull);
			tempData.push(volFull);
			addChild(volFull);
			volFull = null;
			
			var tutorialBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("tutorialBtn"));
			tutorialBtn.x = 125;
			tutorialBtn.y = 153;
			tutorialBtn.addEventListener(Event.TRIGGERED, activateTutorial);
			tempData.push(tutorialBtn);
			addChild(tutorialBtn);
			tutorialBtn = null;
			
		}
		
		public function activateTutorial():void {
			soundsScene.getSound("Gui_Button_accept").play(globalResources.volume);
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:"gamePlayTutorial",  data: { missionId: 1, src:globalResources.pref_url+"maps/tutorial.json" }}, true));
		}
		
		public function volumeMute():void {
			soundsScene.adjustGeneralVolume(0);
			volumeBar.rect.x = 0;
			globalResources.volume = 0;
		}

		public function volumeFull():void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			soundsScene.adjustGeneralVolume(1);
			volumeBar.rect.x = volumeBar.lineWidth - volumeBar.rect.width;
			globalResources.volume = 1;
		}
		
		public function missionComplete(_missionData:Object):void
		{
			var count:int = 0;
			var imagePickups:ImageLoader;
			var imageDestroyed:ImageLoader;
			var marco:Image;
			var missionData:Object;
			
			mission = _missionData.missionData;
			missionData = _missionData;
			currentScore = missionData.score;
			
			trace("Score: " + currentScore);
			
			trophiesCount = (missionData.pickupsId as Array).length; 
			junkCount = (missionData.destroyPickupsId as Array).length; 
			
			trace("Trophies: " +trophiesCount);
			trace("Junk: " +junkCount);
			
			var fondoComplete:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrame01"));
			fondoComplete.scaleX = 1.20;
			fondoComplete.scaleY = 1.22;
			tempData.push(fondoComplete);
			addChild(fondoComplete);
			fondoComplete = null;
			
			var completeFondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiMissionComplete"));
			completeFondo.x = 9;
			completeFondo.y = 51;
			tempData.push(completeFondo);
			addChild(completeFondo);
			completeFondo = null;
			
			var title:TextField = new TextField(530, 40, "", globalResources.fontName, 32, 0xFFFFFF);
			title.x = 0;
			title.y = 10;
			title.hAlign = "center";
			title.vAlign = "center";
			title.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag1;
			title.alpha = 0;
			tempData.push(title);
			addChild(title);
			completeVector.push(title);
			title = null;
			
			var level:TextField = new TextField(108, 32, "", globalResources.fontName, 28, 0xFFFFFF);
			level.x = 540;
			level.y = 10;
			level.hAlign = "center";
			level.vAlign = "top";
			level.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag6 + missionData.level;
			level.alpha = 0;
			tempData.push(level);
			addChild(level);
			completeVector.push(level);
			level = null;
			
			var pickupText:TextField = new TextField(250, 70, "", globalResources.fontName, 16, 0xFFFFFF);
			pickupText.x = 30;
			pickupText.y = 57;
			pickupText.hAlign = "left";
			pickupText.vAlign = "top";
			pickupText.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag2;
			pickupText.alpha = 0;
			tempData.push(pickupText);
			addChild(pickupText);
			completeVector.push(pickupText);
			pickupText = null;
			
			for (var j:int = 0; j < missionData.pickupsId.length; j++) 
			{
				count += 1;
				imagePickups = ((missionData.dictionary[missionData.pickupsId[j]]) as Objetos).objectImage;
				imagePickups.x = ((20 * (count % 10)) + ((count % 10) * 30)) - 13;
				imagePickups.y = ((20 * (Math.floor(count / 10))) + (Math.floor(count / 10) * 60)) + 85;
				imagePickups.scaleX = 0.6;
				imagePickups.scaleY = 0.6;
				imagePickups.alpha = 0;
				tempData.push(imagePickups);
				
				marco = new Image (texturesScene.getAtlas("Botones").getTexture("objectBox"));
				marco.x = (imagePickups.x) - 7;
				marco.y = (imagePickups.y) - 8;
				tempData.push(marco);
				
				addChild(marco);
				addChild(imagePickups);
				completeVector.push(imagePickups);
				
				marco = null;
				imagePickups = null;
			}
			count = 0;
			
			var pickupDestroyedText:TextField = new TextField(250, 70, ":", globalResources.fontName, 16, 0xFFFFFF);
			pickupDestroyedText.x = 30;
			pickupDestroyedText.y = 142;
			pickupDestroyedText.hAlign = "left";
			pickupDestroyedText.vAlign = "top";
			pickupDestroyedText.text = globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag3;
			pickupDestroyedText.alpha = 0;
			tempData.push(pickupDestroyedText);
			addChild(pickupDestroyedText);
			completeVector.push(pickupDestroyedText);
			pickupDestroyedText = null;
			
			for (var i:int = 0; i < missionData.destroyPickupsId.length; i++) 
			{
				count += 1;
				
				imageDestroyed = ((missionData.dictionary[missionData.destroyPickupsId[i]]) as Objetos).objectImage;
				imageDestroyed.x = ((20 * (count % 10)) + ((count % 10) * 30)) - 13;
				imageDestroyed.y = ((20 * (Math.floor(count / 10))) + (Math.floor(count / 10) * 60)) + 170;
				imageDestroyed.scaleX = 0.6;
				imageDestroyed.scaleY = 0.6;
				imageDestroyed.alpha = 0;
				tempData.push(imageDestroyed);
				
				marco = new Image (texturesScene.getAtlas("Botones").getTexture("objectBox"));
				marco.x = (imageDestroyed.x) - 7;
				marco.y = (imageDestroyed.y) - 8;
				tempData.push(marco);
				
				addChild(marco);
				addChild(imageDestroyed);
				completeVector.push(imageDestroyed);
				
				marco = null;
				imageDestroyed = null;
				
			}
			
			var bigCrystal:Image = new Image (texturesScene.getAtlas("worldObjects").getTexture("Crystals_01"));
			bigCrystal.x = 30;
			bigCrystal.y = 230;
			bigCrystal.alpha = 0;
			tempData.push(bigCrystal);
			addChild(bigCrystal);
			completeVector.push(bigCrystal);
			bigCrystal = null;
			
			var crystalText:TextField = new TextField(120, 50, "100%", globalResources.fontName, 48, 0xFFFFFF);
			crystalText.x = 150;
			crystalText.y = 240;
			crystalText.hAlign = "left";
			crystalText.vAlign = "top";
			crystalText.alpha = 0;
			tempData.push(crystalText);
			addChild(crystalText);
			completeVector.push(crystalText);
			crystalText = null;
			
			var pointsStar:Image = new Image (texturesScene.getAtlas("Botones").getTexture("hub-new"));
			pointsStar.x = 300;
			pointsStar.y = 235;
			pointsStar.alpha = 0;
			tempData.push(pointsStar);
			addChild(pointsStar);
			completeVector.push(pointsStar);
			pointsStar = null;
			
			myTrophiesMeter = new objectsCounterMeter(0, globalResources, texturesScene, soundsScene, trophiesCount);
			myTrophiesMeter.x = 560;
			myTrophiesMeter.y = 55;
			addChild(myTrophiesMeter);
			
			myJunksMeter = new objectsCounterMeter( 1, globalResources, texturesScene, soundsScene, junkCount);
			myJunksMeter.x = 606;
			myJunksMeter.y = 55;
			addChild(myJunksMeter);
			
			missionCompleteTween = new Tween(completeVector[missionCompleteInd], 0.1);
			missionCompleteTween.delay = 0.5;
			missionCompleteTween.fadeTo(1);
			missionCompleteTween.onComplete = nextFade;
			Starling.juggler.add(missionCompleteTween);
			
			globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Gameplay: Mission "+ mission.missionId +" Complete");
		}
		
		private function nextFade():void
		{
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			Starling.juggler.remove(missionCompleteTween);
			missionCompleteTween.reset(completeVector[++missionCompleteInd], 0.1);
			missionCompleteTween.delay = 0.5;
			missionCompleteTween.fadeTo(1);
			
			if (missionCompleteInd == completeVector.length - 1) {
				missionCompleteTween.onComplete = animateObjectsMeter;
			} else {
				missionCompleteTween.onComplete = nextFade;
			}
			Starling.juggler.add(missionCompleteTween);
			
		}
		
		private function animateObjectsMeter():void
		{
			myTrophiesMeter.updateMeter(trophiesCount, "Complete");
			myJunksMeter.updateMeter(junkCount, "Complete");
		}
		
		public function scoreTweenAnimation():void
		{
			retryOrSaveCount++;
			if (retryOrSaveCount == 2) 
			{
				trace("Animation Score");
				scoreText = new TextField(140, 50, scoreCounter.toString(), globalResources.fontName, 48, 0xFFFFFF);
				scoreText.autoScale = true;
				scoreText.x = 385;
				scoreText.y = 240;
				scoreText.hAlign = "right";
				scoreText.vAlign = "top";
				tempData.push(scoreText);
				addChild(scoreText);
				
				
				var scoreTween:Tween = new Tween (this, 4, Transitions.EASE_IN);
				scoreTween.animate("scoreCounter", currentScore);
				scoreTween.onUpdate = setValueScore;
				scoreTween.onComplete = retryOrSave;
				Starling.juggler.add(scoreTween);
				retryOrSaveCount = 0;
				
			}
			
		}
		
		private function setValueScore():void
		{
			soundsScene.getSound("score").play(globalResources.volume);
			scoreText.text = scoreCounter.toString();
		}
		
		public function retryOrSave():void {
			var retryBtn:Button;
			var saveBtn:Button;
			var textA:TextField;
			
			soundsScene.getSound("score").stop();
				
			textA = new TextField(410, 50, globalResources.textos[globalResources.idioma].Screens.GamePlay.Finish.pag5, globalResources.fontName, 20, 0xFFFFFF);
			textA.hAlign = "right";
			textA.vAlign = "top";
			textA.x = 10;
			textA.y = 318;
			addChild(textA);
		
			retryBtn = new Button(texturesScene.getAtlas("Botones").getTexture("btnBack2"));
			retryBtn.x = 460;
			retryBtn.y = 320;
			retryBtn.addEventListener(Event.TRIGGERED, retryAndCleanMission);
			addChild(retryBtn);
			
			saveBtn = new Button(texturesScene.getAtlas("Botones").getTexture("btnAccept"));
			saveBtn.x = 560;
			saveBtn.y = 318;
			saveBtn.addEventListener(Event.TRIGGERED, saveAndComplete);
			addChild(saveBtn);
			
			retryOrSaveCount = 0;
			scoreCounter = 0;
			
		}
		
		public function megamapEndedDialog():void
		{
			var blackQuad:Quad = new Quad(760, 480, 0x000000);
			blackQuad.alpha = 0.90;
			addChild(blackQuad);
			
			var fondo:Image = new Image(texturesScene.getAtlas("screens").getTexture("congratulationImg"));
			fondo.x = 60;
			tempData.push(fondo);
			addChild(fondo);
			fondo = null;
			
			var textfield1:TextField = new TextField(360, 60, "", "ERASBD", 56, 0xFFCB00);
			textfield1.text = globalResources.textos[globalResources.idioma].Screens.Megamap.megamapCompleted.pag1;
			textfield1.hAlign = "center";
			textfield1.vAlign = "top";
			//textfield1.border = true;
			textfield1.x = 196;
			textfield1.y = 40;
			tempData.push(textfield1);
			addChild(textfield1);
			
			var textfield2:TextField = new TextField(260, 70, "", globalResources.fontName, 17, 0xFFFFFF);
			textfield2.text = globalResources.textos[globalResources.idioma].Screens.Megamap.megamapCompleted.pag2;
			//textfield2.border = true;
			textfield2.hAlign = "center";
			textfield2.vAlign = "top";
			textfield2.autoScale = true;
			textfield2.x = 290;
			textfield2.y = 224;
			tempData.push(textfield2);
			addChild(textfield2);
			
			var resumeBtn:Button = new Button (texturesScene.getAtlas(ButtonsAssets).getTexture("btnAccept"));;
			resumeBtn.x = 327;
			resumeBtn.y = 300;
			resumeBtn.addEventListener(Event.TRIGGERED, closeBtnClick);
			tempData.push(resumeBtn);
			addChild(resumeBtn);
			resumeBtn = null;
			
		}
		
		public function megamapDeployableMenu():void
		{
			var slideImg:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiDeploy"));
			tempData.push(slideImg);
			addChild(slideImg);
			slideImg = null;
			
			var labRoomBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("labButton"));
			labRoomBtn.name = "labBtn";
			labRoomBtn.x = 38;
			labRoomBtn.y = 10;
			labRoomBtn.addEventListener(Event.TRIGGERED, onBtnClicked);
			tempData.push(labRoomBtn);
			this.addChild(labRoomBtn);
			
			var comicBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("comicButton"));
			comicBtn.name = "comicBtn";
			comicBtn.x = 38;
			comicBtn.y = 91;
			comicBtn.addEventListener(Event.TRIGGERED, onBtnClicked);
			this.addChild(comicBtn);
			
			var optionBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("configBtn"));
			optionBtn.name = "optionBtn";
			optionBtn.x = 109;
			optionBtn.y = 17;
			optionBtn.addEventListener(Event.TRIGGERED, onBtnClicked);
			this.addChild(optionBtn);
		}
		
		public function onBtnClicked(e:Event):void 
		{
			var tempBtn:Button;
			tempBtn = (e.currentTarget as Button);
			trace(tempBtn.name);
			switch (tempBtn.name) 
			{
				case "labBtn":
					(this.parent as MegaMap).onTrophyRoom();
				break;
				case "comicBtn":
					(this.parent as MegaMap).onComicBtn();
				break;
				case "optionBtn":
					(this.parent as MegaMap).onOptionBtn();
				break;
				default:
			}
		}
		
		override public function dispose():void {
			this.removeChildren();
			this.removeEventListeners();
			
			targetObject = null;
			globalResources = null;
			texturesScene = null;
			soundsScene = null;
			
			if(tempData != null){
				for (var i:uint = 0; i < tempData.length;++i) {
					tempData[i].removeEventListeners();
					tempData[i].dispose();
					tempData[i] = null;
				}
				
				tempData.splice(0, tempData.length);
			}
			
			tempData = null;
			super.dispose();
		}
		
	}

}