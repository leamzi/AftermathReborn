package com.tucomoyo.aftermath.Engine 
{
	import com.tucomoyo.aftermath.Clases.Dialogs;
	import com.tucomoyo.aftermath.GlobalResources;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class TaskObject extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		private var soundsScene:SoundManager;
		
		public var taskInfo:Object;
		public var taskdialog:Dialogs;
		
		public function TaskObject(_globalResources:GlobalResources, _texturesScene:AssetManager, _soundsScene:SoundManager, _taskInfo:Object) 
		{
			super();
			
			texturesScene = _texturesScene;
			globalResources = _globalResources;
			soundsScene = _soundsScene;
			taskInfo = _taskInfo;
			
			
			addEventListener(TouchEvent.TOUCH, onTaskClick);
			drawTask();
		}
		
		public function drawTask():void {
			
			var image:Quad = new Quad(70, 58, 0x000000); //x = 10, y = 103
			addChild(image);
			
			var tempObj:Object = new Object();
			
			taskdialog = new Dialogs(globalResources, texturesScene, soundsScene, 100, 100);
			taskdialog.multiDialog(3, tempObj);
		}
		
		public function onTaskClick(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			
			if (touch == null) {
				taskdialog.visible = false;
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN) {
				
				if (touch.tapCount == 1) {
					taskdialog.visible = true;
				}
			}
			if (touch.phase == TouchPhase.HOVER) {
				
			}
		}
		
		override public function dispose():void {
			
			this.removeChildren();
			this.removeEventListeners();
			
			globalResources = null;
			texturesScene = null;
			
			//if (imgTrophy != null) {
				//
				//imgTrophy.removeEventListeners();
				//imgTrophy.dispose();
				//imgTrophy = null;
			//}
		
			taskInfo = null;
			
			super.dispose();
			
		}
		
	}

}