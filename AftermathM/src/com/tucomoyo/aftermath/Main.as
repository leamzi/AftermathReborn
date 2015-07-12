package com.tucomoyo.aftermath
{
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.tucomoyo.aftermath.Engine.Game;
	import com.tucomoyo.aftermath.net.hires.debug.Stats;
	import com.tucomoyo.aftermath.Screens.WelcomeScreen;
	import flash.display.StageDisplayState;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class Main extends Sprite 
	{
		private var status:Stats;
		private var _st:Starling;
		
		public var user_id:String;
		public var acces_token:String;
		public var picture_url:String;
		public var user_name:String;
		public var user_firtsName:String;
		public var user_lastName:String;
		public var game_version:String;
		public var tutorialDone:String;
		public var facebookId:String;
		public var tracker:AnalyticsTracker;
		public var scalex:Number;
		public var scaley:Number;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
			scalex = stage.fullScreenWidth; 
			scaley = stage.fullScreenHeight;
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			if (stage) init();
			else addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		private function init(e:starling.events.Event = null):void 
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			// entry point
			status = new Stats();
			status.scaleX = 3.0;
			status.scaleY = 3.0;
			addChild(status);
			
		
			
			tracker = new GATracker (stage, "UA-44942924-2", "AS3", false );
			//analytics.TrackEvent(cat, "music_volume", player_name, int(FlxG.music.volume * 100) );
			//analytics.TrackEvent(cat, "sound_volume", player_name, int(FlxG.volume * 100) );
			
			_st = new Starling(Game, stage);
			_st.addEventListener(starling.events.Event.ROOT_CREATED, onRoot);
			_st.antiAliasing=0;
			_st.start();
			
		}
		
		private function onRoot():void {
			
			(_st.root as Game).user_id = user_id || "-1";
			(_st.root as Game).acces_token = acces_token;
			(_st.root as Game).picture_url = picture_url;
			(_st.root as Game).user_name = user_name;
			(_st.root as Game).user_firstName = user_firtsName;
			(_st.root as Game).user_lastName = user_lastName;
			(_st.root as Game).game_version = game_version;
			(_st.root as Game).facebookId = facebookId;
			(_st.root as Game).tutorialDone = Boolean(int(tutorialDone));
			(_st.root as Game).global_resources.tracker = tracker;
			(_st.root as Game).global_resources.stageWidth = 760;
			(_st.root as Game).global_resources.stageHeigth = 400;
			(_st.root as Game).scaleX = scalex/760;
			(_st.root as Game).scaleY = scaley/400;
			//if((_st.root as Game).user_id == "-1")addChild(status);
			(_st.root as Game).initializeGame();
			_st.antiAliasing=0;
			//_st.start();
			
			if (game_version == null) game_version = "10i2804";
		}
		
		private function deactivate(e:flash.events.Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}