package com.tucomoyo.aftermath.Engine 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class GameEvents extends Event 
	{
		public var params:Object;
		
		public static const CHANGE_SCREEN:String = "changeScreen";
		public static const REQUEST_RECIVED:String = "requestRecived";
		public static const PICKUP_OBJECT:String = "pickupObject";
		public static const TEXTURE_LOADED:String = "textureLoaded";
		public static const TILEMAP_LOAD:String = "tilemapLoad";
		public static const PICK_OBJECT:String = "pickObject"
		public static const DESTROY_CRYSTAL:String = "DestroyCrystal";
		public static const DESTROY_PICKUP:String = "DestroyPickup";
		public static const GAME_STATE:String = "gameState";
		public static const MISCELLANEOUS_EVENTS:String = "miscellaneousEvents";
		public static const ACTIVATE_DIALOG:String = "activateDialog";
		public static const CONNECTION_OBJECT:String = "connectionObject";
		public static const DROP_OBJECT:String = "DropObject";
		public static const EXIT_TUTORIAL:String = "exitTutorial";
		public static const STATE_ALERT:String = "stateAlert";
		public static const TILE_UNLOCK:String = "tile_unlock";
		public static const ADD_BISHCOINS:String = "add_bishcoins";
		
		public function GameEvents(type:String, _params:Object=null, bubbles:Boolean=true) 
		{
			super(type, bubbles);
			
			this.params=_params;
		}
		
	}

}