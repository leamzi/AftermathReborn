package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.display.Graphics;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class scrollBar extends Sprite 
	{
		
		public var soundsScene:SoundManager;
		public var globalResources:GlobalResources;
		
		private var isSoundBar:Boolean;
		private var linea:Shape = new Shape();
		private var circulo:Shape = new Shape();
		public var rect:Shape = new Shape();
		
		public var currentX:Number;
		public var lineWidth:Number;
		private var circleRadius:int;
		public var rectWidth:int;
		
		public function scrollBar(_globalResources:GlobalResources, _lineWidth:Number, _lineColor:uint, _rectWidth:int, _rectColor:uint, _isSoundBar:Boolean = false, _soundScene:SoundManager = null) 
		{
			super();
			
			soundsScene = _soundScene;
			globalResources = _globalResources;
			
			lineWidth = _lineWidth;
			rectWidth = _rectWidth;
			isSoundBar = _isSoundBar;
			
			linea.graphics.beginFill(_lineColor,0.4);
			linea.graphics.drawRect(0, 0, lineWidth, 6);
			linea.graphics.endFill();
			linea.addEventListener(TouchEvent.TOUCH, onClickLine);
			addChild(linea);
			
			rect.graphics.beginFill(_rectColor);
			rect.graphics.drawRect(0, -13, rectWidth, 32);
			rect.graphics.endFill();
			rect.useHandCursor = true;
			rect.x = (globalResources.volume * lineWidth);
			rect.addEventListener(TouchEvent.TOUCH, onDrag);
			addChild(rect);
			
		}
		
		public function onDrag(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			
			if (touch == null){
				return;
			}
			
			var pos:Point = this.globalToLocal(touch.getLocation(stage));
			
			if (touch.phase == TouchPhase.MOVED) {
				if (pos.x >= 0 && pos.x <= (linea.width - rectWidth) )
				{
					(e.currentTarget as Shape).x = pos.x;
					currentX = pos.x / lineWidth;
					if (isSoundBar) {
						soundsScene.adjustGeneralVolume(currentX);
					}
				}
				
			}
			if (touch.phase == TouchPhase.ENDED) {
				
				if (isSoundBar) {
					globalResources.volume = currentX;
					soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
				}
				
			}
			
		}
		
		public function onClickLine(e:TouchEvent):void {
		var touch:Touch = e.getTouch(this);
		
			if (touch == null){
				return;
			}
			
			var pos:Point = this.globalToLocal(touch.getLocation(stage));
		
			if (touch.phase == TouchPhase.BEGAN) {
				if ((pos.x >= 0 && pos.x <= (linea.width - rect.width)) && (pos.y >= 0 && pos.y <= 6))
				{
					rect.x = pos.x;
					currentX = pos.x / lineWidth;
					if (isSoundBar) {
						soundsScene.adjustGeneralVolume(currentX);
						globalResources.volume = currentX;
					}
				}
			}
		}
		
		override public function dispose():void {
			globalResources = null;
			//texturesScene = null;
			soundsScene = null;
			
			linea = null;
			circulo = null;
			
			super.dispose();
		}
	}

}