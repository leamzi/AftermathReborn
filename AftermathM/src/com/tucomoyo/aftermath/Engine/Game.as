package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.GlobalResources;
	import com.tucomoyo.aftermath.Screens.ComicScene;
	import com.tucomoyo.aftermath.Screens.DiaryScene;
	import com.tucomoyo.aftermath.Screens.Gameplay;
	import com.tucomoyo.aftermath.Screens.MegaMap;
	import com.tucomoyo.aftermath.Screens.TrophyRoomScreen;
	import com.tucomoyo.aftermath.Screens.TutorialGameplay;
	import com.tucomoyo.aftermath.Screens.WelcomeScreen;
	import flash.events.Event;
	import flash.system.System;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Game extends Sprite
	{
		private var currentScene:Scene;
		
		public var global_resources:GlobalResources;
		public var user_id:String;
		public var picture_url:String;
		public var acces_token:String;
		public var user_name:String;
		public var user_firstName:String;
		public var user_lastName:String;
		public var game_version:String;
		public var facebookId:String;
		public var tutorialDone:Boolean;
		public var sceneSprite:Sprite = new Sprite();
		public var cursorSprite:Sprite = new Sprite();
		public var connect:Connection = new Connection();
		
			
		public function Game() 
		{
			super();
			global_resources = new GlobalResources();
			
		}
		
		public function initializeGame():void {
			global_resources.acces_token = acces_token;
			global_resources.game_version = game_version;
			global_resources.picture_url = picture_url;
			global_resources.user_firstName = user_firstName;
			global_resources.user_id = user_id;
			global_resources.facebookId = facebookId;
			global_resources.user_lastName = user_lastName;
			global_resources.user_name = user_name;
			global_resources.tutorialDone = tutorialDone;
			global_resources.scaleX = this.scaleX;
			global_resources.scaleY = this.scaleY;
			global_resources.setVars();
			
			connect.addEventListener(GameEvents.REQUEST_RECIVED, setLanguage);
			connect.getFacebookInfo(global_resources.facebookId);
		}
		
		private function setLanguage(e:GameEvents):void {
			
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, setLanguage);
			
			var faceLanguage:String = e.params.locale;
			var pattern:RegExp = /es/i;
			
			if(faceLanguage.search(pattern)==0)
				global_resources.idioma = "Español";
			else
				global_resources.idioma = "Ingles";
				
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveLanguage);
			connect.loadLanguage(global_resources.pref_url);			
		}
		
		private function onReciveLanguage(e:GameEvents):void 
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveLanguage);
			global_resources.textos = e.params;
			
			currentScene = new WelcomeScreen(global_resources)
			
			this.addChild(sceneSprite);
			this.addChild(cursorSprite);
			sceneSprite.addChild(currentScene);
			this.addChild(global_resources.loadingSplash);
			
			this.addEventListener(GameEvents.CHANGE_SCREEN, onChange);
			/*
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveNpcInfo);
			connect.loadNpcInfo(global_resources.pref_url);
			*/
		}
		
		private function onReciveNpcInfo(e:GameEvents):void 
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveNpcInfo);
			
			global_resources.NpcInfo = e.params;
			
			currentScene = new WelcomeScreen(global_resources)
			
			this.addChild(sceneSprite);
			this.addChild(cursorSprite);
			sceneSprite.addChild(currentScene);
			this.addChild(global_resources.loadingSplash);
			
			this.addEventListener(GameEvents.CHANGE_SCREEN, onChange);
		}
		
		public function onChange(e:GameEvents):void {
			
			global_resources.activateSplash();
			this.removeChild(currentScene);
			currentScene.dispose();
			currentScene = null;
			
			switch (e.params.type) {
				
				case "missionScreen":
					
					currentScene = new MegaMap(global_resources, e.params.megatile_id);
					
					break;
				case "gamePlayScreen":
					
					currentScene = new Gameplay (global_resources,e.params.data);
					
					break;
				case "gamePlayTutorial":
					
					currentScene = new TutorialGameplay (global_resources,e.params.data);
					
					break;
					
				case "myTrophyRoomScreen":
					
					currentScene = new TrophyRoomScreen (global_resources, e.params.megatile_id);
					
					break;
				
				case "comicScreen":
					
					currentScene = new ComicScene (global_resources, e.params.data);
					
					break;
					
				case "newComic":
					
					currentScene = new DiaryScene (global_resources, e.params.data);
					
					break;
			}
			
			sceneSprite.addChild(currentScene);
			
			System.gc();
		}
		
	}

}