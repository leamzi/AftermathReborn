package com.tucomoyo.aftermath.Screens 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.GameEvents
	import com.tucomoyo.aftermath.Engine.Scene;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.Event;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MyWorldScreen extends Scene 
	{
		
		public static const ButtonsAssets:String = "Botones";
		public static const ScreenAssets:String = "screens";
		
		private var connect:Connection;
		
		public function MyWorldScreen(_globalResources:GlobalResources) 
		{
			
			super(_globalResources);
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		public function onAddedtoStage(e:starling.events.Event):void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedtoStage);
			
			texturesScene.addTexture(ScreenAssets, "Backgrounds");
			texturesScene.addTexture(ButtonsAssets, "Buttons");
			texturesScene.addEventListener(GameEvents.TEXTURE_LOADED, onTextureComplete);
			texturesScene.loadTextureAtlas();
		}
		
		public function onTextureComplete(e:GameEvents):void {
			var bg:Image = new Image(texturesScene.getAtlas(ScreenAssets).getTexture("inventory"));
			tempData.push(bg);
			this.addChild(bg)
			
			var returnBtn:Button = new Button(texturesScene.getAtlas(ButtonsAssets).getTexture("btn_back"));
			returnBtn.x = 640;
			tempData.push(returnBtn);
			returnBtn.addEventListener(starling.events.Event.TRIGGERED, onReturn);
			this.addChild(returnBtn);
			
			var sendShuttleBtn:Button = new Button (texturesScene.getAtlas(ButtonsAssets).getTexture("btn_lanzar_00"));
			sendShuttleBtn.x = 570;
			sendShuttleBtn.y = 270;
			tempData.push(sendShuttleBtn);
			this.addChild(sendShuttleBtn);
			
			globalResources.deactivateSplash();
			//globalResources.tracker.trackPageview("/Shuttle Screen");
		}
		
		public function onReturn(e:starling.events.Event):void {
			this.dispatchEvent(new GameEvents(GameEvents.CHANGE_SCREEN, {type:"missionScreen"}));
		}
		
		/********************************************************
         * 
         * 				      EVENTS
         * 
         * *****************************************************/
		
		public function loadMyWorldObjects():void {
			connect.addEventListener(GameEvents.REQUEST_RECIVED, loadMyWorldObjectsComplete);
			connect.get_save_state(parseInt(globalResources.user_id), 0);
		}
		
		public function loadMyWorldObjectsComplete(e:GameEvents):void {
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, loadMyWorldObjectsComplete);
			
			var state:Object = e.params;	
			if(state.status == undefined && state.map.objetos != undefined){
				//inventory_objects = state.map.objetos;
				//shuttleCount = state.map.shuttlecount;
				//shuttleSent = state.map.sentShuttle;
			}
			if(state.status == undefined && state.map.shuttleObjects != undefined){
				//shuttle_objects_id = state.map.shuttleObjects;
				//shuttleSent = state.map.sentShuttle;
			}
			if(state.status == undefined && state.map.sentShuttle != undefined){
				//shuttleSent = state.map.sentShuttle;
			}
			//getObjects(inventory_objects,0);
		}
		
		public function getObjects(_inventoryObjects:Array, _type:int):void {
			if (_type == 0){
				//connect.loader.addEventListener(flash.events.Event.COMPLETE, recieveObjects);
			}
			else{
				//connect.loader.addEventListener(flash.events.Event.COMPLETE, recieveObjectsShuttle);
			}
			//connect.getObjects(_inventory_objects);
		}
		
		public function recieveObjects():void{
			
			//connect.loader.removeEventListener(flash.events.Event.COMPLETE, recieveObjects);
			//json = JSON.parse(connect.loader.data.toString());
			//
			//var i:int = 0;
			//while (json[i] != undefined) {
				//myObjects.push(new myWolrd_object(i, json[i].name, json[i].sources[0].summary, json[i].media[0].src, json[i].object_id, resources));
				//i++;
			//}
			//if (shuttle_objects_id != null){
				//getObjects(shuttle_objects_id,1);
			//}else{
				//init();
			//}
			
		}
		
		public function recieveObjectsShuttle(e:flash.events.Event):void{
			
			//connect.loader.removeEventListener(flash.events.Event.COMPLETE, recieveObjectsShuttle);
			//json = JSON.parse(connect.loader.data.toString());
			//
			//var i:int = 0;
			//while (json[i] != undefined) {
				//myShuttleObjects.push(new myWolrd_object(i, json[i].name, json[i].sources[0].summary, json[i].media[0].src, json[i].object_id, resources));
				//i++;
			//}
			//init();
		}
		
		
	}

}