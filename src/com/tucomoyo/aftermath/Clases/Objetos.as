package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.ObjetoManager;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.display.Loader;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Objetos extends Sprite
	{
		public static const WorldAssetes:String = "worldObjects";
		
		public var id:int;
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		public var namePosition:String;
		
		private var CMFilter:ColorMatrixFilter = new ColorMatrixFilter();
		private var hoverFilter:ColorMatrixFilter = new ColorMatrixFilter();
		public var objectInfoDialog:Dialogs;
		public var Odialog:Dialogs;
		public var filters:BlurFilter = BlurFilter.createGlow(0xFFFFFF,1,20,0.5);
		public var objectData:Object = new Object();
		public var type:int;
		public var isPickable:Boolean = false;
		public var grabOnChopper:Boolean = false;
		public var hoverBoolean:Boolean = false;
		public var collisionArea:Point;
		public var hp:int = 300;
		public var bright:Number = 0;
		private var loader:Loader = new Loader();
		private var mov:MovieClip;
		public var img:Image;
		public var objImg:ObjetoAsset;
		public var imgXray:Image;
		//public var powerPlantOn:Image;
		public var powerPlantOn:MovieClip;
		public var minimapImage:MiniMapObjetos;
		public var objectImage:ImageLoader;
		public var dialog:Dialogs;
		public var elevatorTrigger:MovieClip;
		public var portal:MovieClip;
		public var hatchDoor:MovieClip;
		public var hatchDoorClose:MovieClip;
		public var letterType:String;
		public var numShot:int = 0;
		public var score:Number = 0;
		public var shadow:Image;
		
		private var nearToVehicle:Boolean = false;
		public  var isFinalObject:Boolean = false;
		public var readInfo:Boolean = false;
		public var hoverBool:Boolean = false;
		private var timeNear:Timer = new Timer(500, 1);
		public var tileMitad:int = 16;
		
		public function Objetos(_texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, _objectData:Object) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			soundsScene = _soundsScene;
			objectData = _objectData;
			
			this.x = _objectData.objectPosition.x;
			this.y = _objectData.objectPosition.y;
			this.namePosition = _objectData.namePos;
			
			minimapImage = new MiniMapObjetos(texturesScene, objectData);
			
			drawObjetos();
		}
		
		public function drawObjetos():void {
			filters.blurX = 30;
			filters.blurY = 30;
			switch(objectData.layerName){
				case "Toxicwaste":
					type = 0;
					score = 50;
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName));
					img.pivotX=Math.ceil(img.width*0.5);
					img.pivotY=img.height-16;
					addChild(img);
					img.filter = CMFilter;
					
					collisionArea = new Point(50,100);
					
					break;
				case "Box":
					type = 1;
					isPickable = true;
					//expandSound = new sound (resources.pref_url, "sounds/menu-expand.mp3",0,0,1);
					score = 250;
					Odialog = new Dialogs(globalResources, texturesScene, soundsScene, -25, -10);
					Odialog.linesDialog(objectData.objectInfo.name,1);
					Odialog.x -= ((Odialog.width * 0.5) - 25);
					Odialog.y -= 100;
					Odialog.visible=false;
					addChild(Odialog);
					
					objectInfoDialog = new Dialogs(globalResources, texturesScene, soundsScene,180,255);
					objectInfoDialog.alertDialog("infoObject", this);
					
					shadow = new Image (texturesScene.getAtlas("chopper").getTexture("shadow"));
					shadow.pivotX = Math.ceil(shadow.width * 0.5);
					shadow.pivotY = Math.ceil(shadow.height * 0.5);
					shadow.y = 10;
					addChild(shadow);
					
					objImg = new ObjetoAsset(objectData.objectInfo.object_id,texturesScene, globalResources.loaderContext);
					objImg.pivotY = 27;
					objImg.filter = hoverFilter;
					objImg.useHandCursor = true;
					if (objectData.ghostAlpha) {
						objImg.alpha = 0.30;
						shadow.alpha = 0.30;
					}
					addChild(objImg);
					objImg.addEventListener(TouchEvent.TOUCH, onObjectClick);
					
					collisionArea = new Point(50,25);
					
					//trace("asdf "+objectData.objectInfo);
					objectImage = new ImageLoader(objectData.objectInfo.media[0].src, globalResources.loaderContext, 60, 60);
					break;
					
				case "CrystalPickups":
					type = 12;
					isPickable = false;
					//expandSound = new sound (resources.pref_url, "sounds/menu-expand.mp3",0,0,1);
					score = 50;
					Odialog = new Dialogs(globalResources, texturesScene, soundsScene, -25, -10);
					Odialog.linesDialog(objectData.objectInfo.name,1);
					Odialog.x-=((Odialog.width*0.5)-25);
					Odialog.y -= 100;
					Odialog.visible=false;
					addChild(Odialog);
					
					objectInfoDialog = new Dialogs(globalResources, texturesScene, soundsScene,180,255);
					objectInfoDialog.alertDialog("infoObject", this);
					
					objImg = new ObjetoAsset(objectData.objectInfo.object_id, texturesScene, globalResources.loaderContext);
					objImg.filter = hoverFilter;
					objImg.useHandCursor = true;
					objImg.pivotY = 27;
					objImg.animation = false;
					if (objectData.ghostAlpha) objImg.alpha = 0.30;
					addChild(objImg);
					
					img = new Image (texturesScene.getAtlas(WorldAssetes).getTexture("Crystals_Pickup"));
					//img.scaleY = 1.75;
					img.alpha = 0.65;
					img.pivotX=Math.ceil(img.width*0.5);
					img.pivotY = Math.ceil(img.height * 0.5);
					img.y = -30;
					addChild(img);
					
					img.filter = CMFilter;
					
					collisionArea = new Point(50,25);
					
					//trace("asdf "+objectData.objectInfo);
					objectImage = new ImageLoader(objectData.objectInfo.media[0].src, globalResources.loaderContext, 60, 60);
					break;
					
				case "FinalPickup":
					type = 2;
					isPickable = true;
					isFinalObject = true;
					
					Odialog = new Dialogs(globalResources, texturesScene, soundsScene, -25, -10);
					Odialog.linesDialog(objectData.objectInfo.name,1);
					Odialog.x-=((Odialog.width/2)-25);
					Odialog.y-=50;
					Odialog.visible=false;
					addChild(Odialog);
					
					collisionArea = new Point(50, 25);
					
					mov = new MovieClip(texturesScene.getAtlas(WorldAssetes).getTextures(objectData.objectName), 3);
					mov.pivotX=Math.ceil(mov.width/2);
					mov.pivotY=Math.ceil(mov.height/2);
					Starling.juggler.add(mov);
					addChild(mov);
					
					break;
					
					collisionArea = new Point(50,25);
				case"resources":
					if (objectData.objectName == "Cgel") type = 3;
					if (objectData.objectName == "Fuel") type = 4;
					isPickable = true;
					
					shadow = new Image (texturesScene.getAtlas("chopper").getTexture("shadow"));
					shadow.pivotX = Math.ceil(shadow.width * 0.5);
					shadow.pivotY = Math.ceil(shadow.height * 0.5);
					shadow.y = 10;
					addChild(shadow);
					
					img = new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY = img.height - tileMitad;
					img.filter = hoverFilter;
					img.useHandCursor = true;
					addChild(img);
					img.addEventListener(TouchEvent.TOUCH, onObjectClick);
					
					collisionArea = new Point(50,25);
					
					//img.filter = filters;
					//img.addEventListener(TouchEvent.TOUCH, pickUpAction);
					//glowTimer.start();
					//glowTimer.addEventListener(TimerEvent.TIMER,glowEffect);
					break;
					
				case"Hatch":
					type = 5;
					isPickable = true;
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=img.height - tileMitad;
					addChild(img);
					img.addEventListener(TouchEvent.TOUCH, onObjectClick);
					
					hatchDoor = new MovieClip(texturesScene.getAtlas("worldObjects").getTextures("Hatch_Op"), 10);
					hatchDoor.loop = false;
					Starling.juggler.add(hatchDoor);
					hatchDoor.pivotX = Math.ceil(hatchDoor.width / 2);
					hatchDoor.pivotY = hatchDoor.height - tileMitad;
					hatchDoor.stop();
					hatchDoor.touchable = false;
					addChild(hatchDoor);
					

					hatchDoorClose = new MovieClip(texturesScene.getAtlas("worldObjects").getTextures("Hatch_Cl"), 10);
					hatchDoorClose.loop = false;
					Starling.juggler.add(hatchDoorClose);
					hatchDoorClose.pivotX = Math.ceil(hatchDoorClose.width / 2);
					hatchDoorClose.pivotY = hatchDoorClose.height - tileMitad;
					hatchDoorClose.stop();
					hatchDoorClose.touchable = false;
					addChild(hatchDoorClose);
					//this.alpha = 0.25;
					collisionArea = new Point(50,25);
					
					break;
				
				case "Explosives":
					type = 8;
					isPickable = true;
					
					objectInfoDialog = new Dialogs(globalResources, texturesScene, soundsScene,180,300);
					objectInfoDialog.alertDialog("explotionAlert");
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("Box_Explosive"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY = img.height - tileMitad;
					addChild(img);
					img.addEventListener(TouchEvent.TOUCH, onObjectClick);
					
					collisionArea = new Point(50,25);
					break;
					
				case "Use":
					type = 9;
					letterType = objectData.letterType;
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName));
					img.pivotX = Math.ceil(img.width * 0.5);
					img.pivotY = Math.ceil(img.height * 0.5);
					img.filter = hoverFilter;
					img.useHandCursor = true;
					addChild(img);
					collisionArea = new Point(50, 25);
					//this.y -= (img.pivotY - tileMitad);
					img.addEventListener(TouchEvent.TOUCH, onObjectClick);
					break;
				
				case "Drop":
					type = 10;
					letterType = objectData.letterType;
					
					if (objectData.objectName == "") break;
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName));
					img.pivotX = Math.ceil(img.width * 0.5);
					img.pivotY = Math.ceil(img.height * 0.5);
					addChild(img);
					
					//if (objectData.objectName == "PowerPlant_Off_Blue")powerPlantOn= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("PowerPlant_On_Blue"));
					if (objectData.objectName == "PowerPlant_Off_Green")powerPlantOn= new MovieClip (texturesScene.getAtlas("Animations").getTextures("DropBattery"),5);
					powerPlantOn.pivotX = Math.ceil(powerPlantOn.width * 0.5);
					powerPlantOn.pivotY = Math.ceil(powerPlantOn.height * 0.5);
					powerPlantOn.visible = false;
					powerPlantOn.play();
					Starling.juggler.add(powerPlantOn);
					addChild(powerPlantOn);
					//this.y += (tileMitad - powerPlantOn.pivotY);
					collisionArea = new Point(100,50);
					break;
					
				case "Elevator_Green":
				case "Portal":
				case "Elevator_Blue":
					
					type = 11;
					isPickable = false;
					letterType = objectData.objectInfo.letterType;
					
					Odialog = new Dialogs(globalResources, texturesScene, soundsScene, -25, -10);
					Odialog.linesDialog(objectData.objectInfo.name,1);
					Odialog.x-=((Odialog.width*0.5)-25);
					Odialog.y-=100;
					Odialog.visible=false;
					addChild(Odialog);
					
					objectInfoDialog = new Dialogs(globalResources, texturesScene, soundsScene,180,255);
					objectInfoDialog.alertDialog("infoObject", this);
					
					objImg = new ObjetoAsset(objectData.objectInfo.object_id,texturesScene, globalResources.loaderContext);
					objImg.pivotY = 27;
					//objImg.pivotY = -15;
					objImg.animation = false;
					objImg.visible = false;
					objImg.filter = hoverFilter;
					objImg.useHandCursor = true;
					addChild(objImg);
					
					portal = new MovieClip(texturesScene.getAtlas(WorldAssetes).getTextures("portal_"),20);
					portal.loop = false;
					Starling.juggler.add(portal);
					portal.pivotX = Math.ceil(portal.width / 2);
					portal.pivotY = Math.ceil(portal.height / 2)+32;
					portal.stop();
					portal.touchable = false;
					addChild(portal);
					
					collisionArea = new Point(50, 25);
					
					objectImage = new ImageLoader(objectData.objectInfo.media[0].src, globalResources.loaderContext, 60, 60);
					
					break;

				case "hatchTrigger":
					type = 25;
					collisionArea = new Point(50,25);
					break;
					
				case "bishcoins":
					isPickable = true;
					
					img = new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY = img.height - tileMitad;
					img.filter = hoverFilter;
					img.useHandCursor = true;
					addChild(img);
					img.addEventListener(TouchEvent.TOUCH, onObjectClick);
					
					collisionArea = new Point(50,25);
					break;
			}
			
			this.visible = false;
		}
		
		public function convertToPickup():void {
			objImg.addEventListener(TouchEvent.TOUCH, onObjectClick);
			objImg.animation = true;
			removeChild(img);
			isPickable = true;
			type = 1;
			score = 250;
			numShot = 0;
		}
		
		public function onObjectClick(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			var tween:Tween;
			var dialogPos:Point = new Point(this.x, this.y)
			dialogPos = this.localToGlobal(dialogPos);
			
			
			
			if(Odialog != null)Odialog.visible=false;
			
			if (touch == null) {
				hoverFilter.reset();
				hoverBool = false;
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN) {
				
				if (touch.tapCount == 2) {
					
					switch(type) {
						case 1://For normal pickable objects and For especial objects like Final object
						case 2:
							if (dialog != null) { removeChild(dialog); dialog = null;}
							dialog = new Dialogs(globalResources, texturesScene, soundsScene, this.pivotX, this.pivotY);
							this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"objectDialog", objetox:this }, true));
							dialog.y = -125;
							dialog.alertDialog("objectMenu", this);
							dialog.pivotX = dialog.width/2;
							dialog.pivotY = dialog.height/2;
							dialog.scaleX = 0;
							dialog.scaleY = 0;
							
							tween=new Tween(dialog,0.15);
							tween.scaleTo(1);
							starling.core.Starling.juggler.add(tween);
							
							
							globalResources.trackEvent("Interaction", "user: " + globalResources.user_id, "Gameplay: doubleClick-pickUp");
							this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:3 }, true));
							break;
						case 3://For Cryogel
							soundsScene.getSound("chopper_voice/lock_and_load").play(globalResources.volume);
							globalResources.trackEvent("Interaction", "user: " + globalResources.user_id, "Gameplay: doubleClick-Cryogel");
							this.dispatchEvent(new GameEvents(GameEvents.PICK_OBJECT, { type: "pickupObject", obj: this }, true));

						    break;
						case 4://For Fuel
							soundsScene.getSound("chopper_voice/got it").play(globalResources.volume);
							globalResources.trackEvent("Interaction", "user: " + globalResources.user_id, "Gameplay: doubleClick-Fuel");
							this.dispatchEvent(new GameEvents(GameEvents.PICK_OBJECT, { type: "pickupObject", obj: this }, true));
						    break;
						case 5://For Hatch
							if (dialog != null) { removeChild(dialog); dialog = null;}
							dialog = new Dialogs(globalResources, texturesScene, soundsScene, 180, globalResources.stageHeigth);
							this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"hatch", objetox:this }, true));
							dialog.alertDialog("leaveMission",null,{pauseId:5, tutorial:globalResources.isInTutorial});
							
							tween = new Tween(dialog, 0.20, Transitions.EASE_IN);
							tween.moveTo(180, dialog.y - (dialog.height+100));
							Starling.juggler.add(tween);
							
							this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:5 }, true));
							globalResources.trackEvent("Interaction", "user: " + globalResources.user_id, "Gameplay: doubleClick-Hatch");
							break;
						
						case 8:
							if (dialog != null) { removeChild(dialog); dialog = null;}
							dialog = new Dialogs(globalResources, texturesScene, soundsScene, this.pivotX, this.pivotY);
							this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"objectDialog", objetox:this }, true));
							dialog.y = -125;
							dialog.alertDialog("objectMenu", this);
							dialog.pivotX = dialog.width/2;
							dialog.pivotY = dialog.height/2;
							dialog.scaleX = 0;
							dialog.scaleY = 0;
							
							tween=new Tween(dialog,0.15);
							tween.scaleTo(1);
							starling.core.Starling.juggler.add(tween);
							this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:3 }, true));
						break;
						
						case 9://For use objects
							soundsScene.getSound("chopper_voice/move_in").play(globalResources.volume);
							this.dispatchEvent(new GameEvents(GameEvents.PICK_OBJECT, { type:"useObject", obj:this}, true));
							//this.dispatchEvent(new GameEvents(GameEvents.PICKUP_OBJECT, { type: "pickupObject", obj: this }, true));
							break;
						
					}
				}
				
			}else {
					
					if (touch.phase == TouchPhase.HOVER) {
						if (type == 1 || type == 3 || type == 4 || type == 9 || type == 11 || type == 12) {
							if (!hoverBool) {
								hoverFilter.adjustBrightness(0.3);
								hoverBool = true;
							}
						}
						
					}
					
			}
		}
		
		
		public function hitTestPoint(_p:Point):Boolean{
			
			var _w:int;
			var _h:int;
			
			if (type == 2){
				_w = mov.width/2;
				_h = mov.height/2;
			}
			if (type == 1){
				_w = img.width/2;
				_h = img.height/2;
			}
			return((_p.x<(this.x+_w)) && (_p.x>(this.x-_w)) && (_p.y<(this.y+_h)) && (_p.y>(this.y-_h))  );

		}
		
		public function actionNear():void {
			
			
			if (!nearToVehicle) {
				timeNear.start()
				timeNear.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, onNoNear);
				nearToVehicle = true;
				if ( type == 5) {
					this.hatchDoorClose.visible = false;
					this.hatchDoorClose.stop();
					this.hatchDoor.visible = true;
					this.hatchDoor.play();
					soundsScene.getSound("hatch_open").play(globalResources.volume);
				}
				
				if(type == 1 || type == 2 || type == 12){
					Odialog.visible=true;
				}
				
			}else {
				timeNear.reset();
				timeNear.start();
			}
			
		}
		
		public function onNoNear(e:flash.events.TimerEvent):void {
			nearToVehicle = false;
			timeNear.stop(); 
			timeNear.removeEventListener(flash.events.TimerEvent.TIMER_COMPLETE, onNoNear);
			if ( type == 5) {
				this.hatchDoor.visible = false;
				this.hatchDoor.stop();
				if (this.hatchDoorClose.currentFrame == 0) {
					this.hatchDoorClose.visible = true;
					this.hatchDoorClose.play();
					soundsScene.getSound("hatch_close").play(globalResources.volume);
				}
			}
			if(type == 1 || type == 2 || type == 12){
				Odialog.visible=false;
			}
		}
		
		public function brightAnimation(brightLevel:Number = 0):void {
			if (brightLevel > 0) bright = brightLevel;
			CMFilter.adjustBrightness(bright);
		}
		
		public function scoreReturn():Number {
			
			return (numShot > 0)? Number(score / Number(numShot)) : score;
			
		}
		
		override public function dispose():void {
			
			this.removeChildren();
			this.removeEventListeners();
			
			globalResources = null;
			texturesScene = null;
			soundsScene = null;
			
			timeNear.stop(); 
			timeNear.removeEventListener(flash.events.TimerEvent.TIMER_COMPLETE, onNoNear);
			
			if (minimapImage != null) minimapImage.dispose();
			minimapImage = null;
			
			if (img != null) {
				
				img.removeEventListeners();
				img.dispose();
				
			}
			
			if (objImg != null) {
				objImg.removeEventListeners();
				objImg.dispose();
			}
			
			if(Odialog!=null){
				Odialog.dispose();
				Odialog = null;
			}
			
			if (dialog != null) {
				dialog.dispose();
				dialog = null;
			}
			
			if (shadow != null) {
				shadow.dispose();
				shadow = null;
			}
			
			objectData = null;
			
			super.dispose();
			
		}
	}

}