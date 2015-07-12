package com.tucomoyo.aftermath.Connections 
{
	
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.utils.Dictionary;
		
	import flash.display.Loader;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.events.IOErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Security;
	
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Connection extends EventDispatcher 
	{
		Security.allowDomain("*");
		public var loader:URLLoader = new URLLoader();
		private var actionTable:Dictionary;
		public var resources:GlobalResources;
		
		private var URL_Request_Api:String = "http://aftermath.fourpillargames.com/api/";
		private var URL_Request_Tucomoyo:String = "http://tucomoyo-api.ing3nia.com/v1/";
		
		public function Connection() 
		{
			super();
			actionTable = new Dictionary();
			
			fillActionTable();
			
		}
		
		public function fillActionTable():void {
		
			actionTable["FINAL_PICKUP"] = 22;
			actionTable["PICKUP"] = 23;
			actionTable["PICKUP_DROP_OTHER_ITEM"] = 24;
			actionTable["CHOOSE_MISSION"] = 25;
			actionTable["VOTE_3_ON_TROPHY_ROOM"] = 26;
			actionTable["PICKUP_READ_DESCRIPTION"] = 27;
			actionTable["DROPAFTER_FULL"] = 28;
			actionTable["PICKUP_PLAYED_THE_SAME_MISSION_WITH_SUCCESFULL_SAVE"] = 29;
			actionTable["VOTE_2_ON_TROPHY_ROOM"] = 30;
			actionTable["VOTE_1_ON_TROPHY_ROOM"] = 32;
			actionTable["VOTE_0_ON_TROPHY_ROOM"] = 33;
			actionTable["VOTE_-1_ON_TROPHY_ROOM"] = 34;
			actionTable["DROP"] = 35;
			actionTable["VOTE_-2_ON_TROPHY_ROOM"] = 36;
			actionTable["SHOOT_OBJECT_VIEWED_DESCRIPTION"] = 37;
			actionTable["SHOOT_OBJECT"] = 38;
			actionTable["VOTE_-3_ON_TROPHY_ROOM"] = 39;
		}
		
		public function getActionTableId(Action:String):int {
			if (actionTable[Action] != undefined) {
				//trace(Action + " = " + actionTable[Action]);
				return actionTable[Action];
			}
			
			return 0;
		}
		
		public function onError(resultData:Event):void{
	
			var error:String = '';
			for (var i:Object in resultData) {
				error.concat(resultData + "\n");
			}
		}
		
		/********************************************************
         * 
         * 				    GET AND LOAD FUNCIONS 
         * 
         * *****************************************************/
		
		public function loadLanguage(pref_url:String):void {
			
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.load(new URLRequest(pref_url + "languages/idiomas.json"));
			
		}
		
		public function loadLocalJson(pref_url:String, root:String):void {
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.load(new URLRequest(pref_url + root + ".json"));
		}
		
		public function loadNpcInfo(pref_url:String, mission_id:String):void {
			
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.load(new URLRequest(pref_url + "data/npc"+mission_id+".json"));
			
		}
		
		public function loadVehiclesInfo(pref_url:String):void {
			
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.load(new URLRequest(pref_url + "data/vehicleEditor.json"));
			
		}
		
		public function loadComicsLanguage(pref_url:String, comicName:String):void {
			
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.load(new URLRequest(pref_url + "languages/ComicsText/"+comicName+".json"));
			
		}
		
		public function loadUserLastMegamap(_user:int, _megamap_id:int):void {
			
		}
		
		public function getFacebookInfo(_facebookId:String):void {
			//var url:String = "https://graph.facebook.com/"+_facebookId;
			//var peticion:URLRequest = new URLRequest(url);
			//loader.addEventListener(Event.COMPLETE, connectionEvent);
			//loader.load(peticion);
			
			testJsonUserInfo();
		}
		
		public function getObjects(_objetos:Array):void
		{
			//var url:String = "http://tucomoyo-api.ing3nia.com/v1/object?object_id=";
			var url:String = URL_Request_Tucomoyo+"object?object_id=";
			var peticion:URLRequest;
			var objetos:Array = new Array();
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			objetos = _objetos;
			
				for(var i:uint=0;i<objetos.length;++i){
					url += objetos[i].toString() + ",";
				}
			
			url += "&t="+ new Date().time;
			peticion = new URLRequest(url);
			loader.load(peticion);
			
		}
		
		public function get_missions_info(_user:String):void {
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/missionlist?user_id="+_user+"&t="+ new Date().time;
			var url:String = URL_Request_Api +"game/missionlist?user_id="+_user+"&t="+ new Date().time;
			var peticion:URLRequest;
			
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			peticion = new URLRequest(url);
			loader.load(peticion);
		}
		
		public function get_src_mission(url:String):void {
			
			url+="?t="+ new Date().time;
			var peticion:URLRequest;
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			peticion = new URLRequest(url);
			loader.load(peticion);
			//trace("URL: "+url);
		}
		
		public function get_megamap(_user:int):void
		{
			trace("Get Megamap User: " + _user);
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/missionlist2?user_id="+_user+"&t="+ new Date().time;
			var url:String = URL_Request_Api +"game/missionlist2?user_id="+_user+"&t="+ new Date().time;
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			var peticion:URLRequest = new URLRequest(url);
			loader.load(peticion);

		}
		
		public function get_save_world(_user:int):void
		{
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery?user_id="+ _user+"&method=get_trophies&t="+ new Date().time;
			var url:String = URL_Request_Api +"game/discovery?user_id="+ _user+"&method=get_trophies&t="+ new Date().time;
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			var peticion:URLRequest = new URLRequest(url);
			loader.load(peticion);

		}
		
		public function get_trophy_junk_info(_userId:int):void{

			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery?user_id="+_userId+"&method=get_trophies&t="+ new Date().time;
			var url:String = URL_Request_Api +"game/discovery?user_id="+_userId+"&method=get_trophies&t="+ new Date().time;
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			var peticion:URLRequest = new URLRequest(url);
			loader.load(peticion);
		}
		
		public function get_save_state(_user:int, _mission:int):void{

			//var url:String = "http://games-api.tucomoyo.com/aftermath/api/game/getmission?user_id="+ _user+"&mission_id="+ _mission+"&t="+ new Date().time;
			var url:String = URL_Request_Api +"game/getmission?user_id="+ _user+"&mission_id="+ _mission+"&t="+ new Date().time;
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			var peticion:URLRequest = new URLRequest(url);
			loader.load(peticion);
		}
		
		public function getMissionRanking(_user:int, _missionId:int):void
		{
			//var url:String = "http://games-api.tucomoyo.com/aftermath/api/game/getmission?user_id="+ _user+"&mission_id="+ _mission+"&t="+ new Date().time;
			//loader.addEventListener(Event.COMPLETE, connectionEvent);
			//var peticion:URLRequest = new URLRequest(url);
			//loader.load(peticion);
		}
		
		public function getUserFriendList(_user:int):void
		{
			
		}
		
		/********************************************************
         * 
         * 				    SEND FUNCIONS 
         * 
         * *****************************************************/
		
		//public function save_world(_user:int, id:int, missionId:int, _save:String):void{
			//trace("save world "+_save);
			//var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			//loader.addEventListener(Event.COMPLETE, connectionEvent);
			//loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			//var peticion:URLRequest = new URLRequest(url);
			//peticion.method = URLRequestMethod.GET;
			//url_var["user_id"] = _user;
			//url_var["id"] = id;
			//url_var["mission_id"] = missionId;
			//url_var["objects"] = _save;
			//url_var["method"] = "save_trophies";
			//url_var["t"] = new Date().time;
			//peticion.data = url_var; //trace("url var " + url_var.toString());
			//peticion.contentType = "application/x-www-form-urlencoded";
			//loader.load(peticion);
		//}
		
		public function save_trophies_mission(_user:int, _user_mission_id:int, missionId:int, _objectsIds:String, _types:String):void 
		{
			trace("save_trophies_mission - Objects IDs: "+_objectsIds);
			trace("save_trophies_mission - Objects Types: "+_types);
			
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"/game/discovery";
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "save_trophies_mission";
			url_var["objects"] = _objectsIds;
			url_var["mission_id"] = missionId;
			url_var["user_mission_id"] = _user_mission_id;
			url_var["types"] = _types;
			
			url_var["t"] = new Date().time;
			peticion.data = url_var; 
			//trace("url var " + url_var.toString());
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function modifyTrophyroomVoteAndType(_user:int, _trophyVoteId:int, _vote:int, _type:String, _sceneId:int):void
		{
			//trace("User id: " + _user + ", Trophie Vote Id: " + _trophyVoteId + ", Vote: " + _vote+ ", Type: "+_type+ ", Scene Id: "+_sceneId);
			var url_var:URLVariables = new URLVariables();
			//var url:String = "http://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "save_trophy_votes_types";
			url_var["trophy_vote_ids"] = _trophyVoteId;
			url_var["types"] = _type;
			url_var["votes"] = _vote;
			url_var["scene_ids"] = _sceneId;
			url_var["csrfmiddlewaretoken"] = "zVtwWubSnxYbcAcoSv51whLZsduz2mGM";
			url_var["t"] = new Date().time;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function modifyTrophyroomVote(_user:int, _trophyVoteId:int, _vote:int):void
		{
			var url_var:URLVariables = new URLVariables();
			//var url:String = "http://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "save_trophy_votes";
			url_var["trophy_vote_ids"] = _trophyVoteId;
			url_var["votes"] = _vote;
			url_var["csrfmiddlewaretoken"] = "zVtwWubSnxYbcAcoSv51whLZsduz2mGM";
			url_var["t"] = new Date().time;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function modifyTrophyroomType(_user:int, _trophyVoteId:int, _type:String):void
		{
			var url_var:URLVariables = new URLVariables();
			//var url:String = "http://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "save_trophy_types";
			url_var["trophy_vote_ids"] = _trophyVoteId;
			url_var["types"] = _type;
			url_var["csrfmiddlewaretoken"] = "zVtwWubSnxYbcAcoSv51whLZsduz2mGM";
			url_var["t"] = new Date().time;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function save_state(_user:int, _mission:int, _save:String, _extras:String):void{
			trace("save");
			trace("User Id: " + _user + ", missionId: " + _mission);
			
			var url_var:URLVariables = new URLVariables();
			//var url:String = "http://games-api.tucomoyo.com/aftermath/api/game/savemission";
			var url:String = URL_Request_Api +"game/savemission";
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["id"] = _mission;
			url_var["mission_data"] = _save;
			url_var["mission_extras"] = _extras;
			url_var["csrfmiddlewaretoken"] = "zVtwWubSnxYbcAcoSv51whLZsduz2mGM";
			url_var["t"] = new Date().time;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function save_tuto(_user:int):void {
			
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "save_tutorial";
			url_var["t"] = new Date().time;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function sendVote(_user:int, _actionReference:String, _objectId:int):void {
			//trace("Object ID: " + _objectId + " Action Reference: " + _actionReference);
			var url_var:URLVariables = new URLVariables();
			var url:String = "http://api.tucomoyo.com:1234/vote";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["subject"] = _user;
			url_var["action"] = getActionTableId(_actionReference);
			url_var["object"] = _objectId;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
			trace("Url voto: " + url+"?subject="+_user+"&action="+getActionTableId(_actionReference)+"&object="+_objectId);
		}
		
			public function sendMissionScore(_user:int, _id:int, _score:int, _missionID:int = 0):void {
			
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "save_score";
			url_var["mission_id"] = _missionID;
			url_var["id"] = _id;
			url_var["user_score"] = _score;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function sendMissionComplete(_user:int, _id:int, _score:int, _missionID:int = 0):void {
			trace("Mission Complete: "+_id);
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "complete_mission";
			url_var["mission_id"] = _missionID;
			url_var["id"] = _id;
			url_var["user_score"] = _score;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function changeCurrentMegamap(_user:int, _megamapId:int):void {
			trace("Change to megamap " + _megamapId);
		}
		
		public function unlockMegatile(_user:int, _megatile_id:int):void
		{
			trace("Unlock Megatile/ User: " + _user + " megatile Id: " + _megatile_id +"--------------------------------------------" );
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/unlockmegatile";
			var url:String = URL_Request_Api +"game/unlockmegatile";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["megatile_id"] = _megatile_id;
			url_var["unlocked"] = 1;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function cleanMission(_user:int, _mission_id:int):void {
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["mission_id"] = _mission_id;
			url_var["method"] = "clear_mission";
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function getVehicleStats(userId:String, vehicleId:String="1"):void {
			
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/getvehicleattribute?user_id="+userId+"&vehicle_id="+vehicleId+"&vehicle_attribute=all&t="+ new Date().time;
			var url:String = URL_Request_Api +"game/getvehicleattribute?user_id="+userId+"&vehicle_id="+vehicleId+"&vehicle_attribute=all&t="+ new Date().time;
			loader.addEventListener(Event.COMPLETE, connectionEvent);
			var peticion:URLRequest = new URLRequest(url);
			loader.load(peticion);
			
		}
		
		public function setVehicleStat(userId:String, vehicleAttribute:String, value:String, vehicleId:String = "1"):void {
		
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/setvehicleattribute";
			var url:String = URL_Request_Api +"game/setvehicleattribute";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = userId;
			url_var["vehicle_id"] = vehicleId;
			url_var["vehicle_attribute"] = vehicleAttribute;
			url_var["vehicle_attribute_value"] = value;
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
			
		}
		
		public function resetMissions(_user:int):void {
			//trace("Missions Reseted");
			var url_var:URLVariables = new URLVariables();
			//var url:String = "https://games-api.tucomoyo.com/aftermath/api/game/discovery";
			var url:String = URL_Request_Api +"game/discovery";
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			var peticion:URLRequest = new URLRequest(url);
			peticion.method = URLRequestMethod.GET;
			url_var["user_id"] = _user;
			url_var["method"] = "clear_missions";
			peticion.data = url_var;
			peticion.contentType = "application/x-www-form-urlencoded";
			loader.load(peticion);
		}
		
		public function saveScore(_user:int, _missionId:int):void
		{
			//https://games-api.tucomoyo.com/aftermath/api/game/discovery?user_id=3661&method=save_score&mission_id=1&id=11180&user_score=2000;
		}
		
		/********************************************************
         * 
         * 				         EXTERNAL
         * 
         * *****************************************************/
		
		
		 public function send_notifications(message:String, arr:Array):void {
			
			if (ExternalInterface.available) {
				
				
				ExternalInterface.call("apprequest",message,arr);
				
				
			}
			
		}
		
		 public function post_wall(arr:Array):void {
			
			if (ExternalInterface.available) {
				
				
				ExternalInterface.call("fb_postToWall",arr);
				
				
			}
			
		}
		
		 public function request_facebook(message:String):void {
			
			if (ExternalInterface.available) {
				
				
				ExternalInterface.call("fb_api",message);
				
				
			}
			
		}
		
	 
		
		/********************************************************
         * 
         * 				         EVENTS 
         * 
         * *****************************************************/
		
		public function connectionEvent(e:Event):void{
			loader.removeEventListener(Event.COMPLETE, connectionEvent);
			var json:Object =JSON.parse(loader.data.toString());
			
			this.dispatchEvent(new GameEvents(GameEvents.REQUEST_RECIVED,json,true));
			
		}
		
		public function testJsonUserInfo():void {
			
			var json:Object = JSON.parse("{\"id\": \"12345678\",\"birthday\": \"1/1/1950\",\"first_name\": \"Chris\",\"gender\": \"male\",\"last_name\": \"Colm\",\"link\": \"http://www.facebook.com/12345678\",\"location\": {\"id\": \"110843418940484\",\"name\": \"Seattle, Washington\"},\"locale\": \"en_US\",\"name\": \"Chris Colm\",\"timezone\": -8,\"updated_time\": \"2010-01-01T16:40:43+0000\",\"verified\": true}");
			this.dispatchEvent(new GameEvents(GameEvents.REQUEST_RECIVED,json,true));
		}
		
		public function errorHandler(errorEvent:IOErrorEvent):void{ 
			trace("ERROR in Conection: "+errorEvent.currentTarget.data);
		}
		
		public function clear():void {
			
			loader = null;
			
		}
		
	}

}