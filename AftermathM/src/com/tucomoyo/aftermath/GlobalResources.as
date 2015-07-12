package com.tucomoyo.aftermath 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.tucomoyo.aftermath.Clases.LoadingSplash;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	/**
	 * ...
	 * @author Predictvia
	 * 
	 *  JSON IDIOMA http://www.objgen.com/json/models/4sDfL 
	 * 
	 */
	public class GlobalResources 
	{
		public var stageHeigth:int;
		public var stageWidth:int;
		public var user_id:String;
		public var facebookId:String;
		public var picture_url:String;
		public var acces_token:String;
		public var user_name:String;
		public var user_firstName:String;
		public var user_lastName:String;
		public var game_version:String;
		public var pref_url:String = "media/";
		public var myDomain:SecurityDomain = null
		public var tutorialDone:Boolean;
		public var GoogleAnalitics:Boolean = false;
		public var isInTutorial:Boolean = false;
		public var loaderContext:LoaderContext;
		public var loadingSplash:LoadingSplash;
		public var tracker:AnalyticsTracker;
		public var idioma:String = "Ingles";
		public var textos:Object;
		public var NpcInfo:Object;
		public var splashCount:int = 0;
		public var volume:Number = 0.5;
		public var fontName:String = "Gravity_Book";
		public var scaleX:Number = 1.0;
		public var scaleY:Number = 1.0;
		public var invX:Number = 1.0;
		public var invY:Number = 1.0;
		
		//Embed the Fonts
		[Embed(source="../../../../media/fonts/embedded/Gravity_Book.ttf", fontFamily="MyfontName",fontName="Gravity_Book", embedAsCFF="false", mimeType = "application/x-font-truetype")]
		public static var Code:Class
		
		[Embed(source="../../../../media/fonts/embedded/LVDCD.ttf", fontFamily="MyfontName",fontName="LVDCD", embedAsCFF="false", mimeType = "application/x-font-truetype")]
		public static var Code2:Class
		
		
		public function GlobalResources() 
		{
			
		}
		
		
		public function activateSplash(count:int = -1):void {
			if (count > 0) {
				splashCount = count;
			}
			loadingSplash.activateTimer();
			loadingSplash.visible = true;
		}
		
		public function setCountSplash(count:int):void {
			
			splashCount = count;
		}
		
		public function deactivateSplash(flag:Boolean = false):void {
			if (flag) {
				if(--splashCount == 0){
					loadingSplash.visible = false;
					loadingSplash.deactivateTimer();
				}
			}else {
				loadingSplash.visible = false;
				loadingSplash.deactivateTimer();
			}
		}
		
		public function setVars():void {
			trace("GA = " + GoogleAnalitics);
			if (user_id == "-1") {
				
				//user_id = "20"; //Aldo
				//user_id = "1"; //Arnaldus
				user_id = "3624"; //Isma
				//user_id = "50";//rosa
				//user_id = "3621"; //Pablo
				//user_id = "27";
				//user_id = "3661"; //Yorch
				//user_id = "47"; //Frank
				//user_id = "4191"; //dummy fb
				acces_token = "4191_8_1424986320b5f2e8f5f56f1b0d68e5ed63c03ea2a46f24405b";
				picture_url = "https://d389o9kfupjsqw.cloudfront.net/users/3624/default_profile_3624_1375898783.jpg";
				//picture_url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/c52.53.657.657/s50x50/541929_4625399586235_453975820_n.jpg";
				user_name = "Ismael Serrada";
				user_firstName = "Ismael";
				//user_lastName = "Añez";
				user_lastName = "Serrada";
				facebookId = "718462734"; //Isma
				//facebookId = "707269337"; //Pablo
				
				tutorialDone = true;
				//pref_url = "https://s3.amazonaws.com/tucomoyo-games/aftermath/8k1103/media/";
					
			}else {
				
				this.myDomain = SecurityDomain.currentDomain;
				pref_url = "https://s3.amazonaws.com/tucomoyo-games/aftermath/"+game_version+"/media/";
				//_flag = true;
			}
			
			//this.myDomain = SecurityDomain.currentDomain;
			//game_version = "4a9482";
			//pref_url = "https://s3.amazonaws.com/tucomoyo-games/aftermath/" + game_version + "/media/";
			
			invX = 1.0 / scaleX;
			invY = 1.0 / scaleY;
			
			loaderContext  = new LoaderContext(true, ApplicationDomain.currentDomain, myDomain);
			
			loadingSplash = new LoadingSplash(this);
			deactivateSplash();
			
		}
		
		public function trackEvent(_category:String, _action:String, _label:String):void {
			
			if (GoogleAnalitics) 
			{
				tracker.trackEvent(_category, _action, _label);
			}
		}
		
		public function trackPageview(pageURL:String):void {
			if (GoogleAnalitics) 
			{
				tracker.trackPageview(pageURL);
			}
		}
		
	}

}