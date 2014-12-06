package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Clases.Dialogs;
	import com.tucomoyo.aftermath.Clases.FacebookFriendList;
	import com.tucomoyo.aftermath.Clases.MegaMapButton;
	import com.tucomoyo.aftermath.Clases.MegamapManager;
	import com.tucomoyo.aftermath.Clases.Megatile;
	import com.tucomoyo.aftermath.Clases.MissionTargets;
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.Engine.scrollBar;
	import com.tucomoyo.aftermath.Engine.TaskObject;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
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
	public class MegaMap extends Scene 
	{
		public static const ButtonsAssets:String = "Botones";
		public static const ScreenAssets:String = "screens";
		
		public var connect:Connection;
		
		public var textShowned:Boolean;
		public var comicBtnClick:Boolean;
		public var optionBtnClick:Boolean;
		public var swipeOpen:Boolean = false;
		
		public var targetDialogs:Sprite = new Sprite();
		private var megaMapSprite:Sprite = new Sprite();
		private var dialogSprite:Sprite = new Sprite();
		
		private var megaMapName:String;
		private var megaMapId:int;
		private var megaMapWidth:int;
		private var megaMapHeight:int;
		private var LastMegaMapId:int;
		private var megaTiles:Array = new Array();
		
		
		private var currentMegaTile:int = 0;
		private var missionsCompleted:int = 0;
		
		private var direction:Array;
		
		
		private var upBtn:MegaMapButton;
		private var rightBtn:MegaMapButton;
		private var downBtn:MegaMapButton;
		private var leftBtn:MegaMapButton;
		
		private var megamapManager:MegamapManager;
		
		private var comicsList:Vector.<Object> = new Vector.<Object>;
		private var megamapsList:Vector.<Object> = new Vector.<Object>;
		private var buttonsVec:Vector.<MegaMapButton> = new Vector.<MegaMapButton>;
		public var targetsMissionInfo:Vector.<Object> = new Vector.<Object>;
		public var megaTilesVec:Vector.<Megatile> = new Vector.<Megatile>;
		
		public var comicListDialog:Dialogs;
		public var optionDialog:Dialogs;
		public var megaMapDialog:Dialogs;
		public var congratzDialog:Dialogs;
		public var slideMenu:Dialogs;
		public var dialogQuad:Quad = new Quad(760, 400, 0x000000);
		
		private var megaMapTexts:Object = new Object();;
		
		private var tween:Tween;
		private var tween2:Tween;
		private var dialogSwipeTween:Tween;
		
		public function MegaMap(_globalResources:GlobalResources, _params:int = 0 ) 
		{
			super(_globalResources);
			connect = new Connection();
			if (_params > 0) _params = _params - 1;
			currentMegaTile = _params;
			trace("currentMegaTile: " + currentMegaTile);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
			this.addEventListener(GameEvents.TILE_UNLOCK, animateToTileUnlock);
		}
		
		public function onAddedtoStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
			
			texturesScene.addTexture(ScreenAssets, "Backgrounds");
			texturesScene.addTexture(ButtonsAssets, "Buttons");
			texturesScene.addTexture("Gui", "Buttons");
			
			soundsScene.addSound("BGM_mission_screen", -1);
			soundsScene.addSound("Gui_Button_accept", 0);
			soundsScene.addSound("Gui_Button_click", 0);
			soundsScene.addSound("Gui_Button_denied", 0);
			soundsScene.addSound("Fanfare", 0);
			
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, loadUserInfo);
			texturesScene.loadTextureAtlas();
		}
		
		public function loadUserInfo():void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onUserInfoRecived);
			//connect.loadUserLastMegamap(parseInt(globalResources.user_id), lastMegamapId);
			connect.loadLocalJson(globalResources.pref_url, "userMegamapsInfo");
		}
		
		private function onUserInfoRecived(e:GameEvents = null):void
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onUserInfoRecived);
			
			var json:Object = e.params;
			var tempObj:Object;
			var i:int = 0;
			var j:int = 0;
			
			LastMegaMapId = json.lastMegamapId;
			
			while (json.megamapList[i] != undefined) {
				
				tempObj = new Object();
				tempObj.available = json.megamapList[i].available;
				tempObj.name = json.megamapList[i].name;
				tempObj.posX = json.megamapList[i].posX;
				tempObj.posY = json.megamapList[i].posY;
				tempObj.description = json.megamapList[i].description;
				tempObj.id = json.megamapList[i].id;
				
				megamapsList.push(tempObj);
				tempObj = null;
				
				i++;
			}
			
			while (json.comicList[j] != undefined) {
				
				tempObj = new Object();
				tempObj.name = json.comicList[j].name;
				tempObj.description = json.comicList[j].description;
				tempObj.numImages = json.comicList[j].numImages;
				tempObj.imageUrl = json.comicList[j].imageUrl;
				
				comicsList.push(tempObj);
				tempObj = null;
				
				j++;
			}
			
			loadMissionInfo();
		}
		
		public function loadMissionInfo():void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onRequestRecived);
			connect.get_megamap(parseInt(globalResources.user_id));
		}
		
		private function onRequestRecived(e:GameEvents = null):void
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onRequestRecived);
			
			var json:Object = e.params;
			var i:int = 0;
			var k:int = 0;
			var j:int = 0;
			var tileInfo:Object;
			var array:Array;
			
			(json as Array).sort(sort_missions_function);
			
			while (json[i] != undefined) {
				
				megaMapId = json[i].id;
				megaMapName = json[i].name;
				megaMapWidth = json[i].width;
				megaMapHeight = json[i].height;
				
				//textShowned = Boolean(json[i].comLink.View);
				//megaMapTexts.text1 = json[i].comLink[globalResources.idioma].text1;
				//megaMapTexts.text2 = json[i].comLink[globalResources.idioma].text2;
				//megaMapTexts.text3 = json[i].comLink[globalResources.idioma].text3;
				
				(json[i].megatile_list as Array).sort(sort_missions_function);
				
				while (json[i].megatile_list[k] != undefined) {
					
					var objeto:Object = new Object;
					objeto.megaTileId = json[i].megatile_list[k].id;
					objeto.megaTileName = json[i].megatile_list[k].name;
					objeto.megaTileUnlocked = Boolean(json[i].megatile_list[k].unlocked);
					array = new Array();
						while (json[i].megatile_list[k].mission_list[j] != undefined) {
							
							tileInfo = new Object();
							tileInfo.category = json[i].megatile_list[k].mission_list[j].category;
							tileInfo.missionImage = json[i].megatile_list[k].mission_list[j].picture;
							if (globalResources.idioma == "Español")tileInfo.missionDescription = json[i].megatile_list[k].mission_list[j].description;
							if (globalResources.idioma == "Ingles")tileInfo.missionDescription = json[i].megatile_list[k].mission_list[j].description_eng;
							tileInfo.mission_id = json[i].megatile_list[k].mission_list[j].mission_id;
							tileInfo.source = json[i].megatile_list[k].mission_list[j].source;
							tileInfo.extras = json[i].megatile_list[k].mission_list[j].extras;
							tileInfo.megatile_id = json[i].megatile_list[k].mission_list[j].megatile_id;
							tileInfo.missionCompleted = Boolean(json[i].megatile_list[k].mission_list[j].finished);
							tileInfo.targetPosition = new Point(json[i].megatile_list[k].mission_list[j].targetPositionX, json[i].megatile_list[k].mission_list[j].targetPositionY);
							tileInfo.id = json[i].megatile_list[k].mission_list[j].id;
							tileInfo.name = json[i].megatile_list[k].mission_list[j].name;
							tileInfo.mission_score = (json[i].megatile_list[k].mission_list[j].mission_score == null)?0:json[i].megatile_list[k].mission_list[j].mission_score;
							
							array.push(tileInfo);
							
							if (j == 1 && json[i].megatile_list[k].mission_list[j].mission_id == 2 && json[i].megatile_list[k].mission_list[j].finished == 0) {
								break;
							}
							
							tileInfo = null;
							j++;
						}
					j = 0;
					objeto.megaTileTargets = array;
					array = null;
					megaTiles.push(objeto);
					objeto = null;
					k++;
				}
				
				i++
			}
			
			direction = new Array([1, 0, megaMapWidth], [0, 1, 1], [-1, 0, -megaMapWidth], [ 0, -1, -1]);
			//loadComicList();
			drawMissionScreens();
		}
		
		public function loadComicList():void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onListRecived);
			connect.get_src_mission(globalResources.pref_url+"comicList.json");
			
		}
		
		private function onListRecived(e:GameEvents = null):void
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onListRecived);
			
			var json:Object = e.params;
			var tempObj:Object;
			var i:int=0;
			
			while (json.comicList[i] != undefined) {
				
				tempObj = new Object();
				tempObj.name = json.comicList[i].name;
				tempObj.description = json.comicList[i].description;
				tempObj.numImages = json.comicList[i].numImages;
				tempObj.imageUrl = json.comicList[i].imageUrl;
				
				comicsList.push(tempObj);
				tempObj = null;
				
				i++;
			}
			drawMissionScreens();
		}
		
		public function drawMissionScreens():void {
			var megatile:Megatile;
			var megaTileObject:Object;
			
			soundsScene.getSound("BGM_mission_screen").play(globalResources.volume);
			
			dialogQuad.alpha = 0.5;
			dialogQuad.visible = false;
			dialogQuad.addEventListener(TouchEvent.TOUCH, dialogsOff);
			dialogSprite.addChild(dialogQuad);
			
			globalResources.setCountSplash(megaTiles.length);
			
			for (var i:uint = 0; i < megaTiles.length;++i) {
				
				megaTileObject = new Object();
				megaTileObject.megaTileInfo = megaTiles[i];
				megatile = new Megatile(globalResources, texturesScene, soundsScene, megaTileObject);
				megatile.x = (i % megaMapWidth) * 760;
				megatile.y = -( int (i / megaMapWidth) * 400);
				megaMapSprite.addChild(megatile);
				megaTilesVec.push(megatile);
				megaTileObject = null;
				
				for (var j:int = 0; j < (megaTiles[i].megaTileTargets as Array).length; j++) 
				{
					if (megaTiles[i].megaTileTargets[j].missionCompleted == 1) missionsCompleted++;
				}
				
			}
			megaMapSprite.x = -760 * (currentMegaTile % megaMapWidth);
			megaMapSprite.y = 400 * int (currentMegaTile / megaMapWidth);
			addChild(megaMapSprite);
			
			var guiAvatar:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiAvatar"));
			guiAvatar.x = 620;
			guiAvatar.touchable = false;
			tempData.push(guiAvatar);
			this.addChild(guiAvatar);
			guiAvatar = null;
			
			var userName:TextField = new TextField(106, 17, "Lt. " + globalResources.user_lastName, globalResources.fontName, 14, 0xffffff);
			userName.x = 650;
			userName.y = 116;
			userName.hAlign = "right";
			userName.vAlign = "top";
			tempData.push(userName);
			this.addChild(userName);
			userName = null;
			
			var userImage:ImageLoader = new ImageLoader (globalResources.picture_url, globalResources.loaderContext, 80, 80);
			userImage.x = 666;
			userImage.y = 10;
			tempData.push(userImage);
			this.addChild(userImage);
			userImage = null;
			
			var megamapBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("configBtn"));
			megamapBtn.x = 690;
			megamapBtn.y = 210;
			megamapBtn.addEventListener(Event.TRIGGERED, onMegamapBtn);
		//	this.addChild(megamapBtn);
			
			upBtn = new MegaMapButton("UP",texturesScene.getAtlas(ButtonsAssets).getTexture("guiArrow"));
			upBtn.alignPivot();
			upBtn.rotation = 1.57;
			upBtn.x = 380;
			upBtn.y = 20;
			upBtn.addEventListener(Event.TRIGGERED, spriteMoveAnimation);
			upBtn.visible = false;
			this.addChild(upBtn);
			buttonsVec.push(upBtn);
			
			rightBtn = new MegaMapButton("RIGHT",texturesScene.getAtlas(ButtonsAssets).getTexture("guiArrow"));
			rightBtn.x = 740;
			rightBtn.y = 200;
			rightBtn.rotation = 3.14;
			rightBtn.addEventListener(Event.TRIGGERED, spriteMoveAnimation);
			rightBtn.visible = false;
			this.addChild(rightBtn);
			buttonsVec.push(rightBtn);
			
			downBtn = new MegaMapButton("DOWN",texturesScene.getAtlas(ButtonsAssets).getTexture("guiArrow"));
			downBtn.alignPivot();
			downBtn.rotation = -1.57;
			downBtn.x = 380
			downBtn.y = 370;
			downBtn.addEventListener(Event.TRIGGERED, spriteMoveAnimation);
			downBtn.visible = false;
			this.addChild(downBtn);
			buttonsVec.push(downBtn);
			
			leftBtn = new MegaMapButton("LEFT",texturesScene.getAtlas(ButtonsAssets).getTexture("guiArrow"));
			leftBtn.x = 10;
			leftBtn.y = 200;
			leftBtn.addEventListener(Event.TRIGGERED, spriteMoveAnimation);
			leftBtn.visible = false;
			this.addChild(leftBtn);
			buttonsVec.push(leftBtn);
			
			//slideMenu = new Dialogs(globalResources, texturesScene, soundsScene, (megaMapSprite.x + 724), (megaMapSprite.y + 240));
			slideMenu = new Dialogs(globalResources, texturesScene, soundsScene, 730,240);
			slideMenu.megamapDeployableMenu();
			slideMenu.useHandCursor = true;
			slideMenu.addEventListener(TouchEvent.TOUCH, swipeAnimation);
			this.addChild(slideMenu);
			
			var friendList:FacebookFriendList = new FacebookFriendList(globalResources, texturesScene, connect);
			friendList.x = 10;
			friendList.y = 10;
			addChild(friendList);
			
			showButtons();
			
			createComicList();
			//createMegaMapDialog();
			createMegamapSelection();
			createOptionDialog();
			addChild(dialogSprite);
			
			trace("Missions completed: " + missionsCompleted);
			checkUnlockedMissions();
			
			globalResources.trackPageview("/MegaMap Screen");
			globalResources.trackEvent("Screen View", "user: " + globalResources.user_id, "Mission Screen");
			
			//completeMegamapDialog();
		}
		
		public function showButtons():void {
			var nextDirect:int;
			var i:int;
			var j:int;
			
			for (var k:uint = 0; k < direction.length; k++) 
			{
				i = int( currentMegaTile / megaMapWidth);
				j = (currentMegaTile % megaMapWidth);
				nextDirect = currentMegaTile + direction[k][2];
				
				if ((i+direction[k][0]) > -1 && (i+direction[k][0]) < megaMapWidth && (j+direction[k][1]) > -1 && (j+direction[k][1]) < megaMapHeight && megaTiles[nextDirect].megaTileUnlocked) {
					//trace(megaTiles[nextDirect].megaTileUnlocked, nextDirect);
					buttonsVec[k].visible = true;
				} else {
					buttonsVec[k].visible = false;
				}
			}
			
		}
		
		public function hideButtons():void 
		{
			upBtn.visible = false;
			rightBtn.visible = false;
			downBtn.visible = false;
			leftBtn.visible = false;
		}
		
		public function spriteMoveAnimation(e:Event):void {
			
			hideButtons();
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			var button:MegaMapButton;
			button = (e.currentTarget as MegaMapButton);
			//trace("moved " + button.type);
			
			if (tween != null) 
			{
				Starling.juggler.remove(tween);
				tween = null;
			}
			
			tween = new Tween(megaMapSprite, 0.20);
			
				switch (button.type) 
				{
					case "UP":
						currentMegaTile += direction[0][2];
						tween.moveTo(megaMapSprite.x,megaMapSprite.y+400);
					break;
					case "RIGHT":
						currentMegaTile += direction[1][2];
						tween.moveTo(megaMapSprite.x-760,megaMapSprite.y);
					break;
					case "DOWN":
						currentMegaTile += direction[2][2];
						tween.moveTo(megaMapSprite.x,megaMapSprite.y-400);
					break;
					case "LEFT":
						currentMegaTile += direction[3][2];
						tween.moveTo(megaMapSprite.x+760,megaMapSprite.y);
					break;
				}
			//trace("currentMegaTile: "+ currentMegaTile);
			Starling.juggler.add(tween);
			tween.onComplete = showButtons;
		}
		
		public function sort_missions_function(a:Object, b:Object):int {
			
			if (a.id < b.id) 
			{ 
				return -1; 
			} 
			else if (a.id > b.id) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
				
		}
		
		public function createComicList():void {
			
			comicListDialog = new Dialogs(globalResources, texturesScene, soundsScene, 58, 44);
			comicListDialog.createComicList(comicsList);
			comicListDialog.visible = false;
			dialogSprite.addChild(comicListDialog);
		}
		
		public function createOptionDialog():void {
			optionDialog = new Dialogs(globalResources, texturesScene, soundsScene, 105, 84);
			optionDialog.createOptionScreen();
			optionDialog.visible = false;
			dialogSprite.addChild(optionDialog);
		}
		
		public function onTrophyRoom():void {
			globalResources.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Mission Screen: Trophy Button");
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"myTrophyRoomScreen", megatile_id: megaTiles[currentMegaTile].megaTileId}));
		}
		
		public function onOptionBtn():void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			optionDialog.visible = true;
			optionBtnClick = true;
			dialogQuad.visible = true;
			
		}
		
		public function onComicBtn():void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			comicListDialog.visible = true;
			comicListDialog.megatile_id = megaTiles[currentMegaTile].megaTileId;
			comicBtnClick = true;
			dialogQuad.visible = true;
			
		}
		
		public function createMegamapSelection():void {
			
			megamapManager = new MegamapManager(globalResources, texturesScene, soundsScene, megamapsList);
			megamapManager.visible = false;
			dialogSprite.addChild(megamapManager);
		}
		
		public function createMegaMapDialog():void {
			//if (!textShowned) 
			//{	
				//megaMapDialog = new Dialogs(globalResources, texturesScene, soundsScene, 220, 140);
				//megaMapDialog.multiDialog(3, megaMapTexts);
				//dialogSprite.addChild(megaMapDialog);
			//}
		}
		
		public function onMegamapBtn(e:Event):void {
			soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
			megamapManager.visible = true;
		}
		
		public function dialogsOff(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) 
			{
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN) 
			{
				comicListDialog.visible = false;
				optionDialog.visible = false;
				dialogQuad.visible = false;
				if (congratzDialog != null) congratzDialog.visible = false;
			}
		}
		
		public function checkUnlockedMissions():void
		{
			//trace("check unlock mission");
			var numMission:int;
			
			if (missionsCompleted == 12) 
			{
				completeMegamapDialog();
				return;
			}
			
			for (var i:int = 0; i < currentMegaTile+1; i++) 
			{
				numMission = numMission + megaTiles[i].megaTileTargets.length;
			}
			
			
			if (missionsCompleted == numMission && !megaTiles[currentMegaTile+1].megaTileUnlocked)
			{
				unlockMegatiles(currentMegaTile+1);
			}
		}
		
		public function unlockMegatiles(_megatileid:int):void
		{
			trace("Unlock megatile: " + _megatileid);
			
			dialogQuad.visible = true;
			
			soundsScene.getSound("Fanfare").play(globalResources.volume);
			var newMegatileDialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 200, 100);
			newMegatileDialog.multiDialog(4);
			dialogSprite.addChild(newMegatileDialog);
			
			connect.unlockMegatile(parseInt(globalResources.user_id), megaTiles[_megatileid].megaTileId);
		}
		
		public function completeMegamapDialog():void
		{
			trace("Megatile Completed");
			
			soundsScene.getSound("Fanfare").play(globalResources.volume);
			congratzDialog = new Dialogs(globalResources, texturesScene, soundsScene);
			congratzDialog.megamapEndedDialog();
			dialogSprite.addChild(congratzDialog);
			
			//globalResources.trackEvent("Completed Megamap", "user: " + globalResources.user_id, "Megamap " + megaMapName);
		}
		
		public function updateLastMegamap(_megamapId:int):void
		{
			connect.changeCurrentMegamap(parseInt(globalResources.user_id), _megamapId);
			
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"missionScreen", megatile_id:0}));
		}
		
		public function animateToTileUnlock(e:Event):void {
			
			trace("Me llego new megatile");
			dialogQuad.visible = false;
			
			if (tween2 != null) 
			{
				Starling.juggler.remove(tween2);
				tween2 = null;
			}
			
			tween2 = new Tween(megaMapSprite, 0.20);
			if (currentMegaTile % megaMapWidth == 1)
			{
				currentMegaTile++;
				tween2.moveTo(0, megaMapSprite.y + 400);
			}else {
				currentMegaTile += direction[1][2];
				tween2.moveTo(megaMapSprite.x - 760, megaMapSprite.y);
			}
			megaTiles[currentMegaTile].megaTileUnlocked = true;
			
			Starling.juggler.add(tween2);
			tween2.onComplete = showButtons;
		}
		
		public function swipeAnimation(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) 
			{
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN) 
			{
				if (!swipeOpen) 
				{
					dialogSwipeTween = new Tween(slideMenu, 0.3, Transitions.EASE_IN_OUT_BACK);
					dialogSwipeTween.moveTo(583,240);
					Starling.juggler.add(dialogSwipeTween);
					swipeOpen = true;
				} else {
					dialogSwipeTween = new Tween(slideMenu, 0.3, Transitions.EASE_IN_OUT_BACK);
					dialogSwipeTween.moveTo(730,240);
					Starling.juggler.add(dialogSwipeTween);
					swipeOpen = false;
				}
			}
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			
			connect = null;
			targetDialogs = null;
			megaMapSprite = null;
			dialogSprite = null;
			
			Starling.juggler.remove(tween);
			tween = null;
			
			Starling.juggler.remove(tween2);
			tween2 = null;
			
			for (var a:int = 0; a < megaTilesVec.length; ++a ) {
				
				megaTilesVec[a].dispose();
				megaTilesVec[a] = null
				
			}
			megaTilesVec.splice(0, megaTilesVec.length);
			
			for (var i:int = 0; i < targetsMissionInfo.length; ++i ) {
				
				targetsMissionInfo[i] = null
				
			}
			targetsMissionInfo.splice(0, targetsMissionInfo.length);

			for (var j:int = 0; j < buttonsVec.length; ++j ) {
				
				buttonsVec[j].dispose();
				
			}
			buttonsVec.splice(0, buttonsVec.length);
			
			for (var k:int = 0; k < megaTiles.length; ++k ) {
				
				megaTiles[k] = null
				
			}
			megaTiles.splice(0, megaTiles.length);
			
			for (var l:int = 0; l < comicsList.length; ++l ) {
				
				comicsList[l] = null
				
			}
			comicsList.splice(0, comicsList.length);
			
			super.dispose();
		}
		
	}

}