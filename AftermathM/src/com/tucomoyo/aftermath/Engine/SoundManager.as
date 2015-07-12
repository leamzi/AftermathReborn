package com.tucomoyo.aftermath.Engine 
{
	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import com.tucomoyo.aftermath.Engine.Sounds;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class SoundManager extends EventDispatcher
	{
		private static var soundsPool:Dictionary;
		private var indexName:Vector.<String> = new Vector.<String>();
		private var pref_url:String = "sounds/";
		
		public function SoundManager(_pref_url:String) 
		{
			soundsPool = new Dictionary();
			pref_url = _pref_url+pref_url;
		}
		
		public function addSound(soundName:String,loop:int=-1):void {
			
			if(soundsPool[soundName] == undefined){
				
				soundsPool[soundName] = new Sounds(pref_url + soundName + ".mp3?&t="+ int(new Date().time/86400000), 0, 0, loop);
				indexName.push(soundName);
			}
			
		}
		
		public function getSound(soundName:String):Sounds {
			
			if (soundsPool[soundName] != undefined) {
				
				return soundsPool[soundName];
			}
			
			return null;
		}
		
		
		public function deleteSound(soundName:String):void {
			
			soundsPool[soundName].clear();
			soundsPool[soundName] = null;
			delete(soundsPool[soundName]);
			indexName.splice(indexName.indexOf(soundName), 1);
		}
		
		public function adjustGeneralVolume(volume:Number):void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var soundName:String = indexName[i];
				(soundsPool[soundName] as Sounds).volumenAdjust(volume);
			}
		}
		
		public function dispose():void {
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var soundName:String = indexName[i];
				soundsPool[soundName].dispose();
				soundsPool[soundName] = null;
				delete(soundsPool[soundName]);
				
			}
			
			indexName.splice(0, total_length);
			indexName = null;
			soundsPool = null;
			
		}
		
	}

}