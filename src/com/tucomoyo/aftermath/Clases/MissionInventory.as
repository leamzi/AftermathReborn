package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MissionInventory extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		public static const ButtonAssets:String = "Botones";
		
		public var size:int=0;
		public var carga:Vector.<Objetos> = new Vector.<Objetos>;
		public var marco:Quad=new Quad(300,100,0x000e16);
		public var parentSprite:Sprite = new Sprite();
		public var tempData:Array = new Array();
		private var img_box:Image;
		
		public function MissionInventory(_globalResources:GlobalResources, _texturesScene:AssetManager) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			
			this.addChild(parentSprite);
			
			var fondo:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrameOption"));
			fondo.scaleX = 0.7;
			fondo.scaleY = 0.7;
			tempData.push(fondo);
			parentSprite.addChild(fondo);
			
			var title_text:TextField = new TextField (200,50,"",globalResources.fontName,14,0xffffff);
			title_text.text = "CARGO";
			title_text.x = 40;
			title_text.y = -10;
			tempData.push(title_text);
			parentSprite.addChild(title_text);
			
			img_box = new Image (texturesScene.getAtlas(ButtonAssets).getTexture("objectBox"));
			img_box.x= 10;
			img_box.y= 25;
			img_box.scaleX= 1.38;
			img_box.scaleY = 1.38;
			tempData.push(img_box);
			parentSprite.addChild(img_box);
			img_box = null;
			
			img_box = new Image (texturesScene.getAtlas(ButtonAssets).getTexture("objectBox"));
			img_box.y= 25;
			img_box.x= 82;
			img_box.scaleX= 1.38;
			img_box.scaleY = 1.38;
			tempData.push(img_box);
			parentSprite.addChild(img_box);
			
			img_box = new Image (texturesScene.getAtlas(ButtonAssets).getTexture("objectBox"));
			img_box.y= 25;
			img_box.x= 156;
			img_box.scaleX= 1.38;
			img_box.scaleY = 1.38;
			tempData.push(img_box);
			parentSprite.addChild(img_box);
			
			img_box = new Image (texturesScene.getAtlas(ButtonAssets).getTexture("objectBox"));
			img_box.y= 25;
			img_box.x= 228;
			img_box.scaleX= 1.38;
			img_box.scaleY = 1.38;
			tempData.push(img_box);
			parentSprite.addChild(img_box);
			
			this.pivotX=150;
			this.pivotY=76;
			parentSprite.visible=false;
			this.alpha=0.65;
		}
	
		public function onMouse(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			if (touch == null) return;
			var pos:Point = this.globalToLocal(touch.getLocation(stage));
			//
			if(touch.phase==TouchPhase.BEGAN){
				
				for(var i:int=0;i<size;++i){
					if (avatarHitTestPoint(pos, i)) { 
						eliminar_objeto(i);break;
					}
				}
			}
		}
		
		public function add_objeto(pickUp:Objetos):Boolean{
			var dialogo:Dialogs;
			if(size<4){
			  parentSprite.addChild(pickUp.objectImage);
			  pickUp.objectImage.x = ((12 * (size % 4)) + ((size % 4) * 60)) + 15;
			  pickUp.objectImage.y = ((12 * (Math.floor(size / 4))) + (Math.floor(size / 4) * 60)) + 30;
			  carga.push(pickUp);
			  size++;
			  return false;
			}else{
				return true;
			}
			return false;
		}
		
		public function eliminar_objeto(_i:int):void{
			
			parentSprite.removeChild(carga[_i].objectImage);
			var o_aux:Objetos=carga[_i] as Objetos;
			carga.splice(_i,1);
			size--;
			for(var _j:int=0;_j<size;_j++){
				carga[_j].objectImage.x=((12*(_j%4))+((_j%4)*60))+15;
				carga[_j].objectImage.y=((12*(Math.floor(_j*0.25)))+(Math.floor(_j*0.25)*60))+30;
			}
			this.dispatchEvent(new GameEvents(GameEvents.DROP_OBJECT,o_aux,true));
			
		}
		
		public function onVisible():void {
			//trace("inventory visible");
			parentSprite.visible = true;
			this.addEventListener(TouchEvent.TOUCH, onMouse);
		}
		
		public function onInvisible():void {
			//trace("inventory invisible");
			parentSprite.visible = false;
			this.removeEventListener(TouchEvent.TOUCH, onMouse);
		}
		
		public function avatarHitTestPoint(_p:Point,_i:int):Boolean{
			
			return((_p.x<(carga[_i].objectImage.x+70)) && (_p.x>(carga[_i].objectImage.x)) && (_p.y<(carga[_i].objectImage.y+70)) && (_p.y>(carga[_i].objectImage.y))  );
			
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			this.removeChildren();
			
			parentSprite.removeChildren();
			parentSprite = null;
			
			globalResources = null;
			texturesScene = null;
			for (var j:uint = 0; j < carga.length;++j ) {
				carga[j].dispose();
				carga[j] = null;
			}
			carga.splice(0, carga.length);
			carga = null;
			
			for (var i:uint = 0; i < tempData.length;++i) {
				tempData[i].removeEventListeners();
				tempData[i].dispose();
				tempData[i] = null;
			}
			tempData.splice(0, tempData.length);
			tempData = null;
			
			super.dispose();
		}
		

	}
}