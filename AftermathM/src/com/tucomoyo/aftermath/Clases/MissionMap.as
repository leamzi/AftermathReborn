package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.BodyManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageManager;
	import com.tucomoyo.aftermath.Engine.ObjetoManager;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.Engine.TextureManager;
	import com.tucomoyo.aftermath.Engine.TileManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import nape.geom.Vec2;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MissionMap extends Sprite 
	{
		public var objetosScene:ObjetoManager;
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		private var bitmapsScene:TextureManager
		public var tilemap:TileManager;
		private var tempData:Array;
		public var savemissionMapObjects:Array = new Array();
		public var destroymissionMapObjects:Array = new Array();
		public var savemissionMapCrystals:Array = new Array();
		
		public var tile_center:Point=new Point(380,200);
		public var sprite01:Sprite= new Sprite;
		public var sprite02:Sprite = new Sprite;
		public var missionMapObjects:Vector.<Objetos> = new Vector.<Objetos>;
		public var missionMapCrystals:Vector.<Objetos> = new Vector.<Objetos>;
		//public var cryogelParticles:Vector.<CryogelParticle> = new Vector.<CryogelParticle>;
		private var triggers:Vector.<Object> = new Vector.<Object>;
		
		public var miniWorldMap:MiniMap;
		
		public var hatchObj:Objetos;
		
		public function MissionMap(_globalResources:GlobalResources, _texturesScene:AssetManager, _imagesScene:ImageManager, _soundsScene:SoundManager, _bitmapsScene:TextureManager, _objetosScene:ObjetoManager, _bodiesScene:BodyManager,mapData:Object )
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			bitmapsScene = _bitmapsScene;
			soundsScene = _soundsScene;
			objetosScene = _objetosScene;
			
			tilemap = new TileManager(mapData, texturesScene, bitmapsScene, objetosScene, _bodiesScene,globalResources);
			addChild(tilemap);
			
			addChild(sprite02);
			addChild(sprite01);
			
		}
		
		public function createPickups(missionPickups:Vector.<Objetos>):void {
			missionMapObjects = missionPickups;
			savemissionMapObjects.sort(Array.NUMERIC);
			destroymissionMapObjects.sort(Array.NUMERIC);
			
			var testArray:Array = savemissionMapObjects.concat(destroymissionMapObjects);
			testArray.sort(Array.NUMERIC);
			
			var index:int = testArray.length - 1;
			
			for (var i:int = missionMapObjects.length - 1; i > -1;--i) {
					if (testArray.length > 0 && testArray[index] == i ) {
						missionMapObjects.splice(i,1);
						index--;
						continue;
					}
				var namePosition:String =  int(missionMapObjects[i].objectData.gridPosition.x).toString() + "," + int(missionMapObjects[i].objectData.gridPosition.y).toString();
				objetosScene.addObjeto(namePosition, missionMapObjects[i]);
				missionMapObjects[i].namePosition = namePosition;
				sprite02.addChild(missionMapObjects[i]);
				miniWorldMap.objetosSprite.addChild(missionMapObjects[i].minimapImage);
				missionMapObjects[i].id = i;
			}
		}
		
		public function createExplotions():void {
			var index:int = 0;
			
			for (var i:uint = 0; i < tilemap.tilemap_explosives.length;++i) {

				var objeto:Object = new Object();
				
				objeto.layerName = "Explosives";
				objeto.objectName = tilemap.tilemap_explosives[i].typeName;
				objeto.objectPosition = tilemap.tilemap_explosives[i].pos;
				objeto.gridPosition = tilemap.tilemap_explosives[i].grid;
				
				var namePosition:String =  int(objeto.gridPosition.x).toString() + "," + int(objeto.gridPosition.y).toString();
				objeto.namePos = namePosition;
				
				missionMapObjects.push(new Objetos(texturesScene, soundsScene, globalResources, objeto));
				sprite02.addChild(missionMapObjects[missionMapObjects.length - 1]);
				//miniWorldMap.addChild(missionMapObjects[missionMapObjects.length - 1].minimapImage);
				objetosScene.addObjeto(namePosition, missionMapObjects[missionMapObjects.length - 1]);
				objeto = null;
			}
		}
		
		public  function createObstacles():void {
			var index:int = 0;
			
			savemissionMapCrystals.sort(Array.NUMERIC);
			
			for (var i:uint = 0; i < tilemap.tilemap_obstacules.length;++i) {
				if (savemissionMapCrystals.length > 0 && savemissionMapCrystals[index] == i ) {
					index++;
					continue;
				}
				var objeto:Object = new Object();
				
				objeto.layerName = "Toxicwaste";
				objeto.objectName = tilemap.tilemap_obstacules[i].typeName;
				objeto.objectPosition = tilemap.tilemap_obstacules[i].pos;
				objeto.gridPosition = tilemap.tilemap_obstacules[i].grid;
				
				var namePosition:String =  int(objeto.gridPosition.x).toString() + "," + int(objeto.gridPosition.y).toString();
				objeto.namePos = namePosition;
				
				missionMapObjects.push(new Objetos(texturesScene, soundsScene, globalResources, objeto));
				sprite02.addChild(missionMapObjects[missionMapObjects.length - 1]);
				miniWorldMap.objetosSprite.addChild(missionMapObjects[missionMapObjects.length - 1].minimapImage);
				objetosScene.addObjeto(namePosition, missionMapObjects[missionMapObjects.length - 1]);
				objeto = null;
				//sprite02.addChild(missionMapObjects[missionMapObjects.length-1].h);
				missionMapObjects[missionMapObjects.length-1].id = i;
			}
		}
		
		public function createUsables():void {
			
			//Agregar Hatch 
			var objeto:Object = new Object();

			objeto.layerName = "Hatch";
			objeto.objectName = "Hatch";
			objeto.objectPosition = tilemap.startMission;
			objeto.gridPosition = new Point(tilemap.center.x, tilemap.center.y);
			
			var namePosition2:String =  int(objeto.gridPosition.x).toString() + "," + int(objeto.gridPosition.y).toString();
			objeto.namePos = namePosition2;
			
			hatchObj = new Objetos(texturesScene, soundsScene, globalResources, objeto);
		//	hatchObj.y -= hatchObj.height / 2;
			sprite02.addChild(hatchObj);
			miniWorldMap.hatch = hatchObj.minimapImage;
			miniWorldMap.hatchPos.x = hatchObj.minimapImage.x;
			miniWorldMap.hatchPos.y = hatchObj.minimapImage.y;
			miniWorldMap.objetosSprite.addChild(hatchObj.minimapImage);
			objetosScene.addObjeto(namePosition2,hatchObj);
			
			 //Agregar para rango de compuerta del hatch
			//var initialX:int = objeto.gridPosition.x - 3;
            //var initialY:int = objeto.gridPosition.y - 3;
			
			objeto = null;
			

			//Agregar Resources 
			for (var j:uint = 0; j < tilemap.resources_vec.length;++j) {
				
				var objeto2:Object = new Object();
				objeto2.layerName = "resources";
				objeto2.objectName = tilemap.resources_vec[j].typeName;
				objeto2.objectPosition = tilemap.resources_vec[j].pos;
				objeto2.gridPosition = tilemap.resources_vec[j].grid;
				
				var namePosition:String =  int(objeto2.gridPosition.x).toString() + "," + int(objeto2.gridPosition.y).toString();
				objeto2.namePos = namePosition;
				
				missionMapObjects.push(new Objetos(texturesScene,soundsScene,globalResources,objeto2));
				sprite02.addChild(missionMapObjects[missionMapObjects.length - 1]);
				miniWorldMap.objetosSprite.addChild(missionMapObjects[missionMapObjects.length - 1].minimapImage);
				objetosScene.addObjeto(namePosition,missionMapObjects[missionMapObjects.length - 1]);
				
			}
			//Agregar Pilas
			for (var i:uint = 0; i < tilemap.usables.length;++i) {
				
				var objeto3:Object = new Object();
				objeto3.layerName = tilemap.usables[i].layerName;
				objeto3.letterType = tilemap.usables[i].type;
				objeto3.objectName = tilemap.usables[i].typeName;
				objeto3.objectPosition = tilemap.usables[i].pos;
				objeto3.gridPosition = tilemap.usables[i].grid;
				
				var namePosition3:String =  int(objeto3.gridPosition.x).toString() + "," + int(objeto3.gridPosition.y).toString();
				objeto3.namePos = namePosition3;
				
				missionMapObjects.push(new Objetos(texturesScene,soundsScene,globalResources,objeto3));
				sprite02.addChild(missionMapObjects[missionMapObjects.length - 1]);
				miniWorldMap.objetosSprite.addChild(missionMapObjects[missionMapObjects.length - 1].minimapImage);
				objetosScene.addObjeto(namePosition3, missionMapObjects[missionMapObjects.length - 1]);
				
				if (objeto3.layerName == "Trigger") {
					triggers.push(objeto3);
				}
			}
			
		}
		
		public function createMiniMap():void {
			
			miniWorldMap = new MiniMap(tilemap.width, tilemap.height,texturesScene);
			
		}
		
		public function set_missionStart():void {
			
			sortMap();
			this.x = (360 - tilemap.startMission.x);
			this.y = (360 - tilemap.startMission.y);
			tile_center = tilemap.p_center;
		}
		
		public function create_water(pos:Point, target:Objetos):void{
			//var al:Number=(Math.random()*12.0)-6;
			//var bl:Number=(Math.random()*12.0)-6;
			//var w:CryogelParticle=new CryogelParticle(pos.x+al,pos.y,target.x+al,target.y+bl, target, texturesScene);
			//cryogelParticles.push(w);
			//sprite01.addChild(w);
			//
			//starling.core.Starling.juggler.add(w);
			//w = null;
		}
		
		public function activateTrigger(type:String):void {
			var tempObj:Objetos
			for (var i:int = 0; i < missionMapObjects.length; i++) 
			{
				if (missionMapObjects[i].letterType == type) {
					tempObj = objetosScene.getObjeto(missionMapObjects[i].namePosition);
					tempObj.portal.play();
					tempObj.portal.addEventListener(Event.COMPLETE, onTriggerAnimationComplete);
					trace("active trigger " + missionMapObjects[i].letterType);
				}
			}
		}
		
		private function onTriggerAnimationComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, onTriggerAnimationComplete);
			var tempObj:Objetos = ((e.currentTarget as MovieClip).parent as Objetos);
			tempObj.objImg.visible = true;
			tempObj.removeChild(tempObj.portal)
			tempObj.convertToPickup();
			
		}
		
		public function add_object_drop_chopper(objDrop:Objetos, choppPos:Point):void{
			
			var flag:Boolean = false;
			var gridPos:Point = new Point();
			var distance:int = 2;
			var iter:int = 0;
			
			while(!flag){
			
				var aleat:int = Math.random() * 4;
				
				
				switch (aleat){
					
					case 0:
						gridPos = new Point(choppPos.x - distance, choppPos.y - distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_0:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_0.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_0);
							
							var tween_01:Tween=new Tween(objDrop,2,"easeIn");
							tween_01.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_01);
							
							
							
							flag = true;
						}
						break;
					case 1:
						gridPos = new Point(choppPos.x - distance, choppPos.y + distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_10:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_10.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_10);
							
							var tween_101:Tween=new Tween(objDrop,2,"easeIn");
							tween_101.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_101);
							
							
							flag = true;
						}
						break;
					case 2:
						gridPos = new Point(choppPos.x + distance, choppPos.y - distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_20:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_20.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_20);
							
							var tween_201:Tween=new Tween(objDrop,2,"easeIn");
							tween_201.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_201);
							
							
							flag = true;
						}
						break;
					case 3:
						gridPos = new Point(choppPos.x + distance, choppPos.y + distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_30:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_30.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_30);
							
							var tween_301:Tween=new Tween(objDrop,2,"easeIn");
							tween_301.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_301);
							
							
							flag = true;
						}
						break;				
				}
				
				if (++iter > 10) {
					distance++;
					iter = 0;
				}
				
			}
			
			objDrop.objectData.gridPosition = gridPos;
			objDrop.minimapImage.x = tilemap.pointTilePos(gridPos.x, gridPos.y).x*0.1;
			objDrop.minimapImage.y = tilemap.pointTilePos(gridPos.x, gridPos.y).y*0.1;
			
			var namePosition:String =  int(objDrop.objectData.gridPosition.x).toString() + "," + int(objDrop.objectData.gridPosition.y).toString();
			objDrop.namePosition = namePosition;
			objetosScene.addObjeto(namePosition, objDrop);
			sprite02.addChild(objDrop);
			miniWorldMap.objetosSprite.addChildAt(objDrop.minimapImage,miniWorldMap.objetosSprite.numChildren-2);
		}
		
		public function add_object_enemie(type:int, enemiePos:Point, enemieGridPos:Point):void{
			
			var flag:Boolean = false;
			var gridPos:Point = new Point();
			var distance:int = 2;
			var iter:int = 0;
			var objDrop:Objetos;
			
			switch(type) {
				case 1:
					if (Math.random() > 0.5) {
						
						var objeto1:Object = new Object();
						objeto1.layerName = "resources";
						objeto1.objectName = "Cgel";
						objeto1.objectPosition = enemiePos;
						objeto1.gridPosition = new Point();
						objeto1.namePos = "0,0";
						
						objDrop = new Objetos(texturesScene, soundsScene, globalResources, objeto1);
						
						
						
					}else {
						var objeto2:Object = new Object();
						objeto2.layerName = "resources";
						objeto2.objectName = "Fuel";
						objeto2.objectPosition = enemiePos;
						objeto2.gridPosition = new Point();
						objeto2.namePos = "0,0";
						
						objDrop = new Objetos(texturesScene, soundsScene, globalResources, objeto2);
					}
					
					break;
					
				default:
						return;
					break;
			}
			
		
			while(!flag){
			
				var aleat:int = Math.random() * 4;
				
				
				switch (aleat){
					
					case 0:
						gridPos = new Point(enemieGridPos.x - distance, enemieGridPos.y - distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_0:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_0.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_0);
							
							var tween_01:Tween=new Tween(objDrop,2,"easeIn");
							tween_01.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_01);
							
							objDrop.shadow.y = 125;
							objDrop.shadow.scaleX = 1.5;
							objDrop.shadow.scaleY = 1.5;
							objDrop.shadow.alpha = 0.5;
							var tween_02:Tween=new Tween(objDrop.shadow,2,"easeOutBounce");
							tween_02.animate("y", 10);
							tween_02.animate("scaleX", 1);
							tween_02.animate("scaleY", 1);
							tween_02.fadeTo(1);
							starling.core.Starling.juggler.add(tween_02);
							
							
							flag = true;
						}
						break;
					case 1:
						gridPos = new Point(enemieGridPos.x - distance, enemieGridPos.y + distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_10:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_10.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_10);
							
							var tween_101:Tween=new Tween(objDrop,2,"easeIn");
							tween_101.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_101);
							
							objDrop.shadow.y = 125;
							objDrop.shadow.scaleX = 1.5;
							objDrop.shadow.scaleY = 1.5;
							objDrop.shadow.alpha = 0.5;
							var tween_102:Tween=new Tween(objDrop.shadow,2,"easeOutBounce");
							tween_102.animate("y", 10);
							tween_102.animate("scaleX", 1);
							tween_102.animate("scaleY", 1);
							tween_102.fadeTo(1);
							starling.core.Starling.juggler.add(tween_102);
							
							
							flag = true;
						}
						break;
					case 2:
						gridPos = new Point(enemieGridPos.x + distance, enemieGridPos.y - distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_20:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_20.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_20);
							
							var tween_201:Tween=new Tween(objDrop,2,"easeIn");
							tween_201.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_201);
							
							objDrop.shadow.y = 125;
							objDrop.shadow.scaleX = 1.5;
							objDrop.shadow.scaleY = 1.5;
							objDrop.shadow.alpha = 0.5;
							var tween_202:Tween=new Tween(objDrop.shadow,2,"easeOutBounce");
							tween_202.animate("y", 10);
							tween_202.animate("scaleX", 1);
							tween_202.animate("scaleY", 1);
							tween_202.fadeTo(1);
							starling.core.Starling.juggler.add(tween_202);
							
							
							flag = true;
						}
						break;
					case 3:
						gridPos = new Point(enemieGridPos.x + distance, enemieGridPos.y + distance);
						if((gridPos.x > -1) && (gridPos.y > -1) && (gridPos.x < tilemap.mapWidth) && (gridPos.y < tilemap.mapHeight) && objetosScene.getObjeto(gridPos.x.toString()+","+gridPos.y.toString()) == null){
							var tween_30:Tween=new Tween(objDrop,2,"easeOutBounce");
							tween_30.animate("y",tilemap.pointTilePos(gridPos.x, gridPos.y).y);
							starling.core.Starling.juggler.add(tween_30);
							
							var tween_301:Tween=new Tween(objDrop,2,"easeIn");
							tween_301.animate("x",tilemap.pointTilePos(gridPos.x, gridPos.y).x);
							starling.core.Starling.juggler.add(tween_301);
							
							objDrop.shadow.y = 125;
							objDrop.shadow.scaleX = 1.5;
							objDrop.shadow.scaleY = 1.5;
							objDrop.shadow.alpha = 0.5;
							var tween_302:Tween=new Tween(objDrop.shadow,2,"easeOutBounce");
							tween_302.animate("y", 10);
							tween_302.animate("scaleX", 1);
							tween_302.animate("scaleY", 1);
							tween_302.fadeTo(1);
							starling.core.Starling.juggler.add(tween_302);
							
							
							flag = true;
						}
						break;				
				}
				
				if (++iter > 10) {
					distance++;
					iter = 0;
				}
				
			}
			
			objDrop.objectData.gridPosition = gridPos;
			
			objDrop.minimapImage.x = tilemap.pointTilePos(gridPos.x, gridPos.y).x*0.1;
			objDrop.minimapImage.y = tilemap.pointTilePos(gridPos.x, gridPos.y).y*0.1;
			objDrop.visible = true;
			var namePosition:String =  int(objDrop.objectData.gridPosition.x).toString() + "," + int(objDrop.objectData.gridPosition.y).toString();
			objDrop.namePosition = namePosition;
			objetosScene.addObjeto(namePosition, objDrop); 
			sprite02.addChild(objDrop);
			miniWorldMap.objetosSprite.addChild(objDrop.minimapImage);
			objDrop = null;
		}
		
		public function update_world():void{
			//actualizo las particulas de agua y si una impacta despliego el humo y elimino la particula 
			
			//for(var i:int=cryogelParticles.length-1;i>-1;--i){
				//if (cryogelParticles[i].update_particle()) {
					//if(--cryogelParticles[i].oTarget.hp==0)this.dispatchEvent(new GameEvents(GameEvents.DESTROY_CRYSTAL,{crystal:cryogelParticles[i].oTarget}));
					//sprite01.removeChild(cryogelParticles[i]);
					//var aux_particle:CryogelParticle = (cryogelParticles.splice(i,1)[0]) as CryogelParticle;
					//aux_particle.dispose();
					//aux_particle = null;
				//}
			//}
			
			//Fin actualizar particulas
		}
		
		//Funcion que devuelve la distancia entre el centro del tile set y el centro de la pantalla
		public function dist_tile():Point{
			
			return new Point(380-(tile_center.x+this.x),200-(tile_center.y+this.y));
			
		}
		
		
		//mover el tile set agregar a la izq
		public function tile_left():void {
			tilemap.tile_left();
			
		}
		
		public function tile_right():void {
			tilemap.tile_right();
			
		}
		public function tile_up():void {
			tilemap.tile_up();
			
		}
		public function tile_down():void {
			tilemap.tile_down();
			
		}
		
		public function update_tileCenter():void {
			
			tile_center=tilemap.p_center;
			
		}
		
		public function sortMap():void {
			
			sprite02.sortChildren(sort_sprites_function);
			
		}
		
		public function sort_sprites_function(a:DisplayObject, b:DisplayObject):int {
			
			if (a.y < b.y) 
			{ 
				return -1; 
			} 
			else if (a.y > b.y) 
			{ 
				return 1; 
			} 
			else 
			{ 
				if (a.x < b.x) {
					
					return -1;
					
				}else if (a.x > b.x){
					
					return 1;
				}
				else return 0; 
			} 
				
		}
		
				
		override public function dispose():void {
			this.removeEventListeners();
			this.removeChildren();
			
			sprite01.removeChildren();
			sprite02.removeChildren();
			
			sprite01 = null;
			sprite02 = null;
			
			tilemap.dispose();
			tilemap = null;
			
			miniWorldMap.dispose();
			miniWorldMap = null;
			
			for (var i:int = 0; i < missionMapObjects.length; ++i ){
			
				missionMapObjects[i].dispose();
				missionMapObjects[i] = null;
				
			
			}
			
			missionMapObjects.splice(0, missionMapObjects.length);
			missionMapObjects = null;
			
			globalResources = null;
			texturesScene = null;
			bitmapsScene = null;
			soundsScene = null;
			objetosScene = null;
			
			super.dispose();
			
			
		}
		
	}

}