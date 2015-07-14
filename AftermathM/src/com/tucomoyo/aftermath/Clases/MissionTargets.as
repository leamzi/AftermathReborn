package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.GameEvents;
	import com.tucomoyo.aftermath.Engine.SoundManager;
	import com.tucomoyo.aftermath.GlobalResources;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class MissionTargets extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var textureScene:AssetManager;
		private var soundsScene:SoundManager;
		public static const ButtonsAssets:String = "Botones";
		private var tempData:Array = new Array();
		
		public var dialogo:Dialogs;
		public var dialogoStatus:Boolean = false;
		private var missionInfo:Object;
		
		public function MissionTargets(_globalResources:GlobalResources, _textureScene:AssetManager, _soundsScene:SoundManager, _missionInfo:Object)
		{
			super();
			globalResources = _globalResources;
			textureScene = _textureScene;
			soundsScene = _soundsScene;
			missionInfo = _missionInfo;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
		}
		
		public function onAddedtoStage():void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
			
			var targetMov:MovieClip = new MovieClip(textureScene.getAtlas(ButtonsAssets).getTextures("target_"), 10);
			Starling.juggler.add(targetMov);
			tempData.push(targetMov);
			targetMov.setFrameDuration(0, 3);
			targetMov.setFrameDuration(3, 1);
			targetMov.alignPivot();
			addChild(targetMov);
			
			var targetImage:Image;
			var textureTest:Texture;
			textureTest = textureScene.getAtlas(ButtonsAssets).getTexture(missionInfo.category);
			
			if (textureTest == null) 
			{
				targetImage = new Image(textureScene.getAtlas(ButtonsAssets).getTexture("unknow"));
			}else {
				targetImage = new Image(textureTest);
			}
			tempData.push(targetImage);
			targetImage.alignPivot();
			addChild(targetImage);
			
			dialogo = new Dialogs(globalResources, textureScene, soundsScene,52,40);
			dialogo.createMissionTargetDialog(missionInfo);
			dialogo.visible = false;
			//addChild(dialogo);
			
			var complete:Image = new Image(textureScene.getAtlas(ButtonsAssets).getTexture("completed"));
			complete.alignPivot();
			complete.visible = false;
			tempData.push(complete);
			addChild(complete);
			
			if (missionInfo.missionCompleted) {
				complete.visible = true;
				complete.touchable = false;
				stage.addEventListener(TouchEvent.TOUCH, onTargetClick);
			}else{
			
				stage.addEventListener(TouchEvent.TOUCH, onTargetClick);
				
			}
		}
		
		public function onTargetClick(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			if (touch == null) {
				return;
			}
			if (touch.phase == TouchPhase.BEGAN) {
				if (!dialogoStatus) {
					soundsScene.getSound("Gui_Button_click").play(globalResources.volume);
					this.dispatchEvent(new GameEvents(GameEvents.ACTIVATE_DIALOG,{ type:"activateDialog", target:this}, true));
					dialogo.visible = true;
					dialogoStatus = true;
				}else {
					dialogoStatus = false;
				}
			}
		}
		
		override public function dispose():void 
		{
			this.removeEventListeners();
			
			if (tempData != null) 
			{
				for (var i:uint = 0; i < tempData.length;++i) {
					tempData[i].removeEventListeners();
					tempData[i].dispose();
					tempData[i] = null;
				}
				tempData.splice(0, tempData.length);
				tempData = null;
			}
			
			super.dispose();
		}
		
	}

}