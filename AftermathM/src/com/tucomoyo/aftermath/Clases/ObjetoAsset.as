package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import flash.system.LoaderContext;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class ObjetoAsset extends Sprite 
	{
		public var baseAsset:Image;
		public var baseLight:Image;
		public var light:MovieClip;
		public var objectImage:ImageLoader;
		public var posY:Number = 0;
		public var animation:Boolean = true;
		
		public function ObjetoAsset(_name:String, _texturesScene:AssetManager,_context:LoaderContext, _genere:int=1) 
		{
			super();
			
			var pref_url:String = "https://s3.amazonaws.com/tucomoyo-games/aftermath/objectsAssets/" + _name+".png";
			
			objectImage = new ImageLoader(pref_url, _context, 0, 0, true, { texturesScene: _texturesScene, atlas:"worldObjects", texture: "Box" } );
			if (_genere == 1) {
				baseAsset = new Image (_texturesScene.getAtlas("worldObjects").getTexture("base"));
				baseLight = new Image(_texturesScene.getAtlas("worldObjects").getTexture("highlight"));
				light = new MovieClip (_texturesScene.getAtlas("worldObjects").getTextures("baseLight"), 5);
				
				baseAsset.pivotX = baseAsset.width * 0.5;
				baseAsset.pivotY = baseAsset.height * 0.5;
				
				baseLight.pivotX = baseLight.width * 0.5;
				baseLight.pivotY = baseLight.height * 0.5;
				
				light.pivotX = light.width * 0.5;
				light.pivotY = light.height * 0.5;
				
			//	objectImage.pivotX = 128;
			//	objectImage.pivotY = 128;
				
				Starling.juggler.add(light);
				
				this.addChild(baseAsset);
				this.addChild(light);
			}
			
			this.addChild(objectImage);
			
			if (_genere == 1) {
				
				this.addChild(baseLight);
				this.addEventListener(Event.ENTER_FRAME, onUpdate);
			}
			
		}
		
		public function onUpdate(e:Event):void {
			
			if (!animation) return;
			posY += 0.025;
			if (posY > Math.PI) posY = 0;
			
			objectImage.y = (Math.sin(posY) * 10)-25;
			
			
		}
		override public function dispose():void 
		{
			this.removeEventListeners();
			this.removeChildren();
			objectImage.dispose();
			if(baseAsset!=null)baseAsset.dispose();
			if(baseLight!=null)baseLight.dispose();
			if (light != null) {
				light.dispose();
				Starling.juggler.remove(light);
			}
			super.dispose();
		}
		
	}

}