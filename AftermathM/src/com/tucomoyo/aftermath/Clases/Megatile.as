package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import flash.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class Megatile extends Sprite 
	{
		public var globalResources:GlobalResources;
		public var texturesScene:AssetManager;
		public var soundsScene:SoundManager;
		
		public static const ButtonsAssets:String = "Botones";
		public static const TutorialAssets:String = "Game_objectives";
		public static const ScreenAssets:String = "screens";
		public static const MissionAssets:String = "fondoMission";
		
		public var megaTileObject:Object;
		private var currentDialog:MissionTargets;
		public var R:int; 
		public var targetDialogs:Sprite = new Sprite();
		
		private var megatileBg:ImageLoader;
		
		
		public function Megatile(_globalResources:GlobalResources, _textureScene:AssetManager, _soundScene:SoundManager, _megaTileInfo:Object) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _textureScene;
			soundsScene = _soundScene;
			megaTileObject = _megaTileInfo;
			this.addEventListener(GameEvents.ACTIVATE_DIALOG, removeDialog);
			
			megatileBg = new ImageLoader("https://s3.amazonaws.com/tucomoyo-games/aftermath/external_images/MegaTile/" + megaTileObject.megaTileInfo.megaTileName + ".jpg", globalResources.loaderContext, 760, 400);
			megatileBg._avatar.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, drawSectors);
		}
		
		public function drawSectors(e:flash.events.Event):void {
			
			megatileBg._avatar.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, drawSectors);
			this.addChild(megatileBg);
			
			for (var i:uint = 0; i < megaTileObject.megaTileInfo.megaTileTargets.length;++i) {
				var target:MissionTargets = new MissionTargets(globalResources, texturesScene,soundsScene, megaTileObject.megaTileInfo.megaTileTargets[i]);
				target.useHandCursor = true;
				target.x = (megaTileObject.megaTileInfo.megaTileTargets[i].targetPosition as Point).x;
				target.y = (megaTileObject.megaTileInfo.megaTileTargets[i].targetPosition as Point).y;
				addChild(target);
				targetDialogs.addChild(target.dialogo);
				target = null
			}
			
			globalResources.deactivateSplash(true);
			
			addChild(targetDialogs);
			
		}
		
		private function removeDialog(e:GameEvents):void {
			
			var target:MissionTargets = e.params.target;
			
			if (currentDialog != null) {
				currentDialog.dialogo.visible = false;
				currentDialog.dialogoStatus = false;
				currentDialog = target;
			}else {
				currentDialog = target;
			}
		}

	}

}