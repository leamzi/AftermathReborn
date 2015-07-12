package com.tucomoyo.aftermath.Clases 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MeterBar extends Sprite 
	{
		public var type:int;
		public var meter:Quad; 
		
		public function MeterBar(_type:int) 
		{
			super();
			type = _type;
			
			switch (type){
				case 0:meter = new Quad(17,112,0xf42c3a);break;
				case 1:meter = new Quad(17,112,0x00c7ff);break;
			}
			addChild(meter);
		}
		
		public function update_meter(value:Number):void{
			meter.scaleY = value;
			meter.y =  112 * (1- value);
			
		}
		
	}

}