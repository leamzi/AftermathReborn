package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class Npc extends Sprite 
	{
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		public var animations:Dictionary = new Dictionary();
		public var indexName:Vector.<String> = new Vector.<String>();
		public var direction:Point = new Point();
		public var velocity:Number;
		public var hp:Number;
		public var damage:Number;
		public var detectRange:Number;
		public var totalVistas:int;
		public var offset:Number;
		public var cursorAngle:Number;
		public var objectData:Object;
		public var npcBack:Sprite = new Sprite();
		public var npcSprite:Sprite = new Sprite();
		public var npcFront:Sprite = new Sprite();
		public var shadow:Image;
		public var score:Number;
		public var numShot:int = 0;
		public var imageDirection:int = 0;
		public var lootBonus:int = 0;
		public var noAnimation:Boolean = false;
		
		public function Npc(born:Point, _texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, _objectData:Object = null) 
		{
			super();
			
			texturesScene = _texturesScene;
			globalResources = _globalResources;
			soundsScene = _soundsScene;
			
			objectData = _objectData;
			
			hp = _objectData.hp;
			damage = _objectData.damage;
			velocity = _objectData.velocity;
			score = (_objectData.score != undefined) ? _objectData.score : 150;
			totalVistas = objectData.animations.totalVistas; 
			detectRange = _objectData.detectRange;
			offset =  objectData.animations.offset;
			lootBonus = objectData.loot;
			
			this.x = born.x;
			this.y = born.y;
			
			addChild(npcBack);
			addChild(npcSprite);
			addChild(npcFront);
			
			drawAnimations();
			
		}
		
		public function drawAnimations():void 
		{
			var i:int = 0;
			
			while (objectData.animations.pref[i]!=undefined) {
				
				var TextureName:String = objectData.animations.name + objectData.animations.pref[i].name;
				
				var animation:MovieClip = new MovieClip(texturesScene.getAtlas(objectData.animations.atlas).getTextures(TextureName),objectData.animations.pref[i].fps);
				animation.pivotX = Math.ceil(animation.width * 0.5);
				animation.pivotY = Math.ceil(animation.height * 0.5);
				
				if (animations[TextureName] == undefined) {
					
					Starling.juggler.add(animation);
					animations[TextureName] = animation;
					indexName.push(TextureName);
				}
				
				animation = null;
				
				++i;
			}
			
			npcSprite.addChild(animations[indexName[0]]);
			
			shadow = new Image(texturesScene.getAtlas(objectData.animations.atlas).getTexture("shadow"));
			shadow.alignPivot();
			shadow.y = 135;
			npcBack.addChild(shadow);
		}
		
		public function update():void {
			
			var ax:Number = Math.abs(direction.x);
			var ay:Number = Math.abs(direction.y);
			var t:Number;
			
			if(ax+ay==0)t=0;
			else t=direction.y/(ax+ay);
			
			if(direction.x<0){
				t=2-t;
			}
			else
			{
				
				if(direction.y<0)t+=4;
				
			}
			cursorAngle= 90*t;
			
			this.x += direction.x * velocity;
			this.y += direction.y * velocity;
			
			if(!noAnimation)changeDirection();
		}
		
		public function changeDirection():void {
			
			if (totalVistas == 1) return;
			
			cursorAngle = cursorAngle % 360;
			
			var segments:Number = 360.0 / Number(totalVistas);
			
			for (var i:int = 0; i < totalVistas;++i ) {
				
				if (imageDirection != 0 && (cursorAngle >  i*segments-offset || cursorAngle <= ((i+1)*segments)-offset)) {
					imageDirection = i;
					
					npcSprite.removeChildAt(0);
					var prefijo:String = objectData.animations.name+"_vista_"+i+"_";
					npcSprite.addChildAt(animations[prefijo],0);
					break;
					
				}
				
			}
			
		}
		
		public function scoreReturn():Number {
			
			return (numShot > 0)? Number(score / Number(numShot)) : score;
			
		}
		
		override public function dispose():void 
		{
			globalResources = null;
			texturesScene = null;
			soundsScene = null;
			
			var total_length:int = indexName.length;
			
			for (var i:int = 0; i < total_length; ++i ) {
				
				var imageName:String = indexName[i];
				animations[imageName].dispose();
				animations[imageName] = null;
				delete(animations[imageName]);
				
			}
			
			indexName.splice(0, total_length);
			imageName = null;
			animations = null;
			
			
			direction = null;
			objectData = null;
			npcBack.removeChildren();
			npcSprite.removeChildren();
			npcFront.removeChildren();
			npcBack.dispose();
			npcBack = null;
			npcSprite.dispose();
			npcSprite = null;
			npcFront.dispose();
			npcFront = null;
			
			super.dispose();
		}
		
	}

}