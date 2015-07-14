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
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NpcBonusLoot extends Npc 
	{
		public static const CHASE:String = "chaseMode";
		public static const PATROL:String = "patrolMode";
		public static const ALERT:String = "alertMode";
		public static const BORN:String = "bornMode";
		
		public var directions:Vector.<Point> = new Vector.<Point>();
		public var directionsShoot:Vector.<Point> = new Vector.<Point>();
		
		public var tymer:Timer;
		
		public var chaseVelocity:Number;
		public var alertVelocity:Number;
		public var mode:String = PATROL;
		public var isPaused:Boolean = false;
		
		public var alertRange:Number;
		public var minimapImage:MiniMapObjetos;
		
		private var coins:Particle;
		
		private var coinsParticles:Vector.<Particle> = new Vector.<Particle>;
		
		public function NpcBonusLoot(born:Point, _texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, nameNpc:String) 
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
			
			chaseVelocity = objectData.chaseVelocity;
			alertVelocity = objectData.alertVelocity;
			
			minimapImage = new MiniMapObjetos(texturesScene, {objectPosition:born, layerName:"npcBonus"});
			
			bornEnemie();
			
		}
		
		public function bornEnemie():void {
			
			npcSprite.removeChildAt(0);
			(animations["lootBonus_spawn_"] as MovieClip).currentFrame = 0;
			(animations["lootBonus_spawn_"] as MovieClip).loop = false;
			(animations["lootBonus_spawn_"] as MovieClip).addEventListener(Event.COMPLETE,onBorn);
			npcSprite.addChild(animations["lootBonus_spawn_"]);
			
		}
		
		public function onBorn(e:Event):void {
			
			(animations["lootBonus_spawn_"] as MovieClip).removeEventListener(Event.COMPLETE, onBorn);
			npcSprite.removeChildAt(0);
			npcSprite.addChild(animations[indexName[0]]);
			
			tymer = new Timer(objectData.timeDecision*1000);
			tymer.start();
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			tymer.addEventListener(TimerEvent.TIMER, onTime);
			
		}
		
		private function onTime(e:TimerEvent):void 
		{
			AI();
		}
		
		public function AI():void 
		{
			direction = directions[int(Math.random() * directions.length)];
		}
		
		private function onUpdate(e:Event):void 
		{
			update();
			
			minimapImage.x = this.x * 0.1;
			minimapImage.y = (this.y+135) * 0.1;
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
		
		public function bishCoinAnimation():void
		{
			trace("coin animation");
			coins = new Particle("coinsParticle");
			coinsParticles.push(coins);
			addChild(coins);
			coins = null;
			
			shadow.visible = false;
			npcSprite.visible = false;
			this.removeEventListeners();
			this.dispatchEvent(new GameEvents(GameEvents.ADD_BISHCOINS, { type:"add_bishcoins", lootNum: lootBonus }, true));
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			tymer.removeEventListener(TimerEvent.TIMER, onTime);
			
			minimapImage.dispose();
			minimapImage = null;
			directions.splice(0, directions.length);
			directions = null;
			directionsShoot.splice(0, directionsShoot.length);
			directionsShoot = null;
			tymer.stop();
			tymer = null;
			
			for (var i3:int = 0; i3 < coinsParticles.length; ++i3 ) {
				
				coinsParticles[i3].dispose();
				
			}
			this.parent.removeChild(this);
			super.dispose();
		}
		
	}

}