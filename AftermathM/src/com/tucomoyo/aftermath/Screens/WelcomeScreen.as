package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.Assets;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.system.LoaderContext;
	import starling.animation.Tween;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class WelcomeScreen extends Scene 
	{
		
		public static const ButtonsAssets:String = "Botones";
		public static const ScreenAssets:String = "screens";
		public static const IntroSound:String = "Welcome_title";
		
		public var startText:TextField;
		public var alphaNum:Number = 0;
		
		public var connect:Connection;
		
		public function WelcomeScreen(_globalResources:GlobalResources) 
		{
			
			super(_globalResources);
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedtoStage);
			
		}
		
		public function onAddedtoStage(e:Event):void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
			connect = new Connection();
			soundsScene.addSound(IntroSound);
			soundsScene.addSound("Gui_Button_accept", 0);
			texturesScene.addTexture(ScreenAssets, "Backgrounds");
			texturesScene.addTexture(ButtonsAssets, "Buttons");
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, onTextureComplete);
			texturesScene.loadTextureAtlas();
		}
		
		public function onTextureComplete(e:GameEvents):void {
			
			texturesScene.removeEventListener(GameEvents.TEXTURE_LOADED, onTextureComplete);
			
			soundsScene.getSound(IntroSound).play(globalResources.volume);
			
			var bg:Image = new Image(texturesScene.getAtlas(ScreenAssets).getTexture("background_intro"));
			tempData.push(bg);
			this.addChild(bg);
			
			var logo:Image = new Image(texturesScene.getAtlas(ScreenAssets).getTexture("logo_aftermath"));
			tempData.push(logo);
			logo.x = 140;
			//logo.y = 10;
			this.addChild(logo);

			startText = new TextField(400, 100, "", globalResources.fontName, 32, 0xFFFFFF);
			startText.text = globalResources.textos[globalResources.idioma].Screens.Welcome.start;
			startText.x = (380) - (startText.width * 0.5);
			startText.y = 294;
			startText.alpha = 0;
			startText.hAlign = "center";
			startText.vAlign = "top"; 
			startText.italic = true;
			this.addChild(startText);
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			this.addEventListener(TouchEvent.TOUCH, onTrigger);

			
		}
		
		public function onUpdate(e:Event):void {
			
			startText.alpha = Math.abs( Math.sin(alphaNum));
			
			alphaNum += 0.05;
			
		}
		
		private function createTutorialInfo():void {
			
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onRequestRecived);
			connect.get_missions_info(globalResources.user_id);
			
		}
		
		private function onRequestRecived(e:GameEvents = null):void
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onRequestRecived);
			
			var json:Object = e.params;
			var i:int = 1;
			
			(json as Array).sort(sort_missions_function);
			
			if(json[0] != undefined){
			
				var tempObj:Object = new Object;
				tempObj.type = "gamePlayTutorial";
				tempObj.missionId = json[0].mission_id;
				tempObj.src = json[0].source;
				
				this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:"newComic",  data: { numScenes: 4, name:"Intro", nextSceneData: tempObj}}, true));
				
			}else {
				
				this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"missionScreen", megatile_id:0}));
				
			}
			
		}
		
		public function sort_missions_function(a:Object, b:Object):int {
			
			if (a.mission_id < b.mission_id) 
			{ 
				return -1; 
			} 
			else if (a.mission_id > b.mission_id) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
				
		}
		
		private function onTrigger(e:TouchEvent):void {
			var touch:Touch= e.getTouch(this);
			
			if (touch == null) 
			{
				return;
			}
			if (touch.phase == TouchPhase.BEGAN) 
			{
				globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "WelcomeScreen: btn_empezar");
				trace("Tutorial Done: "+globalResources.tutorialDone);
				
				if (globalResources.tutorialDone) 
				{
					this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"missionScreen", megatile_id:0}));
				}else {
					createTutorialInfo();
				}
			}
		}
	}

}