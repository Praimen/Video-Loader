package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(backgroundColor="#666666", frameRate="100", width="800", height="450")]
	public class MediaStatePlayer extends Sprite
	{	
		private var button:ButtonState
		private var ui:UIGraphics;
		private var uiButtonArray:Array;
		private var _startEndCue:Object;
		
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
			ui = new UIGraphics();			
			_loadVideo = new LoadVideo(800,450);						
			initVideo();			
		}		
			
		
		private function initVideo():void{	
			
			var buttonArray:Array = new Array()
			buttonArray = ["select","loop","ortho","pedo1","pedo2"];
			
			uiButtonArray = ui.addButtons(buttonArray);				
			addChild(ui);			
			//percentage number to start playing the video;
			_loadVideo.startPlayPercent = 5;
			addChild(_loadVideo.video);	
				
			//state = LoadingState.as
			state = loading;
			state.applyState();			
			
		}
		
		public function setLoading(optVideo:String):void{
			
			//_loadVideo = new LoadVideo("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/videos/Cue_1.flv",800,450);
			if(optVideo == "high"){
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");
			}
			if(optVideo == "low"){
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");	
			}
			
			
		}
				
		
		public function setPlaying():void{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);		
			//state = PlayState.as
			state = playing;			
			state.applyState();	
			
		}
		
		public function setWaiting():void{			
			//state = WaitingState.as
			state = waiting;
			state.applyState();				
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
			//trace("media cue array "+_media.video.cueArray[1].name+ " evt.currentTarget.name "+ evt.target.name)
			cuePoint = cuePointObject;
			state.applyState();		
		}
		
		private function onEnterFrame(e:Event):void{
		
			if(videoStream.time > cuePoint.end){
				addEventListener(Event.ENTER_FRAME, onEnterFrame);	
				trace("Video Time "+ videoStream.time);					
				state = waiting;
				getCuePoint("loop")
					
			}			
		}
		
		
///////////////////////////////setters and getters//////////////////////
		
		public function get buttons():Array{			
			return uiButtonArray;
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