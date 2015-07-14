package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class RankingWindow extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var soundsScene:SoundManager;
		private var textureScene:AssetManager;
		
		private var connect:Connection;
		
		private var firstPlaceFrame:Image;
		private var nextRankFrame:Image;
		private var previousRankFrame:Image;
		private var myRankFrame:Image;
		
		private var firstPlaceImage:FacebookImage;
		private var nextRankImage:FacebookImage;
		private var previousRankImage:FacebookImage;
		private var myRankImage:FacebookImage;
		
		private var loading:MovieClip;
		
		private var rankingData:Object;
		
		private var textFieldRank:TextField;
		
		public function RankingWindow(_globalResources:GlobalResources, _textureScene:AssetManager, _soundsScene:SoundManager, _type:int, _data:Object=null, _x:int = 0, _y:int = 0) 
		{
			super();
			this.x = _x;
			this.y = _y;
			rankingData = _data;
			globalResources = _globalResources;
			
			if (_type = 0)drawMissionRanking();
			//if (_type = 1)
			
		}
		
		private function drawMissionRanking():void
		{
			for (var i:int = 0; i < 4 ; i++) 
			{
				//loading = new MovieClip(textureScene.getAtlas("").getTextures(""));
				//loading.x = 10;
				//loading.play();
				//addChild(loading);
				//loading = null;
			}
			
		}
		
		private function getRanking():void
		{
			connect.getMissionRanking(parseInt(globalResources.user_id), rankingData.mission_id);
			connect.addEventListener(GameEvents.REQUEST_RECIVED, reciveRanking);
		}
		
		private function reciveRanking(e:GameEvents = null):void
		{
			
		}
		
		private function setRankingInfo():void
		{
			
		}
		
	}

}