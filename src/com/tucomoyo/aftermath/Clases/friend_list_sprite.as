package com.tucomoyo.aftermath.Clases 
{
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class friend_list_sprite extends Sprite 
	{
		public var canvas:Sprite = new Sprite();
		
		public function friend_list_sprite(_x:int, _y:int) 
		{
			super();
			this.x = _x;
			this.y = _y;
			addChild(canvas);
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			support.finishQuadBatch();
			Starling.context.setScissorRectangle(new Rectangle(x+30, y+97, x+654, y+184));
			super.render(support,alpha);
			support.finishQuadBatch()
			Starling.context.setScissorRectangle(null);
		}
		
	}

}