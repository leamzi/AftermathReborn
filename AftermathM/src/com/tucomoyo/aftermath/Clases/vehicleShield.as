package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class vehicleShield extends Sprite 
	{
		public var texturesScene:AssetManager;
		private var brillo:MovieClip;
		public var frente:Image;
		public var counterVisible:int = 0;
		
		private var timer:Timer; 
		
		public function vehicleShield(_texturesScene:AssetManager) 
		{
			super();
			
			this.touchable = false;
			texturesScene = _texturesScene;
			
			frente = new Image(texturesScene.getAtlas("vehicleShield").getTexture("baseShield"));
			brillo = new MovieClip(texturesScene.getAtlas("vehicleShield").getTextures("Brillo"), 15);
			
			starling.core.Starling.juggler.add(brillo);
			brillo.stop();
			brillo.loop=false;
			
			addChild(frente);
			addChild(brillo);
			
			frente.pivotX = frente.width * 0.5;
			frente.pivotY = frente.height * 0.5;
			
			brillo.pivotX = brillo.width * 0.5;
			brillo.pivotY = brillo.height * 0.5;
			
			timer = new Timer(1000);
			
			this.alpha = 0.5;
			frente.color = 0x00ff00;
			brillo.color = 0x00ff00;
			this.visible = false;
			
		}
		
		public function visibleOn():void {
			
			if (this.visible) return;
			
			this.visible = true;
			counterVisible = 0;
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			
		}
		
		public function visibleOff():void {
			
			if (!this.visible) return;
			
			this.visible = false;
			
			timer.removeEventListener(TimerEvent.TIMER,onTimer);
			timer.stop();
			
		}
		
		public function onTimer(e:TimerEvent):void {
			
			brillo.stop();
			brillo.play();
			
			if (++counterVisible == 2) {
				visibleOff();
				counterVisible = 0;
			}
			
		}
		
	}

}