package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(backgroundColor="#666666", frameRate="100", width="800", height="450")]
	public class MediaStatePlayer extends Sprite
	{			
		private var button:ButtonState
		private var waiting:WaitingState;
		private var loadingVideo:LoadingState;
		private var playing:PlayState;		
		private var videoState:VideoState;
		
		
		
		public function MediaStatePlayer(){				
			init();			
		}
		
		/**
		 * Loads the initial available states and listeners 
		 * 
		 */
		private function init():void{			
			
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_LOADED, setStateLoaded);
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_PLAYING, setStatePlaying);
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_WAITING, setStateWaiting);				
			loadVideo();
		}
		
		private function loadVideo():void{			
			videoState = new LoadingState;
			var buttonArray:Array = new Array()
				buttonArray = ["ortho","pedo","pedo2"];				
				videoState.addButtons(buttonArray);
				
			this.addChild(videoState)
		}
		
		private function setStateLoaded(event:GlobalEvent):void{			
			
		}
		
		private function setStatePlaying(event:GlobalEvent):void{			
			videoState = new PlayState;	
			
		}
		
		private function setStateWaiting(event:GlobalEvent):void{
			videoState = new WaitingState;
			
		}	
		
		
	}//end Class
}//end Package