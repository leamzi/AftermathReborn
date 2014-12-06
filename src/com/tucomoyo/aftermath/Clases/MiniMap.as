package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class MiniMap extends Sprite 
	{
		public var fondo:Quad;
		//public var marco:Image;
		public var mWidth:int;
		public var mHeight:int;
		
		public var minimapSprite:Sprite = new Sprite();
		public var objetosSprite:Sprite = new Sprite();
		public var vehicleMini:MiniMapObjetos;
		public var hatch:MiniMapObjetos;
		public var bonus:MiniMapObjetos;
		public var hatchPos:Point = new Point();
		
		public function MiniMap(_width:int, _height:int, texturesScene:AssetManager) 
		{
			super();
			
			this.touchable = false;
			
			this.x = 620;
			this.y = 10;
			
			mWidth = _width * 0.1;
			mHeight = _height * 0.1;
			
			var background:Image = new Image(texturesScene.getAtlas("worldObjects").getTexture("minimapBg"));
			addChild(background);
			
			fondo = new Quad(mWidth + 100, mHeight + 100, 0x000000);
			fondo.x = -50-(mWidth*0.5);
			fondo.y = -50-(mHeight*0.5);
			fondo.alpha = 0.50;
			//minimapSprite.addChild(fondo);
			
			addChild(objetosSprite);
			addChild(minimapSprite);
		}
		
		public function addMiniVehicle(p:Point, _texturesScene:AssetManager):void {
			
			p.x *= 0.1;
			p.y *= 0.1;
			
			vehicleMini = new MiniMapObjetos(_texturesScene, { objectPosition:p, layerName:"Vehicle", objectName:"vehicle" } );
			objetosSprite.removeChild(hatch);
			objetosSprite.addChild(hatch);
			objetosSprite.addChild(vehicleMini);
			
		}
		
		public function updateHatch():void {
			
			var pto:Point = hatchPos;
			pto = objetosSprite.localToGlobal(pto);
			
			if (pto.x < 626) pto.x = 626;
			if (pto.x > 743) pto.x = 743;
			if (pto.y < 18) pto.y = 18;
			if (pto.y > 78) pto.y = 78;
			
			pto = objetosSprite.globalToLocal(pto);
			
			hatch.x = pto.x;
			hatch.y = pto.y;
			
		}
		
		public function updateBonus():void {
			
			if (bonus == null) return;
			
			var pto:Point = new Point(bonus.x,bonus.y);
			pto = objetosSprite.localToGlobal(pto);
			
			if (pto.x < 626) pto.x = 626;
			if (pto.x > 743) pto.x = 743;
			if (pto.y < 18) pto.y = 18;
			if (pto.y > 78) pto.y = 78;
			
			pto = objetosSprite.globalToLocal(pto);
			
			bonus.x = pto.x;
			bonus.y = pto.y;
			
		}
		
		override public function dispose():void 
		{
			removeChildren();
			vehicleMini.dispose();
			fondo.dispose()
			vehicleMini = null;
			hatch = null;
			fondo = null;
			super.dispose();
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			support.finishQuadBatch();
			Starling.context.setScissorRectangle(new Rectangle(623, 13, 125, 70));
			super.render(support,alpha);
			support.finishQuadBatch()
			Starling.context.setScissorRectangle(null);
		}
		
	}

}