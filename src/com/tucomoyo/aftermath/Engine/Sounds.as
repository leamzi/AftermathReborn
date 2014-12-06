package com.tucomoyo.aftermath.Engine 
{
	import flash.media.Sound;
 	import flash.media.SoundChannel;
 	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
 	import flash.net.URLRequest;
 	
 	/**
 	 * ...
 	 * @author Predictvia
 	 */
 	public class Sounds 
 	{
 		private var so:Sound;
 		private var url:URLRequest;
 		private var buffer:SoundLoaderContext;
 		private var ini:Number;
 		private var loop:Number;
 		private var channel:SoundChannel;
 		
 		public function Sounds(qUrl:String, qBuffer:Number, qIni:Number, qLoop:Number) 
 		{
 			
 			url = new URLRequest(qUrl);
 			buffer = new SoundLoaderContext(qBuffer*1000);
 			ini = qIni * 1000;
 			loop = (qLoop >= 0) ? qLoop : int.MAX_VALUE;
 			so = new Sound(url, buffer);
 			channel=new SoundChannel();
 		}
 		
 		public function play(volLevel:Number):void {
 			
 			var volumeAdjust:SoundTransform = new SoundTransform(volLevel);
			
			channel=so.play(ini, loop);
			channel.soundTransform = volumeAdjust;
 		}
 		
 		public function stop():void {
 			
 			channel.stop();
 		}
		
		public function volumenAdjust(volLevel:Number):void {
			var volumeAdjust:SoundTransform = new SoundTransform(volLevel);
			//trace("ajuste el volumen a: " + volumeAdjust.volume);
			
			channel.soundTransform = volumeAdjust;
		}
 		
 		public function dispose():void {
			channel.stop();
 			so = null;
 			channel = null;
			buffer = null;
			url = null;
 		}
 		
 	}
}
