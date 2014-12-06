package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilter;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class objectsCounterMeter extends Sprite 
	{
		public var fillQuad:Quad;
		
		private var filterText:BlurFilter;
		
		private var meterBackground:Image;
		private var meterFront:Image;
		
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		private var soundScene:SoundManager;
		private var type:int;
		private var totalObjects:int;
		
		private var text1:TextField;
		private var text2:TextField;
		private var text3:TextField;
		private var text4:TextField;
		private var text5:TextField;
		
		private var tween:Tween;
		
		public function objectsCounterMeter(_type:int, _globalResources:GlobalResources, _texturesScene:AssetManager, _soundScene:SoundManager, _totalObjects:int) 
		{
			super();
			
			type = _type;
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			soundScene = _soundScene;
			totalObjects = _totalObjects;
			drawMeters();
			
		}
		
		private function drawMeters():void {
			
			filterText = BlurFilter.createGlow(0x000000,1,1);
		
			//meterBackground = new Image(texturesScene.getAtlas("").getTexture(""));
			meterFront = new Image(texturesScene.getAtlas("Botones").getTexture("meterCount"));
			
			text1 = new TextField(60, 20, "", "LVDCD", 21, 0xFFFFFF);
			text1.hAlign = "center";
			text1.vAlign = "top";
			text1.scaleX = 0.5;
			text1.x = 5;
			text1.y = 24;
			text1.filter = filterText;
			
			text2 = new TextField(60, 20, "", "LVDCD", 21, 0xFFFFFF);
			text2.hAlign = "center";
			text2.vAlign = "top";
			text2.scaleX = 0.5;
			text2.x = 5;
			text2.y = 69;
			text2.filter = filterText;
			
			text3 = new TextField(60, 20, "", "LVDCD", 21, 0xFFFFFF);
			text3.hAlign = "center";
			text3.vAlign = "top";
			text3.scaleX = 0.5;
			text3.x = 5;
			text3.y = 114;
			text3.filter = filterText;
			
			text4 = new TextField(60, 20, "", "LVDCD", 21, 0xFFFFFF);
			text4.hAlign = "center";
			text4.vAlign = "top";
			text4.scaleX = 0.5;
			text4.x = 5;
			text4.y = 159;
			text4.filter = filterText;
			
			text5 = new TextField(60, 20, "", "LVDCD", 21, 0xFFFFFF);
			text5.hAlign = "center";
			text5.vAlign = "top";
			text5.scaleX = 0.5;
			text5.x = 5;
			text5.y = 204;
			text5.filter = filterText;
			
			fillQuad = new Quad(41, 224);
			if (type == 0) fillQuad.color = 0x64B900;
			if (type == 1) fillQuad.color = 0xEA1C24;
			fillQuad.scaleY = 0;
			fillQuad.y = (meterFront.height -3);
			
			//addChild(meterBackground);
			
			updateMeterText(totalObjects);
			
			addChild(fillQuad);
			addChild(meterFront);
			addChild(text1);
			addChild(text2);
			addChild(text3);
			addChild(text4);
			addChild(text5);
		}
		
		public function updateMeter(_num:int, zone:String = "") :void {
			var num:Number;
			
			_num = _num % 25;
			num = _num * ( -0.04);
			
			if(_num>0)soundScene.getSound("chargeMeter").play(globalResources.volume);
			if (tween != null) 
			{
				Starling.juggler.remove(tween);
				tween.reset(fillQuad, 1.9);
				tween.animate("scaleY",num);
			} else {
				tween = new Tween(fillQuad, 1.9);
				tween.animate("scaleY", num);
			}
			if (zone == "Complete") tween.onComplete = (this.parent as Dialogs).scoreTweenAnimation;
			Starling.juggler.add(tween);
		}
		
		public function updateMeterText(_totalObjects:int) :void 
		{
			if (_totalObjects>25) 
			{
				text1.text = "50";
				text2.text = "45";
				text3.text = "40";
				text4.text = "35";
				text5.text = "30";
				
			} else {
				text1.text = "25";
				text2.text = "20";
				text3.text = "15";
				text4.text = "10";
				text5.text = "5";
			}
		}
		
	}

}