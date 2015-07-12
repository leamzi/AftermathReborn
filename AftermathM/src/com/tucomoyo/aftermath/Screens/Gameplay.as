package com.tucomoyo.aftermath.Screens 
{
    import com.tucomoyo.aftermath.Clases.Chopper;
	import com.tucomoyo.aftermath.Clases.CrystalSpawn;
	import com.tucomoyo.aftermath.Clases.DashGlider;
	import com.tucomoyo.aftermath.Clases.Dialogs;
    import com.tucomoyo.aftermath.Clases.MissionHUD;
    import com.tucomoyo.aftermath.Clases.MissionMap;
	import com.tucomoyo.aftermath.Clases.NpcBonusLoot;
    import com.tucomoyo.aftermath.Clases.Objetos;
	import com.tucomoyo.aftermath.Clases.Particle;
	import com.tucomoyo.aftermath.Clases.ScoreManager;
	import com.tucomoyo.aftermath.Clases.SlimeLauncher;
    import com.tucomoyo.aftermath.Connections.Connection;
    import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.Npc;
    import com.tucomoyo.aftermath.Engine.Scene;
    import com.tucomoyo.aftermath.Engine.TileManager;
    import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import nape.geom.Vec2;
	import nape.space.Space;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
    import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    /**
     * ...
     * @author Predictvia
     */
    public class Gameplay extends Scene 
    {
        public static const RAIZ2:Number = Math.sqrt(2);
        public static const I_RAIZ2:Number = 1 / RAIZ2;
        
		private var missionObjects:Array = new Array();
		private var pickedObjectsId:Array = new Array();
		private var destroyedCrystalsId:Array = new Array();
		public var myWorldObjects:Array = new Array();
		public var missionPickupObjectId:Array = new Array();
		public var destroyedObjects:Array = new Array();
		public var destroyedObjectsID:Array = new Array();
		private var saveTrophieroomArray:Array = new Array();
		private var saveTrophieroomTypeArray:Array = new Array();
		
		public var activeShot:Boolean = false;
		private var dropClicked:Boolean = false;
		private var exitMissionDialog:Boolean = true;
		private var nearHatch:Boolean = false;
		private var hatchRange:Boolean = false;
		public var isPaused:Boolean = false;
		public var shuttleSent:Boolean = false;
		public var meterWarning:Boolean = false;
		public var onUse:Boolean = false;
		private var targetLock:Boolean = false;
		public var missionState01:Boolean = false;
		public var missionState02:Boolean = false;
		public var missionState03:Boolean = false;
		private var dropedItem:Boolean = false;
		private var playedMission:Boolean = false;
		private var soundTargetOn:Boolean = false;
		private var completeMission:Boolean = false;
		public var ghostMission:Boolean = false;
		public var bonusMission:Boolean = false;
		
		private var bonusLoot:NpcBonusLoot;
		
        private var connect:Connection;
		private var chopper:Chopper;
		
		private var objectsDictionary:Dictionary = new Dictionary();
		
		private var tileFactor:Number;
        private var tileRelation:Number;
        private var tileProyection:Number;
        
		private var gameplayBackground:ImageLoader;
		
        private var eCorrotion:int;
		public var mouseX:int;
        public var mouseY:int;
        private var totalCrystalPercentage:int;
		private var pauseID:int;
		private var bulletLevelCount:int;
        private var bulletLevel:int;
		private var aoeRange:int;
		private var quoteCount:int;
		private var random:int;
		public var maxSpawns:int;
		public var maxSlime:int;
		public var timeSpawn:int = 10;
		public var countTimeSpawn:int = 0;
		private var aoeDelay:int = 0;
		private var aoeCount:int = 0;
		private var timerSec:int = 0;
		private var missionMegatileId:int;
		public var currentCoins:int;
        
		private var hud:MissionHUD;
        private var world:MissionMap;
        
		private var aoeCurrentObject:Object;
		private var missionData:Object;
		public var missionSource:Object;
		private var targetObject:Objetos;
		private var targetEnemie:Npc;
		
		private var bullet:Particle;
		private var targetPosition:Point;
		
		private  var pauseQuad:Quad;
		private  var invisibleQuad:Quad;
		
		private var mission_Id:String;
		private var mission_use_id:int;
		
		public var missionTime:int;
		public var gameplayTime:Timer = new Timer(1000);
		public var aoeAnimationTime:Timer = new Timer(200);
		
		public var scoreTablet:ScoreManager = new ScoreManager();
        
		private var cryogelBullets:Vector.<Particle> = new Vector.<Particle>;
        public var mapPickups:Vector.<Objetos> = new Vector.<Objetos>;
		public var enemies:Vector.<CrystalSpawn> = new Vector.<CrystalSpawn>();
		public var slimeEnemies:Vector.<SlimeLauncher> = new Vector.<SlimeLauncher>();
		public var dashEnemies:Vector.<DashGlider> = new Vector.<DashGlider>();
		public var aoeTargetsVect:Vector.<Object> = new Vector.<Object>;
        
        public function Gameplay(_globalResources:GlobalResources, params:Object = null ) 
        {
            
            super(_globalResources);
            globalResources = _globalResources;
            mission_Id = params.missionId;
			mission_use_id = params.mission_user_id;
			missionData = params;
			missionMegatileId = params.megatile_id;
			ghostMission = params.missionCompleted;
			bonusMission = (params.bonusMission!=null)?true:false;
			
			trace("Ghost Mission = " + ghostMission);
			
            connect = new Connection();
			globalResources.isInTutorial = false;
            
            this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }
        
        public function onAdded(e:Event):void {
			
			trace("Megatile id: " + missionMegatileId);
            
            this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            
			soundsScene.addSound("gas_cryo_pickup", 0);
			soundsScene.addSound("crystal_explode01", 0);
			soundsScene.addSound("crystal_explode02", 0);
			soundsScene.addSound("charge_start", 0);
			soundsScene.addSound("charge_loop", -1);
			soundsScene.addSound("crioshot_lvl_001", 0);
			soundsScene.addSound("crioshot_lvl_002", 0);
			soundsScene.addSound("crioshot_lvl_003", 0);
			soundsScene.addSound("target_lock", 0);
			soundsScene.addSound("chargeMeter", 0);
			soundsScene.addSound("hatch_open", 0);
			soundsScene.addSound("hatch_close", 0);
			soundsScene.addSound("chopper_full", -1);
			soundsScene.addSound("beep_alert", -1);
			soundsScene.addSound("BGM_RoadWorn", -1);
			soundsScene.addSound("MissionComplete", 0);
			soundsScene.addSound("explosive", 0);
			soundsScene.addSound("chopper_destroyed", 0);
			soundsScene.addSound("Gui_Button_accept", 0);
			soundsScene.addSound("Gui_Button_click", 0);
			soundsScene.addSound("Gui_Button_denied", 0);
			soundsScene.addSound("chopper_voice/ok", 0);
			soundsScene.addSound("chopper_voice/got it", 0);
			soundsScene.addSound("chopper_voice/lock_and_load", 0);
			soundsScene.addSound("chopper_voice/move_in", 0);
			soundsScene.addSound("score", 0);
			
            texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, onAtlasLoad);
            texturesScene.addTexture("screens", "Backgrounds");
            texturesScene.addTexture("Botones", "Buttons");
            texturesScene.addTexture("Gui", "Buttons");
            texturesScene.addTexture("chooperFull", "vehicles");
            texturesScene.addTexture("chopper", "vehicles");
            texturesScene.addTexture("vehicle", "vehicles");
            texturesScene.addTexture("Buildings", "World");
            texturesScene.addTexture("worldObjects", "World");
            texturesScene.addTexture("Animations", "World");
			texturesScene.addTexture("vehicleShield", "vehicles");
			texturesScene.addTexture("vehicleExplosion", "vehicles");
			texturesScene.addTexture("crystalSpawn", "Npc");
            texturesScene.loadTextureAtlas();
            
        }
        
        
        public function initGamePlay(e:flash.events.Event):void {
            
            tileFactor = RAIZ2 / world.tilemap.tileHeight;
            tileProyection = world.tilemap.tileHeight * world.tilemap.mapHeight * RAIZ2 * 0.25;
            tileRelation = world.tilemap.tileHeight / world.tilemap.tileWidth;
            
            world.createObstacles();
            world.createUsables();
			world.createExplotions();
			world.createPickups(mapPickups);
			world.tilemap.crear_tilemap(bodiesScene.space);
			world.set_missionStart();
			
			addChild(gameplayBackground);
            addChild(world);
            
            pauseQuad = new Quad(stage.width, stage.height, 0x000000);
			pauseQuad.alpha = 0.75;
			pauseQuad.visible = false;
			tempData.push(pauseQuad);
			addChild(pauseQuad);
			
            chopper = new Chopper(texturesScene, soundsScene, globalResources);
            chopper.vehicleBody.position.x = world.tilemap.startMission.x;
            chopper.vehicleBody.position.y = world.tilemap.startMission.y-95;
			chopper.x = 360;
			chopper.y = 265;
			chopper.scaleX = 0;
			chopper.scaleY = 0;
			chopper.visible = false;
			chopper.vehicleBody.space = this.bodiesScene.space;
            addChild(chopper);
			chopper.update(null, 380, 200, new Point(world.x, world.y));
			
			hud = new MissionHUD(globalResources, texturesScene);
			
            hud.activateObjectCount(mapPickups.length);
			hud.scoreTablet.pastScore = scoreTablet.pastScore;
			hud.scoreTablet.flight = scoreTablet.flight;
			scoreTablet = null;
			//hud.addChild(scoreTablet.scoreText);
			addChild(hud);
			
			world.miniWorldMap.addMiniVehicle(new Point(world.tilemap.startMission.x,world.tilemap.startMission.x),texturesScene);
			hud.addChild(world.miniWorldMap);
			
            this.addEventListener(TouchEvent.TOUCH, onMouse);
            this.addEventListener(Event.ENTER_FRAME, onUpdate);
            this.addEventListener(GameEvents.PICK_OBJECT, pickUpObject);
			this.addEventListener(GameEvents.DESTROY_CRYSTAL, onDestroyCrystal);
			this.addEventListener(GameEvents.DESTROY_PICKUP, onDestroyPickup);
			this.addEventListener(GameEvents.GAME_STATE, gameCurrentState);
			this.addEventListener(GameEvents.DROP_OBJECT, onDropObject);
            this.addEventListener(GameEvents.MISCELLANEOUS_EVENTS, miscellaneousEvents);
			this.addEventListener(GameEvents.STATE_ALERT, onAlert);
			this.addEventListener(GameEvents.ADD_BISHCOINS, miscellaneousEvents);
			
			eCorrotion = world.tilemap.tilemap_obstacules.length - destroyedCrystalsId.length;
			corrotionPercentage(world.tilemap.tilemap_obstacules.length );
			
            globalResources.deactivateSplash();
            globalResources.trackPageview("/Gameplay Mission " + mission_Id);
			
			
			aoeAnimationTime.start();
			aoeAnimationTime.addEventListener(TimerEvent.TIMER,onAnimationTimer);
			
			world.soundsScene.getSound("BGM_RoadWorn").play(globalResources.volume);
			world.hatchObj.hatchDoor.play();
			world.hatchObj.hatchDoor.addEventListener(Event.COMPLETE, onCompleteHatch);
			
			var musicPlaying:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 200, 330);
			musicPlaying.fadeOutAlerts(globalResources.textos[globalResources.idioma].Screens.GamePlay.Music);
			musicPlaying.touchable = false;
			addChild(musicPlaying);
			
			invisibleQuad = new Quad(stage.width, stage.height, 0x000000);
			invisibleQuad.alpha = 0;
			invisibleQuad.visible = false;
			tempData.push(invisibleQuad);
			addChild(invisibleQuad);
			
			create_dashEnemies();
			
			globalResources.trackEvent("Screen View", "user: " + globalResources.user_id, "Gameplay Screen Mission "+ mission_Id);
			
			aoeRange = globalResources.NpcInfo.aoeRange;
			timeSpawn = globalResources.NpcInfo.timeSpawn;
			hud.timeLimit = missionTime;
			hud.timer_text.text = (missionTime / 60 > 9) ? int(missionTime / 60) + ":": "0" + int(missionTime / 60) + ":";
			hud.timer_text.text += (missionTime % 60 > 9) ?  missionTime % 60 : "0" + missionTime % 60;
			
			gameplayTime.start();
			gameplayTime.addEventListener(TimerEvent.TIMER, onTimer);
			
			trace("AOE Range: "+aoeRange);
        }
		
		public function onCompleteHatch(e:Event):void {
			chopper.visible = true;
			var tween:Tween = new Tween(chopper, 1);
			tween.scaleTo(1);
			Starling.juggler.add(tween);
		}
        
        public function onAtlasLoad(e:GameEvents):void {
            
            texturesScene.removeEventListener(GameEvents.TEXTURE_LOADED, onSimpleTexturesLoad);
            
            bitmapsScene.addEventListener(GameEvents.TEXTURE_LOADED, onSimpleTexturesLoad);
            bitmapsScene.addTexture("BaseFloor", "World");//8mb
            bitmapsScene.addTexture("Debris", "World");//8mb
            bitmapsScene.loadTexture();
        }
        
        public function onSimpleTexturesLoad(e:GameEvents):void {
            
            bitmapsScene.removeEventListener(GameEvents.TEXTURE_LOADED, onSimpleTexturesLoad);
            connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveMissionSource);
			connect.get_src_mission(missionData.src);
            
        }
		
		/********************************************************
         * 
         * 				    LOAD FUNCIONS 
         * 
         * *****************************************************/
		
		public function onReciveMissionSource(e:GameEvents):void{
            
            connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveMissionSource);
			
			missionSource = e.params;
			
			for (var keys:String in missionSource.pickups){
				missionObjects.push(keys);
			}
			
			world = new MissionMap(globalResources, texturesScene, imageScene, soundsScene, bitmapsScene,objetosScene, bodiesScene,missionSource.map);
            
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onNPCinfo);
			connect.loadNpcInfo(globalResources.pref_url,mission_Id);
        }
		
		public function onNPCinfo(e:GameEvents):void{
            
            connect.removeEventListener(GameEvents.REQUEST_RECIVED, onNPCinfo);
			
			globalResources.NpcInfo = e.params;
			missionTime = (globalResources.NpcInfo.missionTime != undefined)? globalResources.NpcInfo.mission : 300;
			
			onGetObject();
		}

        public function onGetObject(e:GameEvents= null):void{
            
			world.createMiniMap();
			
			if (ghostMission) 
			{
				trace("Ghost Mission");
				getObject();
			} else {
				onReciveSave();
			}
			
        }
		
		public function create_dashEnemies():void {
			
			var dashNum:int = globalResources.NpcInfo.enemigoD.maxSpawn;
			
			maxSpawns = globalResources.NpcInfo.enemigoA.maxSpawn;
			
			maxSlime = globalResources.NpcInfo.enemigoC.maxSpawn;
			
			world.tilemap.setSpots(dashNum);
			
			for (var i:int = 0; i < dashNum; ++i ) {
				
				dashEnemies.push(new DashGlider(world.tilemap.spots[i*2], world.tilemap.spots[(i*2)+1], texturesScene, soundsScene, globalResources, "enemigoD"));
				dashEnemies[dashEnemies.length-1].objective = chopper;
				world.addChild(dashEnemies[dashEnemies.length-1]);
				
			}
			
		}
        
        private function onReciveSave(e:GameEvents = null):void
		{
			if(missionSource.state != undefined && missionSource.state.pickUps != undefined){
				world.savemissionMapObjects = missionSource.state.pickUps;
				pickedObjectsId = missionSource.state.pickUps;
				missionPickupObjectId = missionSource.state.missionObjectsId;
				world.savemissionMapCrystals = missionSource.state.crystals;
				destroyedCrystalsId = missionSource.state.crystals;
				world.destroymissionMapObjects = missionSource.state.destroyedObjects;
				destroyedObjects = missionSource.state.destroyedObjects;
				destroyedObjectsID = missionSource.state.destroyedObjectsID;
				playedMission = true;
				
				if (missionSource.state.scoreSave != undefined) {
					missionTime = missionSource.state.scoreSave.timeLapse;
					scoreTablet.pastScore = missionSource.state.scoreSave.parcialScore;
					scoreTablet.flight = missionSource.state.scoreSave.flight;
				}
				
			}
			getObject();
        }
		
		private function getObject():void
        {
            trace("Mission " + mission_Id, "Objects: " + missionObjects);
            connect.getObjects(missionObjects);
            connect.addEventListener(GameEvents.REQUEST_RECIVED, recieveObject);
        }
		
		public function recieveObject(e:GameEvents):void
		{
            connect.removeEventListener(GameEvents.REQUEST_RECIVED, recieveObject);
            var json:Object = e.params;
			var tempObject:Objetos;
            var i:int = 0;
			
			while (json[i] != undefined) {
				
				var objeto:Object = new Object();
				if (int(Math.random() * 4) == 1 && world.tilemap.tilemap_pickups[i].name=="Box")objeto.layerName = "CrystalPickups";
				else objeto.layerName = world.tilemap.tilemap_pickups[i].name;
				objeto.objectName =  world.tilemap.tilemap_pickups[i].name;
				objeto.objectInfo = json[i];
				objeto.objectInfo.letterType = world.tilemap.tilemap_pickups[i].type;
				objeto.objectPosition = world.tilemap.tilemap_pickups[i].pos;
				objeto.gridPosition = world.tilemap.tilemap_pickups[i].grid;
				objeto.ghostAlpha = ghostMission;
				tempObject = new Objetos(texturesScene, soundsScene, globalResources, objeto);
				mapPickups.push(tempObject);
				objectsDictionary[(tempObject.objectData.objectInfo.object_id) as String] = tempObject;
				tempObject = null;
				i++;
				
				if (world.tilemap.tilemap_pickups.length == i) break;
			}
			
			var random:int;
			random = int(Math.random() * 2);
			gameplayBackground = new ImageLoader("https://s3.amazonaws.com/tucomoyo-games/aftermath/external_images/Backgrounds/background_map_0"+ random+".png", globalResources.loaderContext, 760, 400);
			gameplayBackground._avatar.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, initGamePlay);
			
        }
		
        private function loadMyWorld():void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveMyWorld);
            connect.get_save_world(parseInt(globalResources.user_id));
		}
		
		private function onReciveMyWorld(e:GameEvents):void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveMyWorld);
			myWorldObjects = e.params as Array;
			getObject();
		}
		
		/********************************************************
         * 
         * 				    SAVE FUNCTIONS 
         * 
         * *****************************************************/
		
		private function saveMission(_save:Object, _extras:Object = null):void {
			
			var save:String;
			var extras:String = (_extras == null)?"":JSON.stringify(_extras);
			save = JSON.stringify(_save);
			connect.addEventListener(GameEvents.REQUEST_RECIVED, saveMissionComplete);
			connect.save_state(parseInt(globalResources.user_id), parseInt(missionSource.metadata.id), save, extras);
		}
		
		private function saveMissionComplete(e:GameEvents):void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, saveMissionComplete);
			if (!ghostMission) 
			{
				saveObjectsToTrophyroom();
			}else {
				saveObjectsToTrophyroomComplete();
			}
		}
		
		private function saveObjectsToTrophyroom():void 
		{
			connect.addEventListener(GameEvents.REQUEST_RECIVED, saveObjectsToTrophyroomComplete);
			for (var i:int = 0; i < missionPickupObjectId.length; i++) 
			{
				saveTrophieroomArray.push(missionPickupObjectId[i]);
				saveTrophieroomTypeArray.push("trophy");
			}
			
			for (var j:int = 0; j < destroyedObjectsID.length; j++) 
			{
				saveTrophieroomArray.push(destroyedObjectsID[j]);
				saveTrophieroomTypeArray.push("junk");
			}
			trace("Gameplay Save - Objects ID: " + saveTrophieroomArray.join(","));
			trace("Gameplay Save - Objects Type: " + saveTrophieroomTypeArray.join(","));
			
			connect.save_trophies_mission(parseInt(globalResources.user_id), parseInt(mission_Id), missionData.id, saveTrophieroomArray.join(","), saveTrophieroomTypeArray.join(","));
		}
		
		private function saveObjectsToTrophyroomComplete(e:GameEvents = null ):void {
			if (e!=null) connect.removeEventListener(GameEvents.REQUEST_RECIVED, saveObjectsToTrophyroomComplete);
			if (completeMission) { 
				connect.sendMissionComplete(parseInt(globalResources.user_id), mission_use_id, hud.scoreTablet.finalScore((missionTime-timerSec > 0)?(missionTime-timerSec):0,true));
				this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen", megatile_id: missionMegatileId}, true));
			} else {
				var _preScore:int = (ghostMission)?hud.scoreTablet.finalScore((missionTime-timerSec > 0)?(missionTime-timerSec):0,true):hud.scoreTablet.scoreObjectReturn((missionTime-timerSec > 0)?(missionTime-timerSec):0,true).parcialScore;
				connect.sendMissionScore(parseInt(globalResources.user_id), mission_use_id, _preScore);
				this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen", megatile_id: missionMegatileId}, true));
			}
		}
		
		private function saveMissionStatus():void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, saveMissionStatus);
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen", megatile_id: missionMegatileId}, true));
		}
		
		private function saveMissionStatusComplete(e:GameEvents):void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, saveMissionStatusComplete);
			this.dispose();
		}
		
        /********************************************************
         * 
         * 				      FUNCION UPDATE
         * 
         * *****************************************************/
        
        public function onUpdate(e:Event):void {
            chopper.canMove = true;
            bodiesScene.space.step(0.03125);
			
            world.update_world();
            
            chopper.targetCheked = false;
            chopper.nearObjPick = false;
          
            var auxX:int = (chopper.x - world.x)*tileRelation;
            var auxY:int = chopper.y - world.y;
            
            var posX:int = ((((auxX + auxY) * I_RAIZ2) + tileProyection) * tileFactor);
            var posY:int = ((((auxY - auxX) * I_RAIZ2) + tileProyection) * tileFactor);
			
			chopper.GridPos.x = posX;
			chopper.GridPos.y = posY;
            
            //busqueda en el area del chopper
            
            var initialX:int = posX - 5;
            var initialY:int = posY - 5;
           
			nearHatch = false;
           
            for (var i:int = 0; i < 121; ++i) {
                
                var gridX:int = initialX + (i % 11);
                var gridY:int = initialY + (i / 11);
                
                var nameObject:String = gridX.toString() + "," +gridY.toString();
                var worldObject:Objetos = objetosScene.getObjeto(nameObject); 
                
                if (worldObject != null){
                       worldObject.actionNear();
					   
                    //check for picks
                    
                    if (worldObject.isPickable && chopper.pickupObject(worldObject.x + world.x, worldObject.y + world.y, worldObject.collisionArea) && chopper.retractChopperCrane(false)) {
                       
						if (chopper.targetPickup && (worldObject == chopper.targetPickup)) chopper.targetPickup = false;
                        
                        switch (worldObject.type) {
                            
                            case 1: //PICKUP AQUI
								
							case 2:
									chopper.craneDown = false;
									
                                	if (hud.addObject(worldObject)) {
										//aqui va chopper full
										trace("aqui va chopper full");
										var cargoFull:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene);
										cargoFull.alertDialog("vehicleFull");
										cargoFull.y = -100;
										chopper.frontSprite.addChild(cargoFull);
									}else {
										globalResources.trackEvent("Pickup", "user: " + globalResources.user_id, "Object Pickup: " + worldObject.objectData.objectInfo.object_id);
										hud.scoreTablet.addScore(worldObject.scoreReturn(),2);
										pickedObjectsId.push(worldObject.id);
										myWorldObjects.push(worldObject.objectData.objectInfo.object_id);
										missionPickupObjectId.push(worldObject.objectData.objectInfo.object_id);
										trace(worldObject.objectData.objectInfo.object_id);
										world.sprite02.removeChild(worldObject);
										world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
										objetosScene.deleteObjeto(nameObject,false);
										hud.disposeAnimation(worldObject, world.x, world.y);
										hud.updateCargo(1, "sum");
										
										connect.sendVote(parseInt(globalResources.user_id),"PICKUP",worldObject.objectData.objectInfo.object_id);
										if (worldObject.isFinalObject) 
										{
											connect.sendVote(parseInt(globalResources.user_id),"FINAL_PICKUP",worldObject.objectData.objectInfo.object_id);
										}
										if (dropedItem) 
										{
											connect.sendVote(parseInt(globalResources.user_id),"PICKUP_DROP_OTHER_ITEM",worldObject.objectData.objectInfo.object_id);
										}
										if (worldObject.readInfo) 
										{
											connect.sendVote(parseInt(globalResources.user_id),"PICKUP_READ_DESCRIPTION",worldObject.objectData.objectInfo.object_id);
										}
										if (playedMission) 
										{
											connect.sendVote(parseInt(globalResources.user_id),"PICKUP_PLAYED_THE_SAME_MISSION_WITH_SUCCESFULL_SAVE",worldObject.objectData.objectInfo.object_id);
										}
										
										dropedItem = false;
									}
                                
                               
                                break;
                                
                            case 3:
								chopper.cryogel += 0.4;
                                if (++chopper.cryogel > globalResources.profileData.vehicleData.cryogel+1.0) chopper.cryogel = globalResources.profileData.vehicleData.cryogel+1.0;
                                chopper.craneDown = false;
                                world.sprite02.removeChild(worldObject);
								world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
                                objetosScene.deleteObjeto(nameObject);
								hud.disposeAnimation(worldObject, world.x, world.y);
								soundsScene.getSound("gas_cryo_pickup").play(globalResources.volume);
                                break;
                                
                            case 4:
								chopper.fuel += 0.005;
                                if (++chopper.fuel > globalResources.profileData.vehicleData.fuel+1.0) chopper.fuel = globalResources.profileData.vehicleData.fuel+1.0;
                                chopper.craneDown = false;
                                world.sprite02.removeChild(worldObject);
								world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
                                objetosScene.deleteObjeto(nameObject);
								hud.disposeAnimation(worldObject, world.x, world.y);
								soundsScene.getSound("gas_cryo_pickup").play(globalResources.volume);
                                break;
							case 8:
								chopper.fuel -= 0.3;
								chopper.craneDown = false;
								explosiveAnimation(chopper.x, chopper.y);
								aoeDamage(worldObject);
								break;
							case 9:
								if (onUse) {
									chopper.canShoot = false;
									chopper.grabBattery = worldObject;
									world.sprite02.setChildIndex(worldObject, world.sprite02.numChildren - 1);
									world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
									objetosScene.deleteObjeto(worldObject.namePosition, false);
									chopper.useBtn = true;
								}
								break;
                        }
                        
                        break;
                    }
                    
                        //Detectar si tengo un objeto cerca que puedo agarrar
					if(!chopper.nearObjPick && worldObject.isPickable && chopper.detectNearObject(worldObject.x+world.x,worldObject.y+world.y, worldObject.collisionArea)){
						if (!chopper.craneDown && worldObject.type != 5) chopper.initChopperCrane();
						
						switch (worldObject.type) 
						{
							case 5:
							nearHatch = true;
									if (!exitMissionDialog && timerSec > 10) 
									{
										trace("exit Dialog");
										//if (dialog != null) { removeChild(dialog); dialog = null;}
										var exitDialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 180, globalResources.stageHeigth);
										//this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"hatch", objetox:worldObject }, true));
										exitDialog.alertDialog("leaveMission",null,{pauseId:5});
										
										var tween:Tween = new Tween(exitDialog, 0.20, Transitions.EASE_IN);
										tween.moveTo(180, exitDialog.y - (exitDialog.height+100));
										Starling.juggler.add(tween);
										
										hud.dialogSprite.removeChildren();
										hud.invisibleQuad.visible = true;
										hud.dialogSprite.addChild(exitDialog);
										
										this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:5 }, true));
										exitMissionDialog = true;
									}
							break;
						}
						chopper.nearObjPick=true;
						//break;
					}
                    
					
                    if(!chopper.nearObjPick && chopper.detectNearObject(worldObject.x+world.x,worldObject.y+world.y, worldObject.collisionArea)){
							
							switch (worldObject.type) 
							{
								case 10:
									if (onUse) {
										//trace("cerca del drop point");
										chopper.doubleClickAnimation();
									}
								break;
							}
					}
					
                    //end for picks
                    
                    //check for targets
                    
                    if(!chopper.targetCheked && worldObject.type==0 && chopper.detectTarget(worldObject.x, worldObject.y, world.x, world.y, worldObject.collisionArea)){
						
                        if (chopper.cryogel < 0){
                            chopper.cryogel =0;
                        }else { 
                            chopper.targetCheked = true;
							chopper.shield.visibleOn();
							chopper.fuel-=0.0009;
                        }
                    }
                    
                    hatchRange = false;
                }
				
				//Si no detecté nada y tengo el crane desplegado
				if(!chopper.nearObjPick && i==120 && chopper.retractChopperCrane(false)){
						chopper.craneDown=false;
				}
                
            }
			
			if (chopper.grabBattery != null) {
				chopper.grabBattery.x = chopper.x - world.x;
				chopper.grabBattery.y = (chopper.y-35)  - world.y;
				onUse = true;
				
			}
			
			if (!nearHatch) 
			{
				exitMissionDialog = false;
			}
			
            translate_fondo();
            
			//if (!chopper.targetCheked) chopper.shield.visibleOff();
            chopper.update(e, mouseX, mouseY, new Point(world.x,world.y));
			
			hud.update_meters(chopper.fuel, chopper.cryogel);
			
			// EOG by running out of fuel
			
			if (chopper.fuel < 0) {
				chopper.fuel = -0.1;
				soundsScene.getSound("chopper_full").stop();
				soundsScene.getSound("chopper_destroyed").play(globalResources.volume);
				pause();
				chopper.destroyChooper();
				soundsScene.getSound("beep_alert").stop();
				chopper.explosion.addEventListener(Event.COMPLETE, onDestroyVehicle);
			}//-----
            
			// Low meters Alerts
			if ((chopper.fuel < 0.2) && !meterWarning ) {
				soundsScene.getSound("beep_alert").play(globalResources.volume);
				meterWarning = true;
			}
			
			if ((chopper.fuel > 0.2) && meterWarning ) {
				soundsScene.getSound("beep_alert").stop();
				meterWarning = false;;
			}
			//--------
			
			if (totalCrystalPercentage == 0 && hud.picked_total == hud.objectTotal) {
				comfirmCompleteMission();
			}
			
			//if (hud.picked_total == hud.objectTotal) {
				//comfirmCompleteMission();
			//}
			
			hud.updateHurtImage(chopper.fuel);
			
        }
		
		private function onTimer(e:TimerEvent):void 
		{
			quoteCount++;
			timerSec++;
			
			if (!isPaused && (++countTimeSpawn == timeSpawn)) {
				
				countTimeSpawn = 0;
				
				var tipo:int = (Math.random() * 2);
			
				switch (tipo) {
					
					
					case 0: {
						
						if (!createSpawn()) {
							
							createSlime();
							
						}
						
						
					}break;
					
					case 1: {
						
						if (!createSlime()) {
							
							createSpawn();
							
						}
						
					}break;
				}
				
			}
			
			hud.updateTimer(timerSec);
			
			if (timerSec == globalResources.NpcInfo.lootBonusTime && globalResources.NpcInfo.lootBonusTime != null) 
			{
				createLootBonus();
			}
			
		}
		
		public function createSpawn():Boolean {
			
			if (enemies.length < maxSpawns && totalCrystalPercentage > 0) {
					
					var indexPos:int = int(Math.random() * objetosScene.indexName.length);
					trace(indexPos);
					for (var i:int = 0; i < objetosScene.indexName.length; ++i ) {
						
						var objetoAux:Objetos = objetosScene.getObjeto(objetosScene.indexName[(indexPos + i) % objetosScene.indexName.length]);
						
						if (objetoAux.type == 0) {
							
							
							var enemie:CrystalSpawn = new CrystalSpawn(new Point(objetoAux.x, objetoAux.y-50), texturesScene, soundsScene, globalResources, "enemigoA");
							enemie.objective = chopper;
							enemies.push(enemie);
							world.addChild(enemie);
							objetoAux = null;
							return true;
						}
						
						objetoAux = null;
						
					}
					
				}
			
			return false;
			
		}
		
		public function createSlime():Boolean {
			
			if (slimeEnemies.length < maxSlime && totalCrystalPercentage > 0) {
					
					var indexPos2:int = int(Math.random() * objetosScene.indexName.length);
					for (var i2:int = 0; i2 < objetosScene.indexName.length; ++i2 ) {
						
						var objetoAux2:Objetos = objetosScene.getObjeto(objetosScene.indexName[(indexPos2 + i2) % objetosScene.indexName.length]);
						
						if (objetoAux2.type == 0) {
							
							var slime:SlimeLauncher = new SlimeLauncher(new Point(objetoAux2.x, objetoAux2.y - 50), texturesScene, soundsScene, globalResources, "enemigoC");
							slime.objective = chopper;
							slimeEnemies.push(slime);
							world.addChild(slime);
							objetoAux2 = null;
							return true;
							
						}
						
						objetoAux2 = null;
						
					}
					
				}

			return false;

		}
		
		public function createLootBonus():void {
				
			bonusLoot = new NpcBonusLoot(new Point(world.tilemap.mapWidth *0.5, world.tilemap.mapHeight *0.5), texturesScene, soundsScene, globalResources, "lootBonus");
			world.miniWorldMap.bonus = bonusLoot.minimapImage;
			world.miniWorldMap.objetosSprite.addChild(world.miniWorldMap.bonus);
			world.addChild(bonusLoot);
		}
		
		private function onAnimationTimer(e:TimerEvent):void 
		{
			if (aoeTargetsVect.length > 0) 
			{
				aoeCurrentObject = aoeTargetsVect.shift();
				//trace("Activando explosion de tipo: " + aoeCurrentObject.type);
				switch (aoeCurrentObject.type) 
				{
					case 0:
						explosiveAnimation(aoeCurrentObject.posX, aoeCurrentObject.posY, false);
						this.dispatchEvent(new GameEvents(GameEvents.DESTROY_CRYSTAL, {crystal: aoeCurrentObject.target}, true));
					break;
					case 1:
						explosiveAnimation(aoeCurrentObject.posX, aoeCurrentObject.posY, false);
						this.dispatchEvent(new GameEvents(GameEvents.DESTROY_PICKUP, {pickup: aoeCurrentObject.target}, true));
					break;
					case 8:
						explosiveAnimation(aoeCurrentObject.posX, aoeCurrentObject.posY, false );
						aoeDamage(aoeCurrentObject.target);
					break;
				}
			}
		}
        
        public function translate_fondo():void {
            var p:Point=new Point(0,0);
            if (chopper.canMove) {
				
                if(/*chopper.x==200 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.x=chopper.vehicleBody.velocity.x*0.03125;chopper.ptoPickup.x-=p.x;}
              //  if(/*chopper.x==560 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.x=chopper.vehicleBody.velocity.x*0.03125;chopper.ptoPickup.x-=p.x;}
                if(/*chopper.y==200 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.y=chopper.vehicleBody.velocity.y*0.03125;chopper.ptoPickup.y-=p.y;}
              //  if(/*chopper.y==250 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.y=chopper.vehicleBody.velocity.y*0.03125;chopper.ptoPickup.y-=p.y;}
                world.x -= p.x;
                world.y -= p.y;
				
                move_tileset();
                
            }
			
			world.miniWorldMap.objetosSprite.x = 30 + world.x * 0.1;
			world.miniWorldMap.objetosSprite.y = 15 + world.y * 0.1;
			world.miniWorldMap.updateHatch();
			world.miniWorldMap.updateBonus();
			world.miniWorldMap.vehicleMini.x = chopper.vehicleBody.position.x * 0.1;
			world.miniWorldMap.vehicleMini.y = chopper.vehicleBody.position.y * 0.1;
        }
        
        public function move_tileset():void {
            
            var t_mov:Point=world.dist_tile();
            
				if(t_mov.x<-64){
					world.tile_left();
					
				}
				if(t_mov.x>64){
					world.tile_right();
					
				}
				if(t_mov.y<-31){
					world.tile_up();
					
				}
				if(t_mov.y>31){
					world.tile_down();
					
				}
            
            world.update_tileCenter();
            
        }// end move_tileset
		
		private function onAlert(e:GameEvents):void 
		{
			var sender:Npc = e.params.sender;
			
			for (var i:int = 0; i < enemies.length; ++i ) {
				
				var distancia:int = Point.distance(new Point(sender.x, sender.y), new Point(enemies[i].x, enemies[i].y));
				
				if (distancia > 0 && distancia < enemies[i].alertRange) {
					enemies[i].onAlert();
				}
				
			}
			
			for (var i2:int = 0; i2 < slimeEnemies.length; ++i2 ) {
				
				var distancia2:int = Point.distance(new Point(sender.x, sender.y), new Point(slimeEnemies[i2].x, slimeEnemies[i2].y));
				
				if (distancia2 > 0 && distancia2 < slimeEnemies[i2].alertRange) {
					slimeEnemies[i2].onAlert();
				}
				
			}
			
			sender = null;
		}
		
		public function onDestroyVehicle(e:Event):void {
			
			chopper.explosion.removeEventListener(Event.COMPLETE, onDestroyVehicle);
			
			var dialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene,200,150);
			dialog.alertDialog("missionFailed", null , missionData);
			tempData.push(dialog);
			addChild(dialog);
			
			invisibleQuad.visible = true;
			
		}
		
		public function onDestroyCrystal(e:GameEvents):void {
			
			var crystalDestroyed:Objetos = e.params.crystal as Objetos;
			
			hud.scoreTablet.addScore(crystalDestroyed.scoreReturn(),4);
			
			if(crystalDestroyed.type == 0){
			
				destroyedCrystalsId.push(crystalDestroyed.id);
				world.sprite02.removeChild(crystalDestroyed);
				world.miniWorldMap.objetosSprite.removeChild(crystalDestroyed.minimapImage);
				eCorrotion--;
				corrotionPercentage(world.tilemap.tilemap_obstacules.length);
				objetosScene.deleteObjeto(crystalDestroyed.namePosition);
				
			}
			
			if (crystalDestroyed.type == 12) {
				
				crystalDestroyed.convertToPickup();
				
				
			}
            crystalDestroyed = null;
			activeShot = false;
//			inGame_interface.mini.min.minimap_subSprite.removeChildAt(i);

		}
		
		public function onDropObject(e:GameEvents):void {
			dropedItem = true;
			hud.updateScore(1);
			hud.updateCargo(1, "res");
			var p:Objetos = e.params as Objetos;
			var _p:Point = world.globalToLocal(new Point(chopper.x,chopper.y+Chopper.H));
			p.x=_p.x;
			p.y = _p.y;
			
			globalResources.trackEvent("Release Pickup", "user: " + globalResources.user_id, "Object Release: " + p.objectData.objectInfo.object_id);
		    
			if (hud.missionInventory.size == 3) 
			{
				connect.sendVote(parseInt(globalResources.user_id),"DROPAFTER_FULL",p.objectData.objectInfo.object_id);
			}else 
			{
				connect.sendVote(parseInt(globalResources.user_id),"DROP",p.objectData.objectInfo.object_id);
			}
			hud.scoreTablet.addScore(-p.scoreReturn(),2);
			world.add_object_drop_chopper(p,chopper.GridPos);
			
//			Eliminar del arreglo de objetos y mi mundo el objeto dropeado
			
			for(var i:uint=0;i<pickedObjectsId.length;++i){
				if (pickedObjectsId[i] == p.id){
					pickedObjectsId.splice(i as int,1);	
				}
			}
			
			for(var k:uint=0;k<missionPickupObjectId.length;++k){
				if (missionPickupObjectId[k] == p.objectData.objectInfo.object_id){
					missionPickupObjectId.splice(k as int,1);	
				}
			}
			
			for(var j:uint=0;j<myWorldObjects.length;++j){
				if (myWorldObjects[j] == p.objectData.objectInfo.object_id){
					myWorldObjects.splice(j as int,1);	
				}
			}
			
			world.sortMap();
			
		}
		
		public function onDestroyPickup(e:GameEvents):void {
			var pickupDestroyed:Objetos = e.params.pickup as Objetos;
			hud.scoreTablet.addScore(pickupDestroyed.scoreReturn(),2);
			destroyedObjects.push(pickupDestroyed.id);
			destroyedObjectsID.push(pickupDestroyed.objectData.objectInfo.object_id);
			globalResources.trackEvent("Shoot-Pickup", "user: " + globalResources.user_id, "Object Shoot: "+pickupDestroyed.objectData.objectInfo.object_id);
			connect.sendVote(parseInt(globalResources.user_id),"SHOOT_OBJECT",pickupDestroyed.objectData.objectInfo.object_id);
			if (pickupDestroyed.readInfo) 
			{
				connect.sendVote(parseInt(globalResources.user_id),"SHOOT_OBJECT_VIEWED_DESCRIPTION",pickupDestroyed.objectData.objectInfo.object_id);
			}
			//trace(pickupDestroyed.objectData.objectInfo.object_id);
			world.sprite02.removeChild(pickupDestroyed);
			world.miniWorldMap.objetosSprite.removeChild(pickupDestroyed.minimapImage);
			objetosScene.deleteObjeto(pickupDestroyed.namePosition);
			hud.updateScore(0, 1);
		}
		
        public function corrotionPercentage(_length:int):void{
            
            totalCrystalPercentage = (eCorrotion * 100) / _length;
			hud.corrotion_text.text = totalCrystalPercentage + "%";
        }
		
		public function pickUpObject(e:GameEvents):void{
                
                var _object:Objetos;
                var num:int;
                _object = e.params.obj;
                switch(e.params.type) {
					case "useObject":
						chopper.targetingPickup(new Point(_object.x + world.x, _object.y + world.y), _object);
						_object.isPickable = true;
						onUse = true;
						break;
                    default:
                        chopper.targetingPickup(new Point(_object.x+world.x,_object.y+world.y),_object);
                    break;
                }
                _object = null;
        }
            
		/********************************************************
         * 
         * 				      GAME STATES
         * 
         * *****************************************************/
         
		public function gameCurrentState(e:GameEvents):void {
			//trace ("recibo: " + e.params.type);
			completeMission = e.params.complete;
			
			switch(e.params.type) {
				case "gamePause":
					if (!isPaused) {
						pauseID = e.params.pauseId;
						pause();
						if (pauseID == 5) 
						{
							hud.onButtonClicked();
						}
					}
					break;
				case "gameResume":
					if (pauseID == e.params.resumeId) {
						pause();
						//hud.removeChild(hud.invisibleQuad);
						hud.invisibleQuad.visible = false;
						if (e.params.resumeId == 5) 
						{
							
							hud.onButtonClicked();
						}
					}
					break;
				case "saveState":
					var sObject:Object = new Object();
					if (!ghostMission) 
					{
						var sExtras:Object = new Object();
						sExtras.picked = hud.picked_total;
						sExtras.total = hud.objectTotal;
						sExtras.crystal = totalCrystalPercentage;
						
						sObject.destroyedObjectsID = destroyedObjectsID;
						sObject.destroyedObjects = destroyedObjects;
						sObject.missionObjectsId = missionPickupObjectId;
						sObject.pickUps= pickedObjectsId;
						sObject.crystals= destroyedCrystalsId;
						sObject.id = mission_Id;
						sObject.scoreSave = hud.scoreTablet.scoreObjectReturn((missionTime-timerSec > 0)?(missionTime-timerSec):0);
						saveMission(sObject, sExtras);
					}else {
						trace("Ghost Mission save score");
						sObject.scoreSave = hud.scoreTablet.scoreObjectReturn((missionTime-timerSec > 0)?(missionTime-timerSec):0);
						saveMission(sObject);
						//this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen", megatile_id: missionMegatileId}, true));
					}
					
					break;
				case "cleanAndRetry":
					trace("Retry and clear mission");
					if (!ghostMission) 
					{
						connect.cleanMission(parseInt(globalResources.user_id), parseInt(mission_Id));
					}
					this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type:"gamePlayScreen",data:missionData},true));
					break;
			}
		}
		
		public function comfirmCompleteMission():void
		{
			
			soundsScene.getSound("BGM_RoadWorn").stop();
			soundsScene.getSound("beep_alert").stop();
			soundsScene.getSound("Chopperv1").stop();
			
			pause();
			
			trace("Picks: "+missionPickupObjectId);
			trace("Destroyed: " + destroyedObjectsID);
			
			var completeInfo:Object = new Object();
			completeInfo.pickupsId = missionPickupObjectId;
			completeInfo.destroyPickupsId = destroyedObjectsID;
			completeInfo.dictionary = objectsDictionary;
			completeInfo.missionData = missionData;
			completeInfo.level = 0;
			completeInfo.mission_user_id = missionData;
			completeInfo.score = hud.scoreTablet.finalScore((missionTime-timerSec > 0)?(missionTime-timerSec):0);
			
			soundsScene.getSound("MissionComplete").play(globalResources.volume);
			
			var dialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 20, 5);
			dialog.missionComplete(completeInfo);
			addChild(dialog);
			
			invisibleQuad.visible = true;
			hud.blackQuad.visible = true;
		}
		
        public function pause():void {
                    
                    if (isPaused) {
						("resume");
                        pauseQuad.visible = false;
                        this.addEventListener(Event.ENTER_FRAME, onUpdate);
                        isPaused = false;
						
						for (var k:int = 0; k < enemies.length; ++k ) {
							enemies[k].unpause();
						}
						for (var h:int = 0; h < dashEnemies.length; ++h ) {
							dashEnemies[h].unpause();
						}
						for (var m:int = 0; m < slimeEnemies.length; ++m ) {
							slimeEnemies[m].unpause();
						}
						
						if(bonusLoot != null)bonusLoot.unpause();
					/*	if (pauseID == 3) 
						{
							hud.boxBomb.visible = false;
							hud.boxXray.visible = false;
						}*/
						
                        gameplayTime.start();
                    }else {
						("pausa");
                        pauseQuad.visible = true;
						
						for (var j:int = 0; j < enemies.length; ++j ) {
							enemies[j].pause();
						}
						
						for (var l:int = 0; l < dashEnemies.length; ++l ) {
							dashEnemies[l].pause();
						}
						
						for (var o:int = 0; o < slimeEnemies.length; ++o ) {
							slimeEnemies[o].pause();
						}
						
						if(bonusLoot != null)bonusLoot.pause();
						
                        this.removeEventListener(Event.ENTER_FRAME, onUpdate);
						
                        isPaused = true;
						gameplayTime.stop();
                    }
                    
        }
        
        /********************************************************
         * 
         * 				      EVENTS
         * 
         * *****************************************************/
        
        public function onMouse(e:TouchEvent):void{     //function onMouse
            
            var touch:Touch = e.getTouch(stage);
            if(touch==null)return;
            var pos:Point = new Point(touch.globalX,touch.globalY);//touch.getLocation(stage);
            var rec:Rectangle = new Rectangle(680, 333, 80, 68);

            mouseX=pos.x;
            mouseY=pos.y;	
            /*
        
            if (worldObject == null){
            */
                if(touch.phase==TouchPhase.BEGAN && chopper.hitTestPoint(mouseX,mouseY) && touch.tapCount != 2 && (chopper.cryogel > 0.2 && chopper.canShoot && !isPaused)){
                   this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"shootState" }, true));
                }
                else { 
                    if (!isPaused && touch.tapCount != 2 && !rec.containsPoint(pos)) {
                        if (touch.phase == TouchPhase.ENDED && chopper.clickToMove) {
							quoteCount = 0;
						}
						if (touch.phase == TouchPhase.BEGAN && !chopper.clickToMove && quoteCount > 4) {
							random = int(Math.random() * 4);
							switch (random) 
							{
								case 0:
									soundsScene.getSound("chopper_voice/got it").play(globalResources.volume);
								break;
								case 1:
									soundsScene.getSound("chopper_voice/lock_and_load").play(globalResources.volume);
								break;
								case 2:
									soundsScene.getSound("chopper_voice/move_in").play(globalResources.volume);
								break;
								case 3:
									soundsScene.getSound("chopper_voice/ok").play(globalResources.volume);
								break;
							}
							
						}
						chopper.onMouse_H(touch.phase, mouseX, mouseY);
                    }
					if (touch.phase==TouchPhase.BEGAN && chopper.hitTestPoint(mouseX,mouseY) && chopper.cryogel <= 0.2) {
						var fadeDialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene);
						fadeDialog.fadeOutAlerts(globalResources.textos[globalResources.idioma].Screens.GamePlay.lowCryo, true);
						hud.dialogSprite.addChild(fadeDialog);
						tempData.push(fadeDialog);
					}
                }
				
				if (touch.phase == TouchPhase.ENDED && activeShot) {
					this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"shootState" }, true));
				}
          /*  }
            else{
            }*/

        }// END onMouse
		
		private function dropUsable():void {
			if (chopper.chopperDoubleClick == true) 
			{
				//trace("hice doble click en chopper");
				dropClicked = true;
				if (dropClicked) 
				{
					
				}
			}
		}
		
		public function miscellaneousEvents (e:GameEvents):void {
			//trace("recibi: " + e.params.type);
			var _objeto:Objetos;
			switch(e.params.type) {
				
				case "objectDialog":
					_objeto = e.params.objetox;
					chopper.frontSprite.addChild(_objeto.dialog);
					
					if (_objeto.type == 1) 
					{
						//hud.boxXray.x = _objeto.x + world.x;
						//hud.boxXray.y = _objeto.y + world.y;
						//hud.boxXray.visible = true;
					}
					if (_objeto.type == 8) 
					{
						hud.boxBomb.x = _objeto.x + world.x;
						hud.boxBomb.y = _objeto.y + world.y;
						hud.boxBomb.visible = true;
					}
					break;
				case "objectInfo":
					_objeto = e.params.objetox;
					hud.dialogSprite.removeChildren();
					hud.dialogSprite.addChild(_objeto.objectInfoDialog);
					_objeto.objectInfoDialog.visible = true;
					_objeto.readInfo = true;
					break;
				case "hatch":
					_objeto = e.params.objetox;
					hud.dialogSprite.removeChildren();
					hud.dialogSprite.addChild(_objeto.dialog);
					hud.invisibleQuad.visible = true;
					break;
				case "shootState":
					if (!activeShot) 
					{
						chopper.target01.visible = true;
						chopper.addChild(chopper.target01);
						chopper.chargeAnimation.visible = true;
						chopper.chargeAnimation.play();
						
						bulletLevelCount = 0;
						this.addEventListener(Event.ENTER_FRAME, chopperShotUpdate);
						
						bullet = new Particle("cShotParticle");
						bullet.x = chopper.x;
						bullet.y = chopper.y -80;
						cryogelBullets.push(bullet);
						addChild(bullet);
						activeShot = true;
						targetLock = false;
						targetPosition = null;
						this.removeEventListener(Event.ENTER_FRAME, onUpdate);
						
						soundsScene.getSound("charge_loop").play(globalResources.volume);
						soundsScene.getSound("charge_start").play(globalResources.volume);
					}else {
						
						if (targetLock == true && targetPosition != null) {
							
							if (targetObject == null) {
								fireEnemie(targetPosition);
							}else{
								fireCryogel(targetPosition, targetObject.type);
							}
							this.removeEventListener(Event.ENTER_FRAME, chopperShotUpdate);
							this.addEventListener(Event.ENTER_FRAME, onUpdate);
						}else {
							if (targetObject == null) {
								chopper.chargeAnimation.visible = false;
								chopper.chargeAnimation.stop();
						
								bullet.psShoot.stop();
								removeChild(bullet);
								bullet.dispose();
								bullet = null;
								activeShot = false;
								this.removeEventListener(Event.ENTER_FRAME, chopperShotUpdate);
								this.addEventListener(Event.ENTER_FRAME, onUpdate);
								
								soundsScene.getSound("charge_loop").stop();
							}
							
						}
						chopper.target01.visible = false;
						chopper.removeChild(chopper.target01);
						
						chopper.target02.visible = false;
						chopper.removeChild(chopper.target02);
						
					}
					break;
				case "chopperDobleClick":
					
					var dropPoint:Point;
					var triggerPoint:Point;
				
					var posX1:int = chopper.GridPos.x;
					var posY1:int = chopper.GridPos.y;
					
					var nameObject1:String = posX1.toString() + "," +posY1.toString();
					var tempObj:Objetos = objetosScene.getObjeto(nameObject1);
							
					if (tempObj != null && tempObj.type != 10) return;
					
					var initialX:int = posX1 - 2;
					var initialY:int = posY1 - 3;
				
			
					for (var i:int = 0; i < 16; ++i) {
                
						var gridX:int = initialX + (i % 4);
						var gridY:int = initialY + (i / 4);
						
						tempObj = null;
						
						nameObject1 = gridX.toString() + "," +gridY.toString();
						tempObj = objetosScene.getObjeto(nameObject1);
						
						if (tempObj !=null && tempObj.type == 10) {
							
							tempObj.img.visible = false;
							tempObj.powerPlantOn.visible = true;
							
							chopper.grabBattery.dispose();
							chopper.grabBattery = null;
							
							onUse = false;
							chopper.craneDown = false;
							chopper.canShoot = true;
							chopper.useBtn = false;
							
							world.activateTrigger(tempObj.letterType);
						}
						
					}
					
					if (onUse) {
						nameObject1 = posX1.toString() + "," +posY1.toString();
						chopper.grabBattery.objectData.namePos = nameObject1;
						world.objetosScene.addObjeto(nameObject1, chopper.grabBattery);
						chopper.grabBattery.minimapImage.x = (chopper.x - world.x) * 0.1;
						chopper.grabBattery.minimapImage.y = (chopper.y - world.y) * 0.1;
						world.miniWorldMap.objetosSprite.addChildAt(chopper.grabBattery.minimapImage,world.miniWorldMap.objetosSprite.numChildren-2);
						chopper.grabBattery.y += 50;
						chopper.grabBattery.isPickable = false;
						chopper.grabBattery = null;
						
						onUse = false;
						chopper.craneDown = false;
						chopper.canShoot = true;
						chopper.useBtn = false;
						world.sortMap();
						
					}
					break;
				case "add_bishcoins":
					//asdf
					trace("Bishcoin Added: +"+ e.params.lootNum);
					globalResources.profileData.bishcoins += e.params.lootNum;
					hud.updateBishCoins(e.params.lootNum);
					break;
			}
		}
		
        public function chopperShotUpdate(e:Event):void {
			
			var mouseWorld:Point = new Point((mouseX - world.x),(mouseY - world.y));
			
			//Carga de niveles de disparo de Cryogel
            bulletLevelCount++;
			if ((bulletLevelCount % 32) == 0) {
				bulletLevel = bulletLevelCount / 32;
				bulletChargeAnimation(bulletLevel);
				if (bulletLevel == 2) bulletLevelCount = -20;
			}
			
			chopper.updateTarget(mouseX, mouseY);
			
			for (var c:int = 0; c < enemies.length; ++c ) {
				
				if (Point.distance(mouseWorld, new Point(enemies[c].x, enemies[c].y)) < 50){
					targetObject = null;
					targetEnemie = enemies[c];
					chopper.target01.visible = false;
					chopper.target02.visible = true;
					chopper.addChild(chopper.target02);
					targetLock = true;
					targetPosition = world.localToGlobal(new Point(enemies[c].x, enemies[c].y));
					chopper.target02.x = chopper.globalToLocal(targetPosition).x;
					chopper.target02.y = chopper.globalToLocal(targetPosition).y;
					
					return;
				}
				
			}
			
			for (var d:int = 0; d < dashEnemies.length; ++d ) {
				
				if (dashEnemies[d].mode == DashGlider.REST && Point.distance(mouseWorld, new Point(dashEnemies[d].x, dashEnemies[d].y)) < 50) {
					targetObject = null;
					targetEnemie = dashEnemies[d];
					chopper.target01.visible = false;
					chopper.target02.visible = true;
					chopper.addChild(chopper.target02);
					targetLock = true;
					targetPosition = world.localToGlobal(new Point(dashEnemies[d].x, dashEnemies[d].y));
					chopper.target02.x = chopper.globalToLocal(targetPosition).x;
					chopper.target02.y = chopper.globalToLocal(targetPosition).y;
					
					return;
				}
				
			}
			
			for (var s:int = 0; s < slimeEnemies.length; ++s ) {
				
				if (slimeEnemies[s].mode == SlimeLauncher.STUN && Point.distance(mouseWorld, new Point(slimeEnemies[s].x, slimeEnemies[s].y+slimeEnemies[s].npcSprite.y)) < 50) {
					targetObject = null;
					targetEnemie = slimeEnemies[s];
					chopper.target01.visible = false;
					chopper.target02.visible = true;
					chopper.addChild(chopper.target02);
					targetLock = true;
					targetPosition = world.localToGlobal(new Point(slimeEnemies[s].x, slimeEnemies[s].y+slimeEnemies[s].npcSprite.y));
					chopper.target02.x = chopper.globalToLocal(targetPosition).x;
					chopper.target02.y = chopper.globalToLocal(targetPosition).y;
					
					return;
				}
				
			}
			
			if (bonusLoot != null && Point.distance(mouseWorld, new Point(bonusLoot.x, bonusLoot.y)) < 50) 
			{
				targetObject = null;
				targetEnemie = bonusLoot;
				targetEnemie.name = "bonusLoot";
				chopper.target01.visible = false;
				chopper.target02.visible = true;
				chopper.addChild(chopper.target02);
				targetLock = true;
				targetPosition = world.localToGlobal(new Point(bonusLoot.x, bonusLoot.y));
				chopper.target02.x = chopper.globalToLocal(targetPosition).x;
				chopper.target02.y = chopper.globalToLocal(targetPosition).y;
				
				return;
			}

			var auxX:int = mouseWorld.x*tileRelation;
            var auxY:int = mouseWorld.y;
            
            var posX:int = ((((auxX + auxY) * I_RAIZ2) + tileProyection) * tileFactor);
            var posY:int = ((((auxY - auxX) * I_RAIZ2) + tileProyection) * tileFactor);
			
			
			
			//Busqueda de cristal por area
            
            var initialX:int = posX - 1;
            var initialY:int = posY - 1;
			
			targetEnemie = null;
			
            
            for (var i:int = 0; i < 9; ++i) {
                
                var gridX:int = initialX + (i % 3);
                var gridY:int = initialY + (i / 3);
				
				var nameObject:String = gridX.toString() + "," +gridY.toString();
				targetObject = objetosScene.getObjeto(nameObject);
			
				if (targetObject != null)
				{
					
					if (targetObject.type == 0 || targetObject.type == 1 || targetObject.type == 8 || targetObject.type == 12) 
					{
						
						chopper.target01.visible = false;
						chopper.target02.visible = true;
						chopper.addChild(chopper.target02);
						targetLock = true;
						targetPosition = world.localToGlobal(new Point(targetObject.x, targetObject.y));
						chopper.target02.x = chopper.globalToLocal(targetPosition).x;
						chopper.target02.y = chopper.globalToLocal(targetPosition).y;
						break;
					}else
					{
						chopper.target01.visible = true;
						chopper.removeChild(chopper.target02);
						targetLock = false;
						targetPosition = null;
					}
					
				}else 
				{
					chopper.target01.visible = true;
					chopper.removeChild(chopper.target02);
					targetLock = false;
					targetPosition = null;
					targetObject = null;
					soundTargetOn = false;
				}
			}	
			
		}
		
		public function bulletChargeAnimation(Level:int):void {
			var tween:Tween;
			
			tween = new Tween (bullet, 0.1);
			
			switch (Level) 
			{
				case 0:
					tween.animate("scaleX", 0.8);
					tween.animate("scaleY", 0.8);
				break;
				case 1:
					tween.animate("scaleX", 1.10);
					tween.animate("scaleY", 1.10);
				break;
				case 2:
					tween.animate("scaleX", 1.50);
					tween.animate("scaleY", 1.50);
				break;
			}
			
			Starling.juggler.add(tween);
			tween = null;

		}
		
		public function fireEnemie(enemiePos:Point):void {
			
			soundsScene.getSound("charge_loop").stop();
			
			var tween:Tween;
			
			activeShot = true;
			targetLock = false;
			
			var worldBulletPos:Point; 
			worldBulletPos = world.globalToLocal(new Point(bullet.x, bullet.y));
			bullet.x = worldBulletPos.x;
			bullet.y = worldBulletPos.y;
			world.addChild(bullet);
			
			var worldBulletPosEnd:Point;
			worldBulletPosEnd = world.globalToLocal(new Point(enemiePos.x, enemiePos.y));
			
			tween = new Tween(bullet, 0.4, Transitions.EASE_IN);
			tween.moveTo(worldBulletPosEnd.x, worldBulletPosEnd.y);
			Starling.juggler.add(tween);
			
			chopper.chargeAnimation.visible = false;
			chopper.chargeAnimation.stop();

			tween.onComplete = shootEnemie;
			//trace(bulletLevel)
			switch (bulletLevel) 
			{
				case 0:
					soundsScene.getSound("crioshot_lvl_001").play(globalResources.volume);
					
						targetEnemie.hp -= chopper.damage;
						targetEnemie.numShot++;
						bulletLevel = 0;
					
				break;
				case 1:
					soundsScene.getSound("crioshot_lvl_002").play(globalResources.volume);
					chopper.cryogel -= 0.10;
					
						targetEnemie.hp -= chopper.damage*2;
						targetEnemie.numShot++;
						bulletLevel = 0;
					
				break;
				case 2:
					soundsScene.getSound("crioshot_lvl_003").play(globalResources.volume);
					chopper.cryogel -= 0.15;
					
						targetEnemie.hp -= chopper.damage*3;
						targetEnemie.numShot++;
						bulletLevel = 0;
				break;
			}
			
			
		}
		
		public function fireCryogel(crystalpos:Point, type:int):void {
			
			soundsScene.getSound("charge_loop").stop();
			
			var tween:Tween;
			
			activeShot = true;
			targetLock = false;
			
			removeChild(bullet);
			
			var worldBulletPos:Point; 
			worldBulletPos = world.globalToLocal(new Point(bullet.x, bullet.y));
			bullet.x = worldBulletPos.x;
			bullet.y = worldBulletPos.y;
			world.addChild(bullet);
			
			var worldBulletPosEnd:Point;
			worldBulletPosEnd = world.globalToLocal(new Point(crystalpos.x, crystalpos.y));
			
			tween = new Tween(bullet, 0.4, Transitions.EASE_IN);
			tween.moveTo(worldBulletPosEnd.x, worldBulletPosEnd.y);
			Starling.juggler.add(tween);
			
			chopper.chargeAnimation.visible = false;
			chopper.chargeAnimation.stop();
			
			if (type == 0 || type == 12)tween.onComplete = crystalFreezeAnimation;
			if (type == 8)tween.onComplete = explosiveAoe;
			if (type == 1) tween.onComplete = destroyBox;
			
			switch (bulletLevel) 
			{
				case 0:
					soundsScene.getSound("crioshot_lvl_001").play(globalResources.volume);
					chopper.cryogel -= 0.05;
					if (type == 0 || type == 12) 
					{
						targetObject.hp -= chopper.damage;
						targetObject.numShot++;
						bulletLevel = 0;
					}
				break;
				case 1:
					soundsScene.getSound("crioshot_lvl_002").play(globalResources.volume);
					chopper.cryogel -= 0.10;
					if (type == 0 || type == 12) 
					{
						targetObject.hp -= chopper.damage*2;
						targetObject.numShot++;
						bulletLevel = 0;
					}
				break;
				case 2:
					soundsScene.getSound("crioshot_lvl_003").play(globalResources.volume);
					chopper.cryogel -= 0.15;
					if (type == 0 || type == 12) 
					{
						targetObject.hp -= chopper.damage*3;
						targetObject.numShot++;
						bulletLevel = 0;
					}
				break;
			}
			//trace("Bullet Level: " + (bulletLevel + 1), "Crystal HP: " + targetObject.hp);
		}
		
		public function crystalFreezeAnimation():void {
			var random:int = 0;
			var tween:Tween;
			if (targetObject.hp < 0) targetObject.hp = 0;
			
			if (targetObject.hp > 100) {
				
				random = Math.random() * 100;
					if (random % 2 == 0)
					{
						soundsScene.getSound("crystal_explode01").play(globalResources.volume);
					}else 
					{
						soundsScene.getSound("crystal_explode02").play(globalResources.volume);
					}
					targetObject.bright = 0.02;
					tween = new Tween(targetObject, 0.5);
					tween.animate("bright",0.02);
					Starling.juggler.add(tween);
					tween.onUpdate = targetObject.brightAnimation;
					bullet.psShoot.stop();
					removeChild(bullet);
					bullet.dispose();
					bullet = null;
					activeShot = false;
			}else {
				
				if (targetObject.hp > 0) {
					
					random = Math.random() * 100;
					if (random % 2 == 0)
					{
						soundsScene.getSound("crystal_explode01").play(globalResources.volume);
					}else 
					{
						soundsScene.getSound("crystal_explode02").play(globalResources.volume);
					}
					targetObject.bright = 0.02;
					tween = new Tween(targetObject, 0.5);
					tween.animate("bright",0.02);
					Starling.juggler.add(tween);
					tween.onUpdate = targetObject.brightAnimation;
					bullet.psShoot.stop();
					removeChild(bullet);
					bullet.dispose();
					bullet = null;
					activeShot = false;
					
				}else {
					
					random = Math.random() * 100;
					if (random % 2 == 0)
					{
						soundsScene.getSound("crystal_explode01").play(globalResources.volume);
					}else 
					{
						soundsScene.getSound("crystal_explode02").play(globalResources.volume);
					}
					tween = new Tween(targetObject, 0.5);
					tween.animate("bright",1);
					Starling.juggler.add(tween);
					tween.onUpdate = targetObject.brightAnimation;
					tween.onComplete = removeCryogelBullet;
					
				}
				
			}
			
		}
		
		public function removeCryogelBullet():void {
			var tween:Tween;
			bullet.explotionAnimation();
			bullet = null;
			this.dispatchEvent(new GameEvents(GameEvents.DESTROY_CRYSTAL, {crystal: targetObject}, true));
		}
		
		public function shootEnemie():void {
			if (bullet != null) bullet.psShoot.stop();
			removeChild(bullet);
			if (bullet != null) bullet.dispose();
			bullet = null;
			activeShot = false;
			
			explosiveAnimation(targetPosition.x, targetPosition.y);
			
			if (targetEnemie.hp < 1) {
				
				hud.scoreTablet.addScore(targetEnemie.scoreReturn(),3);
				var auxX:int = targetEnemie.x*tileRelation;
				var auxY:int = targetEnemie.y+125;
				
				var posX:int = ((((auxX + auxY) * I_RAIZ2) + tileProyection) * tileFactor);
				var posY:int = ((((auxY - auxX) * I_RAIZ2) + tileProyection) * tileFactor);
				
				if(targetEnemie.name != "bonusLoot")world.add_object_enemie(1, new Point(targetEnemie.x, targetEnemie.y), new Point(posX, posY));
				if(targetEnemie.name == "bonusLoot")world.add_object_enemie(0, new Point(targetEnemie.x, targetEnemie.y), new Point(posX, posY));
				
				world.sortMap();
			
				for (var k:int = 0; k < enemies.length; ++k ) {
					if (enemies[k] == targetEnemie) {
						enemies.splice(k, 1);
						world.removeChild(targetEnemie);
						targetEnemie.dispose();
					}
				}
				
				for (var h:int = 0; h < dashEnemies.length;++h ) {
					if (dashEnemies[h] == targetEnemie) {
						dashEnemies.splice(h, 1);
						world.removeChild(targetEnemie);
						targetEnemie.dispose();
					}
				}
				
				for (var o:int = 0; o < slimeEnemies.length;++o ) {
					if (slimeEnemies[o] == targetEnemie) {
						slimeEnemies.splice(o, 1);
						world.removeChild(targetEnemie);
						targetEnemie.dispose();
					}
				}
				
				if (bonusLoot == targetEnemie) {
					bonusLoot.bishCoinAnimation();
					hud.updateBishCoins();
					hud.coinAddAnimation();
					world.miniWorldMap.removeChild(world.miniWorldMap.bonus);
					world.miniWorldMap.bonus = null;
					bonusLoot = null;
				}
			}
			targetEnemie = null;
			
		}
		
		public function destroyBox():void {
			bullet.psShoot.stop();
			removeChild(bullet);
			bullet.dispose();
			bullet = null;
			activeShot = false;
			
			explosiveAnimation(targetPosition.x, targetPosition.y);
			this.dispatchEvent(new GameEvents(GameEvents.DESTROY_PICKUP, {pickup: targetObject}, true));
		}
		
		public function explosiveAoe():void {
			bullet.psShoot.stop();
			removeChild(bullet);
			bullet.dispose();
			bullet = null;
			activeShot = false;
			
			explosiveAnimation(targetPosition.x, targetPosition.y);
			aoeDamage(targetObject);
		}
		
		public function explosiveAnimation(posX:int, posY:int, toWorld:Boolean = true):void {
			var explotion:Particle = new Particle("explotionParticle");
			var worldBulletPos:Point; 
			
			if (toWorld) {
				worldBulletPos = world.globalToLocal(new Point(posX, posY));
			}else {
				worldBulletPos = new Point(posX, posY);
			}
			explotion.x = worldBulletPos.x;
			explotion.y = worldBulletPos.y;
			world.addChild(explotion);
			
			soundsScene.getSound("explosive").play(globalResources.volume);
		}
		
		public function aoeDamage(_targetObject:Objetos):void {
			
			var my_array:Array = _targetObject.namePosition.split(",");
			var initialX:int = int(my_array[0]) - aoeRange;
            var initialY:int = int(my_array[1]) - aoeRange;
			var objectAoeTrigger:Object;
			
			world.sprite02.removeChild(_targetObject);
			objetosScene.deleteObjeto(_targetObject.namePosition);
			
			for (var i:int = 0; i < (((aoeRange * 2) + 1) * ((aoeRange * 2) + 1)); ++i) {
                
                var gridX:int = initialX + (i % ((aoeRange * 2) + 1));
                var gridY:int = initialY + (i / ((aoeRange * 2) + 1));
                
                var nameObject:String = gridX.toString() + "," +gridY.toString();
                var objectToAoe:Objetos = objetosScene.getObjeto(nameObject); 
                var objectToAoePoint:Point;
				
				
				if (objectToAoe != null) {
					
					objectToAoePoint = new Point(objectToAoe.x, objectToAoe.y);
					switch (objectToAoe.type) 
					{
						case 0:
								//trace("AOE: Crystal");
								objectAoeTrigger = new Object();
								objectAoeTrigger.posX = objectToAoePoint.x;
								objectAoeTrigger.posY = objectToAoePoint.y;
								objectAoeTrigger.type = 0;
								objectAoeTrigger.target = objectToAoe;
								aoeTargetsVect.push(objectAoeTrigger);
								objectAoeTrigger = null;
								
								objetosScene.deleteObjeto(objectToAoe.namePosition, false);
							break;
						case 1:
								//trace("AOE: Pickup");
								objectAoeTrigger = new Object();
								objectAoeTrigger.posX = objectToAoePoint.x;
								objectAoeTrigger.posY = objectToAoePoint.y;
								objectAoeTrigger.type = 1;
								objectAoeTrigger.target = objectToAoe;
								aoeTargetsVect.push(objectAoeTrigger);
								objectAoeTrigger = null;
								
								objetosScene.deleteObjeto(objectToAoe.namePosition, false);
							break;
						case 8:
								//trace("AOE: Explosive");s
								objectAoeTrigger = new Object();
								objectAoeTrigger.posX = objectToAoePoint.x;
								objectAoeTrigger.posY = objectToAoePoint.y;
								objectAoeTrigger.type = 8;
								objectAoeTrigger.target = objectToAoe;
								aoeTargetsVect.push(objectAoeTrigger);
								objectAoeTrigger = null;
								
								objetosScene.deleteObjeto(objectToAoe.namePosition, false);
							break;
					}
				}
			}
		}
		
		override public function dispose():void 
		{
			trace("dispose gameplay");
			aoeAnimationTime.stop();
			aoeAnimationTime.removeEventListener(TimerEvent.TIMER,onAnimationTimer);
			aoeAnimationTime = null;
			
			gameplayTime.stop();
			gameplayTime.removeEventListener(TimerEvent.TIMER, onTimer);
			gameplayTime = null;
			
			
			//Clean Vectors-------------------------------------------------
			for (var i:int = 0; i < enemies.length; ++i ) {
				
				enemies[i].dispose();
				
			}
			
			enemies.splice(0, enemies.length);
			enemies = null;
			
			for (var i2:int = 0; i2 < dashEnemies.length; ++i2 ) {
				
				dashEnemies[i2].dispose();
				
			}
			
			dashEnemies.splice(0, dashEnemies.length);
			dashEnemies = null;
			
			for (var i3:int = 0; i3 < cryogelBullets.length; ++i3 ) {
				
				cryogelBullets[i3].dispose();
				
			}
			
			cryogelBullets.splice(0, cryogelBullets.length);
			cryogelBullets = null;
			
			for (var i4:int = 0; i4 < mapPickups.length; ++i4 ) {
			
				if (mapPickups[i4].objectData == null) continue;
				var indexString:String = (mapPickups[i4].objectData.objectInfo.object_id) as String;
				objectsDictionary[indexString].dispose();
				objectsDictionary[indexString] = null;
				delete(objectsDictionary[indexString]);
				mapPickups[i4].dispose();
				
			}
			mapPickups.splice(0, mapPickups.length);
			mapPickups = null;
			
			for (var i5:int = 0; i5 < slimeEnemies.length; ++i5 ) {
				
				slimeEnemies[i5].dispose();
				
			}
			
			slimeEnemies.splice(0, slimeEnemies.length);
			slimeEnemies = null;
			
			for (var i6:int = 0; i6 < aoeTargetsVect.length; ++i6 ) {
				
				aoeTargetsVect[i6].dispose();
				
			}
			
			aoeTargetsVect.splice(0, aoeTargetsVect.length);
			aoeTargetsVect = null;
			
			//Clean Arrays-------------------------------------------------
			
			missionObjects.splice(0, missionObjects.length);
			missionObjects = null;
			
			pickedObjectsId.splice(0, pickedObjectsId.length);
			pickedObjectsId = null;
			
			destroyedCrystalsId.splice(0, destroyedCrystalsId.length);
			destroyedCrystalsId = null;
			
			myWorldObjects.splice(0, myWorldObjects.length);
			myWorldObjects = null;
			
			missionPickupObjectId.splice(0, missionPickupObjectId.length);
			missionPickupObjectId = null;
			
			destroyedObjects.splice(0, destroyedObjects.length);
			destroyedObjects = null;
			
			destroyedObjectsID.splice(0, destroyedObjectsID.length);
			destroyedObjectsID = null;
			
			saveTrophieroomArray.splice(0, saveTrophieroomArray.length);
			saveTrophieroomArray = null;
			
			saveTrophieroomTypeArray.splice(0, saveTrophieroomTypeArray.length);
			saveTrophieroomTypeArray = null;
			
			world.soundsScene.getSound("BGM_RoadWorn").stop();
			gameplayBackground.dispose();
			gameplayBackground = null;
			hud.dispose();
			hud = null;
			world.dispose();
			world = null;
			chopper.dispose();
			chopper = null;
			
			super.dispose();
			
		}
        
    }

}