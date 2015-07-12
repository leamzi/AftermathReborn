package com.tucomoyo.aftermath.Clases 
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class VoteButtons extends Button 
	{
		public var type:int;
		public var UpState:Image;
		public var DownState:Image;
		
		public function VoteButtons( _type:int, upState:Texture, downState:Texture=null) 
		{
			super(upState, "", downState);
			UpState = new Image (upState);
			DownState = new Image (downState);
			type = _type;
			
			addChild(UpState);
			addChild(DownState);
			DownState.visible = false;
		}
		
		override public function dispose():void 
		{
			UpState = null;
			DownState = null;
			super.dispose();
		}
	}

}