package com.tucomoyo.aftermath.Clases 
{
	import com.tucomoyo.aftermath.Connections.Connection;
	import com.tucomoyo.aftermath.Engine.AssetManager;
	import com.tucomoyo.aftermath.Engine.ImageLoader;
	import com.tucomoyo.aftermath.GlobalResources;
	import com.tucomoyo.aftermath.Screens.TrophyRoomScreen;
	import flash.utils.Dictionary;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
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
	public class ObjectVote extends Sprite 
	{
		private var globalResources:GlobalResources;
		private var textureScene:AssetManager;
		public static const ButtonsAssets:String = "Botones";
		private var objectData:Object;
		private var tempData:Array = new Array();
		private var connect:Connection;
		private var voteDescription:TextField;
		private var objectVote:String;
		private var objectButtonsDict:Dictionary;
		
		private var acceptBtn:Button;
		private var closeBtn:Button;
		
		private var voteType:int;
		private var genere:int;
		
		private var comlink:Image;
		
		private var hate1:VoteButtons;
		private var hate2:VoteButtons;
		private var hate3:VoteButtons;
		private var dontCare:VoteButtons;
		private var love1:VoteButtons;
		private var love2:VoteButtons;
		private var love3:VoteButtons;
		
		private var bigFondo:Quad;
		private var dialogFondo:Quad;
		private var a_text:TextField;
		
		public function ObjectVote(_globalResources:GlobalResources, _textureScene:AssetManager, _objectData:Object, _vote:String, _genere:int) 
		{
			super();
			globalResources = _globalResources;
			textureScene = _textureScene;
			objectData = _objectData;
			objectVote = _vote;
			genere = _genere;
			objectButtonsDict = new Dictionary();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
			
			connect = new Connection();
		}
		
		public function onAddedtoStage():void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);
			
			var fondo:Image = new Image(textureScene.getAtlas("screens").getTexture("trophyRoom"));
			tempData.push(fondo);
			addChild(fondo);
			
			var objectName:TextField = new TextField(300,100,objectData.name,globalResources.fontName,18,0xffffff);
			objectName.x=400;
			objectName.y = 20;
			objectName.vAlign = "top";
			objectName.hAlign = "center";
			objectName.touchable = false;
			tempData.push(objectName);
			addChild(objectName);
			
			var objectInfo:TextField = new TextField(300, 300, objectData.sources[0].summary, globalResources.fontName, 14, 0xffffff);
			objectInfo.vAlign = "top";
			objectInfo.hAlign = "left";
			objectInfo.x = 400;
			objectInfo.y = 50;
			objectInfo.touchable = false;
			tempData.push(objectInfo);
			addChild(objectInfo);
			
			var objetoImagen:ImageLoader = new ImageLoader(objectData.media[0].src, globalResources.loaderContext, 200, 200);
			objetoImagen.x = 100;
			objetoImagen.y = 55;
			objetoImagen.touchable = false;
			tempData.push(objetoImagen);
			addChild(objetoImagen);
			
			var close:Button = new Button(textureScene.getAtlas(ButtonsAssets).getTexture("btnBack"));
			close.x = 750 - close.width;
			close.y = 340;
			close.addEventListener(Event.TRIGGERED, closeDialog);
			tempData.push(close);
			addChild(close);
			
			var buttonText:TextField = new TextField(300, 100, globalResources.textos[globalResources.idioma].Screens.TrophyRoom.DescriptionButtons, globalResources.fontName, 20, 0x000000);
			buttonText.vAlign = "top";
			buttonText.hAlign = "center";
			buttonText.x=50;
			buttonText.y=270;
			tempData.push(buttonText);
			addChild(buttonText);
			
			drawVoteButtons(objectVote);
		}
		
		public function fillDictionary():void {
			
			objectButtonsDict["-3"] = hate1;
			objectButtonsDict["-2"] = hate2;
			objectButtonsDict["-1"] = hate3;
			objectButtonsDict["0"] = dontCare;
			objectButtonsDict["1"] = love1;
			objectButtonsDict["2"] = love2;
			objectButtonsDict["3"] = love3;
		}
		
		public function drawVoteButtons(currentVote:String):void {
			
			hate3 = new VoteButtons( -3, textureScene.getAtlas(ButtonsAssets).getTexture("btn_hate3_00"), textureScene.getAtlas(ButtonsAssets).getTexture("btn_hate3_01"));
			hate3.x = 20;
			hate3.y = 300;
			hate3.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(hate3);
			
			hate2 = new VoteButtons(-2, textureScene.getAtlas(ButtonsAssets).getTexture("btn_hate2_00"),textureScene.getAtlas(ButtonsAssets).getTexture("btn_hate2_01"));
			hate2.x = 70;
			hate2.y = 300;
			hate2.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(hate2);
			
			hate1 = new VoteButtons( -1, textureScene.getAtlas(ButtonsAssets).getTexture("btn_hate1_00"), textureScene.getAtlas(ButtonsAssets).getTexture("btn_hate1_01"));
			hate1.x = 120;
			hate1.y = 300;
			hate1.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(hate1);
				
			dontCare = new VoteButtons(0, textureScene.getAtlas(ButtonsAssets).getTexture("btn_dontcare_00"),textureScene.getAtlas(ButtonsAssets).getTexture("btn_dontcare_01"));
			dontCare.x = 170;
			dontCare.y = 300;
			dontCare.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(dontCare);
				
			love1 = new VoteButtons(1, textureScene.getAtlas(ButtonsAssets).getTexture("btn_love1_00"),textureScene.getAtlas(ButtonsAssets).getTexture("btn_love1_01"));
			love1.x = 220;
			love1.y = 300;
			love1.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(love1);
				
			love2 = new VoteButtons(2, textureScene.getAtlas(ButtonsAssets).getTexture("btn_love2_00"),textureScene.getAtlas(ButtonsAssets).getTexture("btn_love2_01"));
			love2.x = 270;
			love2.y = 300;
			love2.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(love2);
				
			love3 = new VoteButtons(3, textureScene.getAtlas(ButtonsAssets).getTexture("btn_love3_00"), textureScene.getAtlas(ButtonsAssets).getTexture("btn_love3_01"));
			love3.x = 320;
			love3.y = 300;
			love3.addEventListener(Event.TRIGGERED, validationDialog);
			tempData.push(love3);
			
			fillDictionary();
			
			if (currentVote == "unknown") 
			{
				addChild(hate1);
				addChild(hate2);
				addChild(hate3);
				addChild(dontCare);
				addChild(love1);
				addChild(love2);
				addChild(love3);
			} else {
				//trace(objectData.name + " vote: " + currentVote);
				(objectButtonsDict[currentVote] as Button).x = 150;
				(objectButtonsDict[currentVote] as Button).y = 300;
				addChild(objectButtonsDict[currentVote]);
				(objectButtonsDict[currentVote] as Button).touchable = false;
			}
			
			bigFondo = new Quad(760, 400, 0x000000);
			bigFondo.visible = false;
			bigFondo.alpha = 0.50;
			tempData.push(bigFondo);
			addChild(bigFondo);
			
			dialogFondo = new Quad(350, 100, 0x000000);
			dialogFondo.x = 180;
			dialogFondo.y = 150;
			dialogFondo.visible = false;
			dialogFondo.alpha = 0.75;
			dialogFondo.height 150;
			tempData.push(dialogFondo);
			addChild(dialogFondo);
			
			comlink = new Image (textureScene.getAtlas(ButtonsAssets).getTexture("comlink"));
			comlink.x = 180;
			comlink.y = 155;
			comlink.visible = false;
			tempData.push(comlink);
			addChild(comlink);
			
			a_text = new TextField(200, 70, "", globalResources.fontName, 14, 0xFFFFFF);
			a_text.x = 260;
			a_text.y = 160;
			a_text.width = 250;
			a_text.height = 80;
			a_text.hAlign = "center";
			a_text.vAlign = "top";
			a_text.text = globalResources.textos[globalResources.idioma].Screens.TrophyRoom.ObjectsNoVoted.confirm;
			a_text.visible = false;
			tempData.push(a_text);
			addChild(a_text);
			
			acceptBtn = new Button (textureScene.getAtlas("Botones").getTexture("btnAccept"));
			acceptBtn.addEventListener(Event.TRIGGERED, onAcceptClick);
			acceptBtn.visible = false;
			acceptBtn.x = 420;
			acceptBtn.y = 190;
			tempData.push(acceptBtn);
			addChild(acceptBtn);
			
			closeBtn = new Button (textureScene.getAtlas("Botones").getTexture("btnBack"));
			closeBtn.addEventListener(Event.TRIGGERED, closeWindow);
			closeBtn.x = 280;
			closeBtn.y = 190;
			closeBtn.visible = false;
			tempData.push(closeBtn);
			addChild(closeBtn);
			
		}
		
		public function validationDialog(e:Event):void {
			voteType = (e.currentTarget as VoteButtons).type;
			//trace(voteType);
			bigFondo.visible = true;
			dialogFondo.visible = true;
			a_text.visible = true;
			acceptBtn.visible = true;
			closeBtn.visible = true;
			comlink.visible = true;
		}
		
		public function closeWindow(e:Event = null):void {
			
			bigFondo.visible = false;
			dialogFondo.visible = false;
			a_text.visible = false;
			acceptBtn.visible = false;
			closeBtn.visible = false;
			comlink.visible = false;
		}
		
		public function onAcceptClick(e:Event):void {

			globalResources.trackEvent("Vote Object", "user: " + globalResources.user_id, "Object ID: " + objectData.object_id);
			
				switch (voteType) 
				{ 
					case -3:
						trace("click en -3");
						objectVote = "-3";
						removeVoteButtons();
						hate3.x = 150;
						hate3.y = 300;
						addChild(hate3);
						hate3.touchable = false;
						
						trophyToJunk("-3");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_-3_ON_TROPHY_ROOM",objectData.object_id);
					break;
					case -2:
						trace("click en -2");
						objectVote = "-2";
						removeVoteButtons();
						hate2.x = 150;
						hate2.y = 300;
						addChild(hate2);
						hate2.touchable = false;
						
						//closeDialog();
						trophyToJunk("-2");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_-2_ON_TROPHY_ROOM",objectData.object_id);
					break;
					case -1:
						trace("click en -1");
						objectVote = "-1";
						removeVoteButtons();
						hate1.x = 150;
						hate1.y = 300;
						addChild(hate1);
						hate1.touchable = false;
						
						//closeDialog();
						trophyToJunk("-1");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_-1_ON_TROPHY_ROOM",objectData.object_id);
					break;
					case 0:
						trace("click en 0");
						objectVote = "0";
						removeVoteButtons();
						dontCare.x = 150;
						dontCare.y = 300;
						addChild(dontCare);
						dontCare.touchable = false;
						
						changeObjectVote("0");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_0_ON_TROPHY_ROOM",objectData.object_id);
					break;
					case 1:
						trace("click en 1");
						objectVote = "1";
						removeVoteButtons();
						love1.x = 150;
						love1.y = 300;	
						addChild(love1);
						love1.touchable = false;
						
						changeObjectVote("1");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_1_ON_TROPHY_ROOM",objectData.object_id);
					break;
					case 2:
						trace("click en 2");
						objectVote = "2";
						removeVoteButtons();
						love2.x = 150;
						love2.y = 300;
						addChild(love2);
						love2.touchable = false;
						
						changeObjectVote("2");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_2_ON_TROPHY_ROOM",objectData.object_id);
					break;
					case 3:
						trace("click en 3");
						objectVote = "3";
						removeVoteButtons();
						love3.x = 150;
						love3.y = 300;
						addChild(love3);
						love3.touchable = false;
						
						changeObjectVote("3");
						//connect.sendVote(parseInt(globalResources.user_id),"VOTE_3_ON_TROPHY_ROOM",objectData.object_id);
					break;
				}
			bigFondo.visible = false;
			dialogFondo.visible = false;
			a_text.visible = false;
			acceptBtn.visible = false;
			closeBtn.visible = false;
			comlink.visible = false;
			
		}
		
		public function trophyToJunk(_vote:String):void {
			if (genere != 0) 
			{
				(this.parent.parent as TrophyRoomScreen).convertTrophyToJunk(objectData.object_id, objectVote);
				(this.parent.parent as TrophyRoomScreen).changeObjectVoteAndType(globalResources.user_id, objectData.trophy_vote_id, _vote, "junk");
			}else {
				(this.parent.parent as TrophyRoomScreen).changeObjectVote(globalResources.user_id, objectData.trophy_vote_id,parseInt(_vote));
			}
		}
		
		public function changeObjectVote(_vote:String):void 
		{
			(this.parent.parent as TrophyRoomScreen).changeObjectVote(globalResources.user_id, objectData.trophy_vote_id,parseInt(_vote));
		}
		
		public function removeVoteButtons():void {
			removeChild(hate1);
			removeChild(hate2);
			removeChild(hate3);
			removeChild(dontCare);
			removeChild(love1);
			removeChild(love2);
			removeChild(love3);
		}
		
		public function closeDialog(e:Event = null):void {
			
			this.visible = false;
		}
		
		override public function dispose():void 
		{
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