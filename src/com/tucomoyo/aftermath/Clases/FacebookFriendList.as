package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.VerticalScrollBar;
	import com.tucomoyo.aftermath.Clases.FacebookImage;
	import com.tucomoyo.aftermath.Clases.FacebookFriendListBox;
	import com.tucomoyo.aftermath.GlobalResources;
	import feathers.controls.TextInput;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Predictvia
	 */
	public class FacebookFriendList extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var texturesScene:AssetManager;
		private var friendsVec:Vector.<FacebookFriendListBox> = new Vector.<FacebookFriendListBox>;
		private var scrollSprite:friend_list_sprite;
		private var searchTextInput:TextInput = new TextInput();
		public var d_scrollbar:VerticalScrollBar = new VerticalScrollBar();
		private var countRelationVisible:int = 0;
		public var check:Image;		
		public var connect:Connection;
		
		public function FacebookFriendList(_globalResources:GlobalResources, _texturesScene:AssetManager,_connect:Connection) 
		{
			super();
			globalResources = _globalResources;
			texturesScene = _texturesScene;
			connect = _connect;
			
			d_scrollbar.x = 674;
			d_scrollbar.y = 88;
			d_scrollbar.addEventListener(starling.events.TouchEvent.TOUCH, onMouse);
			
			globalResources.friendsList.sort(sort_name);
			
			scrollSprite = new friend_list_sprite(x, y);
			
			var fondoImg1:Image = new Image(texturesScene.getAtlas("Gui").getTexture("guiFrame01"));
			fondoImg1.scaleX = 1.3;
			fondoImg1.scaleY = 1.2;
			addChild(fondoImg1);
			
			
			var fondoImg2:Image = new Image(texturesScene.getAtlas("Gui").getTexture("friendList_bg"));
			fondoImg2.x = 17;
			fondoImg2.y = 66;
			addChild(fondoImg2); 
			
			var closeBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("guiClose"));
			closeBtn.x = fondoImg1.width - (closeBtn.width + 15);
			closeBtn.y = 20;
			closeBtn.addEventListener(starling.events.Event.TRIGGERED, onCloseDialog);
			addChild(closeBtn);
			
			var title:TextField = new TextField(705, 40, "Share with Friends", globalResources.fontName, 30, 0xFFFFFF);
			title.x = 15;
			title.y = 20;
			title.vAlign = "center";
			title.hAlign = "center";
			title.touchable = false;
			addChild(title);
			title = null;
			
			var friendBox:FacebookFriendListBox;
			for (var i:int = 0; i < globalResources.friendsList.length; i++) 
			{
				friendBox = new FacebookFriendListBox(globalResources, texturesScene, globalResources.friendsList[i])
				friendBox.x =  ((friendBox.width + 1) * (i % 3)) + 20;
				friendBox.y = (friendBox.height + 1) * Math.floor(i / 3) + 85;
				if (i > 11) friendBox.visible = false;
				friendsVec.push(friendBox);
				scrollSprite.canvas.addChild(friendBox);
				friendBox = null;
			}
			addChild(scrollSprite);
			
			var checkAll:Button = new Button(texturesScene.getAtlas("Gui").getTexture("selectAll"));
			checkAll.x = 425;
			checkAll.y = 299;
			checkAll.addEventListener(starling.events.Event.TRIGGERED, onCheckAll);
			addChild(checkAll);
			
			check = new Image(texturesScene.getAtlas("Botones").getTexture("checkmark"));
			check.x = 441;
			check.y = 318;
			check.visible = false;
			addChild(check);
			
			var confirmBtn:Button = new Button(texturesScene.getAtlas("Botones").getTexture("btnAccept"));
			confirmBtn.x = 601;
			confirmBtn.y = 308;
			confirmBtn.addEventListener(Event.TRIGGERED, onSendNotifications);
			addChild(confirmBtn);
			
			searchTextInput.x = 38;
			searchTextInput.y = 326;
			searchTextInput.width = 280;
			searchTextInput.height = 22;
			searchTextInput.addEventListener(starling.events.Event.CHANGE, input_changeHandler);
			searchTextInput.textEditorProperties.fontName = globalResources.fontName;
			searchTextInput.textEditorProperties.fontSize = 20;
			addChild(searchTextInput);
			
			if (globalResources.friendsList.length > 9) {
				d_scrollbar.create_scrollBar(1, 184, (int((friendsVec.length - 1) / 3) + 1) * 63);
			}
			
			addChild(d_scrollbar);
			
			this.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, onWheelMove);
		}
		
		
		public function sort_name(a:Object, b:Object):int 
		{ 

			if (a.name < b.name) 
			{ 
				return -1; 
			} 
			else if (a.name > b.name) 
			{ 
				return 1; 
			} else { 
				return 0; 
			} 
		}
		
		private function onSendNotifications(e:Event):void 
		{
			var friendsSend:Array = new Array();
			
			for (var i:int = 0; i < friendsVec.length; ++i ) {
				
				if(friendsVec[i].check.visible)friendsSend.push(friendsVec[i].data.id);
				
			}
			
			if(friendsSend.length>0)connect.send_notifications("Te ha invitado", friendsSend);
			
			friendsSend = null;
		}
		
		public function onCheckAll():void
		{
			check.visible = !check.visible;
			
			for (var i:int = 0; i < friendsVec.length; i++) 
			{
				friendsVec[i].checkFriend(check.visible);
				//friendsVec[i].check.visible = check.visible;
			}
			
		}
		
		public function onCloseDialog():void
		{
			this.visible = false;
		}
		
		/*************************************
		 CONTROL DEL MOUSE
		 *************************************/
		
		public function onMouse(e:starling.events.TouchEvent):void{
			
			var touch:Touch = e.getTouch(d_scrollbar);
			if (touch == null) return;
			var pos:Point = this.globalToLocal(touch.getLocation(d_scrollbar));
			if(touch.phase==TouchPhase.BEGAN){
				onMouseDown(pos);
			}
			if(touch.phase==TouchPhase.MOVED){
				onMouseMove(pos);
			}
			if(touch.phase==TouchPhase.ENDED){
				onMouseUp();
			}
			
		}
	
		public function onMouseDown(p:Point):void {//trace(p)
			if (p.x +10> 0&& p.x <  30 && p.y+10 > d_scrollbar.bar.y && p.y < d_scrollbar.bar.y + d_scrollbar.bar_size){
				d_scrollbar.scrollBar_onMouseDown(p.y);
			}
			
		}//end onMouseDown
		
		public function onMouseMove(p:Point):void {
			if (d_scrollbar.bar_press) {
				scrollSprite.canvas.y = d_scrollbar.scrollBar_onMouseMove(p.y);
				
				var countRelation:int = int(scrollSprite.canvas.y / -63);
				
				if (countRelation != countRelationVisible) {
					
					for (var j:int = 0; j < friendsVec.length; ++j )friendsVec[j].visible = false;
				
					var index:int = 0;
					
					for (var i:int = 0; i < 15; ++i ) {
						
					
						index = (((countRelation - 1) * 3)) + i;
						
						if( index > -1 && index < friendsVec.length)friendsVec[index].visible = true;
					
					}
					countRelationVisible = countRelation;
				}
				
			}
			
		}//end onMouseMove
		
		public function onMouseUp():void {
			d_scrollbar.scrollBar_onMouseUp();
		}//end onMouseUp
		
		public function input_changeHandler(e:starling.events.Event=null):void {	
		    
			var reg:RegExp = new RegExp(searchTextInput.text, "i");
			var num_visible:int = 0;
			
			scrollSprite.canvas.removeChildren();
			
			for (var i:int = 0; i < globalResources.friendsList.length;++i ) {
				
				if(( globalResources.friendsList[i].name as String).search(reg)>-1){
					scrollSprite.canvas.addChild(friendsVec[i]);
					friendsVec[i].x = ((friendsVec[i].width + 1) * (num_visible % 3)) + 20;
					friendsVec[i].y = (friendsVec[i].height + 1) * Math.floor(num_visible / 3) + 85;
					num_visible++;
					
				}
				
				
			}
			if (num_visible > 9) {
				d_scrollbar.create_scrollBar(1, 184, (int((num_visible-1) / 3) + 1) * 63);
				
			}else {
			  d_scrollbar.removeChildren();
			}
			d_scrollbar.bar.y = 0;
			scrollSprite.canvas.y = 0;
				
		}
		
		public function onWheelMove(e:flash.events.Event):void
		{
			
			trace("muevo");
		}
		
	}

}