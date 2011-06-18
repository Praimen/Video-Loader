package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import trh.helpers.LoadVideo;
	
	[SWF(backgroundColor="#666666", frameRate="60", width="940", height="670")]
	public class MediaStatePlayer extends Sprite
	{	
		private var button:ButtonState
		private var ui:UIGraphics;
		private var btnArray:Array;
		private var _startEndCue:Object;
		private var buttonArray:Array = new Array();
		private var _btnState:ButtonState;
		
		private var loading:IVideoState;		
		private var playing:IVideoState;		
		private var waiting:IVideoState;
		
		private var _loadVideo:LoadVideo;	
		private var _state:IVideoState;
		
		public function MediaStatePlayer(){				
			init();
		}
		
		/**
		 * Loads the initial available states and listeners 
		 * 
		 */
		private function init():void{			
			loading = new LoadingState(this);
			waiting = new WaitingState(this);
			playing = new PlayState(this);
			_btnState = new ButtonState(this);
			ui = new UIGraphics();			
			_loadVideo = new LoadVideo(800,450);						
			initVideo();			
		}		
			
		
		private function initVideo():void{			
			//add buttons to array
			buttonArray = 	[	
								{name:"ortho1",posX:300, posY:50},
								{name:"ortho2",posX:300, posY:100},
								{name:"ortho3",posX:300, posY:150},
								{name:"pedo1",posX:300, posY:200},
								{name:"pedo2",posX:300, posY:250},								
							];	
			ui.addButtons(buttonArray);
			buttons = ui.uiButtonArray;				
			addChild(ui);			
			
			//percentage number to start playing the video;
			_loadVideo.startPlayPercent = 5;
			addChild(_loadVideo.video);	
				
			//intial state is loading state   state = LoadingState.as
			state = loading;
			state.applyState();
			
		}
		
		public function setLoading(optVideo:String):void{			
			//_loadVideo = new LoadVideo("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/videos/Cue_1.flv",800,450);
			if(optVideo == "high"){
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_600.flv");
			}
			if(optVideo == "low"){
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");	
			}			
		}
				
		
		public function setPlaying():void{
				
			//state = PlayState.as
			state = playing;			
			//state.applyState();
			//state.buttonState();
		}
		
		public function setWaiting():void{			
			//state = WaitingState.as
			state = waiting;
			getCuePoint("loop");	
			//state.applyState();	
			//state.buttonState();
		}
		
		
		public function getCuePoint(cueName:String):void{
			trace("button working");
			var cueArray:Array = video.cueArray;			
			var cuePointObject:Object = new Object();
			
			for(var i:Number = 0; i < cueArray.length; i++){
				if(video.cueArray[i].name == cueName){					
					var cuePointStart:Number = cueArray[i].time;
					var cuePointEnd:Number = cueArray[i+1].time;
					cuePointObject = {name:cueName,start:cuePointStart,end:cuePointEnd};
				}
			}
			trace("media cue array: "+ cuePointObject.name + " cuePointObject.start: " + cuePointObject.start+ " cuePointObject.end: "+ cuePointObject.end)
			cuePoint = cuePointObject;
			state.applyState();
			state.buttonState();
				
		}
		
	
		
		
///////////////////////////////setters and getters//////////////////////
		
		public function get btnState():ButtonState{
			return _btnState;
		}
		public function set buttons(value:Array):void{			
			btnArray = value; 
		}		
		
		public function get buttons():Array{			
			return btnArray;
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
		
		public function set state(value:IVideoState):void{			
			_state = value;
		}
		
		public function get state():IVideoState{			
			return _state;
		}			
		
	}//end Class
}//end Package