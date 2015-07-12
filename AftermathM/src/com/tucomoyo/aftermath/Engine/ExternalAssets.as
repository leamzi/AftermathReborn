package com.tucomoyo.aftermath.Engine 
{
	import flash.system.LoaderContext;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class ExternalAssets extends Sprite 
	{
		public var image:ImageLoader;
		
		public function ExternalAssets(folder:String, imagePref:String, _context:LoaderContext) 
		{
			super();
			
			var pref_url:String = "https://s3.amazonaws.com/tucomoyo-games/aftermath/external_images/" + folder + "/" + imagePref + ".png";
			
			image = new ImageLoader(pref_url, _context, 0, 0, true);
			
			this.addChild(image);
		}
		
		override public function dispose():void 
		{
			
			image.dispose();
			
			super.dispose();
		}
		
	}

}