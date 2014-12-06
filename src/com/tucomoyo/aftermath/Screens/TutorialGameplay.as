package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Clases.Chopper;
	import com.tucomoyo.aftermath.Clases.Dialogs;
    import com.tucomoyo.aftermath.Clases.MissionHUD;
    import com.tucomoyo.aftermath.Clases.MissionMap;
    import com.tucomoyo.aftermath.Clases.Objetos;
	import com.tucomoyo.aftermath.Clases.Particle;
    import com.tucomoyo.aftermath.Connections.Connection;
    import com.tucomoyo.aftermath.Engine.GameEvents;
    import com.tucomoyo.aftermath.Engine.Scene;
    import com.tucomoyo.aftermath.Engine.TileManager;
    import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	import flash.utils.Timer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
    import starling.display.Button;
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
	public class TutorialGameplay extends Scene 
	{
		public static const RAIZ2:Number = Math.sqrt(2);
        public static const I_RAIZ2:Number = 1 / RAIZ2;
        
		private var missionObjects:Array = new Array();
		private var pickedObjectsId:Array = new Array();
		private var destroyedCrystalsId:Array = new Array();
		public var myWorldObjects:Array = new Array();
		public var myWorldShuttleObjects:Array = new Array();
		
		public var activeShot:Boolean = false;
		private var exitMissionDialog:Boolean = true;
		private var nearHatch:Boolean = false;
		private var hatchRange:Boolean = false;
		public var isPaused:Boolean = false;
		public var shuttleSent:Boolean = false;
		public var meterWarning:Boolean = false;
		public var onUse:Boolean = false;
		private var targetLock:Boolean = false;
		public var tutorialBox:Boolean = false;
		public var tutorialBoxDestroy:Boolean = false;
		public var tutorialHatch:Boolean = false;
		public var tutorialResourcesFuel:Boolean = false;
		public var tutorialResourcesCryo:Boolean = false;
		public var tutorialCrystals:Boolean = false;
		public var tutorialFull:Boolean = false;
		public var tutorialFuel:Boolean = false;
		public var tutorialFinish:Boolean = false;
		public var tutorialExplotionBox:Boolean = false;
		private var dropedItem:Boolean = false;
		private var crystalBool:Boolean = false;
		private var pickedObject:Boolean = false;
		
        private var connect:Connection;
		private var chopper:Chopper;
		
		private var success:Dialogs;
		
		private var hatchDoor:MovieClip;
		private var hatchPosition:Point; 
		
		private var tileFactor:Number;
        private var tileRelation:Number;
        private var tileProyection:Number;
        
        private var eCorrotion:int;
		public var mouseX:int;
        public var mouseY:int;
        private var totalCrystalPercentage:int;
		private var pauseID:int;
        private var bulletLevelCount:int;
		private var bulletLevel:int;
        
		private var hud:MissionHUD;
        private var world:MissionMap;
        
		private var missionData:Object;
		public var missionSource:Object;
		private var targetObject:Objetos;
		
		private var bullet:Particle;
		private var targetPosition:Point;
		
		private  var pauseQuad:Quad;
		
		private var mission_Id:String;
		
		public var gameplayTime:Timer = new Timer(1000);
		private var timerSec:int = 0;
        
		private var cryogelBullets:Vector.<Particle> = new Vector.<Particle>;
        public var mapPickups:Vector.<Objetos> = new Vector.<Objetos>;
		
		//public var space:Space = new Space(new Vec2(0,0));
		
		public function TutorialGameplay(_globalResources:GlobalResources, params:Object = null) 
		{
			super(_globalResources);
			globalResources = _globalResources;
            mission_Id = params.missionId;
			//missionObjects = params.missionObjects;
			missionData = params;
            connect = new Connection();
			globalResources.isInTutorial = true;
            
            this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }
        
        public function onAdded(e:Event):void {
            
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
			soundsScene.addSound("tutorialBGM", -1);
			soundsScene.addSound("explosive", 0);
			soundsScene.addSound("chopper_destroyed", 0);
			soundsScene.addSound("Gui_Button_accept", 0);
			soundsScene.addSound("Gui_Button_click", 0);
			soundsScene.addSound("Gui_Button_denied", 0);
			soundsScene.addSound("success", 0);
			soundsScene.addSound("chopper_voice/ok", 0);
			soundsScene.addSound("chopper_voice/got it", 0);
			soundsScene.addSound("chopper_voice/lock_and_load", 0);
			soundsScene.addSound("chopper_voice/move_in", 0);
			
            texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, onAtlasLoad);
			texturesScene.addTexture("screens", "Backgrounds");
            texturesScene.addTexture("Botones", "Buttons");
            texturesScene.addTexture("Gui", "Buttons");
            texturesScene.addTexture("chopper", "vehicles");
            texturesScene.addTexture("chooperFull", "vehicles");
            texturesScene.addTexture("Buildings", "World");
            texturesScene.addTexture("worldObjects", "World");
            texturesScene.addTexture("cryogel", "vehicles");
			texturesScene.addTexture("vehicleShield", "vehicles");
			texturesScene.addTexture("vehicleExplosion", "vehicles");
			texturesScene.addTexture("tutorial", "Tutorial");
            texturesScene.loadTextureAtlas();
            
        }
        
        
        public function initGamePlay():void {
           
            tileFactor = RAIZ2 / world.tilemap.tileHeight;
            tileProyection = world.tilemap.tileHeight * world.tilemap.mapHeight * RAIZ2 * 0.25;
            tileRelation = world.tilemap.tileHeight / world.tilemap.tileWidth;
            
            world.createPickups(mapPickups);
			world.createExplotions();
            world.createObstacles();
            world.createUsables();
			world.tilemap.crear_tilemap(bodiesScene.space);
			world.set_missionStart();
            addChild(world);
            
			hatchPosition = new Point(world.tilemap.center.x,world.tilemap.center.y);
			
			world.miniWorldMap.addMiniVehicle(new Point(world.tilemap.startMission.x,world.tilemap.startMission.x),texturesScene);
			addChild(world.miniWorldMap);
			
            pauseQuad = new Quad(stage.width, stage.height, 0x000000);
			pauseQuad.alpha = 0.75;
			pauseQuad.visible = false;
			tempData.push(pauseQuad);
			addChild(pauseQuad);
			
            chopper = new Chopper(texturesScene, soundsScene, globalResources);
            chopper.vehicleBody.position.x = world.tilemap.startMission.x;
            chopper.vehicleBody.position.y = world.tilemap.startMission.y - 95;
			chopper.x = 360;
			chopper.y = 265;
			chopper.scaleX = 0;
			chopper.scaleY = 0;
			chopper.visible = false;
			chopper.vehicleBody.space = bodiesScene.space;
			chopper.cryogel = 0;
            addChild(chopper);
			//chopper.update(null, 380, 200, new Point(world.x, world.y));
			
			hud = new MissionHUD(globalResources, texturesScene);
            hud.activateObjectCount(world.tilemap.tilemap_pickups.length);
			addChild(hud);
			
            this.addEventListener(TouchEvent.TOUCH, onMouse);
            this.addEventListener(Event.ENTER_FRAME, onUpdate);
            this.addEventListener(GameEvents.PICK_OBJECT, pickUpObject);
			this.addEventListener(GameEvents.DESTROY_CRYSTAL, onDestroyCrystal);
			this.addEventListener(GameEvents.DESTROY_PICKUP, onDestroyPickup);
			this.addEventListener(GameEvents.DROP_OBJECT, onDropObject);
			this.addEventListener(GameEvents.GAME_STATE, gameCurrentState);
            this.addEventListener(GameEvents.MISCELLANEOUS_EVENTS, miscellaneousEvents);
			this.addEventListener(GameEvents.EXIT_TUTORIAL, onDidTutorial);
			
			eCorrotion = world.tilemap.tilemap_obstacules.length;
			corrotionPercentage(world.tilemap.tilemap_obstacules.length);
			
            globalResources.deactivateSplash();
            globalResources.trackPageview("/Tutorial Gameplay");
			gameplayTime.start();
			gameplayTime.addEventListener(TimerEvent.TIMER, onTimer);
			
			world.soundsScene.getSound("tutorialBGM").play(globalResources.volume);
			world.hatchObj.hatchDoor.play();
			soundsScene.getSound("hatch_open").play(globalResources.volume);
			world.hatchObj.hatchDoor.addEventListener(Event.COMPLETE, onCompleteHatch);
			
			var dialogox:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
			dialogox.tutoDialogs("Principal",{pauseId:1});
			tempData.push(dialogox);
			addChild(dialogox);
			this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
			
			globalResources.trackEvent("Screen View", "user: " + globalResources.user_id, "Tutorial Screen");
			
			bodiesScene.activateAll();
			bodiesScene.diactivateBody("wall1");
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
            bitmapsScene.addTexture("BaseFloor", "World");
            bitmapsScene.loadTexture();
            
        }
        
        public function onSimpleTexturesLoad(e:GameEvents):void {
            
            bitmapsScene.removeEventListener(GameEvents.TEXTURE_LOADED, onSimpleTexturesLoad);
            connect.addEventListener(GameEvents.REQUEST_RECIVED, onReciveMissionSource);
			connect.get_src_mission(globalResources.pref_url+"maps/tutorialShort.json");
            
        }
		
		public function onReciveMissionSource(e:GameEvents):void{
            
            connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveMissionSource);
			
			missionSource = e.params;
			
			for (var keys:String in missionSource.pickups){
				missionObjects.push(keys);
			}
			
//			world.tilemap.addEventListener(GameEvents.TILEMAP_LOAD, onGetObject);
			world = new MissionMap(globalResources, texturesScene, imageScene, soundsScene, bitmapsScene,objetosScene, bodiesScene,missionSource.map);
            
			onGetObject();
			
        }
        /*
        public function onInit():void {
            
            world = new MissionMap(globalResources, texturesScene, imageScene, soundsScene, bitmapsScene,objetosScene, mission_Id);
            world.tilemap.addEventListener(GameEvents.TILEMAP_LOAD, onGetObject);
        }*/
        
        public function onGetObject(e:GameEvents= null):void{
            
            //world.tilemap.removeEventListener(GameEvents.TILEMAP_LOAD, onGetObject);
			world.createMiniMap();
			onReciveSave();
        }
        
		/********************************************************
         * 
         * 				    LOAD FUNCIONS 
         * 
         * *****************************************************/
		
        private function onReciveSave(e:GameEvents=null):void
        {/*
            connect.removeEventListener(GameEvents.REQUEST_RECIVED, onReciveSave);
            var state:Object = e.params;
            
                if(state.status == undefined && state.map.pickUps != undefined){
                    //world.missionMapObjects = state.map.pickUps;
                    //pickedObjectsId = state.map.pickUps;
                    //world.missionMapCrystals = state.map.crystals;
                    //destroyedCrystalsId=state.map.crystals;
                }*/
            getObject();
        }
        
        private function getObject():void
        {
            //trace("Mission " + mission_Id, "Objects: " + missionObjects);
            connect.getObjects(missionObjects);
            connect.addEventListener(GameEvents.REQUEST_RECIVED, recieveObject);
        }
        
        public function recieveObject(e:GameEvents):void{
            
            
            connect.removeEventListener(GameEvents.REQUEST_RECIVED, recieveObject);
            var json:Object = e.params;
            
            var i:int = 0;
                while (json[i] != undefined) {
                    var objeto:Object = new Object();
                    objeto.layerName = world.tilemap.tilemap_pickups[i].name;
                    objeto.objectName =  world.tilemap.tilemap_pickups[i].name;
                    objeto.objectInfo = json[i];
                    objeto.objectPosition = world.tilemap.tilemap_pickups[i].pos;
                    objeto.gridPosition = world.tilemap.tilemap_pickups[i].grid; 
                    mapPickups.push(new Objetos(texturesScene, soundsScene, globalResources, objeto));
                    i++;
                }
                initGamePlay();
                
        }
		
		/********************************************************
         * 
         * 				    SAVE FUNCIONS 
         * 
         * *****************************************************/
		
		private function saveMission(_save:Object):void {
			var save:String;
			save = JSON.stringify(_save);
			connect.addEventListener(GameEvents.REQUEST_RECIVED, saveMissionComplete);
		}
		
		private function saveMissionComplete(e:GameEvents):void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, saveMissionComplete);
			var mObject:Object = new Object();
			mObject.objetos = myWorldObjects;
			mObject.shuttleObjects = myWorldShuttleObjects;
			mObject.sentShuttle = shuttleSent;
			saveObjectsToWorld(mObject);
		}
		
		private function saveObjectsToWorld(_save:Object):void {
			var save:String;
			save = JSON.stringify(_save);
			connect.addEventListener(GameEvents.REQUEST_RECIVED, saveObjectsToWorldComplete);
		}
		
		private function saveObjectsToWorldComplete(e:GameEvents):void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, saveObjectsToWorldComplete);
			var mObject:Object = new Object();
			//mObject.mission001 = missionState01;
			//mObject.mission002 = missionState02;
			//mObject.mission003 = missionState03;
			saveMissionStatus(mObject);
		}
		
		private function saveMissionStatus(_save:Object):void {
			var save:String
			save = JSON.stringify(_save);
			connect.addEventListener(GameEvents.REQUEST_RECIVED, saveMissionStatusComplete);
			connect.save_state(parseInt(globalResources.user_id),-1,save,"");
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
			var objectPos:Point;
            
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
                
                if (worldObject != null) {
                    //check for picks
                    worldObject.actionNear();
                    if (worldObject.isPickable && chopper.pickupObject(worldObject.x + world.x, worldObject.y + world.y, worldObject.collisionArea) && chopper.retractChopperCrane(false)) {
                       
						if (chopper.targetPickup && (worldObject == chopper.targetPickup)) chopper.targetPickup = false;
                        
                        switch (worldObject.type) {
                            
                            case 1://aqui va chopper full
									chopper.craneDown = false;
                                	if (hud.addObject(worldObject)) {
										if (!tutorialFull) 
										{
											var tutoDialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
											worldObject.img.filter = worldObject.filters;
											tutoDialog.tutoDialogs("Full", { pauseId:1 } );
											tempData.push(tutoDialog);
											addChild(tutoDialog);
											tutorialFull = true;
											this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
										}
										trace("aqui va chopper full");
										var cargoFull:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene);
										cargoFull.alertDialog("vehicleFull");
										cargoFull.y = -100;
										chopper.frontSprite.addChild(cargoFull);
										
									}else {
										pickedObjectsId.push(worldObject.id);
										myWorldObjects.push(worldObject.objectData.objectInfo.object_id);
										trace(worldObject.objectData.objectInfo.object_id);
										world.sprite02.removeChild(worldObject);
										world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
										objetosScene.deleteObjeto(nameObject,false);
										hud.disposeAnimation(worldObject, world.x, world.y);
										hud.updateCargo(1, "sum");
										pickedObject = true;
										if (hud.missionInventory.size == 4) 
										{
											if (!tutorialHatch) 
												{
													var tutoDialogFull:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
													tutoDialogFull.tutoDialogs("Full", { pauseId:1 } );
													tempData.push(tutoDialogFull);
													addChild(tutoDialogFull);
													tutorialHatch = true;
													this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
													
												}
										}
										
										deploySuccess("wall2");
										
									}
                                
                                break;
                                
                            case 2:
                                
                                
                                break;
                                
                            case 3:
								chopper.cryogel += 0.4;
                                if (++chopper.cryogel > 1) chopper.cryogel = 1;
                                chopper.craneDown = false;
                                world.sprite02.removeChild(worldObject);
								world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
                                objetosScene.deleteObjeto(nameObject);
								hud.disposeAnimation(worldObject, world.x, world.y);
								soundsScene.getSound("gas_cryo_pickup").play(globalResources.volume);
                                break;
                                
                            case 4:
								chopper.fuel += 0.005;
                                if (++chopper.fuel > 1) chopper.fuel = 1;
                                chopper.craneDown = false;
                                world.sprite02.removeChild(worldObject);
								world.miniWorldMap.objetosSprite.removeChild(worldObject.minimapImage);
                                objetosScene.deleteObjeto(nameObject);
								hud.disposeAnimation(worldObject, world.x, world.y);
								soundsScene.getSound("gas_cryo_pickup").play(globalResources.volume);
                                break;
							case 8:
								chopper.fuel -= 0.2;
								chopper.craneDown = false;
								world.sprite02.removeChild(worldObject);
                                objetosScene.deleteObjeto(nameObject);
								explosiveAnimation(chopper.x, chopper.y);
								break;
							case 9:
								if (onUse) {
									chopper.canShoot = false;
									chopper.grabBattery = worldObject;
									objetosScene.deleteObjeto(worldObject.namePosition, false);
									chopper.useBtn = true;
								}
								break;
						
                        }
                        
                        break;
                    }
                    
                        //Detectar si tengo un objeto cerca
                        if(!chopper.nearObjPick && worldObject.isPickable && chopper.detectNearObject(worldObject.x+world.x,worldObject.y+world.y, worldObject.collisionArea)){
                            if (!chopper.craneDown && worldObject.type != 5) chopper.initChopperCrane();
							switch (worldObject.type) 
							{
								case 1:
									if (!tutorialBox) 
									{
										var tutoDialog0:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
										//worldObject.img.filter = worldObject.filters;
										tutoDialog0.tutoDialogs("Pickups", { pauseId:1 }, true );
										tempData.push(tutoDialog0);
										addChild(tutoDialog0);
										tutorialBox = true;
										this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
										
										bodiesScene.activateAll();
									}
									
									if (pickedObject && !tutorialBoxDestroy) 
									{
										worldObject.isPickable = false;
										
										var tutoDialogDestroyPickup:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
										//worldObject.img.filter = worldObject.filters;
										tutoDialogDestroyPickup.tutoDialogs("PickupsDestroy", { pauseId:1 } );
										tempData.push(tutoDialogDestroyPickup);
										addChild(tutoDialogDestroyPickup);
										tutorialBoxDestroy = true;
										this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
										
										bodiesScene.activateAll();
									}
									
								break;
								case 3:
								if (!tutorialResourcesCryo) 
									{
										var tutoDialog1:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
										worldObject.img.filter = worldObject.filters;
										tutoDialog1.tutoDialogs("Cryogel", { pauseId:1 } );
										tempData.push(tutoDialog1);
										addChild(tutoDialog1);
										tutorialResourcesCryo = true;
										this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
									}
									
								break;
								case 4:
									if (!tutorialResourcesFuel) 
									{
										var tutoDialog2:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
										worldObject.img.filter = worldObject.filters;
										tutoDialog2.tutoDialogs("Fuel", { pauseId:1 } );
										tempData.push(tutoDialog2);
										addChild(tutoDialog2);
										tutorialResourcesFuel = true;
										this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
									}
								break;
								case 5:
								nearHatch = true;
										if (!exitMissionDialog && timerSec > 10) 
										{
											//if (dialog != null) { removeChild(dialog); dialog = null;}
											var exitDialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 180, globalResources.stageHeigth);
											//this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"hatch", objetox:worldObject }, true));
											exitDialog.alertDialog("leaveMission",null,{pauseId:5, tutorial:true});
											
											var tween:Tween = new Tween(exitDialog, 0.20, Transitions.EASE_IN);
											tween.moveTo(180, exitDialog.y - (exitDialog.height+100));
											Starling.juggler.add(tween);
											
											hud.dialogSprite.removeChildren();
											hud.dialogSprite.addChild(exitDialog);
											
											this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:5 }, true));
											exitMissionDialog = true;
										}
								break;
								case 8:
									if (!tutorialExplotionBox) 
									{
										var tutoDialog3:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
										worldObject.img.filter = worldObject.filters;
										tutoDialog3.tutoDialogs("Explosives", { pauseId:1 } );
										tempData.push(tutoDialog3);
										addChild(tutoDialog3);
										tutorialExplotionBox = true;
										this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
									}
								break;
							}
                            chopper.nearObjPick=true;
                            break;
                        }
                    //end for picks
                    
					
					
									
                    //check for targets
                    
                    if(!chopper.targetCheked && worldObject.type==0 && chopper.detectTarget(worldObject.x, worldObject.y, world.x, world.y,worldObject.collisionArea)){
                    
                        if (chopper.cryogel < 0){
                            chopper.cryogel =0;
                        }else { 
							if (!tutorialCrystals) 
							{
								var tutoDialogCristal:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene, 100, 40);
								//worldObject.img.filter = worldObject.filters;
								tutoDialogCristal.tutoDialogs("Cristales", { pauseId:1 } );
								tempData.push(tutoDialogCristal);
								addChild(tutoDialogCristal);
								tutorialCrystals = true;
								this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
								
								bodiesScene.activateAll();
							}else {
								chopper.targetCheked = true;
								chopper.shield.visibleOn();
								chopper.fuel-=0.0009;
							}
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
				chopper.grabBattery.y = (chopper.y - 50) - world.y;
				onUse = true;
				
			}
        
			if (!nearHatch) 
			{
				exitMissionDialog = false;
			}
			
            translate_fondo();
            
			if (!chopper.targetCheked) chopper.shield.visibleOff();
            chopper.update(e, mouseX, mouseY,new Point(world.x,world.y));
			
			hud.update_meters(chopper.fuel, chopper.cryogel);
			
			// EOG by running out of fuel
			
			if (chopper.fuel < 0) {
				chopper.fuel = -0.1;
				soundsScene.getSound("chopper_full").stop();
				soundsScene.getSound("beep_alert").stop();
				//pause();
				//chopper.destroyChooper();
				//chopper.explosion.addEventListener(Event.COMPLETE, onDestroyVehicle);
			}//-----
            
			// Low meters Alerts
			if ((chopper.fuel < 0.2) && !meterWarning ) {
				meterWarning = true;
				if (!tutorialFuel) 
				{
					var dialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene,100, 40);
					dialog.tutoDialogs("FuelEmpty", { pauseId:1 } );;
					tempData.push(dialog);
					addChild(dialog);
					tutorialFuel = true;
					this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
				}
			}
			
			if ((chopper.fuel > 0.2) && meterWarning ) {
				meterWarning = false;;
			}
			//--------
			
			if (totalCrystalPercentage == 0 && hud.picked_total == hud.objectTotal && !tutorialFinish) {
				if (!tutorialFinish) 
				{
					var tutoFinish:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene,100, 40);
					tutoFinish.tutoDialogs("Finish", { pauseId:1 } );;
					tempData.push(tutoFinish);
					addChild(tutoFinish);
					tutorialFinish = true;
					translateHatch();
					this.dispatchEvent(new GameEvents(GameEvents.GAME_STATE, { type:"gamePause", pauseId:1 }, true));
				}
			}
			
			if (totalCrystalPercentage == 0 && !crystalBool) {
				deploySuccess("wall3");
				crystalBool = true;
			}
        }
		
		private function onTimer(e:TimerEvent):void 
		{
			timerSec++;
		}
        
		public function translateHatch():void {
			
			var nameObject:String = hatchPosition.x.toString() + "," + hatchPosition.y.toString();
			var hatchAux:Objetos = objetosScene.getObjeto(nameObject);
			objetosScene.deleteObjeto(nameObject, false);
			
			hatchAux.visible = true;
			hatchAux.x = world.tilemap.startMission.x+(20*world.tilemap.tileWidth);
			hatchAux.y = world.tilemap.startMission.y+(20*world.tilemap.tileHeight);
			nameObject = (hatchPosition.x+40).toString() + "," +hatchPosition.y.toString();
			objetosScene.addObjeto(nameObject, hatchAux);
			hatchAux = null;
			
		}
		
        public function translate_fondo():void {
            var p:Point=new Point(0,0);
            if (chopper.canMove) {
				
                if(/*chopper.x==200 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.x=chopper.vehicleBody.velocity.x*0.03125;chopper.ptoPickup.x-=p.x;}
            //    if(/*chopper.x==560 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.x=chopper.vehicleBody.velocity.x*0.03125;chopper.ptoPickup.x-=p.x;}
                if(/*chopper.y==200 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.y=chopper.vehicleBody.velocity.y*0.03125;chopper.ptoPickup.y-=p.y;}
            //    if(/*chopper.y==250 &&*/ (chopper.clickToMove || chopper.targetPickup)){p.y=chopper.vehicleBody.velocity.y*0.03125;chopper.ptoPickup.y-=p.y;}
                world.x -= p.x;
                world.y -= p.y;
				
                move_tileset();
                
            }
			
			world.miniWorldMap.objetosSprite.x = 30 + world.x * 0.1;
			world.miniWorldMap.objetosSprite.y = 15 + world.y * 0.1;
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
		
		public function onDestroyVehicle(e:Event):void {
			
			chopper.explosion.removeEventListener(Event.COMPLETE, onDestroyVehicle);
			
			var dialog:Dialogs = new Dialogs(globalResources, texturesScene, soundsScene,200,150);
			dialog.alertDialog("missionFailed", null , missionData);
			tempData.push(dialog);
			addChild(dialog);
			
		}
		
		public function onDestroyCrystal(e:GameEvents):void {
			
			var crystalDestroyed:Objetos = e.params.crystal as Objetos;
			
			if(crystalDestroyed.type == 0){
			
			destroyedCrystalsId.push(crystalDestroyed.id);
			
            world.sprite02.removeChild(crystalDestroyed);
			world.miniWorldMap.objetosSprite.removeChild(crystalDestroyed.minimapImage);
            eCorrotion--;
//			destroyed_crystal.push(worldObject.id);// Save in Destroy crystal vector for Save State
            corrotionPercentage(world.tilemap.tilemap_obstacules.length);
            objetosScene.deleteObjeto(crystalDestroyed.namePosition);
			}
			if (crystalDestroyed.type == 12) {
				
				crystalDestroyed.convertToPickup();
				
				
			}
            crystalDestroyed = null;
			activeShot = false;
		}
		
		public function onDropObject(e:GameEvents):void {
			dropedItem = true;
			hud.updateScore(1);
			hud.updateCargo(1, "res");
			var p:Objetos = e.params as Objetos;
			var _p:Point = world.globalToLocal(new Point(chopper.x,chopper.y+Chopper.H));
			p.x=_p.x;
			p.y=_p.y;
		    	
			
			world.add_object_drop_chopper(p,chopper.GridPos);
			
//			Eliminar del arreglo de objetos y mi mundo el objeto dropeado
			
			for(var i:uint=0;i<pickedObjectsId.length;++i){
				if (pickedObjectsId[i] == p.id){
					pickedObjectsId.splice(i as int,1);	
				}
			}
			
			for(var j:uint=0;j<myWorldObjects.length;++j){
				if (myWorldObjects[j] == p.objectData.objectInfo.object_id){
					myWorldObjects.splice(j as int,1);	
				}
			}
			
			
		}
		
		public function onDestroyPickup(e:GameEvents):void {
			var pickupDestroyed:Objetos = e.params.pickup as Objetos;
			pickedObjectsId.push(pickupDestroyed.id);
			myWorldObjects.push(pickupDestroyed.objectData.objectInfo.object_id);
			//trace(pickupDestroyed.objectData.objectInfo.object_id);
			world.sprite02.removeChild(pickupDestroyed);
			world.miniWorldMap.removeChild(pickupDestroyed.minimapImage);
			objetosScene.deleteObjeto(pickupDestroyed.namePosition);
			//hud.disposeAnimation(pickupDestroyed, world.x, world.y);
			hud.updateScore(0, 1);
			deploySuccess();
		}
        public function corrotionPercentage(_length:int):void{
            
            totalCrystalPercentage = (eCorrotion * 100) / _length;
			hud.corrotion_text.text = totalCrystalPercentage + "%";
            //inGame_interface.corrotion_text.text = totalCrystalPercentage+"%";
        }
		
		public function onDidTutorial(e:GameEvents):void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onExitTutorial);
			connect.save_tuto(parseInt(globalResources.user_id))
		}
		
		public function onExitTutorial(e:GameEvents):void {
			if (globalResources.tutorialDone) {
				trace("tutorial: ya lo habia hecho");
				this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN,{type: "missionScreen", megatile_id: 0}, true));
			}else {
				trace("tutorial: Primera vez que hago tutorial");
				globalResources.tutorialDone = true;
				this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, { type:"newComic",  data: { numScenes: 3, name:"Movies", nextSceneData: {type: "missionScreen", megatile_id: 0}}}, true));
			}
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
						if (e.params.resumeId == 5) 
						{
							hud.onButtonClicked();
						}
					}
					break;
				case "saveState":
					var sObject:Object = new Object();
					sObject.pickUps= pickedObjectsId;
					sObject.crystals= destroyedCrystalsId;
					sObject.id = mission_Id;
					saveMission(sObject);
					break;
			}
		}
		
        public function pause():void {
                    
                    if (isPaused) {
                        pauseQuad.visible = false;
                        this.addEventListener(Event.ENTER_FRAME, onUpdate);
                        isPaused = false;
						//if (pauseID == 3) 
						//{
							//hud.boxBomb.visible = false;
							//hud.boxXray.visible = false;
						//}
                    }else {
                        pauseQuad.visible = true;
                        if (pauseID == 8) 
						{
							pauseQuad.visible = false
						}
						this.removeEventListener(Event.ENTER_FRAME, onUpdate);
						
                        isPaused = true;
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
            var rec:Rectangle = new Rectangle(0, 180, 65, 220);
            /*
            var auxX:int = (pos.x - world.x)*tileRelation;
            var auxY:int = pos.y - world.y;
            
            var posX:int = ((((auxX + auxY) * I_RAIZ2) + tileProyection) * tileFactor);
            var posY:int = ((((auxY - auxX) * I_RAIZ2) + tileProyection) * tileFactor);
            
            var nameObject:String = posX.toString() + "," +posY.toString();
            var worldObject:Objetos = objetosScene.getObjeto(nameObject);
            
			*/
            mouseX=pos.x;
            mouseY=pos.y;	
            /*
        
            if (worldObject == null){
            */
                if(touch.phase==TouchPhase.BEGAN && chopper.hitTestPoint(mouseX,mouseY) && touch.tapCount != 2 && (chopper.cryogel > 0.2 && chopper.canShoot)){
                   this.dispatchEvent(new GameEvents(GameEvents.MISCELLANEOUS_EVENTS, { type:"shootState" }, true));
                }
                else { 
                    if (!isPaused && touch.tapCount != 2 && !rec.containsPoint(pos)) {
                        chopper.onMouse_H(touch.phase,mouseX,mouseY);
                    }
					if (touch.phase==TouchPhase.BEGAN && chopper.hitTestPoint(mouseX,mouseY) && chopper.cryogel <= 0.2) {
						trace("out of cryogel");
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
						//hud.boxBomb.x = _objeto.x + world.x;
						//hud.boxBomb.y = _objeto.y + world.y;
						//hud.boxBomb.visible = true;
					}
					break;
				case "objectInfo":
					_objeto = e.params.objetox;
					hud.dialogSprite.removeChildren();
					hud.dialogSprite.addChild(_objeto.objectInfoDialog);
					_objeto.objectInfoDialog.visible = true;
					break;
				case "hatch":
					_objeto = e.params.objetox;
					hud.dialogSprite.removeChildren();
					hud.dialogSprite.addChild(_objeto.dialog);
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
							fireCryogel(targetPosition, targetObject.type);
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
						
						if (tempObj !=null && tempObj.type == 10 && chopper.pickupObject(tempObj.x + world.x, tempObj.y + world.y, tempObj.collisionArea)) {
							
							tempObj.img.visible = false;
							tempObj.powerPlantOn.visible = true;
							
							world.sprite02.removeChild(chopper.grabBattery);
							chopper.grabBattery.dispose();
							chopper.grabBattery = null;
							
							onUse = false;
							chopper.craneDown = false;
							chopper.canShoot = true;
							chopper.useBtn = false;
							
							world.activateTrigger(tempObj.letterType);
							
							break;
						}
						
					}
					
					if (onUse) {
						
						nameObject1 = posX1.toString() + "," +posY1.toString();
						chopper.grabBattery.objectData.namePos = nameObject1;
						world.objetosScene.addObjeto(nameObject1, chopper.grabBattery);
						chopper.grabBattery.y += 50;
						chopper.grabBattery.isPickable = false;
						chopper.grabBattery = null;
						
						onUse = false;
						chopper.craneDown = false;
						chopper.canShoot = true;
						chopper.useBtn = false;
					}
					break;
			}
		}
		
		public function chopperShotUpdate(e:Event):void {

			var auxX:int = (mouseX - world.x)*tileRelation;
            var auxY:int = mouseY - world.y;
            
            var posX:int = ((((auxX + auxY) * I_RAIZ2) + tileProyection) * tileFactor);
            var posY:int = ((((auxY - auxX) * I_RAIZ2) + tileProyection) * tileFactor);
			
			chopper.updateTarget(mouseX, mouseY);
			
			//Busqueda de cristal por area
            
            var initialX:int = posX - 1;
            var initialY:int = posY - 1;
			
			//Carga de niveles de disparo de Cryogel
			
			bulletLevelCount++;
			if ((bulletLevelCount % 32) == 0) {
				bulletLevel = bulletLevelCount / 32;
				bulletChargeAnimation(bulletLevel);
				if (bulletLevel == 2) bulletLevelCount = -20;
			}
			
            for (var i:int = 0; i < 9; ++i) {
                
                var gridX:int = initialX + (i % 3);
                var gridY:int = initialY + (i / 3);
				
				var nameObject:String = gridX.toString() + "," +gridY.toString();
				targetObject = objetosScene.getObjeto(nameObject);
			
				if (targetObject != null)
				{
					
					if (targetObject.type == 0 || targetObject.type == 1 || targetObject.type == 12)
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
				}
			}	
			
		}
		
		public function bulletChargeAnimation(Level:int):void {
			var tween:Tween;
			//trace("Level: " + Level);
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
			
			if (type == 0 || targetObject.type == 12)tween.onComplete = crystalFreezeAnimation;
			if (type == 1) tween.onComplete = destroyBox;
			
			switch (bulletLevel) 
			{
				case 0:
					soundsScene.getSound("crioshot_lvl_001").play(globalResources.volume);
					chopper.cryogel -= 0.05;
					if (type == 0 || targetObject.type == 12) 
					{
						targetObject.hp -= 300;
						bulletLevel = 0;
					}
				break;
				case 1:
					soundsScene.getSound("crioshot_lvl_002").play(globalResources.volume);
					chopper.cryogel -= 0.10;
					if (type == 0 || targetObject.type == 12) 
					{
						targetObject.hp -= 300;
						bulletLevel = 0;
					}
				break;
				case 2:
					soundsScene.getSound("crioshot_lvl_003").play(globalResources.volume);
					chopper.cryogel -= 0.15;
					if (type == 0 || targetObject.type == 12) 
					{
						targetObject.hp -= 300;
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
			switch (targetObject.hp) 
			{
				case 0:
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
				break;
				case 100:
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
				break;
				case 200:
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
				break;
			}
		}
		
		public function removeCryogelBullet():void {
			var tween:Tween;
			bullet.explotionAnimation();
			bullet = null;
			this.dispatchEvent(new GameEvents(GameEvents.DESTROY_CRYSTAL, {crystal: targetObject}, true));
			
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

		public function explosiveAnimation(posX:int, posY:int):void {
			var explotion:Particle = new Particle("explotionParticle");
			explotion.x = posX;
			explotion.y = posY;
			addChild(explotion);
		}
		
		public function deploySuccess(_type:String = "All"):void {
			if (success!= null) 
			{
				chopper.frontSprite.removeChild(success);
				success = null;
			}
			success = new Dialogs(globalResources, texturesScene, soundsScene);
			success.successAlert();
			chopper.frontSprite.addChild(success);
			
			if (_type == "All") 
			{
				bodiesScene.diactivateAll();
			}else{
				bodiesScene.diactivateBody(_type);
			}
		}
		
		override public function dispose():void 
		{
			world.soundsScene.getSound("tutorialBGM").stop();
			hud.dispose();
			world.dispose();
			gameplayTime.stop();
			gameplayTime.removeEventListener(TimerEvent.TIMER, onTimer);
			gameplayTime = null;
			super.dispose();
			
		}
        
    }

}
