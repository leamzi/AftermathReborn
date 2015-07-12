package com.tucomoyo.aftermath.Clases 
{
	import starling.display.Button;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MegaMapButton extends Button 
	{
		public var type:String;
		
		public function MegaMapButton(_type:String, upState:Texture, text:String="", downState:Texture=null) 
		{
			super(upState, text, downState);
			type = _type;
		}
		
	}

}