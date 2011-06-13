package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(backgroundColor="#666666", frameRate="100", width="800", height="450")]
	public class MediaStatePlayer extends Sprite
	{	
		
		private var button:ButtonState
		private var createUI:UIGraphics;		
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
			
			createUI = new UIGraphics();
			
			//GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_PLAYING, setStatePlaying);
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_WAITING, setWaiting);
			
			initVideo();
			
		}		
			
		
		private function initVideo():void{
			
			state = loading;			
			
			var buttonArray:Array = new Array()
				buttonArray = ["ortho","pedo","pedo2"];				
				createUI.addButtons(buttonArray);				
				
				_loadVideo = new LoadVideo("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/videos/Cue_1.flv",800,400);
				_loadVideo.videoPlayPercent = 15;
				addChild(_loadVideo.video);				
			state.applyState();
		}
				
		
		public function setPlaying():void{			
			state = playing;	
			state.applyState();
		}
		
		private function setWaiting(event:GlobalEvent):void{
			state = waiting;
			state.applyState();
		}
		
		
///////////////////////////////setters and getters//////////////////////
		
		public function get video():LoadVideo{
			return _loadVideo; 
		}
		
		public function get videoStream():NetStream{
			return _loadVideo.stream;
		}
		
		
		public function set state(value:IVideoState):void{
			
			_state = value;
		}
		
		public function get state():IVideoState{
			
			return _state;
		}	
		
		
		
	}//end Class
}//end Package