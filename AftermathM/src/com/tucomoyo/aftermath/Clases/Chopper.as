package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ObjetoManager;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.Engine.Vehicles;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Chopper extends Vehicles 
	{
		
		public static const ChopperSoundBlades:String = "Chopperv1";
		public static const ChopperSoundCraneUp:String = "crane_up";
		public static const ChopperSoundCraneDown:String = "crane_down";
		public static const H:int = -125;
		
		public var useBtn:Boolean = false;
		public var nearObjPick:Boolean = false;
		public var craneDown:Boolean = false;
		public var canShoot:Boolean = true;
		
		private var chopperCrane:MovieClip;
		private var rotor:MovieClip;
		public var chargeAnimation:MovieClip;
		private var chopperShadow:Image;
		
		public var grabBattery:Objetos;
		
		
		public function Chopper(_textureScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, _objectData:Object = null) 
		{
			
			super(_textureScene, _soundsScene, _globalResources, _objectData);
			
			canonX = 0;
			canonY = -125;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		public function onAddedtoStage(e:Event):void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
			
			soundsScene.addSound(ChopperSoundBlades);
			soundsScene.addSound(ChopperSoundCraneUp,0);
			soundsScene.addSound(ChopperSoundCraneDown,0);
			
			initChopper();
			
		}
		
		public function initChopper():void {
			this.addEventListener(TouchEvent.TOUCH, chopperDoubleClick);
			
			//soundsScene.getSound(ChopperSoundBlades).play(0.3);
			soundsScene.getSound(ChopperSoundBlades).play(globalResources.volume);
			drawVehicle("chopper");
			vehicleSprite.y = H;
			shield.y = H;
			
			chargeAnimation = new MovieClip (texturesScene.getAtlas("chopper").getTextures("chargeShoot"), 10);
			chargeAnimation.pivotX = Math.ceil(chargeAnimation.width *0.5);
			chargeAnimation.pivotY = Math.ceil(chargeAnimation.height *0.5);
			chargeAnimation.y = H +40;
			chargeAnimation.scaleX = 1.2;
			chargeAnimation.scaleY = 1.2;
			chargeAnimation.touchable = false;
			chargeAnimation.visible = false;
			Starling.juggler.add(chargeAnimation);
			chargeAnimation.stop();
			tempData.push(chargeAnimation);
			addChild(chargeAnimation);
			
			rotor = new MovieClip(texturesScene.getAtlas("chopper").getTextures("Chopper_Rotor"),30);
			rotor.y = H-15;
			rotor.pivotX = Math.ceil(rotor.width * 0.5);
			rotor.pivotY = Math.ceil(rotor.height * 0.5);
			rotor.touchable = false;
			Starling.juggler.add(rotor);
			tempData.push(rotor);
			addChild(rotor);
			
			chopperShadow = new Image(texturesScene.getAtlas("chopper").getTexture("shadow"));
			chopperShadow.alpha = 0.75;
			chopperShadow.pivotX = Math.ceil(chopperShadow.width/2);
			chopperShadow.pivotY = Math.ceil(chopperShadow.height/2);
			chopperShadow.touchable = false;
			tempData.push(chopperShadow);
			addChildAt(chopperShadow,0);
			
			chopperCrane = new MovieClip(texturesScene.getAtlas("chopper").getTextures("crane"),11);
			chopperCrane.pivotX = Math.ceil(chopperCrane.width * 0.5);
			chopperCrane.y = H;
			chopperCrane.stop();
			chopperCrane.loop = false;
			Starling.juggler.add(chopperCrane);
			tempData.push(chopperCrane);
			vehicleSpriteBack.addChild(chopperCrane);
			
			addChild(shield);
			addChild(frontSprite);
			/*
			var patron:Quad = new Quad(704, 341, 0xff0000);
			patron.alpha = 0.5;
			patron.pivotX = patron.width * 0.5;
			patron.pivotY = patron.height * 0.5;
			addChild(patron);
			*/
		}
		
		override public function update(e:Event, _X:int, _Y:int, wPos:Point):void 
		{
			super.update(e, _X, _Y, wPos);
			
			chopperCraneAnimation();
		}
		
		public function initChopperCrane():void {
			craneDown=true;
			chopperCrane.currentFrame=0;
			chopperCrane.play();
			//soundsScene.getSound(ChopperSoundCraneDown).play(0.5);
			soundsScene.getSound(ChopperSoundCraneDown).play(globalResources.volume);
		}
		
		public function chopperCraneAnimation():void {
			if(chopperCrane.currentFrame == 7){
				chopperCrane.pause();
			}
			if(chopperCrane.currentFrame == 12){
				chopperCrane.currentFrame = 0;
				craneDown=false;
				chopperCrane.pause();
			}
			if (chopperCrane.currentFrame == 9 && useBtn == true){
				chopperCrane.pause();
			}
			if (chopperCrane.currentFrame == 9 && useBtn == false){
				chopperCrane.play()
			}
		}
		
		public function retractChopperCrane(_useBtn:Boolean):Boolean{
			
			if (chopperCrane.currentFrame == 7) {
				//useBtn = _useBtn;
				chopperCrane.currentFrame=8;
				chopperCrane.play();
				//soundsScene.getSound(ChopperSoundCraneUp).play(0.5);
				soundsScene.getSound(ChopperSoundCraneUp).play(globalResources.volume);
				return true;
			}
			return false;
		}
		
		
		public function chopperDoubleClick(e:TouchEvent):Boolean {
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) 
			{
				return false;
			}
			if (touch.phase == TouchPhase.BEGAN) 
			{
				if (touch.tapCount == 2) 
				{
					if (cryogel > 0.2 && canShoot) {
						return true;
					}else {
						this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"chopperDobleClick" }, true));
					}
					
					return true;
				}
				return false;
			}
			else {
				return false;
			}
			
			
			return false;
		}
		
		public function destroyChooper():void {
			
			this.cursorAngle = 0;
			explosion.y = -125;
			var tween:Tween = new Tween(this, 3);
			tween.animate("cursorAngle", 1800);
			tween.animate("y", this.y+105);
			tween.onComplete = explotionChopper;
			tween.onUpdate = destroyUpdate;
			Starling.juggler.add(tween);
			
			var tween2:Tween = new Tween(chopperShadow, 3);
			tween2.animate("y", -105);
			Starling.juggler.add(tween2);
			
		}
		
		public function explotionChopper():void {
			
			rotor.stop();
			soundsScene.getSound(ChopperSoundBlades).stop();
			destroyVehicle();
			
		}
		
		public function destroyUpdate():void {
			
			
			changeDirection();
			
		}
		
		override public function hitTestPoint(_X:int, _Y:int):Boolean 
		{
			return super.hitTestPoint(_X, _Y-H);
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
	}

}