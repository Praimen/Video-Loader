package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.text.*;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import trh.helpers.*;
	
	[SWF(backgroundColor="#666666", frameRate="60", width="940", height="670")]
	public class MediaStatePlayer extends Sprite
	{	
		private var button:ButtonState;
		private var ui:UIGraphics;
		private var _btnArray:Array;
		private var _startEndCue:Object;
		private var buttonArray:Array;
		private var _btnState:ButtonState;
		
		private var loading:IVideoState;		
		private var playing:IVideoState;		
		private var waiting:IVideoState;
		
		private var _loadVideo:LoadVideo;		
		private var _state:IVideoState;
		public var testing:Boolean = true;
		private var statusTxt:TextField; 
		
		
		
		/**
		 * Loads the initial available states and listeners 
		 * 
		 */
		public function MediaStatePlayer(){				
			loading = new LoadingState(this);
			waiting = new WaitingState(this);
			playing = new PlayState(this);
			_btnState = new ButtonState(this);
			ui = new UIGraphics();			
			_loadVideo = new LoadVideo(800,450);
			
			init();		
		}			
		
		private function init():void{			
			//add buttons to array, 
			//name should correspond to the cue point name
			//posX, posY are the positions of the buttons relative to the stage
			//image: link to image asset
			//imgW and imgH are the width and height of the image asset
			buttonArray = 	[	
								{name:"pedo1",posX:135, posY:80, image:"assets/pedo1.png",imgW:240,imgH:50},
								{name:"pedo2",posX:135, posY:140,image:"assets/pedo2.png",imgW:240,imgH:50},
								{name:"pedo3",posX:132, posY:200,image:"assets/pedo3.png",imgW:240,imgH:50},
								{name:"pedo4",posX:127, posY:260,image:"assets/pedo4.png",imgW:240,imgH:50},
								{name:"pedo5",posX:120, posY:330,image:"assets/pedo5.png",imgW:240,imgH:50},
								{name:"ortho1",posX:395, posY:80, image:"assets/ortho1.png",imgW:240,imgH:50},
								{name:"ortho2",posX:395, posY:140,image:"assets/ortho2.png",imgW:240,imgH:50},
								{name:"ortho3",posX:398, posY:200,image:"assets/ortho3.png",imgW:240,imgH:50},
								{name:"ortho4",posX:403, posY:260,image:"assets/ortho4.png",imgW:240,imgH:50},
								{name:"ortho5",posX:410, posY:330,image:"assets/ortho5.png",imgW:240,imgH:50}	
							];
			
			ui.addBtns(buttonArray);
			_btnArray = ui.uiButtonArray;
			
			//percentage number to start playing the video;
			_loadVideo.startPlayPercent = 5;
			
			//add visual elements order is important
			addChild(_loadVideo.video);		
			
			var book:Book = new Book();
			
			book.addChild(ui);			
			addChild(book);
			
			book.x = 40;
			book.y = 145;
				
			//intial state is loading state   state = LoadingState.as
			_state = loading;
			state.applyState();
			statusMsgField();
			
		}
		
		
		
		public function setInitCueStart():void{
			//the inital start will need to change based on the Shared Object state			
			var initCueSegment:Object = new Object();
			//the object contains the inital cue point segment
			var initCueName:String = video.cueArray[1].name;
			var initCuePointStart:Number = video.cueArray[1].time;
			var initCuePointEnd:Number = video.cueArray[2].time;
			initCueSegment = {name:initCueName,start:initCuePointStart,end:initCuePointEnd};
			
			cuePoint = initCueSegment;
			btnState.checkButtonLoad();
			playingState();			
			state.applyState();
			state.buttonState()
		}
		
		public function setLoading(optVideo:String):void{			
			if(optVideo == "high"){			
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_600.flv");
			}
			if(optVideo == "low"){				
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");	
			}			
		}
				
		
		public function playingState():void{				
			//state = PlayState.as
			_state = playing;			
			
		}
		
		public function waitingState():void{			
			//state = WaitingState.as
			_state = waiting;
			getCuePoint("loop");	
			
		}
		
		//this controls the playing of the segments and which segments play
		public function getCuePoint(cueName:String):void{			
			var cueArray:Array = video.cueArray;			
			var cuePointObject:Object = new Object();			
			for(var i:Number = 0; i < cueArray.length; i++){
				if(video.cueArray[i].name == cueName){					
					cuePointObject = {name:cueName, start:cueArray[i].time, end:cueArray[i+1].time};
				}else if (cueName == null){
					waitingState();
				}
			}
			//testing
			if(testing)trace("media cue array: "+ cuePointObject.name + " cuePointObject.start: " + cuePointObject.start+ " cuePointObject.end: "+ cuePointObject.end);
			cuePoint = cuePointObject;
			state.applyState();
			state.buttonState();				
		}
		
		private function statusMsgField():void	{
			var embFonts:EmbedFonts = new EmbedFonts(30);			
			statusTxt = new TextField;
			statusTxt.defaultTextFormat = embFonts.format;				
			statusTxt.autoSize = TextFieldAutoSize.CENTER;			
			statusTxt.textColor = 0xFFFFFF;
			statusTxt.text = "Loading.."; 
			statusTxt.embedFonts = true;			
			statusTxt.x = (this.width/2);
			statusTxt.y = this.height - (statusTxt.height-5);
			statusTxt.width = 50;
			statusTxt.height = 50;
			addChild(statusTxt);		
		}
		
		public function updateStatus(message:*):void{
			statusTxt.text = message; 
		}
	
		
		
///////////////////////////////setters and getters//////////////////////
		
		public function get btnState():ButtonState{
			return _btnState;
		}			
		
		public function get buttons():Array{			
			return _btnArray;
		}		
		
		public function get video():LoadVideo{
			return _loadVideo; 
		}
		
		public function get videoStream():NetStream{
			return _loadVideo.stream;
		}
		
		public function set cuePoint(value:Object):void{	
			//start and End cuePoint			
			_startEndCue = value;			
		}
		
		public function get cuePoint():Object{	
			//start and End cuePoint
			return _startEndCue	;		
		}		
		
		public function get state():IVideoState{			
			return _state;
		}			
		
	}//end Class
}//end Package