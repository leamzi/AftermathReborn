package com.tucomoyo.aftermath.Engine 
{
	import flash.geom.Point;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class releaseTraceConsole extends Sprite 
	{
		
		private var fondo:Quad;
		private var texto:TextField;
		
		public function releaseTraceConsole(_w:int = 760, _h:int=400, _alpha:Number = 0.6) 
		{
			super();
			
			this.alpha = _alpha;
			this.touchable = false;
			fondo = new Quad(_w, _h, 0x202020);
			addChild(fondo);
			texto = new TextField(_w, _h, "", "Verdana", 18, 0xffffff, true);
			texto.vAlign = "bottom";
			addChild(texto);
			
		}
		public function log(_texto:String):void {
			
			texto.text += ("\n"+ _texto);
			
		}
		
	}

}