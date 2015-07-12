package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Clases.MissionTargets;
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MissionScreen extends Scene 
	{
		
		public static const ButtonsAssets:String = "Botones";
		public static const TutorialAssets:String = "Game_objectives";
		public static const ScreenAssets:String = "screens";
		public static const MissionAssets:String = "fondoMission";
		
		public var connect:Connection;
		public var targetsMissionInfo:Vector.<Object> = new Vector.<Object>;
		
		public function MissionScreen(_globalResources:GlobalResources)
		{
			
			super(_globalResources);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		public function onAddedtoStage(e:Event):void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
			
			texturesScene.addTexture(MissionAssets, "Backgrounds");
			texturesScene.addTexture(ScreenAssets, "Backgrounds");
			texturesScene.addTexture(TutorialAssets, "Backgrounds");
			texturesScene.addTexture(ButtonsAssets, "Buttons");
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, loadMissionInfo);
			texturesScene.loadTextureAtlas();
		}
		
		public function drawScreen():void {
			var bg:Image = new Image(texturesScene.getAtlas(ScreenAssets).getTexture("missionSelect"));
			tempData.push(bg);
			this.addChild(bg)
			bg = null;
			
			var grid:Image = new Image(texturesScene.getAtlas(MissionAssets).getTexture("mission_grid"));
			tempData.push(grid);
			this.addChild(grid);
			grid = null;
			
			var legend01:Image = new Image(texturesScene.getAtlas(MissionAssets).getTexture("mission_db"));
			tempData.push(legend01);
			legend01.y = 280;
			this.addChild(legend01);
			legend01 = null;
			
			var legend02:Image = new Image(texturesScene.getAtlas(MissionAssets).getTexture("mission_dt"));
			tempData.push(legend02);
			this.addChild(legend02);
			legend02 = null;
			
			var userName:TextField = new TextField(106, 17, "Lt. " + globalResources.user_lastName, "Roboto-Regular", 10, 0xffffff);
			userName.x = 575;
			userName.y = 2;
			tempData.push(userName);
			this.addChild(userName);
			userName = null;
			
			var userImage:ImageLoader = new ImageLoader (globalResources.picture_url, globalResources.loaderContext, 60, 60);
			userImage.x = 690;
			userImage.y = 5;
			tempData.push(userImage);
			this.addChild(userImage);
			userImage = null;
			
			var myWorldBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("myWorld"));
			tempData.push(myWorldBtn);
			myWorldBtn.x = 700;
			myWorldBtn.y = 340;
			myWorldBtn.addEventListener(Event.TRIGGERED, onMyWorld);
			this.addChild(myWorldBtn);
			
			for (var i:uint = 0; i < targetsMissionInfo.length;++i) {
				var target:MissionTargets = new MissionTargets(globalResources, texturesScene,soundsScene, targetsMissionInfo[i]);
				target.x = targetsMissionInfo[i].targetPosition.x;
				target.y = targetsMissionInfo[i].targetPosition.y;
				tempData.push(target);
				addChild(target);
				target = null;
			}
			
			globalResources.deactivateSplash();
			//globalResources.tracker.trackPageview("/Mission Screen");
		}
		
		public function loadMissionInfo():void {
			//connect.addEventListener(GameEvents.REQUEST_RECIVED, onRequestRecived);
			//connect.get_missions_info();
			onRequestRecived();
		}
		
		private function onRequestRecived(e:GameEvents = null):void
		{
			//connect.removeEventListener(GameEvents.REQUEST_RECIVED, onRequestRecived);
			
			//var json:Object = e.params;
			var objeto:Object = new Object;
			var objeto2:Object = new Object;
			var objeto3:Object = new Object;
			var i:int = 1;
			
			objeto.missionID = "001";
			objeto.missionObjects = [61,47,46,408,324];
			objeto.targetPosition = new Point(150, 80);
			objeto.finalMissionID = null;
			objeto.missionDescription = "Recoje los objetos y destruye los cristales";
			objeto.missionImage = "http://d389o9kfupjsqw.cloudfront.net/objects/23/picture/23_picture_1373402214.png";
			targetsMissionInfo.push(objeto);
			
			objeto2.missionID = "002";
			objeto2.missionObjects = [401,4,380,379,377,20,375];
			objeto2.targetPosition = new Point(100, 300);
			objeto2.finalMissionID = null;
			objeto2.missionDescription = "Recoje los objetos y destruye los cristales";
			objeto2.missionImage = "http://d389o9kfupjsqw.cloudfront.net/objects/47/picture/47_picture_1373402235.jpg";
			targetsMissionInfo.push(objeto2);
			
			objeto3.missionID = "003";
			objeto3.missionObjects = [374,373,372,371,407,3,376,1];
			objeto3.targetPosition = new Point(300, 300);
			objeto3.finalMissionID = null;
			objeto3.missionDescription = "Recoje los objetos y destruye los cristales";
			objeto3.missionImage = "http://d389o9kfupjsqw.cloudfront.net/objects/1/picture/1_picture_1373402193.jpg";
			targetsMissionInfo.push(objeto3);
		
			//while (json[i] != undefined) {
				//
				//objeto.missionID = json[i].missionID;
				//objeto.missionObjects = json[i].objectsID;
				//objeto.targetPosition = new Point(json[i].targetX, json[i].targetY);
				//objeto.finalMissionID = json[i].finalObject;
				//objeto.missionDescription = json[i].description;
				//objeto.missionImage = json[i].imageURL;
				//targetsMissionInfo.push(objeto);
				//i++
			//}
			
			drawScreen();
		}
		
		public function onMyWorld(e:Event):void {
			//globalResources.tracker.trackEvent("Button-Triggered", "user: " + globalResources.user_id, "Mission Screen: bnt_shuttleScreen");
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"myWorldScreen"}));
		}
	}

}