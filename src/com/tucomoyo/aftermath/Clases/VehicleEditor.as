package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author predictivia
	 * URL http://www.objgen.com/json/models/CQ1
	 */
	public class VehicleEditor extends Sprite 
	{
		private var texturesScene:AssetManager;
		private var globalResources:GlobalResources;
		private var soundScene:SoundManager;
		private var connect:Connection;
		private var editorData:Object;
		private var vehicleBodies:Vector.<Image> = new Vector.<Image>();
		private var vehicleGuns:Vector.<Image> = new Vector.<Image>();
		private var vehicleShields:Vector.<Image> = new Vector.<Image>();
		
		private var bodyBtnL:Button;
		private var bodyBtnR:Button;
		private var buyBodyBtn:Button;
		private var buyGunBtn:Button;
		private var buyShieldBtn:Button;
		
		private var gunFondo:Image;
		private var shieldFondo:Image;
		
		private var gunStat:Image;
		private var shieldStat:Image;
		private var gunMeter:Quad = new Quad(70, 15, 0x7fd800);
		private var shieldMeter:Quad = new Quad(70,15,0x7fd800);
		
		private var bodyText:TextField = new TextField(200,34,"");
		private var gunText:TextField = new TextField(211,23,"");
		private var shieldText:TextField = new TextField(211,23,"");
		
		private var statsBar:VehicleEditorStats;
		
		
		private var fondo:Quad = new Quad(760, 400, 0x191919);
		private var line1:Quad = new Quad(760, 34, 0x0e0e0e);
		private var line2:Quad = new Quad(760, 400, 0x191919);
		private var line3:Quad = new Quad(760, 400, 0x191919);
		private var indexBody:int;
		private var indexGun:int;
		private var indexShield:int;
		private var buyBotonsEnabled:Vector.<Boolean> = new Vector.<Boolean>();
		
		
		public function VehicleEditor(_globalResources:GlobalResources, _texturesScene:AssetManager, _soundsScene:SoundManager, _connect:Connection, _objectData:Object = null) 
		{
			super();
			
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			soundScene = _soundsScene;
			connect = _connect;
			connect.addEventListener(GameEvents.REQUEST_RECIVED, onVehicleData);
			connect.loadVehiclesInfo(globalResources.pref_url);
			
		}
		
		private function onVehicleData(e:GameEvents):void 
		{
			connect.removeEventListener(GameEvents.REQUEST_RECIVED, onVehicleData);
			editorData = e.params;
			
			line1.y = 169;
			
			
			for (var i:int = 0; i < editorData.bodies.length ; ++i ) {
				
				vehicleBodies.push(new Image(texturesScene.getAtlas("vehicleEditor").getTexture(editorData.bodies[i].texture)));
				vehicleBodies[i].x = 246;
				vehicleBodies[i].y = 11;
				vehicleBodies[i].scaleX = vehicleBodies[i].scaleY = 1.35;
				buyBotonsEnabled.push(true);
			}
			
			
			for (var j:int = 0; j < editorData.weapons.length ; ++j ) {
				
				vehicleGuns.push(new Image(texturesScene.getAtlas("vehicleEditor").getTexture(editorData.weapons[j].texture)));
				vehicleGuns[j].x = 43;
				vehicleGuns[j].y = 200;
			}
			
			for (var k:int = 0; k < editorData.shields.length ; ++k ) {
				
				vehicleShields.push(new Image(texturesScene.getAtlas("vehicleEditor").getTexture(editorData.shields[k].texture)));
				vehicleShields[k].x = 568;
				vehicleShields[k].y = 200;
			}
			
			for (var u:int = 0; u < globalResources.profileData.vehicleData.bodiesBought.length; u++ ) {
				
				buyBotonsEnabled[globalResources.profileData.vehicleData.bodiesBought[u]] = false;
				
			}
			
			bodyBtnL = new Button(texturesScene.getAtlas("vehicleEditor").getTexture("arrow_moreL"));
			bodyBtnR = new Button(texturesScene.getAtlas("vehicleEditor").getTexture("arrow_moreR"));
			
			buyBodyBtn = new Button(texturesScene.getAtlas("vehicleEditor").getTexture("boton-bishcoin"));
			buyGunBtn = new Button(texturesScene.getAtlas("vehicleEditor").getTexture("boton-bishcoinS"));
			buyShieldBtn = new Button(texturesScene.getAtlas("vehicleEditor").getTexture("boton-bishcoinS"));
			
			buyBodyBtn.textHAlign = buyGunBtn.textHAlign = buyShieldBtn.textHAlign = "right";
			buyBodyBtn.fontSize = 18;
			buyBodyBtn.fontBold = buyGunBtn.fontBold = buyShieldBtn.fontBold = true;
			buyBodyBtn.text = buyGunBtn.text = buyShieldBtn.text = "500 .";
			buyBodyBtn.fontColor = buyGunBtn.fontColor = buyShieldBtn.fontColor = 0xffffff;
			
			bodyBtnL.addEventListener(Event.TRIGGERED, onBtnL);
			bodyBtnR.addEventListener(Event.TRIGGERED, onBtnR);
			
			
			bodyBtnL.x = 235;
			bodyBtnR.x = 495;
			bodyBtnL.y = bodyBtnR.y = 75;
			
			buyBodyBtn.addEventListener(Event.TRIGGERED, onBuyBody);
			buyGunBtn.addEventListener(Event.TRIGGERED, onBuyGun);
			buyShieldBtn.addEventListener(Event.TRIGGERED, onBuyShield);
			
			buyBodyBtn.x = 334;
			buyBodyBtn.y = 211;
			
			buyGunBtn.x = 84;
			buyShieldBtn.x = 614;
			buyGunBtn.y = buyShieldBtn.y = 358;
			
			gunFondo = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("windows"));
			shieldFondo = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("windows"));
			
			gunStat = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("shield_bar"));
			shieldStat = new Image(texturesScene.getAtlas("vehicleEditor").getTexture("shield_bar"));
			
			bodyText.text = editorData.bodies[0].name[globalResources.idioma];
			gunText.text = editorData.weapons[0].name[globalResources.idioma];
			shieldText.text = editorData.shields[0].name[globalResources.idioma];
			bodyText.color = gunText.color = shieldText.color = 0xffffff;
			bodyText.fontSize = 18;
			bodyText.x = 280;
			gunText.x = 10;
			shieldText.x = 540;
			bodyText.y = 169;
			gunText.y = shieldText.y = 330;
			
			gunFondo.x = 10;
			shieldFondo.x = 540;
			gunFondo.y = shieldFondo.y = 191;
			
			gunMeter.x = 82;
			shieldMeter.x = 609;
			gunMeter.y = shieldMeter.y = 203;
			
			gunStat.x = 73;
			shieldStat.x = 600;
			gunStat.y = shieldStat.y = 200;
			
			statsBar = new VehicleEditorStats(globalResources, texturesScene);
			
			
			addChild(fondo);
			addChild(line1);
			addChild(gunFondo);
			addChild(shieldFondo);
			addChild(gunMeter);
			addChild(shieldMeter);
			addChild(gunStat);
			addChild(shieldStat);
			addChild(bodyText);
			addChild(gunText);
			addChild(shieldText);
			addChild(bodyBtnL);
			addChild(bodyBtnR);
			addChild(buyBodyBtn);
			addChild(buyGunBtn);
			addChild(buyShieldBtn);
			
			addChild(statsBar);
			
			initStats();
			
		}
		
		public function initStats():void 
		{
			indexBody = globalResources.profileData.vehicleData.body;			
			indexGun = globalResources.profileData.vehicleData.weapon+1;
			indexShield = globalResources.profileData.vehicleData.shield + 1;
			
			gunMeter.scaleX = indexGun * 0.2;
			shieldMeter.scaleX = indexShield * 0.2;
			
			if (indexGun == editorData.weapons.length) {
				indexGun--;
				buyGunBtn.enabled = false;
			}
			
			if (indexShield == editorData.shields.length) {
				indexShield--;
				buyShieldBtn.enabled = false;
			}
			
			
			buyBodyBtn.text = String(editorData.bodies[indexBody].costo) + " .";
		    buyGunBtn.text = String(editorData.weapons[indexGun].costo) + " .";
			buyShieldBtn.text = String(editorData.shields[indexShield].costo) + " .";
			buyBodyBtn.enabled = false;
			bodyText.text = editorData.bodies[indexBody].name[globalResources.idioma];
			statsBar.updateStats(editorData.bodies[indexBody].stats.fuel,editorData.bodies[indexBody].stats.cryogel,editorData.bodies[indexBody].stats.speed);
			addChild(vehicleBodies[indexBody]);
			addChild(vehicleGuns[indexGun]);
			addChild(vehicleShields[indexShield]);
			
		}
		
		private function onBtnL(e:Event):void 
		{
			if (indexBody > 0) {
				indexBody--;
				removeChild(vehicleBodies[indexBody + 1]);
				addChild(vehicleBodies[indexBody]);
				bodyText.text = editorData.bodies[indexBody].name[globalResources.idioma];
				buyBodyBtn.text = String(editorData.bodies[indexBody].costo) + " .";
				buyBodyBtn.fontColor = (globalResources.profileData.bishcoins > editorData.bodies[indexBody].costo)?0xffffff:0xff0000;
				buyBodyBtn.enabled = buyBotonsEnabled[indexBody];
				statsBar.updateStats(editorData.bodies[indexBody].stats.fuel,editorData.bodies[indexBody].stats.cryogel,editorData.bodies[indexBody].stats.speed);
				
				if (!buyBotonsEnabled[indexBody]) {
					globalResources.profileData.vehicleData.cryogel = editorData.bodies[indexBody].stats.cryogel;
					globalResources.profileData.vehicleData.fuel = editorData.bodies[indexBody].stats.fuel;
					globalResources.profileData.vehicleData.velocityValue = editorData.bodies[indexBody].stats.speed;
					globalResources.profileData.vehicleData.body = indexBody;
				}
			}
		}
		
		private function onBtnR(e:Event):void 
		{
			if (indexBody < vehicleBodies.length-1) {
				indexBody++;
				removeChild(vehicleBodies[indexBody - 1]);
				addChild(vehicleBodies[indexBody]);
				bodyText.text = editorData.bodies[indexBody].name[globalResources.idioma];
				buyBodyBtn.text = String(editorData.bodies[indexBody].costo) + " .";
				buyBodyBtn.fontColor = (globalResources.profileData.bishcoins > editorData.bodies[indexBody].costo)?0xffffff:0xff0000;
				buyBodyBtn.enabled = buyBotonsEnabled[indexBody];
				statsBar.updateStats(editorData.bodies[indexBody].stats.fuel, editorData.bodies[indexBody].stats.cryogel, editorData.bodies[indexBody].stats.speed);
				
				if (!buyBotonsEnabled[indexBody]) {
					globalResources.profileData.vehicleData.cryogel = editorData.bodies[indexBody].stats.cryogel;
					globalResources.profileData.vehicleData.fuel = editorData.bodies[indexBody].stats.fuel;
					globalResources.profileData.vehicleData.velocityValue = editorData.bodies[indexBody].stats.speed;
					globalResources.profileData.vehicleData.body = indexBody;
				}
			}
		}
		
		private function onBuyBody(e:Event):void 
		{
			if (globalResources.profileData.bishcoins > editorData.bodies[indexBody].costo) {
				globalResources.profileData.bishcoins -= editorData.bodies[indexBody].costo;
				buyBotonsEnabled[indexBody] = buyBodyBtn.enabled = false;
				globalResources.profileData.vehicleData.cryogel = editorData.bodies[indexBody].stats.cryogel;
				globalResources.profileData.vehicleData.fuel = editorData.bodies[indexBody].stats.fuel;
				globalResources.profileData.vehicleData.velocityValue = editorData.bodies[indexBody].stats.speed;
				globalResources.profileData.vehicleData.body = indexBody;
				globalResources.profileData.vehicleData.bodiesBought.push(indexBody);
			}
		}
		
		private function onBuyGun(e:Event):void 
		{
			if (globalResources.profileData.bishcoins > editorData.weapons[indexGun].costo) {
				
				globalResources.profileData.vehicleData.weapon = indexGun;
				connect.setVehicleStat(globalResources.user_id,"weapon",indexGun as String);
				if(indexGun < editorData.weapons.length - 1){
					removeChild(vehicleGuns[indexGun]);
					indexGun++;
					buyGunBtn.text = String(editorData.weapons[indexGun].costo) + " .";
					addChild(vehicleGuns[indexGun]);
					
				}else {
					buyGunBtn.enabled = false;
					indexGun++;
				}
				globalResources.profileData.vehicleData.damage = indexGun * 25;
				connect.setVehicleStat(globalResources.user_id,"damage",globalResources.profileData.vehicleData.damage as String);
				globalResources.profileData.bishcoins -= editorData.weapons[indexGun-1].costo;
				gunMeter.scaleX = indexGun * 0.2;
			}
		}
		
		private function onBuyShield(e:Event):void 
		{
			if (globalResources.profileData.bishcoins > editorData.shields[indexShield].costo) {
				
				globalResources.profileData.vehicleData.shield = indexShield;
				connect.setVehicleStat(globalResources.user_id,"shield",indexShield as String);
				if(indexShield < editorData.shields.length - 1){
					removeChild(vehicleShields[indexShield]);
					indexShield++;
					buyGunBtn.text = String(editorData.shields[indexShield].costo) + " .";
					addChild(vehicleShields[indexShield]);
					
				}else {
					buyShieldBtn.enabled = false;
					
					indexShield++;
				}
				globalResources.profileData.vehicleData.shieldValue = indexShield * 25;
				connect.setVehicleStat(globalResources.user_id,"shieldValue",globalResources.profileData.vehicleData.shieldValue as String);
				globalResources.profileData.bishcoins -= editorData.shields[indexShield-1].costo;
				shieldMeter.scaleX = indexShield * 0.2;
			}
		}
		
	}

}