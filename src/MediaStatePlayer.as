package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.text.*;
	import flash.utils.*;
	
	import trh.helpers.*;
	
	//your Flash program may not support this tag
	[SWF(backgroundColor="#666666", frameRate="60", width="940", height="670")]
	public class MediaStatePlayer extends Sprite
	{	
		private var book:Book;
		private var button:ButtonState;		
		private var _btnArray:Array;		
		private var buttonArray:Array;
		private var _btnState:ButtonState;
		private var flashCookie:FlashCookie = new FlashCookie(15);//expiration in minutes MAX 59
		
		private var loading:IVideoState;
		private var _loadVideo:LoadVideo;
		public var path:String = "http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/";
		private var playing:IVideoState;
			
		private var _state:IVideoState;
		private var _startEndCue:Object;
		
		public var testing:Boolean = false;
		private var ui:UIGraphics;
		private var waiting:IVideoState;
		
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
			_loadVideo = new LoadVideo(940,550);			
			init();			
		}			
		
		private function init():void{
			//add buttons to array, 
			//name should correspond to the cue point name
			//posX, posY are the positions of the buttons relative to the stage
			//image: link to image asset
			//imgW and imgH are the width and height of the image asset
			
			buttonArray = 	[	
								{name:"pedo1",posX:135, posY:90, image:path+"assets/pedo1.png",imgW:240,imgH:50},
								{name:"pedo2",posX:135, posY:140,image:path+"assets/pedo2.png",imgW:240,imgH:50},
								{name:"pedo3",posX:132, posY:200,image:path+"assets/pedo3.png",imgW:240,imgH:50},
								{name:"pedo4",posX:127, posY:260,image:path+"assets/pedo4.png",imgW:240,imgH:50},
								{name:"pedo5",posX:120, posY:330,image:path+"assets/pedo5.png",imgW:240,imgH:50},
								{name:"ortho1",posX:395, posY:90, image:path+"assets/ortho1.png",imgW:240,imgH:50},
								{name:"ortho2",posX:395, posY:140,image:path+"assets/ortho2.png",imgW:240,imgH:50},
								{name:"ortho3",posX:403, posY:200,image:path+"assets/ortho3.png",imgW:240,imgH:50},
								{name:"ortho4",posX:408, posY:260,image:path+"assets/ortho4.png",imgW:240,imgH:50},
								{name:"ortho5",posX:415, posY:330,image:path+"assets/ortho5.png",imgW:240,imgH:50}	
							];
			
			ui.addBtns(buttonArray);
			_btnArray = ui.uiButtonArray;
			
			//percentage number to start playing the video;
			_loadVideo.startPlayPercent = 8;
			
			//add visual elements order is important
			addChild(_loadVideo.video);		
			_loadVideo.video.y = 21;
			
			
			book = new Book();
			book.addChild(ui);			
			addChild(book);
			
			book.x = stage.width/2 - book.width/2;
			book.y = stage.height - (book.height - 104);
				
			//intial state is loading state   state = LoadingState.as
			_state = loading;
			state.applyState();
		}
		
		public function setLoading(optVideo:String):void{			
			if(optVideo == "high"){			
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");
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
		
		public function setInitCueStart():void{
			//the Shared Object will detect if the video has already played once before(roughly)	
			if (flashCookie.isExpired()){					
				playingState();	
			}else{
				waitingState();			
			}
			
			//the object contains the inital cue point segment			
			var initCueName:String = video.cueArray[1].name;
			var initCuePointStart:Number = video.cueArray[1].time;
			var initCuePointEnd:Number = video.cueArray[2].time;				
			
			var initCueSegment:Object = {name:initCueName,start:initCuePointStart,end:initCuePointEnd};
			cuePoint = initCueSegment;
			btnState.checkButtonLoad();
			
				
			state.applyState();
			state.buttonState();
			addEventListener(Event.ENTER_FRAME, updateStatus);
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
		
		public function updateStatus(evt:Event):void{
			book.statusTxt.text = String(video.currentPercentLoaded+"%");
			if(video.currentPercentLoaded == 100){				
				removeEventListener(Event.ENTER_FRAME, updateStatus);
				book.statusTxt.text = "";
			}			
			
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