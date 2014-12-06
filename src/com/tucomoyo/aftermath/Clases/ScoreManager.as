package com.tucomoyo.aftermath.Clases 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author predictivia
	 */
	public class ScoreManager extends Sprite
	{
		
		public var timeBonus:Number;
		public var objectBonus:Number;
		public var enemyBonus:Number;
		public var crystalBonus:Number;
		
		public var scoreTotal:Number = 0.0;
		public var pastScore:Number = 0.0;
		public var flight:int = 0;
		public var scoreText:TextField = new TextField(126, 25, "0", "Gravity_Book",23,0xFFFFFF);
		
		public function ScoreManager() 
		{
			super();
			scoreText.hAlign = "right";
			scoreText.vAlign = "top";
			scoreText.x = 360;
			scoreText.y = 12;
			addChild(scoreText);
		}
		
		public function addScore(addScore:int,type:int):void {
			switch(type) {
				
				case 1: timeBonus += addScore; break;
				case 2: objectBonus += addScore; break;
				case 3: enemyBonus += addScore; break;
				case 4: crystalBonus += addScore; break;
			}
			
			scoreTotal += addScore;
			scoreText.text = int(scoreTotal).toString();
			
			
			(this.parent as MissionHUD).scoreStarAnimation();
		}
		
		
		public function finalScore(tiempo:int, flag:Boolean = false):int {
			if(!flag)addScore(tiempo * 10, 1);
			var decimalAdd:Number = Number(Number((!flag)?flight:(flight - 1)) / 10.0);
			
			return int((pastScore + scoreTotal) / (1.0+decimalAdd));
		}
		
		public function scoreObjectReturn(tiempo:int, flag:Boolean = false):Object {
			var decimalAdd:Number = Number(Number((!flag)?flight:(flight-1)) / 10.0);
			var scoreObject:Object = new Object();
			scoreObject.timeLapse = tiempo;
			scoreObject.parcialScore = (pastScore + scoreTotal) / (1.0+decimalAdd);
			scoreObject.flight = ++flight;
			
			return scoreObject;
			
		}
		
		
	}

}