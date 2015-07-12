package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.Npc;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class SlimeLauncher extends Npc 
	{
		
		public static const SLIMEPOOL:String = "slimePoolMode";
		public static const PRESLIMEPOOL:String = "preSlimePoolMode";
		public static const WANDER:String = "wanderMode";
		public static const ALERT:String = "alertMode";
		public static const PRESTUN:String = "preStunMode";
		public static const STUN:String = "stunMode";
		public static const ATTACK:String = "attackMode"
		
		public var directions:Vector.<Point> = new Vector.<Point>();
		
		public var tymer:Timer;
		
		public var countSlimeState:int = 0;
		public var countAlertState:int = 0;
		public var slimeVelocity:Number;
		public var alertVelocity:Number;
		public var attackRange:int;
		public var objective:Sprite;
		public var mode:String = WANDER;
		public var chaseSignal:Image;
		public var checkSlime:int;
		public var checkAlert:int;
		public var limitShoot:int;
		public var countStun:int = 0;
		public var checkStun:int;
		public var isPaused:Boolean = false;
		public var attackPoint:Point;
		public var spots:Vector.<Point> = new Vector.<Point>();
		private var tween:Tween;
		private var tween2:Tween;
		
		public var alertRange:Number;
		
		public function SlimeLauncher(born:Point, _texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, nameNpc:String) 
		{
			super(born, _texturesScene, _soundsScene, _globalResources, _globalResources.NpcInfo[nameNpc]);
			
			directions.push(new Point(-1,0));
			directions.push(new Point(-0.70710678118654752440084436210485,-0.70710678118654752440084436210485));
			directions.push(new Point(0,-1));
			directions.push(new Point(0.70710678118654752440084436210485,-0.70710678118654752440084436210485));
			directions.push(new Point(1,0));
			directions.push(new Point(0.70710678118654752440084436210485,0.70710678118654752440084436210485));
			directions.push(new Point(0,1));
			directions.push(new Point( -0.70710678118654752440084436210485, 0.70710678118654752440084436210485));
			
			spots.push(new Point(0,0));
			spots.push(new Point(-100,0));
			spots.push(new Point(100,0));
			spots.push(new Point(0,-100));
			spots.push(new Point(0,100));
			
			
			slimeVelocity = objectData.slimeVelocity;
			alertVelocity = objectData.alertVelocity;
			checkSlime = objectData.checkSlime;
			checkAlert = objectData.checkAlert;
			attackRange = objectData.attackRange;
			alertRange = objectData.alertRange;
			checkStun = objectData.checkStun;
			
			chaseSignal = new Image(texturesScene.getAtlas(objectData.animations.atlas).getTexture("chaseSignal"));
			chaseSignal.y = 75;
			chaseSignal.visible = false;
			npcFront.addChild(chaseSignal);
			
			
			var animation:MovieClip = new MovieClip(texturesScene.getAtlas(objectData.animations.atlas).getTextures("poolSlime"),3);
			animation.pivotX = Math.ceil(animation.width * 0.5);
			animation.pivotY = Math.ceil(animation.height * 0.5);
				
			if (animations["Pool"] == undefined) {
					
				Starling.juggler.add(animation);
				animations["Pool"] = animation;
				indexName.push("Pool");
			}
			
			tween = new Tween(this.npcSprite, 0.5);
			
			
			tymer = new Timer(objectData.timeDecision*1000);
			tymer.start();
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			tymer.addEventListener(TimerEvent.TIMER, onTime);
			
		}
		
		private function onTime(e:TimerEvent):void 
		{
			AI();
		}
		
		private function onUpdate(e:Event):void 
		{
			var posWorld:Point = new Point(objective.x - this.parent.x, (objective.y - this.parent.y)-125);
			var posMe:Point = new Point(this.x, this.y);
			var distanceObjandMe:Number = Point.distance(posWorld, posMe);
			
			
			if ((mode == WANDER || mode == ALERT) &&  distanceObjandMe < this.detectRange) {
				
				mode = PRESLIMEPOOL;
				Starling.juggler.remove(tween);
				tween.reset(this.npcSprite, 0.5);
				tween.animate("y", 115);
				tween.onComplete = onSlime;
				Starling.juggler.add(tween);
				velocity = 0;
				
				
				this.dispatchEvent(new GameEvents(GameEvents.STATE_ALERT,{sender: this}, true));
				
			}else {
				if (mode == SLIMEPOOL) {
					
					if (Point.distance(attackPoint, posMe) < 10) {
						
						Starling.juggler.remove(tween);
						tween.reset(this.npcSprite, 0.3);
						tween.animate("y", 0); 
						tween.onComplete = onAttack;
						Starling.juggler.add(tween);
						mode = ATTACK;
						
						noAnimation = false;
						npcSprite.removeChildAt(0);
						var prefijo:String = objectData.animations.name+"_vista_0_";
						npcSprite.addChildAt(animations[prefijo],0);
						
						direction.x = 0;
						direction.y = 0;
					}
					
				}
				
			}
			
			if ((mode == ATTACK) &&  distanceObjandMe < 75 && !(objective as Chopper).immunity) {
				(objective as Chopper).fuel -= damage;
				(objective as Chopper).shield.visibleOn();
				(objective as Chopper).setImmunity();
			}
			
			if (mode == ALERT) {
				
				direction = posWorld.subtract(posMe);
				direction.normalize(1);
				
				
			}
			
			update();
		}
		
		public function onAttack():void 
		{
		
			Starling.juggler.remove(tween);
			tween.reset(this.npcSprite, 1, Transitions.EASE_IN_BACK);
			tween.animate("y", 115);
			mode = PRESTUN;
			tween.onComplete = onStun;
			Starling.juggler.add(tween);
		}
		
		public function onStun():void 
		{
			mode = STUN;
			chaseSignal.visible = true;
			countStun = 0;
		}
		
		public function onSlime():void {
			
			var posWorld:Point = new Point(objective.x - this.parent.x, (objective.y - this.parent.y)-125);
			var posMe:Point = new Point(this.x, this.y);
			
			var spot:int = Math.random() * 5;
			
			attackPoint = new Point(posWorld.x+spots[spot].x, posWorld.y+spots[spot].y);
			
			
			direction = attackPoint.subtract(posMe);
		    direction.normalize(1);
			velocity = slimeVelocity;
			countStun = 0;
			
			
			noAnimation = true;
			npcSprite.removeChildAt(0);
			npcSprite.addChildAt(animations["Pool"],0);
			
			mode = SLIMEPOOL;
		}
		
		public function onPause(e:GameEvents):void {
			
			switch(e.params.type) {
				case "gamePause":
					if (!isPaused) {
						isPaused = true;
						pause();
					}
					break;
				case "gameResume":
					if (isPaused) {
						isPaused = false;
						unpause();
					}
					break;
					
			}
			
		}
		
		public function pause():void {
			
			this.removeEventListener(Event.ENTER_FRAME, onUpdate);
			tymer.stop();
			
		}
		
		public function unpause():void {
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			tymer.start();
		}
		
		public function AI():void 
		{
			switch(mode) {
				
				case WANDER:
					
					if (Math.random() * 2 < 1) {
						
						direction = directions[int(Math.random() * directions.length)];
						
					}
					
					break;
				
			/*	case SLIMEPOOL:
					
					var posWorld:Point = new Point(objective.x - this.parent.x, objective.y - (this.parent.y-125));
					var posMe:Point = new Point(this.x, this.y);
				
					if (Point.distance(posWorld, posMe) > this.detectRange) {
						
						if (++countSlimeState == checkSlime) {
							
							chaseSignal.visible = false;
							mode = PATROL
							velocity = objectData.velocity;
							
						}
					}else {
						countSlimeState = 0;
					}
				
					break;
				*/	
				case ALERT:
					
					var posWorld1:Point = new Point(objective.x - this.parent.x, objective.y - (this.parent.y-125));
					var posMe1:Point = new Point(this.x, this.y);
					
					if (Point.distance(posWorld1, posMe1) > this.alertRange) {
						
						if (++countAlertState == checkAlert) {
							
							
							mode = WANDER
							velocity = objectData.velocity;
							
						}else {
						 countAlertState = 0;
						}
						
					}
					
				break;
				
				case STUN:
					
					
						if (++countStun == checkStun) {
							
							chaseSignal.visible = false;
							Starling.juggler.remove(tween);
							tween.reset(this.npcSprite, 1);
							tween.animate("y", 0);
							tween.onComplete = onRecovery;
							Starling.juggler.add(tween);
							
						}
					
					
				break;
			
			}
		}
		
		public function onRecovery():void 
		{
			mode = WANDER
			velocity = objectData.velocity;
		}
		
		public function onAlert():void {
			
			if (mode != WANDER) return;
			
			var posWorld1:Point = new Point(objective.x - this.parent.x, objective.y - (this.parent.y-125));
			var posMe1:Point = new Point(this.x, this.y);
			
			if(Point.distance(posWorld1, posMe1) < this.alertRange){
				mode = ALERT;
				velocity = alertVelocity;
			}
			
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			tymer.removeEventListener(TimerEvent.TIMER, onTime);
			tween.onComplete = null;
			Starling.juggler.remove(tween);
			tween = null;
			directions.splice(0, directions.length);
			directions = null;
			tymer.stop();
			tymer = null;
			objective = null; 
			chaseSignal.dispose();
			chaseSignal = null;

			super.dispose();
		}
		
	}

}