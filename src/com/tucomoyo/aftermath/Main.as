package com.tucomoyo.aftermath
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.tucomoyo.aftermath.Engine.Game;
	import com.tucomoyo.aftermath.net.hires.debug.Stats;
	import com.tucomoyo.aftermath.Screens.WelcomeScreen;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
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
		private var cursorNormal:Loader = new Loader();
		private var cursorHand:Loader = new Loader();
		
		public function Main():void 
		{
			if (stage) init(null);
			else addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
		}
		
		private function init(e:flash.events.Event):void 
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			// entry point
			//status = new Stats();
			//status.scaleX = 1.5;
			//status.scaleY = 1.5;
			//addChild(status);
			
			tracker = new GATracker (stage, "UA-44942924-2", "AS3", false);
			
			_st = new Starling(Game, stage);
			_st.addEventListener(starling.events.Event.ROOT_CREATED, onRoot);
			_st.antiAliasing = 0;
			_st.start();
			
		}
		
		private function cursorComplete(e:flash.events.Event):void {
			//trace("cursor complete");
			cursorNormal.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, cursorComplete);
			addChild(cursorNormal);
			
			cursorHand.load(new URLRequest("https://s3.amazonaws.com/tucomoyo-games/aftermath/"+game_version+"/media/graphics/Buttons/cursorHand.png"));
			cursorHand.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, cursorHandComplete);
		}
		
		private function cursorHandComplete(e:flash.events.Event):void {
			cursorHand.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, cursorHandComplete);
			cursorHand.visible = false;
			addChild(cursorHand);
			
			Mouse.hide();
		}
		
		private function onMoveMouse(e:MouseEvent):void
		{
			
			cursorNormal.x = e.stageX;
			cursorNormal.y = e.stageY;
			
			cursorHand.x = e.stageX;
			cursorHand.y = e.stageY;
			
			if (Mouse.cursor == "button") 
			{
				cursorHand.visible = true;
				cursorNormal.visible = false;
			}else {
				cursorNormal.visible = true;
				cursorHand.visible = false;
			}
			
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
			(_st.root as Game).global_resources.stageWidth = stage.stageWidth;
			(_st.root as Game).global_resources.stageHeigth = stage.stageHeight;
			(_st.root as Game).initializeGame();
			_st.antiAliasing=0;
			//_st.start();
			
			if (game_version == null) game_version = "10i2804";
			cursorNormal.load(new URLRequest("https://s3.amazonaws.com/tucomoyo-games/aftermath/"+game_version+"/media/graphics/Buttons/cursor.png"));
			cursorNormal.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, cursorComplete);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
			Mouse.hide();
		}
		
	}
	
}