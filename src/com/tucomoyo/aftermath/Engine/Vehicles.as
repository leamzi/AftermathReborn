package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.Clases.Objetos;
	import com.tucomoyo.aftermath.Clases.vehicleShield;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Vehicles extends Sprite 
	{
		
		public static const COLLISION_WIDTH:Number=100.0;
		public static const COLLISION_HEIGHT:Number = COLLISION_WIDTH *0.5;
		
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		public var tempData:Array = new Array();
		public var frontSprite:Sprite = new Sprite();
		public var vehicleSprite:Sprite = new Sprite();
		public var vehicleSpriteBack:Sprite = new Sprite();
		
		public var canonX:int;
		public var canonY:int;
		
		public var fuel:Number;
		public var cryogel:Number;
		public var damage:Number;
		public var shieldValue:Number;
		public var velocityValue:Number;
		
		public var targetObject:Objetos;
		public var ptoPickup:Point = new Point();
		public var targetPickup:Boolean = false;
		public var targetCheked:Boolean = false;
		
		public var velocity:Point = new Point();
		public var clickToMove:Boolean = false;
		public var canMove:Boolean = false;
		public var immunity:Boolean = false;
		
		private var imageDirection:int = 0;
		private var vehicleAngle:Number;
		public var cursorAngle:Number;
		
		private var vehicleN:Image;
		private var vehicleNO1:Image;
		private var vehicleNO2:Image;
		private var vehicleNO3:Image;
		private var vehicleO:Image;
		private var vehicleSO1:Image;
		private var vehicleSO2:Image;
		private var vehicleSO3:Image;
		private var vehicleS:Image;	
		public var target01:Image;
		public var target02:Image;
		
		public var shield:vehicleShield;
		
		public var vehicleData:Object;
		
		public var explosion:MovieClip;
		public var doubleClick:MovieClip;
		//private var chargeAnimationN:MovieClip;
		//private var chargeAnimationNO1:MovieClip;
		//private var chargeAnimationNO2:MovieClip;
		//private var chargeAnimationNO3:MovieClip;
		//private var chargeAnimationO:MovieClip;
		//private var chargeAnimationSO1:MovieClip;
		//private var chargeAnimationSO2:MovieClip;
		//private var chargeAnimationSO3:MovieClip;
		//private var chargeAnimationS:MovieClip;
		
		public var GridPos:Point = new Point();
		
		public var tymer:Timer = new Timer(2000, 1);
		public var vehicleBody:Body = new Body(BodyType.DYNAMIC);
		
		public function Vehicles(_texturesScene:AssetManager, _soundsScene:SoundManager, _globalResources:GlobalResources, _objectData:Object)
		{
			
			super();
			texturesScene = _texturesScene;
			globalResources = _globalResources;
			soundsScene = _soundsScene;
			
			cryogel = 1;
			fuel = 1;
			shieldValue = 0.0;
			damage = 100;
			velocityValue = 200;
			
			vehicleData = (globalResources.profileData!=null)?globalResources.profileData.vehicleData:null;
			
			if (vehicleData != null) {
				
				cryogel += vehicleData.cryogel;
				fuel += vehicleData.fuel;
				shieldValue = vehicleData.shieldValue;
				damage += vehicleData.damage;
				velocityValue += vehicleData.velocityValue;
			}
			
			tymer.addEventListener(TimerEvent.TIMER_COMPLETE,onImmunity);
			
			vehicleBody.shapes.add(new Circle(20,null,new Material()));
			
		}
		
		
		
		public function drawVehicle(_type:String):void {
			
			var type:String;
			
			type = _type;
			
			vehicleN = new Image(texturesScene.getAtlas(type).getTexture((globalResources.profileData.vehicleData.body as int).toString()));
			vehicleN.pivotX = Math.ceil(vehicleN.width / 2);
			vehicleN.pivotY = Math.ceil(vehicleN.height / 2);
			
			/*vehicleN = new Image(texturesScene.getAtlas(type).getTexture(type + "_N"));
			vehicleN.pivotX = Math.ceil(vehicleN.width / 2);
			vehicleN.pivotY = Math.ceil(vehicleN.height / 2);
			
			vehicleNO1 = new Image(texturesScene.getAtlas(type).getTexture(type + "_NO1"));
			vehicleNO1.pivotX = Math.ceil(vehicleNO1.width / 2);
			vehicleNO1.pivotY = Math.ceil(vehicleNO1.height / 2);
			
			vehicleNO2 = new Image(texturesScene.getAtlas(type).getTexture(type + "_NO2"));
			vehicleNO2.pivotX = Math.ceil(vehicleNO2.width / 2);
			vehicleNO2.pivotY = Math.ceil(vehicleNO2.height / 2);
			
			vehicleNO3 = new Image(texturesScene.getAtlas(type).getTexture(type + "_NO3"));
			vehicleNO3.pivotX = Math.ceil(vehicleNO3.width / 2);
			vehicleNO3.pivotY = Math.ceil(vehicleNO3.height / 2);
			
			vehicleO = new Image(texturesScene.getAtlas(type).getTexture(type + "_O"));
			vehicleO.pivotX = Math.ceil(vehicleO.width / 2);
			vehicleO.pivotY = Math.ceil(vehicleO.height / 2);
			
			vehicleSO1 = new Image(texturesScene.getAtlas(type).getTexture(type + "_SO1"));
			vehicleSO1.pivotX = Math.ceil(vehicleSO1.width / 2);
			vehicleSO1.pivotY = Math.ceil(vehicleSO1.height / 2);
			
			vehicleSO2 = new Image(texturesScene.getAtlas(type).getTexture(type + "_SO2"));
			vehicleSO2.pivotX = Math.ceil(vehicleSO2.width / 2);
			vehicleSO2.pivotY = Math.ceil(vehicleSO2.height / 2);
			
			vehicleSO3 = new Image(texturesScene.getAtlas(type).getTexture(type + "_SO3"));
			vehicleSO3.pivotX = Math.ceil(vehicleSO3.width / 2);
			vehicleSO3.pivotY = Math.ceil(vehicleSO3.height / 2);
			
			vehicleS = new Image(texturesScene.getAtlas(type).getTexture(type + "_S"));
			vehicleS.pivotX = Math.ceil(vehicleS.width / 2);
			vehicleS.pivotY = Math.ceil(vehicleS.height / 2);*/
			
			target01 = new Image(texturesScene.getAtlas(type).getTexture("target001"));
			target01.scaleY = 0.5;
			target01.pivotX = Math.ceil(target01.width / 2);
			target01.pivotY = Math.ceil(target01.height / 2);
			tempData.push(target01);
			
			target02 = new Image(texturesScene.getAtlas(type).getTexture("target002"));
			target02.scaleY = 0.5;
			target02.pivotX = Math.ceil(target02.width / 2);
			target02.pivotY = Math.ceil(target02.height / 2);
			tempData.push(target02);
			
			shield = new vehicleShield(texturesScene);
			tempData.push(shield);
			
			explosion = new MovieClip(texturesScene.getAtlas("vehicleExplosion").getTextures("explosion"), 15);
			tempData.push(explosion);
			
			tempData.push(vehicleSpriteBack);
			addChild(vehicleSpriteBack);
			tempData.push(vehicleSprite);
			addChild(vehicleSprite);
			//vehicleSprite.addChild(vehicleO);
			vehicleSprite.addChild(vehicleN);
			
			doubleClick = new MovieClip(texturesScene.getAtlas("Botones").getTextures("click"), 25);
			doubleClick.alignPivot();
			doubleClick.setFrameDuration(13, 0.5);
			Starling.juggler.add(doubleClick);
			doubleClick.stop();
			//doubleClick.x = 0;
			//doubleClick.y = ;
			tempData.push(doubleClick);
			doubleClick.addEventListener(Event.COMPLETE, doubleClickAnimationOff);
			frontSprite.addChild(doubleClick);
			doubleClick.visible = false;
			
			tempData.push(frontSprite);
			//addChild(frontSprite);
		
		}
		
		public function hitVehicle(damage:Number):void {
			
			this.fuel -= (damage<shieldValue)?0.01:(damage-shieldValue);
			this.shield.visibleOn();
			this.setImmunity();
		}
		
		public function setImmunity():void {
			immunity = true;
			tymer.start();
			this.alpha = 0.5;
		}
		
		private function onImmunity(e:TimerEvent):void 
		{
			immunity = false;
			tymer.stop();
			this.alpha = 1.0;
		}
		
		public function onMouse_H(e:String, _X:int, _Y:int):void {
			
			if( e==TouchPhase.BEGAN && !targetPickup){
				
				clickToMove=true;
				canMove=false;
				
			}
			
			if( e==TouchPhase.ENDED){
				
				clickToMove=false;
				
				
			}			
			
		}//END onMouse_H
		
		public function update(e:Event,_X:int,_Y:int,wPos:Point):void {
			
			//this.x = vehicleBody.position.x+wPos.x;
			//this.y = vehicleBody.position.y+wPos.y;
			
			var dx:int = _X-this.x;
			var dy:int = _Y-this.y;
			var ax:int = Math.abs(dx);
			var ay:int = Math.abs(dy);
			var t:Number;
			
			if(ax+ay==0)t=0;
			else t=dy/(ax+ay);
			
			if(dx<0){
				t=2-t;
			}
			else
			{
				
				if(dy<0)t+=4;
				
			}
			if(clickToMove)cursorAngle= 90*t;
//			dir_mc.rotation = (90*t*3.14)/180;
			
			
			if (clickToMove) {
				
				var estimated:Point = new Point(dx,dy);
				estimated.normalize(1);
				/*
				var absEstimatedX:Number = Math.abs(estimated.x);
				var absEstimatedY:Number = Math.abs(estimated.y);
				var velocityRelation:Number = (absEstimatedX > 150 || absEstimatedY > 150)?((absEstimatedX > absEstimatedY)? (150.0 / absEstimatedX):(150.0 / absEstimatedY)):(1.0);
				*/
				
				
				velocity.x = estimated.x * velocityValue;
				velocity.y = estimated.y * velocityValue;
				if(canMove){
					 vehicleBody.velocity.x = velocity.x;//this.x+=velocity.x;
					 vehicleBody.velocity.y = velocity.y;//this.y+=velocity.y;
				}
				
			}else {
					
				vehicleBody.velocity.x = 0;
				vehicleBody.velocity.y = 0;
					
			}
			
			if(targetPickup){
			/*	velocity.x=(ptoPickup.x-this.x)*0.75;
				velocity.y = (ptoPickup.y - this.y) * 0.75;
			*/	
				var estimated2:Point = new Point((ptoPickup.x-this.x)*0.75, (ptoPickup.y - this.y) * 0.75);
				
				var absEstimatedX2:Number = Math.abs(estimated2.x);
				var absEstimatedY2:Number = Math.abs(estimated2.y);
				var velocityRelation2:Number = (absEstimatedX2 > 150 || absEstimatedY2 > 150)?((absEstimatedX2 > absEstimatedY2)? (150.0 / absEstimatedX2):(150.0 / absEstimatedY2)):(1.0);
				
				velocity.x = estimated2.x * velocityRelation2;
				velocity.y = estimated2.y * velocityRelation2;
				
				if(canMove){	
					vehicleBody.velocity.x = velocity.x;//this.x+=velocity.x;
					vehicleBody.velocity.y = velocity.y;//this.y+=velocity.y;
				}
				if(Math.abs(this.x-ptoPickup.x)<30 && Math.abs(this.y-ptoPickup.y)<30){
					targetPickup=false;
				/*	if(ptoPickup.x<200){this.x=201;}
					else{if(ptoPickup.x>560){this.x=559;}
					else this.x=ptoPickup.x;}
					if(ptoPickup.y<200){this.y=201;}
					else {if(ptoPickup.y>250){this.y=249;}
					else this.y=ptoPickup.y;}*/
				}
			}
			else {
				if(!clickToMove){	
					vehicleBody.velocity.x = 0;
					vehicleBody.velocity.y = 0;
				}
			}
			
		//	if (Math.abs(velocity.x) < 1) vehicleBody.velocity.x = 0;
		//	if (Math.abs(velocity.y) < 1) vehicleBody.velocity.y = 0;
			
			if(fuel>0){
				fuel-=0.0006;
			}
			
			/******************************************
			 no salirme del cuadro
			 *****************************************/
		/*	if (this.x < 200) { this.vehicleBody.position.x += (200 - this.x); this.x = 200; }
			if (this.y < 200) { this.vehicleBody.position.y += (200 - this.y); this.y = 200; }
			if (this.x > 560) { this.vehicleBody.position.x -= (this.x - 560); this.x = 560; }
			if (this.y > 250) { this.vehicleBody.position.y -= (this.y - 250); this.y = 250; }
		*/	
			/*******************************************
			 
			 si estoy moviendome cambio la
			 dirección donde miro
			 
			 *********************************************/
				
			if(clickToMove){
				
				//changeDirection();
			}
			/*******************************
			 termino cambio de direccion
			 donde miro
			 ********************************/
			
			
		}// END onEnterFr
		
		public function updateTarget(targetX:int, targetY:int):void {
			//Direccion del target de disparo
			 var mousePoint:Point = globalToLocal(new Point(targetX, targetY));
			 target01.x = mousePoint.x;
			 target01.y = mousePoint.y;
			 target02.x = mousePoint.x;
			 target02.y = mousePoint.y;
		}
		
		
		public function changeDirection():void {
			var addAngle:Number;
			
				cursorAngle = cursorAngle % 360;
			
				if(imageDirection!=0 && (cursorAngle>357.5 || cursorAngle <= 6.25)){
					imageDirection=0;
					setDirection("E");
				}
				if(imageDirection!=1 && cursorAngle>16.25 && cursorAngle <= 49){
					imageDirection=1;
					setDirection("SE1");
				}
				if(imageDirection!=2 && cursorAngle>59 && cursorAngle <= 67){
					imageDirection=2;
					setDirection("SE2");
				}
				if(imageDirection!=3 && cursorAngle>77 && cursorAngle <= 80.5){
					imageDirection=3;
					setDirection("SE3");
				}
				if(imageDirection!=4 && cursorAngle>90.5 && cursorAngle <= 89.5){
					imageDirection=4;
					setDirection("S");
				}
				if(imageDirection!=5 && cursorAngle>99.5 && cursorAngle <= 121){
					imageDirection=5;
					setDirection("SO3");
				}
				if(imageDirection!=6 && cursorAngle>131 && cursorAngle <= 141.25){
					imageDirection=6;
					setDirection("SO2");
				}
				if(imageDirection!=7 && cursorAngle>151.25 && cursorAngle <= 163.75){
					imageDirection=7;
					setDirection("SO1");
				}
				if(imageDirection!=8 && cursorAngle>173.75 && cursorAngle <= 182.5){
					imageDirection=8;
					setDirection("O");
				}
				if(imageDirection!=9 && cursorAngle>192.5 && cursorAngle <= 212.5){
					imageDirection=9;
					setDirection("NO3");
				}
				if(imageDirection!=10 && cursorAngle>222.5 && cursorAngle <= 231.25){
					imageDirection=10;
					setDirection("NO2");
				}
				if(imageDirection!=11 && cursorAngle>241.25 && cursorAngle <= 253.75){
					imageDirection=11;
					setDirection("NO1");
				}
				if(imageDirection!=12 && cursorAngle>263.75 && cursorAngle <= 276.25){
					imageDirection=12;
					setDirection("N");
				}
				if(imageDirection!=13 && cursorAngle>286.25 && cursorAngle <= 317.5){
					imageDirection=13;
					setDirection("NE1");
				}
				if(imageDirection!=14 && cursorAngle>327.5 && cursorAngle <= 332.5){
					imageDirection=14;
					setDirection("NE2");
				}
				if(imageDirection!=15 && cursorAngle>342.5 && cursorAngle <= 347.5){
					imageDirection=15;
					setDirection("NE3");
				}
				
				if(vehicleAngle > cursorAngle){
					if((vehicleAngle - cursorAngle)<180){
						addAngle=8;
					}else{
						addAngle=-8;
					}
				}else{
					if((cursorAngle - vehicleAngle)<180){
						addAngle=-5;
					}else{
						addAngle=5;
					}
					
				}
				cursorAngle+=addAngle;
				if(cursorAngle<0)cursorAngle=360;
				if(cursorAngle>360)cursorAngle=0;
			
		}
		
		
		public function setDirection(_direction:String):void {
			var direction:String
			
			direction = _direction;
			
			switch (direction) {
				
				case "N":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleN);
					vehicleN.scaleX=Math.abs(vehicleN.scaleX);
					break;
				case "NO1":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleNO1);
					vehicleNO1.scaleX=Math.abs(vehicleNO1.scaleX);
					break;
				case "NO2":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleNO2);
					vehicleNO2.scaleX=Math.abs(vehicleNO2.scaleX);
					break;
				case "NO3":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleNO3);
					vehicleNO3.scaleX=Math.abs(vehicleNO3.scaleX);
					break;
				case"O":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleO);
					vehicleO.scaleX=Math.abs(vehicleO.scaleX);
					break;	
				case"SO1":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleSO1);
					vehicleSO1.scaleX=Math.abs(vehicleSO1.scaleX);
					break;
				case"SO2":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleSO2);
					vehicleSO2.scaleX=Math.abs(vehicleSO2.scaleX);
					break;
				case"SO3":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleSO3);
					vehicleSO3.scaleX=Math.abs(vehicleSO3.scaleX);
					break;
				case"S":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleS);
					vehicleS.scaleX=Math.abs(vehicleS.scaleX);
					break;
				case"SE3":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleSO3);
					vehicleSO3.scaleX=-1*Math.abs(vehicleSO3.scaleX);
					break;
				case"SE2":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleSO2);
					vehicleSO2.scaleX=-1*Math.abs(vehicleSO2.scaleX);
					break;
				case"SE1":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleSO1);
					vehicleSO1.scaleX=-1*Math.abs(vehicleSO1.scaleX);
					break;
				case"E":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleO);
					vehicleO.scaleX=-1*Math.abs(vehicleO.scaleX);
					break;
				case "NE3":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleNO3);
					vehicleNO3.scaleX=-1*Math.abs(vehicleNO3.scaleX);
					break;
				case "NE2":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleNO2);
					vehicleNO2.scaleX=-1*Math.abs(vehicleNO2.scaleX);
					break;
				case "NE1":
					vehicleSprite.removeChildAt(0);
					vehicleSprite.addChild(vehicleNO1);
					vehicleNO1.scaleX=-1*Math.abs(vehicleNO1.scaleX);
					break;
			}
		}
		
		public function detectTarget(_X:Number, _Y:Number, w_X:int, w_Y:int, collision:Point):Boolean{
			
				
				var auxX:Number =(_X+w_X)-this.x;
				var auxY:Number =(_Y+w_Y)-this.y;
				
				auxX*=auxX;
				auxY*=auxY;
				
				auxX=auxX/((COLLISION_WIDTH+collision.x)*(COLLISION_WIDTH+collision.x));
				auxY=auxY/ ((COLLISION_HEIGHT+collision.y)*(COLLISION_HEIGHT+collision.y));
				
				return (auxX+auxY) < 1.0;

		}
		
		public function detectNearObject(_X:int, _Y:int, collision:Point):Boolean{
			var auxX:Number =_X-this.x;
			var auxY:Number =_Y-this.y;
			
			auxX*=auxX;
			auxY*=auxY;
			
			auxX=auxX/((COLLISION_WIDTH+collision.x)*(COLLISION_WIDTH+collision.x));
			auxY = auxY / ((COLLISION_HEIGHT+collision.y)*(COLLISION_HEIGHT+collision.y));
			
			return (auxX+auxY) < 1.0;
		}
		
		public function pickupObject(_X:int, _Y:int, collision:Point):Boolean{
			var auxX:Number =_X-this.x;
			var auxY:Number =_Y-this.y;
			
			auxX*=auxX;
			auxY*=auxY;
			
			auxX=auxX/((COLLISION_WIDTH+collision.x)*(COLLISION_WIDTH+collision.x)*0.2);
			auxY = auxY / ((COLLISION_HEIGHT+collision.y)*(COLLISION_HEIGHT+collision.y)*0.2);
			
			return (auxX+auxY) < 1.0;
		}
		
		public function targetingPickup(p:Point, obj:Objetos):void {
			
			if (targetPickup) return;
			ptoPickup.x=p.x;
			ptoPickup.y=p.y;
			targetPickup = true;
			targetObject=obj;
			if(cursorAngle<0)cursorAngle=360+cursorAngle;
		}
		
		public function hitTestPoint(_X:int,_Y:int):Boolean{
			var _w:int =50;
			var _h:int =50;
			return((_X<(this.x+_w)) && (_X>(this.x-_w)) && (_Y<(this.y+_h)) && (_Y>(this.y-_h))  );
		}
		
		public function destroyVehicle():void {
			
			explosion.pivotX = explosion.width * 0.5;
			explosion.pivotY = explosion.height * 0.5;
			explosion.loop = false;
			Starling.juggler.add(explosion);
			this.addChild(explosion);
			
		}
		
		public function doubleClickAnimation(type:String = ""):void 
		{
			
			if (!doubleClick.isPlaying)
			{
				trace("Play");
				doubleClick.visible = true;
				doubleClick.play();
			}
		}
		
		public function doubleClickAnimationOff(e:Event):void 
		{
			trace("Pare");
			doubleClick.visible = false;
			doubleClick.stop();
		}
		
		override public function dispose():void 
		{
			
			this.removeEventListeners();
			this.removeChildren();
			
			targetObject = null;
			globalResources = null;
			soundsScene = null;
			texturesScene = null;
			
			
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