package com.tucomoyo.aftermath.Clases 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class ContextualMenu extends Sprite 
	{
		public var UpState:Image;
		public var DownState:Image;
		
		public function ContextualMenu(_upState:Texture,_downState:Texture) 
		{
			super();
			UpState = new Image (_upState);
			DownState = new Image (_downState);
	
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