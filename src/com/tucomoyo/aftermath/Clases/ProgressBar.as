package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class ProgressBar extends Sprite 
	{
		public var type:String;
		public var textureScene:AssetManager;
		public var barImg:Image;
		public var barImgQuad:Quad;
		public var barQuad:Quad;
		
		public function ProgressBar(_textureScene:AssetManager, _type:String, _textureName:String = "", quadColor:uint = 0) 
		{
			super();
			textureScene = _textureScene;
			type = _type;
			
			switch (type){
				case "Texture":
					barImg = new Image(textureScene.getAtlas("Botones").getTexture(_textureName));
					addChild(barImg);
					
					barImgQuad = new Quad((barImg.width - 5), (barImg.height - 5), 0x000000);
					barImgQuad.scaleX = 0;
					barImgQuad.scaleY = 0;
					barImgQuad.x = barImg.width - 5;
					addChild(barImgQuad);
				break;
				case "Quad":
					barQuad = new Quad(17, 112, quadColor);
					addChild(barQuad);
				break;
			}
			
		}
		
		public function update_meter(value:Number, type:String, direction:String):void{
			switch (type) 
			{
				case "Texture":
					if (direction == "Horizontal") {
						barImgQuad.scaleY = 1;
						barImgQuad.scaleX = -value;
					}
					if (direction == "Vertical") {
						barImgQuad.scaleX = 1;
						barImgQuad.scaleY = -value;
					}
				break;
				case "Quad":
					if (direction == "Horizontal") {
						barQuad.scaleX = value;
						barQuad.y =  112 * (1- value);
					}
					if (direction == "Vertical") {
						barQuad.scaleY = value;
						barQuad.y =  112 * (1- value);
					}
				break;
			}
			
			
			meter.y =  112 * (1- value);
			
		}
		
	}

}