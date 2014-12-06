package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author predictivia
	 */
	public class VehicleEditorStats extends Sprite
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		
		private var fuelMeter:Quad;
		private var cryoGelMeter:Quad;
		private var speedMeter:Quad;
		
		private var cryoStat:Image;
		private var fuelStat:Image;
		private var speedStat:Image;
		
		private var cryoFondo:Quad;
		private var fuelFondo:Quad;
		private var speedFondo:Quad;
		
		private var cryoIcon:Image;
		private var fuelIcon:Image;
		private var speedIcon:Image;
		
		
		
		public function VehicleEditorStats(_globalResources:GlobalResources, _texturesScene:AssetManager, _objectData:Object = null) 
		{
			super();
			
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			
			this.x = 268;
			this.y = 248;
			
			drawStats();
			
		}
		
		public function drawStats():void 
		{
			fuelMeter = new Quad(68, 22, 0xf42c3a);
			cryoGelMeter = new Quad(68, 22, 0x00c7ff);
			speedMeter = new Quad(68, 22, 0xfcb400);
			
			fuelFondo = new Quad(114, 22, 0x2f2f2f);
			cryoFondo = new Quad(114, 22, 0x2f2f2f);
			speedFondo = new Quad(114, 22, 0x2f2f2f);
			
			cryoGelMeter.x = fuelMeter.x = speedMeter.x = 74;
			cryoGelMeter.y = 18;
			fuelMeter.y = 63;
			speedMeter.y = 108;
			
			cryoFondo.x = fuelFondo.x = speedFondo.x = 74;
			cryoFondo.y = 18;
			fuelFondo.y = 63;
			speedFondo.y = 108;
			
			
			cryoStat = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("stats_bar"));
			fuelStat = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("stats_bar"));
			speedStat = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("stats_bar"));
			
			cryoStat.x = fuelStat.x = speedStat.x = 19;
			cryoStat.y = 7;
			fuelStat.y = 52;
			speedStat.y = 97;
			
			cryoIcon = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("baricon_cryo"));
			fuelIcon = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("baricon_gas"));
			speedIcon = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("baricon_speed"));
			
			cryoIcon.x = fuelIcon.x = 35;
			speedIcon.x = 27;
			cryoIcon.y = 14;
			fuelIcon.y = 59;
			speedIcon.y = 104;
			
			addChild(fuelFondo);
			addChild(cryoFondo);
			addChild(speedFondo);
			addChild(fuelMeter);
			addChild(cryoGelMeter);
			addChild(speedMeter);
			addChild(cryoStat);
			addChild(fuelStat);
			addChild(speedStat);
			addChild(cryoIcon);
			addChild(fuelIcon);
			addChild(speedIcon);
			
		}
		
		public function updateStats(fuel:Number , cryogel:Number, velocity:Number):void {
			
			fuelMeter.scaleX = (fuel + 1.0);
			cryoGelMeter.scaleX = (cryogel + 1.0);
			speedMeter.scaleX = (velocity + 200.0)*0.005;
			
		}
		
	}

}