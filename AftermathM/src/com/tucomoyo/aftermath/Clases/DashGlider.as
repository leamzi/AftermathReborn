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
	 */
	public class DashGlider extends Npc 
	{
		
		public static const PATROL:String = "patrolMode";
		public static const DASH:String = "dashMode";
		public static const REST:String = "restMode";
		
		public var directionOrto:Point;
		private var amplitud:Number;
		private var waveLenght:Number;
		
		public var tymer:Timer;
		
		public var countDashState:int = 0;
		public var countRestState:int = 0;
		public var dashVelocity:Number;
		public var attackRange:int;
		public var objective:Sprite;
		public var mode:String = PATROL;
		public var chaseSignal:Image;
		public var checkRest:int;
		public var checkDash:int;
		public var limitShoot:int;
		public var timeShoot:int = 200;
		public var isPaused:Boolean = false;
		
		public var alertRange:Number;
		
		public var initPoint:Point;
		public var endPoint:Point;
		public var _x:Number;
		public var _y:Number;
		public var distanciaRecorrida:Number=0;
		
		public function DashGlider(born:Point, _endPoint:Point, _texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, nameNpc:String) 
		{
			super(born, _texturesScene, _soundsScene, _globalResources, _globalResources.NpcInfo[nameNpc]);
			
			_x = born.x;
			_y = born.y;
			
			initPoint = born;
			endPoint = _endPoint;
			
			direction = new Point(_endPoint.x - born.x, _endPoint.y - born.y);
			direction.normalize(1);
			directionOrto = new Point(-direction.y,direction.x);
			dashVelocity = objectData.dashVelocity;
			checkDash = objectData.checkDash;
			checkRest = objectData.checkRest;
			
			chaseSignal = new Image(texturesScene.getAtlas(objectData.animations.atlas).getTexture("chaseSignal"));
			chaseSignal.y = -50;
			chaseSignal.visible = false;
			npcFront.addChild(chaseSignal);
			
			amplitud = objectData.amplitude;
			waveLenght = (Math.PI * 2.0) / objectData.waveLength;
			
			tymer = new Timer(objectData.timeDecision*1000);
			tymer.start();
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			tymer.addEventListener(TimerEvent.TIMER, onTime);
			
		}
		
		private function onUpdate(e:Event):void 
		{
			var posWorld:Point = new Point(objective.x - this.parent.x, (objective.y - this.parent.y)-125);
			var posMe:Point = new Point(this.x, this.y);
			var distanceObjandMe:Number = Point.distance(posWorld, posMe);
			
			if ((mode == PATROL) &&  distanceObjandMe < this.detectRange) {
				mode = DASH;
				velocity = dashVelocity;
				chaseSignal.visible = true;
				countDashState = 0;
				this.dispatchEvent(new GameEvents(GameEvents.STATE_ALERT,{sender: this}, true));
				
			}
			
			
			if ((mode == DASH) &&  distanceObjandMe < 50 && !(objective as Chopper).immunity) {
				(objective as Chopper).fuel -= damage;
				(objective as Chopper).shield.visibleOn();
				(objective as Chopper).setImmunity();
			}
			
			if (Point.distance(new Point(this.x, this.y), endPoint) < 50) {
				_x = initPoint.x;
				_y = initPoint.y;
				
				distanciaRecorrida = 0;
			}
			/*
			if ((mode == PATROL) &&  distanceObjandMe < this.detectRange) {
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
			
			*/
			
			_x += (velocity * direction.x);
			_y += (velocity * direction.y);
			distanciaRecorrida += velocity;
			
			var longitudSeno:Number = amplitud * Math.sin(distanciaRecorrida * waveLenght);
			
			this.x = (longitudSeno * directionOrto.x)+ _x;
			this.y = (longitudSeno * directionOrto.y)+ _y;
			
			/*
			var ax:Number = Math.abs(direction.x);
			var ay:Number = Math.abs(direction.y);
			var t:Number;
			
			if(ax+ay==0)t=0;
			else t=direction.y/(ax+ay);
			
			if(direction.x<0){
				t=2-t;
			}
			else
			{
				
				if(direction.y<0)t+=4;
				
			}
			cursorAngle = 90 * t;
			
			_x += velocity;
			_y = amplitud * Math.sin(_x * waveLenght);
			
			var radianAngle:Number = ( Math.PI * 0.5 ) * t;
			var cosA:Number = Math.cos(radianAngle);
			var sinA:Number = Math.sin(radianAngle);
			
			this.x = ((_x - initPoint.x) * cosA - (_y - initPoint.y) * sinA) + initPoint.x;
			this.y = ((_y - initPoint.y) * cosA + (_x - initPoint.x) * sinA) + initPoint.y;
			
			*/
			changeDirection();
		}
		
		private function onTime(e:TimerEvent):void 
		{
			AI();
		}
		
		public function AI():void 
		{
			switch(mode) {
				
				case DASH:
					
					if (++countDashState == checkDash) {
							
							chaseSignal.visible = false;
							mode = REST
							velocity = 0;
							countRestState = 0;
					}
					
					break;
				case REST:
					
					if (++countRestState == checkRest) {
							
							mode = PATROL
							velocity = objectData.velocity;
					}
					
					break;
				
			}
			
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
		
		
			override public function dispose():void 
		{
			this.removeEventListeners();
			tymer.removeEventListener(TimerEvent.TIMER, onTime);
			
			directionOrto = null;
			tymer.stop();
			tymer = null;
			objective = null; 
			chaseSignal.dispose();
			chaseSignal = null;

			super.dispose();
		}
		
	}

}