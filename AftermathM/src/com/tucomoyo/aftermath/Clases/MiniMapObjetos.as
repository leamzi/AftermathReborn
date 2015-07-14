package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class MiniMapObjetos extends Sprite 
	{
		public static const WorldAssetes:String = "worldObjects";
		
		public var id:int;
		public var texturesScene:AssetManager;
		public var namePosition:String;
		public var objectData:Object = new Object();
		public var type:int;
		public var img:Image;		
		
		public function MiniMapObjetos(_texturesScene:AssetManager, _objectData:Object) 
		{
			super();
			texturesScene = _texturesScene;
			objectData = _objectData;
			
			this.x = _objectData.objectPosition.x*0.1;
			this.y = _objectData.objectPosition.y*0.1;			
			drawObjetos();
			
		}
		
		public function drawObjetos():void {
			
			switch(objectData.layerName){
				case "Toxicwaste":
			
					img= new Image(texturesScene.getAtlas(WorldAssetes).getTexture("CristalMiniMap"));
					img.pivotX=Math.ceil(img.width*0.5);
					img.pivotY=Math.ceil(img.height*0.5);
					addChild(img);
					
					
					break;
				case "Box":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("BoxMiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					
					break;
					
					
				case "CrystalPickups":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName+"MiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					
					break;
				case "FinalPickup":
					
					break;
				
				case"resources":
					
					img = new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName+"MiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
				 
					break;
					
				case"Hatch":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName+"MiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					
					break;
					
				case"Vehicle":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture(objectData.objectName+"MiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					
					break;
					
				case "Elevator_Green":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("BoxMiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					
					break;
					
				case "Use":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("batteryMiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					break;
					
				case "Drop":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("batteryBaseMiniMap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					break;
					
				case "npcBonus":
					
					img= new Image (texturesScene.getAtlas(WorldAssetes).getTexture("bishcoins_minimap"));
					img.pivotX=Math.ceil(img.width/2);
					img.pivotY=Math.ceil(img.height/2);
					addChild(img);
					break;
			}
			
			
		}
		
		
		override public function dispose():void 
		{
			removeChildren();
			texturesScene = null;
			objectData = null;
			if(img!=null)img.dispose();
			img = null;
			super.dispose();
		}
		
	}

}