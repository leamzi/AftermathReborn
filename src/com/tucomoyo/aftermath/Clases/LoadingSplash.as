package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class LoadingSplash extends Sprite 
	{
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		public var tempData:Array = new Array();
		
		public var clock:Timer = new Timer(500);
		public var timerNumber:int = 0;
		public var loadingText:TextField;
		
		public function LoadingSplash(_globalResources:GlobalResources) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = new AssetManager(globalResources.pref_url, globalResources.loaderContext);
			soundsScene = new SoundManager(globalResources.pref_url);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		public function onAddedtoStage(e:Event):void {
			
			texturesScene.addTexture("chopper", "vehicles");
			texturesScene.addTexture("Botones", "Buttons");
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, onTextureComplete);
			texturesScene.loadTextureAtlas();
		}
		
		public function onTextureComplete():void {
			
			var backgroundQuad:Quad = new Quad(760, 400, 0x002e49);
			tempData.push(backgroundQuad);
			addChild(backgroundQuad);
			
			var chopper:Image = new Image(texturesScene.getAtlas("chopper").getTexture("chopper_SO1"));
			chopper.x = 270;
			chopper.y = 120;
			tempData.push(chopper);
			addChild(chopper);
			
			var chopperBlades:MovieClip = new MovieClip(texturesScene.getAtlas("chopper").getTextures("Chopper_Rotor"),20);
			chopperBlades.x = 280;
			chopperBlades.y = 130;
			Starling.juggler.add(chopperBlades);
			tempData.push(chopperBlades);
			addChild(chopperBlades);
			
			loadingText = new starling.text.TextField(200, 50, "CARGANDO", globalResources.fontName, 18, 0xffffff);
			loadingText.hAlign = "left";
			tempData.push(loadingText);
			loadingText.x = 20;
			loadingText.y = 350;
			tempData.push(loadingText);
			addChild(loadingText);
			
			clock.start();
			clock.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function onTimer(e:TimerEvent):void {
			
			timerNumber = timerNumber % 4;
			
				 switch(timerNumber) {
					case 0:
						loadingText.text = "CARGANDO";
						break;
					case 1:
						loadingText.text = "CARGANDO .";
						break;
					case 2:
						loadingText.text = "CARGANDO . .";
						break;
					case 3:
						loadingText.text = "CARGANDO . . .";
						break;
				}
			timerNumber++;
		}
		
		public function activateTimer():void {
			
			loadingText.text = "CARGANDO";
			clock.start();
			clock.addEventListener(TimerEvent.TIMER, onTimer);
			
		}
		
		public function deactivateTimer():void {
			
			timerNumber = 0;
			clock.stop();
			clock.removeEventListener(TimerEvent.TIMER, onTimer);
			
			
		}
		
		override public function dispose():void {
			this.removeEventListeners();
			this.removeChildren();
			
			globalResources = null;
			
			soundsScene.dispose();
			texturesScene.dispose();
			
			soundsScene = null;
			texturesScene = null;
			
			for (var i:uint = 0; i < tempData.length;++i) {
				tempData[i].removeEventListeners();
				tempData[i].dispose();
				tempData[i] = null;
			}
			
			//for (var j:uint = 0; j < animationsTempData.length; j++) {
				//animationsTempData[j] = null;
			//}
			
			tempData.splice(0, tempData.length);
			tempData = null;
			super.dispose();
		}
		
	}

}