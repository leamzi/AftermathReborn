package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Clases.Dialogs;
	import com.tucomoyo.aftermath.Clases.objectsCounterMeter;
	import com.tucomoyo.aftermath.Clases.Trofeos;
	import com.tucomoyo.aftermath.Clases.VehicleEditor;
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.Engine.TaskObject;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class TrophyRoomScreen extends Scene 
	{
		private var connect:Connection;
		private var myObjects:Vector.<Object> = new Vector.<Object>;
		private var trophiesAndJunk:Vector.<Trofeos> = new Vector.<Trofeos>;
		private var objects_id:Array = new Array();
		
		private var trophySprite:Sprite = new Sprite();
		private var labSprite:Sprite = new Sprite();
		private var dialogSprite:Sprite = new Sprite();
		private var junkyardSprite:Sprite = new Sprite();
		private var hudSprite:Sprite = new Sprite();
		
		private var touched:Boolean = false;
		private var touchPoint:Point = new Point();
		
		private var objectsVote:Dictionary = new Dictionary;
		
		private var taskVec:Vector.<TaskObject> = new Vector.<TaskObject>;
		private var taskArray:Array = new Array();
		
		public var trophyMeter:objectsCounterMeter;
		public var junkMeter:objectsCounterMeter;
		private var trophyCount:int = 0;
		private var junkCount:int = 0;
		
		private var junkPos:int = 0;
		private var trophyPos:int = 0;
		
		private var megatile_id:int = 0;
		
		private var trophyBackground:Image;
		private var junkBackground:Image;
		
		//Embed my world background
		
		[Embed(source="../../../../../media/graphics/Backgrounds/trophyScreen.png")]
		public static const backgroundTrophyRoom:Class;
		
		[Embed(source="../../../../../media/graphics/Backgrounds/trophyJunkyard.png")]
		public static const backgroundJunkyard:Class;
		
		public function TrophyRoomScreen(_resources:GlobalResources, _megatile_id:int)
		{
			super(_resources);
			
			globalResources = _resources;
			megatile_id = _megatile_id;
			trace("Trophy room megatile id: " + _megatile_id);
			connect = new Connection();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
			
		}
		
		public function onAddedtoStage(e:starling.events.Event):void {
			
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
			trophySprite.addEventListener(TouchEvent.TOUCH, onTouch);
			junkyardSprite.addEventListener(TouchEvent.TOUCH, onTouch);
			
			texturesScene.addTexture("Botones", "Buttons");
			texturesScene.addTexture("Gui", "Buttons");
			texturesScene.addTexture("vehicleEditor", "Buttons");
			texturesScene.addTexture("worldObjects", "World");
			texturesScene.addTexture("screens", "Backgrounds");
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, onTextureComplete);
			texturesScene.loadTextureAtlas();
			
			soundsScene.addSound("trophyRoomBGM", -1);
			soundsScene.addSound("pulldownScreen", 0);
			soundsScene.addSound("pullupScreen", 0);
			soundsScene.addSound("lab_message", 0);
			soundsScene.addSound("chargeMeter", 0);
			soundsScene.addSound("Gui_Button_accept", 0);
			soundsScene.addSound("Gui_Button_click", 0);
			soundsScene.addSound("Gui_Button_denied", 0);
		}
		
		public function onTextureComplete(e:GameEvents):void {
			
			getObjects();
			globalResources.trackPageview("/Trophy Screen");
		}
		
		/********************************************************
         * 
         * 				      EVENTS
         * 
         * *****************************************************/
		
		public function getObjects():void {
		
			connect.addEventListener(GameEvents.REQUEST_RECIVED, recieveObjects);
			connect.get_trophy_junk_info(parseInt(globalResources.user_id));
		}
		
		public function recieveObjects(e:GameEvents = null):void
		{
			
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, recieveObjects);
			
			if (e != null) {
				var json:Object = e.params;
				var tempObj:Object;
				var i:int = 0;
				
				while (json[i] != undefined) {
					
					tempObj = new Object();
					tempObj.object_id = json[i].object_id;
					tempObj.trophy_vote_id = json[i].trophy_vote_id;
					tempObj.type = json[i].type;
					tempObj.vote = json[i].vote;
					
					//trace("object_id: " + json[i].object_id);
					
					objects_id.push(json[i].object_id);
					myObjects.push(tempObj);
					
					tempObj = null;
					i++;
				}
				
			}
			
			myObjects.sort(sort_array_objects);
			
			loadObjectsInfo();
		}
		
		public function loadObjectsInfo():void 
		{
			if (objects_id.length >0) 
			{
				connect.addEventListener(GameEvents.REQUEST_RECIVED, loadObjectsInfoComplete);
				connect.getObjects(objects_id);
			}else {
				drawTrophyRoom();
			}
			
		}
		
		public function loadObjectsInfoComplete(e:GameEvents):void 
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, loadObjectsInfoComplete);
			
			if (e != null) {
				var json:Object = e.params;
				var i:int = 0;
				var objectInfo:Object;
				var genere:int;
				var newObject:Trofeos;
				
				while (json[i] != undefined) 
				{
					objectInfo = new Object();
					objectInfo.id = json[i].id;
					objectInfo.name = json[i].name;
					objectInfo.object_id = json[i].object_id;
					objectInfo.sources = json[i].sources;
					objectInfo.media = json[i].media;
					objectInfo.trophy_vote_id = myObjects[i].trophy_vote_id;
					
					//trace("object id: " + json[i].object_id+ " Object Name: "+ json[i].name);
					
					if (myObjects[i].type == "junk") 
					{
						genere = 0;
						junkCount++;
					}
					
					if (myObjects[i].type == "trophy") 
					{
						genere = 1;
						trophyCount++;
					}
					
					newObject = new Trofeos(texturesScene, soundsScene, globalResources, objectInfo, myObjects[i].vote, genere);
					trophiesAndJunk.push(newObject);
					
					objectInfo = null;
					newObject = null;
					
					i++;
				}
			}
			
			drawTrophyRoom();
		}
		
		public function loadMegamapTasks():void 
		{
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onTasksRecived);
			//connect.get_trophy_junk_info(parseInt(globalResources.user_id));
			//connect.get_src_mission(globalResources.pref_url+"trophieRoomTasks.json");
		}
		
		private function onTasksRecived(e:GameEvents = null):void
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onTasksRecived);
			
			var json:Object = e.params;
			var i:int = 0;
			var k:int = 0;
			var objeto:Object;
			
			while (json[i] != undefined) 
			{
				while (json[i].comicList[k] != undefined) 
				{
					objeto = new Object;
					objeto.id = json[i].comicList[k].id;
					objeto.finished = json[i].comicList[k].finished;
					objeto.available = json[i].comicList[k].available;
					objeto.name = json[i].comicList[k][globalResources.idioma].name;
					objeto.text1 = json[i].comicList[k][globalResources.idioma].text1;
					objeto.text2 = json[i].comicList[k][globalResources.idioma].text2;
					
					taskArray.push(objeto);
					
					objeto = null;
					k++
				}
				
				i++
			}
			
			drawTrophyRoom();
			
		}
		
		public function drawTrophyRoom():void {
			
			//soundsScene.getSound("trophyRoomBGM").play(globalResources.volume);
			
			var iniX:int = 360;
			var iniY:int = 200;
			var angle:Number = Math.PI * 0.25;
			
			//var labBackground:Image = new Image(texturesScene.getAtlas("screens").getTexture("labBackground"));
			//labBackground.alpha = 0.98;
			labSprite.addChild(new VehicleEditor(globalResources,texturesScene,soundsScene,connect));
			
			trophyBackground = new Image(Texture.fromBitmap(new backgroundTrophyRoom()));
			trophyBackground.pivotX = trophyBackground.width * 0.5 -380;
			trophyBackground.pivotY = trophyBackground.height * 0.5 -200;
			trophySprite.addChild(trophyBackground);
			
			junkBackground = new Image(Texture.fromBitmap(new backgroundJunkyard()));
			junkBackground.pivotX = junkBackground.width * 0.5 -380;
			junkBackground.pivotY = junkBackground.height * 0.5 -200;
			junkyardSprite.addChild(junkBackground);
			
			var close:Button = new Button(texturesScene.getAtlas("Botones").getTexture("btnBack"));
			close.x = 30;
			close.y = 60;
			close.addEventListener(Event.TRIGGERED, returnMissionScreen);
			labSprite.addChild(close);
			
			trace("Torphies Lenght: " + trophiesAndJunk.length);
			
			for (var i:int = 0; i < trophiesAndJunk.length; ++i ) {
				
				if (trophiesAndJunk[i].genere == 0)
				{
					trophiesAndJunk[i].x = iniX + (100+(int(junkPos/8)*100))*Math.cos(junkPos * angle);
					trophiesAndJunk[i].y = iniY + (100+(int(junkPos/8)*100))*Math.sin(junkPos * angle);
					junkyardSprite.addChild(trophiesAndJunk[i]);
					junkPos++;
				}
				if (trophiesAndJunk[i].genere == 1) 
				{
					trophiesAndJunk[i].x = iniX + (100+(int(trophyPos/8)*100))*Math.cos(trophyPos * angle);
					trophiesAndJunk[i].y = iniY + (100+(int(trophyPos/8)*100))*Math.sin(trophyPos * angle);
					trophySprite.addChild(trophiesAndJunk[i]);
					trophyPos++;
				}
				trace(trophiesAndJunk[i].x,trophiesAndJunk[i].y)
				dialogSprite.addChild(trophiesAndJunk[i].dialogVote);
			
			}
			
			junkMeter = new objectsCounterMeter(1, globalResources, texturesScene, soundsScene, junkPos);
			junkMeter.x = 21;
			junkMeter.y = 30;
			junkMeter.name = "junkMeter";
			junkMeter.visible = false;
			hudSprite.addChild(junkMeter);
			
			trophyMeter = new objectsCounterMeter(0, globalResources, texturesScene, soundsScene, trophyPos);
			trophyMeter.x = 21;
			trophyMeter.y = 30;
			trophyMeter.visible = false;
			trophyMeter.name = "trophyMeter";
			hudSprite.addChild(trophyMeter);
			
			var junkyardBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("junkButton"));
			junkyardBtn.x = 680;
			junkyardBtn.y = 90;
			junkyardBtn.addEventListener(Event.TRIGGERED, onJunkyardVisible);
			tempData.push(junkyardBtn);
			labSprite.addChild(junkyardBtn);
			
			var trophyBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("trophyButton"));
			trophyBtn.x = 680;
			trophyBtn.y = 10;
			trophyBtn.addEventListener(Event.TRIGGERED, onTrophiesVisible);
			tempData.push(trophyBtn);
			labSprite.addChild(trophyBtn);
			
			var labBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("labButton"));
			labBtn.x = 680;
			labBtn.y = 330;
			labBtn.addEventListener(Event.TRIGGERED, onLabVisible);
			tempData.push(labBtn);
			hudSprite.addChild(labBtn);
			/*
			var guiPredictvia:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiMeterBar"));
			guiPredictvia.x = -24;
			guiPredictvia.y = 262;
			hudSprite.addChild(guiPredictvia);
			*/
			trophySprite.visible = false;
			junkyardSprite.visible = false;
			
			addChild(trophySprite);
			addChild(junkyardSprite);
			addChild(hudSprite);
			addChild(labSprite);
			
			addChild(dialogSprite);
			/*
			var welcomeDialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 90, 0);
			welcomeDialog.multiDialog(2, { pauseId:1 } );
			tempData.push(welcomeDialog);
			labSprite.addChild(welcomeDialog);
			*/
			globalResources.deactivateSplash();
			globalResources.trackEvent("Screen View", "user: " + globalResources.user_id, "Trophy Screen");
			
		}
		
		public function onJunkyardVisible(e:Event):void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			junkyardSprite.sortChildren(sort_sprites_function);
			hudSprite.getChildByName("junkMeter").visible = true;
			junkMeter.updateMeterText(junkCount);
			junkMeter.updateMeter(junkCount);
			
			junkyardSprite.visible = true;
			junkyardSprite.touchable = true;
			
			trophySprite.visible = false;
			trophySprite.touchable = false;
			
			labSprite.visible = false;
			labSprite.touchable = false;
		}
		
		public function onTrophiesVisible(e:Event):void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			trophySprite.sortChildren(sort_sprites_function);
			hudSprite.getChildByName("trophyMeter").visible = true;
			trophyMeter.updateMeterText(trophyCount);
			trophyMeter.updateMeter(trophyCount);
			
			trophySprite.visible = true;
			trophySprite.touchable = true;
			
			junkyardSprite.visible = false;
			junkyardSprite.touchable = false;
			
			labSprite.visible = false;
			labSprite.touchable = false;
		}
		
		public function onLabVisible(e:Event):void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			junkMeter.updateMeter(0);
			trophyMeter.updateMeter(0);
			
			hudSprite.getChildByName("trophyMeter").visible = false;
			hudSprite.getChildByName("junkMeter").visible = false;
			junkyardSprite.visible = false;
			junkyardSprite.touchable = false;
			
			trophySprite.visible = false;
			trophySprite.touchable = false;
			
			labSprite.visible = true;
			labSprite.touchable = true;
			
		}
		
		public function convertTrophyToJunk(_id:int, _vote:String):void {
			
			var tempObjectInfo:Object;
			var tempObject:Trofeos;
			var angle:Number = Math.PI * 0.25;
			
			globalResources.trackEvent("ConvertTrophy_to_Junk: "+ _id, "user: " + globalResources.user_id, "Trophy Screen");
			
			for (var i:int = 0; i < trophiesAndJunk.length; i++) 
			{
				if (trophiesAndJunk[i].objectData.object_id == _id) 
				{
					
					
					trophySprite.removeChild(trophiesAndJunk[i]);
					
					tempObjectInfo = new Object();
					tempObjectInfo.objectData = trophiesAndJunk[i].objectData;
					tempObjectInfo.vote = _vote;
					
					tempObject = new Trofeos (texturesScene, soundsScene, globalResources, tempObjectInfo.objectData, _vote, 0);
					tempObject.x = 360 + (100 +  (int(junkPos / 8) * 100)) * Math.cos(junkPos * angle);
					tempObject.y = 200 + (100 +  (int(junkPos / 8) * 100)) * Math.sin(junkPos * angle);
					
					trophiesAndJunk.splice(i, 1);
					trophiesAndJunk.push(tempObject);
					junkyardSprite.addChild(tempObject);
					dialogSprite.addChild(tempObject.dialogVote);
					
					trophyCount--;
					
					tempObjectInfo = null;
					tempObject = null;
					
					trophyMeter.updateMeter(trophyCount);
					trophyMeter.updateMeterText(trophyCount);
					
					junkPos++;
					junkCount++;
					
					break;
				}
			}
			
		}
		
		public function changeObjectVoteAndType(_id:String, _trophy_vote_id:int, _vote:String, _type:String):void 
		{
			//trace("User id: " + _id + ", Trophie Vote Id: " + _trophy_vote_id + ", Vote: " + _vote);
			//connect.addEventListener(GameEvents.REQUEST_RECIVED, changeObjectType);
			connect.modifyTrophyroomVoteAndType(parseInt(globalResources.user_id), _trophy_vote_id, parseInt(_vote), _type, 3);
			
		
		}
		
		public function changeObjectVote(_id:String, _trophy_vote_id:int,_vote:int):void {
			
			//trace("User id: " + _id + ", Trophie Vote Id: " + _trophy_vote_id + ", Type: " + _type);
			connect.modifyTrophyroomVote(parseInt(globalResources.user_id), _trophy_vote_id, _vote);
		}
		
		public function onTouch(e:TouchEvent):void {
			
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) return;
			
			 var pos:Point = new Point(touch.globalX,touch.globalY);
			
			switch(touch.phase) {
				
				case TouchPhase.BEGAN:
					if (touch.tapCount != 2) {
						if (!touched) {
							touched = true;
							touchPoint = pos;
						}
					}
				break;
				
				case TouchPhase.MOVED:
					
					if (touched) {
						
						(e.currentTarget as DisplayObject).x += pos.x - touchPoint.x;
						(e.currentTarget as DisplayObject).y += pos.y - touchPoint.y;
						if ((e.currentTarget as DisplayObject).x > 500) (e.currentTarget as DisplayObject).x = 500;
						if ((e.currentTarget as DisplayObject).x < -500) (e.currentTarget as DisplayObject).x = -500;
						if ((e.currentTarget as DisplayObject).y > 550) (e.currentTarget as DisplayObject).y = 550;
						if ((e.currentTarget as DisplayObject).y < -550) (e.currentTarget as DisplayObject).y = -550;
						touchPoint = pos;
					}
				break;
				
				case TouchPhase.ENDED:
					touched = false;
				break;
				
			}
			
			if (touch.phase == TouchPhase.BEGAN) {
				
				if (touch.tapCount != 2) {
					
					if (!touched) {
						touched = true;
					}
				}
			}
		}
		
		public function sort_sprites_function(a:DisplayObject, b:DisplayObject):int {
			if(a.y == 0) return -1;
			if (a.y < b.y) 
			{ 
				return -1; 
			} 
			else if (a.y > b.y) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
				
		}
		
		public function sort_array_objects(a:Object, b:Object):int {
			
			if (a.object_id < b.object_id) 
			{ 
				return -1; 
			} 
			else if (a.object_id > b.object_id) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
				
		}
		
		public function returnMissionScreen():void {
			
			connect.setVehicleStat(globalResources.user_id, "body", globalResources.profileData.vehicleData.body as String);
			connect.setVehicleStat(globalResources.user_id, "cryogel", globalResources.profileData.vehicleData.cryogel as String);
			connect.setVehicleStat(globalResources.user_id, "fuel", globalResources.profileData.vehicleData.fuel as String);
			connect.setVehicleStat(globalResources.user_id, "velocity", globalResources.profileData.vehicleData.velocityValue as String);
			connect.setVehicleStat(globalResources.user_id, "bodiesBought", (globalResources.profileData.vehicleData.bodiesBought as Array).join(","));
			
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen", megatile_id: megatile_id}, true));
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			
			connect = null;
			
			trophySprite.dispose();
			trophySprite = null;
			labSprite.dispose();
			labSprite = null;
			dialogSprite.dispose();
			dialogSprite = null;
			junkyardSprite.dispose();
			junkyardSprite = null;
			hudSprite.dispose();
			hudSprite = null;
			junkBackground.dispose();
			junkBackground = null;
			trophyBackground.dispose();
			trophyBackground = null;
			
			for (var i:int = 0; i < trophiesAndJunk.length; ++i) {
				
				trophiesAndJunk[i].dispose();
				trophiesAndJunk[i] = null;
				
			}
			
			trophiesAndJunk.splice(0, trophiesAndJunk.length);
			trophiesAndJunk = null;
			
			for (var j:int = 0; j < myObjects.length; ++j) {
				
				myObjects[j] = null;
				
			}
			
			myObjects.splice(0, myObjects.length);
			myObjects = null;
			
			super.dispose();
			
		}
		
	}

}