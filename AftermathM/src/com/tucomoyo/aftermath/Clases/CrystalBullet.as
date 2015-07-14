package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class CrystalBullet extends Sprite 
	{
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		
		public var bullet:Image;
		
		public var bulletInfo:Object = new Object();
		
		public var lifeTime:Timer;
		
		private var chopperRadius:Number = 80;
		
		
		public function CrystalBullet(_globalResources:GlobalResources, _textureScene:AssetManager, _bulletInfo:Object) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _textureScene;
			bulletInfo = _bulletInfo;
			
			lifeTime = new Timer((bulletInfo.lifeTime) * 1000, 1);
			lifeTime.addEventListener(TimerEvent.TIMER_COMPLETE, disposeLife);
			
			this.x = bulletInfo.startPoint.x;
			this.y = bulletInfo.startPoint.y;
			
			drawBullet();
			
		}
		
		public function drawBullet():void {
			
			var dx:Number = bulletInfo.direction.x;
			var dy:Number = bulletInfo.direction.y;
			var ax:Number = Math.abs(dx);
			var ay:Number = Math.abs(dy);
			var t:Number;
			var angle:Number;
			
			if(ax+ay==0)t=0;
			else t=dy/(ax+ay);
			
			if(dx<0){
				t=2-t;
			}
			else{
				if(dy<0)t+=4;
			}
			angle = t * (Math.PI * 0.5);
			
			bullet = new Image(texturesScene.getAtlas("crystalSpawn").getTexture("ene_bala"));
			bullet.alignPivot();
			bullet.rotation = angle;
			addChild(bullet);
			lifeTime.start();
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			this.addEventListener(Event.REMOVED, removeAll);
		}
		public function onUpdate(e:Event):void {
			
			this.x += bulletInfo.direction.x * bulletInfo.velocity;
			this.y += bulletInfo.direction.y * bulletInfo.velocity;
			
			hitVehicle();
		}
		
		public function hitVehicle():void {
			var posWorld:Point = new Point(bulletInfo.objective.x - this.parent.x, (bulletInfo.objective.y - 125)  - this.parent.y);
			var posMe:Point = new Point(this.x, this.y);
			var distanceObjandMe:Number = Point.distance(posWorld, posMe);
			
			if (distanceObjandMe < chopperRadius && !(bulletInfo.objective as Chopper).immunity) {

				(bulletInfo.objective as Chopper).hitVehicle(bulletInfo.damage);
				disposeLife();
			}
		}
		
		public function removeAll():void {
			dispose();
		}
		public function disposeLife(e:TimerEvent=null):void {
			this.parent.removeChild(this);
			dispose();
		}
		
		override public function dispose():void {
			
			globalResources = null;
			texturesScene = null;
			bullet = null;
			bulletInfo = null;
			lifeTime.stop();
			this.removeEventListeners();
			this.removeChildren();
			
			super.dispose();
		}
	}

}