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
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author predictivia
	 * 
	 * JSON CRYSTALSPAWN A http://www.objgen.com/json/models/d0jt
	 * 
	 */
	public class CrystalSpawn extends Npc 
	{
		public static const CHASE:String = "chaseMode";
		public static const PATROL:String = "patrolMode";
		public static const ALERT:String = "alertMode";
		
		public var directions:Vector.<Point> = new Vector.<Point>();
		public var directionsShoot:Vector.<Point> = new Vector.<Point>();
		
		public var tymer:Timer;
		
		public var countChaseState:int = 0;
		public var countAlertState:int = 0;
		public var chaseVelocity:Number;
		public var alertVelocity:Number;
		public var attackRange:int;
		public var objective:Sprite;
		public var mode:String = PATROL;
		public var chaseSignal:Image;
		public var checkChase:int;
		public var checkAlert:int;
		public var limitShoot:int;
		public var timeShoot:int = 200;
		public var isPaused:Boolean = false;
		
		public var alertRange:Number;
		
		public function CrystalSpawn(born:Point, _texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, nameNpc:String) 
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
			
			directionsShoot.push(new Point(-0.70710678118654752440084436210485,-0.70710678118654752440084436210485));
			directionsShoot.push(new Point( -1, 0));
			directionsShoot.push(new Point( -0.70710678118654752440084436210485, 0.70710678118654752440084436210485));
			
			chaseVelocity = objectData.chaseVelocity;
			alertVelocity = objectData.alertVelocity;
			checkChase = objectData.checkChase;
			checkAlert = objectData.checkAlert;
			attackRange = objectData.attackRange;
			limitShoot = objectData.bullet.timeShoot;
			alertRange = objectData.alertRange;
			
			chaseSignal = new Image(texturesScene.getAtlas(objectData.animations.atlas).getTexture("chaseSignal"));
			chaseSignal.y = -50;
			chaseSignal.visible = false;
			npcFront.addChild(chaseSignal);
			
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
			
			++timeShoot;
			
			if ((mode == PATROL || mode == ALERT) &&  distanceObjandMe < this.detectRange) {
				mode = CHASE;
				velocity = chaseVelocity;
				chaseSignal.visible = true;
				countChaseState = 0;
				this.dispatchEvent(new GameEvents(GameEvents.STATE_ALERT,{sender: this}, true));
				
			}else {
				if (mode == CHASE) {
					
					var shootPoint:Point = ( Point.distance(new Point(posWorld.x - 100, posWorld.y), posMe) < Point.distance(new Point(posWorld.x + 100, posWorld.y), posMe) )? new Point(posWorld.x - 100, posWorld.y):new Point(posWorld.x + 100, posWorld.y);
					if (Point.distance(shootPoint,posMe)>10){
						direction = shootPoint.subtract(posMe);
						direction.normalize(1);
					}else {
						direction.x = 0;
						direction.y = 0;
					}
					
					if (distanceObjandMe < attackRange) {
					
						if (timeShoot > limitShoot) {
							shoot();
							timeShoot = 0;
						}
						
					}
					
				}
				
			}
			
			if (mode == ALERT) {
				
				direction = posWorld.subtract(posMe);
				direction.normalize(1);
				
				
			}
			
			update();
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
				
				case PATROL:
					
					if (Math.random() * 2 < 1) {
						
						direction = directions[int(Math.random() * directions.length)];
						
					}
					
					break;
				
				case CHASE:
					
					var posWorld:Point = new Point(objective.x - this.parent.x, objective.y - (this.parent.y-125));
					var posMe:Point = new Point(this.x, this.y);
				
					if (Point.distance(posWorld, posMe) > this.detectRange) {
						
						if (++countChaseState == checkChase) {
							
							chaseSignal.visible = false;
							mode = PATROL
							velocity = objectData.velocity;
							
						}
					}else {
						countChaseState = 0;
					}
				
					break;
					
				case ALERT:
					
					var posWorld1:Point = new Point(objective.x - this.parent.x, objective.y - (this.parent.y-125));
					var posMe1:Point = new Point(this.x, this.y);
					
					if (Point.distance(posWorld1, posMe1) > this.alertRange) {
						
						if (++countAlertState == checkAlert) {
							
							chaseSignal.visible = false;
							mode = PATROL
							velocity = objectData.velocity;
							
						}else {
						 countAlertState = 0;
						}
						
					}
					
				break;
			
			}
		}
		
		public function onAlert():void {
			
			if (mode != PATROL) return;
			
			var posWorld1:Point = new Point(objective.x - this.parent.x, objective.y - (this.parent.y-125));
			var posMe1:Point = new Point(this.x, this.y);
			
			if(Point.distance(posWorld1, posMe1) < this.alertRange){
				mode = ALERT;
				velocity = alertVelocity;
			}
			
		}
		
		public function shoot():void {
			
			var directX:int = (this.x - (objective.x-this.parent.x));
			directX = directX / Math.abs(directX);
			
			var typeShoot:int = Math.random() * 5;
			
			if (typeShoot < 2) {
				
				for (var i:int = 0; i < 3;++i ) {
					
					var bulletInfo:Object = new Object();
					bulletInfo.direction = new Point(directionsShoot[i].x * directX, directionsShoot[i].y);
					bulletInfo.velocity = objectData.bullet.velocity;
					bulletInfo.lifeTime = objectData.bullet.lifeTime;
					bulletInfo.damage = objectData.bullet.damage;
					bulletInfo.startPoint = new Point(this.x, this.y);
					bulletInfo.objective = objective;
					
					var bullet1:CrystalBullet = new CrystalBullet(globalResources, texturesScene, bulletInfo);
					this.parent.addChild(bullet1);
					
				}
				
				
				
			}else {
				
				var directY:int = this.y - ((objective.y-this.parent.y)-125);
				var absDirectY:int = Math.abs(directY);
				
				if (absDirectY < 50) {
					
					var bulletInfo1:Object = new Object();
					bulletInfo1.direction = new Point(directionsShoot[1].x * directX, directionsShoot[1].y);
					bulletInfo1.velocity = objectData.bullet.velocity;
					bulletInfo1.lifeTime = objectData.bullet.lifeTime;
					bulletInfo1.damage = objectData.bullet.damage;
					bulletInfo1.startPoint = new Point(this.x, this.y);
					bulletInfo1.objective = objective;
					
					var bullet2:CrystalBullet = new CrystalBullet(globalResources, texturesScene, bulletInfo1);
					this.parent.addChild(bullet2);
					
				}else {
					
					if (directY < 0) {
						
						var bulletInfo2:Object = new Object();
						bulletInfo2.direction = new Point(directionsShoot[2].x * directX, directionsShoot[2].y);
						bulletInfo2.velocity = objectData.bullet.velocity;
						bulletInfo2.lifeTime = objectData.bullet.lifeTime;
						bulletInfo2.damage = objectData.bullet.damage;
						bulletInfo2.startPoint = new Point(this.x, this.y);
						bulletInfo2.objective = objective;
						
						var bullet3:CrystalBullet = new CrystalBullet(globalResources, texturesScene, bulletInfo2);
						this.parent.addChild(bullet3);
						
						
					}else {
						
						var bulletInfo3:Object = new Object();
						bulletInfo3.direction = new Point(directionsShoot[0].x * directX, directionsShoot[0].y);
						bulletInfo3.velocity = objectData.bullet.velocity;
						bulletInfo3.lifeTime = objectData.bullet.lifeTime;
						bulletInfo3.damage = objectData.bullet.damage;
						bulletInfo3.startPoint = new Point(this.x, this.y);
						bulletInfo3.objective = objective;
						
						var bullet4:CrystalBullet = new CrystalBullet(globalResources, texturesScene, bulletInfo3);
						this.parent.addChild(bullet4);
						
						
					}
					
				}
				
				
			}
			
			
			
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			tymer.removeEventListener(TimerEvent.TIMER, onTime);
			
			directions.splice(0, directions.length);
			directions = null;
			directionsShoot.splice(0, directionsShoot.length);
			directionsShoot = null;
			tymer.stop();
			tymer = null;
			objective = null; 
			chaseSignal.dispose();
			chaseSignal = null;

			super.dispose();
		}
		
		
	}

}