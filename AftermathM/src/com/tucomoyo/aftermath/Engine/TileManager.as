package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.space.Space;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author predictivia
	 */
	public class TileManager extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		private var bitmapsScene:TextureManager;
		private var objetosScene:ObjetoManager;
		private var bodiesScene:BodyManager;
		private var loader:URLLoader  = new URLLoader ();
		
		public var tileWidth:int;
		public var tileHeight:int;
		public var mapWidth:int;
		public var mapHeight:int;
		
		public var fiList:Vector.<int> = new Vector.<int>;
		public var tilemap_tiles:Vector.<Sprite> = new Vector.<Sprite>;
		public var tilemapVector_img:Vector.<Vector.<Image>> = new Vector.<Vector.<Image>>();
		public var tilemap_pickups:Vector.<Object> = new Vector.<Object>;
		public var tilemap_explosives:Vector.<Object> = new Vector.<Object>;
		public var layersSprite:Sprite = new Sprite();
		public var tilemap_obstacules:Vector.<Object> = new Vector.<Object>;
		public var resources_vec:Vector.<Object> = new Vector.<Object>;
		public var usables:Vector.<Object> = new Vector.<Object>;
		public var bodies:Vector.<Body> = new Vector.<Body>;
		
		public var startMission:Point;
		
		public var center:Point;
		public var p_center:Point;
		private var pref_url:String;
		private var missionID:String;
		private var jason:Object = null;
		
		public var frontiers:Vector.<Body> = new Vector.<Body>();
		public var spots:Vector.<Point> = new Vector.<Point>();
		
		public function TileManager(mapData:Object, _textureScene:AssetManager, _bitmapsScene:TextureManager, _objetosScene:ObjetoManager, _bodiesScene:BodyManager,_globalResources:GlobalResources) 
		{
			super();
			
			globalResources = _globalResources;
			texturesScene = _textureScene;
			bitmapsScene = _bitmapsScene;
			objetosScene = _objetosScene;
			bodiesScene = _bodiesScene;
			addChild(layersSprite);
			
			jason = mapData;
			tileWidth=jason.tilewidth;
			tileHeight=jason.tileheight;
			mapWidth=jason.width;
			mapHeight = jason.height;
			
			var i:int = 0;
			
			while(jason.tilesets[i] != undefined){
				
				fiList.push(jason.tilesets[i].firstgid as int);
				i++;
			}
			
			llenar_tileset();
			p_center = startMission;
			
			//setSpots();
			
			//crear_tilemap();  
			
//			this.dispatchEvent(new GameEvents(GameEvents.TILEMAP_LOAD));
			/*
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(new URLRequest(globalResources.pref_url + "maps/mission" + _missionID + ".json"));
			*/
			
		}
		
		public function loadComplete(e:Event):void {
			
			jason = JSON.parse(String(e.target.data));
			tileWidth=jason.tilewidth;
			tileHeight=jason.tileheight;
			mapWidth=jason.width;
			mapHeight = jason.height;
			
			var i:int = 0;
			
			while(jason.tilesets[i] != undefined){
				
				fiList.push(jason.tilesets[i].firstgid as int);
				i++;
			}
			
			llenar_tileset();
			p_center = startMission;
			
			//crear_tilemap();  
			
			this.dispatchEvent(new GameEvents(GameEvents.TILEMAP_LOAD));
			
			
		}
		
		public function crear_tilemap(_space:Space):void {
			
			
			
			var p:Point = center;
			var _i:int=p.x-15;
			var _j:int=p.y-1;
			
			
			
			for(var j:int=0;j<17;++j){
				for(var i:int=0;i<15;++i){
					if (_i > mapWidth - 1 || _i < 0 || _j > mapHeight - 1 || _j < 0) {
						--_j;
						++_i
						continue;
					}
					
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = true;
					var nameObject:String = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = true;
					--_j;
					++_i
				}
				_j=p.y+j;
				_i=p.x-14+j;
			}
			
			_i = p.x - 14;
			_j = p.y-1;
			
			for(var j2:int=0;j2<16;++j2){
				for(var i2:int=0;i2<14;++i2){
					if (_i > mapWidth - 1 || _i < 0 || _j > mapHeight - 1 || _j < 0) {
						--_j;
						++_i
						continue;
					}
					
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = true;
					nameObject = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = true;
					--_j;
					++_i
				}
				_j=p.y+j2;
				_i=p.x-13+j2;
			}
			
			this.set_frontiers(_space);
			
		}
		
		public function pointTilePos(i:int, j:int):Point {
			
			return new Point(((tileWidth*0.5) * i) - ((j+1) * (tileWidth*0.5)), ((tileHeight*0.5) * (j+1)) + ((tileHeight*0.5) * i) - ((mapHeight*tileHeight)*0.5));
			
		}
		
		
		public function llenar_tileset():void {
			
			//Dibujar layers en el world map
			llenarLayer(0);
		//	if (getLayerPos("Debris") != 0) llenarLayer(getLayerPos("Debris"));
			if (getLayerPos("Buildings") != 0) llenarLayer(getLayerPos("Buildings"));
			
			addTileSprite();

			var cosas:Vector.<int> = new Vector.<int>(4);
			
			//Objetos dentro del mapa
			for(var j:int=0;j<mapHeight;++j){
				for (var i:int = 0; i < mapWidth;++i) {
					
					var posAux:Point = pointTilePos(i, j);
					var gridAux:Point = new Point(i, j);
					
					if (getLayerPos("Pickups")!=0 && jason.layers[getLayerPos("Pickups")].data[i+(j*mapWidth)] != 0){
						//trace(jason.layers[getLayerPos("Pickups")].data[i+(j*mapWidth)]);
						cosas[0]++;
						var pick:Object = new Object();
						pick.name = jason.tilesets[getFid(jason.layers[getLayerPos("Pickups")].data[i + (j * mapWidth)])].name;
						pick.pos = posAux;
						pick.grid = gridAux;
						
						if (pick.name != "Box") {
							pick.type = "A";
							pick.active = false;
							
						}
						
						tilemap_pickups.push(pick);
					}
					
					if (getLayerPos("Explosives")!=0 && jason.layers[getLayerPos("Explosives")].data[i+(j*mapWidth)] != 0){
						//trace(jason.layers[getLayerPos("Explosives")].data[i+(j*mapWidth)]);
						var explosive:Object = new Object();cosas[1]++;
						explosive.pos = posAux;
						explosive.grid = gridAux;
						explosive.typeName = getTilesetName(jason.layers[getLayerPos("Explosives")].data[i+(j*mapWidth)]);
						tilemap_explosives.push(explosive);
					}

					if (getLayerPos("Toxicwaste")!=0 && jason.layers[getLayerPos("Toxicwaste")].data[i+(j*mapWidth)] != 0){
						var crystal:Object = new Object();cosas[2]++;
						crystal.grid = gridAux;
						crystal.pos = posAux;
						crystal.typeName = getTilesetName(jason.layers[getLayerPos("Toxicwaste")].data[i+(j*mapWidth)]);
						tilemap_obstacules.push(crystal);
						
					}
					
					if (getLayerPos("Hatch")!=0 && jason.layers[getLayerPos("Hatch")].data[i+(j*mapWidth)] != 0){
						startMission = pointTilePos(i, j);
						center = new Point(i, j); 
					}
					//if (jason.layers[getLayerPos("FinalPickup")].data[i+(j*mapWidth)] != 0){
						//lastPickup = new Point((32*(i+1))-((j)*32), (15.5*(j))+(15.5*(i+1))-(1550));
					//}
					if (getLayerPos("UseA")!=0 && jason.layers[getLayerPos("UseA")].data[i + (j * mapWidth)] != 0) {trace(getLayerPos("UseA"),jason.layers[getLayerPos("UseA")].data[i + (j * mapWidth)],jason.layers[getLayerPos("UseA")].data[i + (j * mapWidth)] != 0)
						var usableA:Object = new Object();
						usableA.grid = gridAux;
						usableA.pos = posAux;
						usableA.type = "A";
						usableA.layerName = "Use";
						usableA.typeName = getTilesetName(jason.layers[getLayerPos("UseA")].data[i+(j*mapWidth)]);
						usables.push(usableA);
					}

					if (getLayerPos("DropA")!=0 && jason.layers[getLayerPos("DropA")].data[i+(j*mapWidth)] != 0){
						var dropA:Object = new Object();
						dropA.grid = gridAux;
						dropA.pos = posAux;
						dropA.type = "A";
						dropA.layerName = "Drop";
						dropA.typeName = getTilesetName(jason.layers[getLayerPos("DropA")].data[i+(j*mapWidth)]);
						dropA.active = false;
						usables.push(dropA);
					}
						
					if (getLayerPos("Resources") != 0 && jason.layers[getLayerPos("Resources")].data[i + (j * mapWidth)] != 0) {
						
						var fId:int = getFid(jason.layers[getLayerPos("Resources")].data[i + (j * mapWidth)]);
						cosas[3]++;
						var resources:Object = new Object();
						resources.grid = gridAux;
						resources.pos = posAux;
						resources.type = jason.tilesets[fId].properties.type;
						resources.typeName = getTilesetName(jason.layers[getLayerPos("Resources")].data[i+(j*mapWidth)]);
						resources_vec.push(resources);
						
					}
				}
			}
			
			
		}
		
		public function llenarLayer(_Id:int):void {
			
			var _id:int = _Id;
			var layerName:String = jason.layers[_id].name;
			
			var tilemap_info:Array;
			tilemap_info = jason.layers[_id].data;
			var cosa:int = 0;
			var img_vector:Vector.<Image> = new Vector.<Image>();
			
			for(var j:int=0;j<mapHeight;++j){
				for(var i:int=0;i<mapWidth;++i){
					
					var type:int = tilemap_info[i + (j * mapWidth)];
					
					if (_id == 0) {
						tilemap_tiles.push(new Sprite());
						var punto:Point = pointTilePos(i, j);
						tilemap_tiles[i+(j*mapWidth)].x=punto.x;
						tilemap_tiles[i + (j * mapWidth)].y = punto.y;
						
					}
					
					if (type != 0) { cosa++;
						tilemap_tiles[i + (j * mapWidth)].addChild(getTile(type, layerName));
						tilemap_tiles[i + (j * mapWidth)].visible = false;
						
					} 
				}
			}
			
			tilemap_info = null;
		}
		
		public function addTileSprite():void {
			for(var j:int=0;j<mapHeight;++j){
				for(var i:int=0;i<mapWidth;++i){
					layersSprite.addChild(tilemap_tiles[i + (j * mapWidth)]);
				}
			}
			
		}
		
		public function getTilesetName(_id:int):String{
			var i:int = 0;
			
			while(jason.tilesets[i] != undefined){
				if (jason.tilesets[i].firstgid == _id){
					return (jason.tilesets[i].name as String);
				}
				i++
			}
			
			return ("");
		}
		
		public function getTile(_idT:int, _layerName:String):Image {
			
			var layerName:String;
			var idL:int;
			var idT:int;
			var fId:int;
			var spriteW:int;
			var ft:int;
			var ct:int;
			var tx:int;
			var ty:int;
			
			var tile:Image;
			var tileMov:MovieClip;
			var random:Number;
			var tWidth:int;
			var tHeight:int;
			
			var w:int;
			
			layerName = _layerName;
			idT = _idT;
			fId = getFid(idT);
			spriteW = int(jason.tilesets[fId].imagewidth);
			
			w = spriteW/tileWidth;
			idL = idT - int(jason.tilesets[fId].firstgid);
			ft = idL / w;
			ct = idL % w;
			tWidth = int(jason.tilesets[fId].tilewidth);
			tHeight = int(jason.tilesets[fId].tileheight);
			
			tx = ct*tWidth;
			ty = ft * tHeight;
			
			if (jason.tilesets[fId].properties.type == "animation") 
			{
				if (texturesScene.getAtlas(layerName) != null) { 
					tileMov = new MovieClip (texturesScene.getAtlas("Animations").getTextures(jason.tilesets[fId].name as String), 5);
				}
			
				tileMov.pivotX = tWidth * 0.5;
				tileMov.pivotY = tHeight - (tileHeight * 0.5);
				random = (Math.random() * 5);
			
				Starling.juggler.add(tileMov);
				tileMov.advanceTime(random);
				tileMov.play();
				
				return (tileMov);
			} else {
				if (texturesScene.getAtlas(layerName) != null) { 
					tile = new Image(texturesScene.getAtlas(layerName).getTexture(jason.tilesets[fId].name as String));
				}else { 
					tile = new Image(Texture.fromTexture(bitmapsScene.getTexture(layerName), new Rectangle( tx, ty, tWidth, tHeight)));
				}
				
				tile.pivotX = tWidth * 0.5;
				tile.pivotY = tHeight - (tileHeight * 0.5);
				
				return (tile);
			}
			
			return (null);
			
		}
		
		public function getFid(_idT:int):int{
			
			for(var j:int; j < fiList.length - 1; j++){
				if (_idT >= fiList[j] && _idT < fiList[j+1] ){
					
					return (j);
				}
			}
			
			return (fiList.length -1);
		}
	
		public function getLayerPos(_name:String):int{
			var i:int=0;
			while (jason.layers[i] != undefined){
				if (jason.layers[i].name as String == _name) {
					return i;
				}
				i++
			}
			return 0;			
		}
		
		public function tile_left():void {
			var _i:int=center.x-16;
			var _j:int=center.y;
			
			for(var i:int=0;i<33;++i){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i+1)%2);
					_j+=((i)%2);
					
				}else{
					//addChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = true;
					var nameObject:String = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = true;
					_i+=((i+1)%2);
					_j+=((i)%2);
				}
			}
			
			_i=center.x-1;
			_j=center.y-15;
			
			for(var i2:int=0;i2<33;++i2){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i2)%2);
					_j+=((i2+1)%2);
					
				}else{
					//removeChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = false;
					nameObject = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = false;
					_i+=((i2)%2);
					_j+=((i2+1)%2);
				}
			}
			
			center.x--;
			center.y++;
			p_center=pointTilePos(center.x,center.y);
			
		}//end tile_left
		
		public function tile_right():void {
			var _i:int=center.x;
			var _j:int=center.y-16;
			
			for(var i:int=0;i<33;++i){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i)%2);
					_j+=((i+1)%2);
				}else{
					//addChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = true;
					var nameObject:String = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = true;
					_i+=((i)%2);
					_j+=((i+1)%2);
				}
			}
			
			_i=center.x-15;
			_j=center.y-1;
			
			for(var i2:int=0;i2<33;++i2){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i2+1)%2);
					_j+=((i2)%2);
				}else{
					//removeChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = false;
					nameObject = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = false;
					_i+=((i2+1)%2);
					_j+=((i2)%2);
				}
			}
			
			center.x++;
			center.y--;
			p_center=pointTilePos(center.x,center.y);
		}//end tile_right
		
		public function tile_up():void {
			var _i:int=center.x-16;
			var _j:int=center.y-2;
			
			for(var i:int=0;i<29;++i){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i+1)%2);
					_j-=(i%2);
				}else{
					//addChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = true;
					var nameObject:String = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = true;
					_i+=((i+1)%2);
					_j-=(i%2);
				}
			}
			
			_i=center.x+1;
			_j=center.y+15;
			
			for(var i2:int=0;i2<29;++i2){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i2)%2);
					_j-=((i2+1)%2);					 
				}else{
					//removeChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = false;
					nameObject = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = false;
					_i+=((i2)%2);
					_j-=((i2+1)%2);
				}
			}
			
			center.x--;
			center.y--;
			p_center=pointTilePos(center.x,center.y);
		}//end tile_up
		
		public function tile_down():void {
			var _i:int=center.x+2;
			var _j:int=center.y+16;
			
			for(var i:int=0;i<29;++i){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){ 
					_i+=(i%2);
					_j-=((i+1)%2);
				}else{
					//addChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = true;
					var nameObject:String = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = true;
					_i+=(i%2);
					_j-=((i+1)%2);
				}
			}
			
			_i=center.x-15;
			_j=center.y-1;
			
			for(var i2:int=0;i2<29;++i2){
				if(_i > mapWidth-1 || _i < 0 || _j > mapHeight-1 || _j < 0){
					_i+=((i2+1)%2);
					_j-=(i2%2);
				}else{
					//removeChild(tilemap_tiles[_i+((_j)*mapWidth)]);
					tilemap_tiles[_i + ((_j) * mapWidth)].visible = false;
					nameObject = _i.toString() + "," +_j.toString();
					if (objetosScene.getObjeto(nameObject) != null) objetosScene.getObjeto(nameObject).visible = false;
					_i+=((i2+1)%2);
					_j-=(i2%2);
				}
			}
			
			center.x++;
			center.y++;
			p_center=pointTilePos(center.x,center.y);
		}//end tile_down
		
		public function set_frontiers(_space:Space):void {
		
			var body1:Body = new Body(BodyType.STATIC);
			var body2:Body = new Body(BodyType.STATIC);
			var body3:Body = new Body(BodyType.STATIC);
			var body4:Body = new Body(BodyType.STATIC);
			
			var p1:Point = new Point(pointTilePos(0, mapHeight - 1).x - (tileWidth * 0.5), pointTilePos(0, mapHeight-1).y);
			var p2:Point = new Point(pointTilePos(0, 0).x, pointTilePos(0, 0).y-(tileHeight*0.5));
			var p3:Point = new Point(pointTilePos(mapWidth-1, 0).x + (tileWidth * 0.5), pointTilePos(mapWidth-1, 0).y);
			var p4:Point = new Point(pointTilePos(mapWidth-1, mapHeight - 1).x , pointTilePos(mapWidth-1, mapHeight-1).y+(tileHeight*0.5));
			
/*			var p1:Point = new Point(0,200);
			var p2:Point = new Point(380,0);
			var p3:Point = new Point(760,200);
			var p4:Point = new Point(380,400);
*/			
			var poly1:Shape = new Polygon([   Vec2.weak(p1.x, p1.y)   ,  Vec2.weak(p2.x, p2.y)   ,  Vec2.weak(p1.x, p2.y)   ],new Material());
			var poly2:Shape = new Polygon([   Vec2.weak(p4.x, p4.y)   ,  Vec2.weak(p1.x, p1.y)   ,  Vec2.weak(p1.x, p4.y)   ],new Material());
			var poly3:Shape = new Polygon([   Vec2.weak(p3.x, p4.y)   ,  Vec2.weak(p3.x, p3.y)   ,  Vec2.weak(p4.x, p4.y)   ],new Material());
			var poly4:Shape = new Polygon([   Vec2.weak(p3.x, p3.y)   ,  Vec2.weak(p3.x, p2.y)   ,  Vec2.weak(p2.x, p2.y)   ],new Material());
			
			body1.shapes.add(poly1);
			body2.shapes.add(poly2);
			body3.shapes.add(poly3);
			body4.shapes.add(poly4);
			
			body1.space = body2.space = body3.space = body4.space = _space;
			
			frontiers.push(body1);
			frontiers.push(body2);
			frontiers.push(body3);
			frontiers.push(body4);
		 
			if (getLayerPos("Coliders") != 0)create_coliders();
		}
		
		public function create_coliders():void 
		{
			var pos:int = getLayerPos("Coliders");
			var i:int = 0;
			while (jason.layers[pos].objects[i]) {
				
				
			
				if (jason.layers[pos].objects[i].name != "") { 
					var aux:Object = jason.layers[pos].objects[i];
				
					createBody(aux);
				}
				
				++i;
			}
			
		}
		
		public function createBody(obj:Object):void {
			
			var body:Body = new Body(BodyType.STATIC);
			
			var p0:Point = new Point(Math.round(obj.x/tileHeight),Math.round(obj.y/tileHeight));
			
			var p1:Point = new Point(pointTilePos(p0.x, p0.y).x, pointTilePos(p0.x, p0.y).y-(tileHeight*0.5));
			var p2:Point = new Point(pointTilePos(p0.x,Math.round(p0.y+Number(Number(obj.height)/Number(tileHeight)))).x,pointTilePos(p0.x,Math.round(p0.y+Number(Number(obj.height)/Number(tileHeight)))).y-(tileHeight*0.5));
			var p3:Point = new Point(pointTilePos(Math.round(p0.x+Number(Number(obj.width)/Number(tileHeight))),Math.round(p0.y+Number(Number(obj.height)/Number(tileHeight)))).x,pointTilePos(Math.round(p0.x+Number(Number(obj.width)/Number(tileHeight))),Math.round(p0.y+Number(Number(obj.height)/Number(tileHeight)))).y-(tileHeight*0.5));
			var p4:Point = new Point(pointTilePos(Math.round(p0.x+Number(Number(obj.width)/Number(tileHeight))),p0.y).x,pointTilePos(Math.round(p0.x+Number(Number(obj.width)/Number(tileHeight))),p0.y).y-(tileHeight*0.5));
			
			var poly:Shape = new Polygon([   Vec2.weak(p1.x, p1.y)   ,  Vec2.weak(p2.x, p2.y)   ,  Vec2.weak(p3.x, p3.y) ,  Vec2.weak(p4.x, p4.y)  ],new Material());
			
			body.shapes.add(poly);
			
			bodiesScene.addBody(obj.name, body);
			
			body = null;
		}
		
		
		override public function dispose():void {
			
			globalResources = null;
			texturesScene = null;
			bitmapsScene = null;
			objetosScene = null;
			loader = null;
			
			
			for (var i:int = 0; i < tilemap_tiles.length; ++i ) {
				
				tilemap_tiles[i].dispose()
				tilemap_tiles[i].removeChildren();
				tilemap_tiles[i] = null;
				
			}
			
			tilemap_tiles.splice(0, tilemap_tiles.length);
			tilemap_tiles = null;
			
		
			layersSprite.dispose()
			layersSprite.removeChildren();
			layersSprite = null;
				
			
			fiList.splice(0,fiList.length);
			fiList = null;
			
			this.removeChildren();
			super.dispose();
			
		}
		
		public function setSpots(num:int):void {
			
			var n:int = mapWidth / (num+1)
		
			for (var i:int = 1; i < num+1;++i ) {				
				spots.push(pointTilePos(i*n, 0));
				spots.push(pointTilePos(i*n, mapHeight-1));				
				
			}
			
		}
		
		public function sort_sprites():void {
			
			layersSprite.sortChildren(sort_sprites_function);
			
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
				return 0; 
			} 
				
		}
		
	}

}