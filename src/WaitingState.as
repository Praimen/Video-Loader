package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;	
	
	public class WaitingState implements IVideoState{	
		
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(500);
		
		public function WaitingState(msObject:MediaStatePlayer)		{
			
			_media = msObject;						
		}
		
		public function applyState():void{			
			_media.videoStream.pause();			
			_media.videoStream.seek(_media.cuePoint.start);				
			_media.videoStream.resume();
			startWaitingTimer();			
		}		
		
		public function buttonState():void{			
			for each (var button:Sprite in  _media.btnState.activeBtnArray){				
				button.alpha = 1;
				button.useHandCursor = true;
				button.addEventListener(MouseEvent.CLICK, runCuePoint);
			}
		}
		
		private function runCuePoint(evt:Event):void{
			//sets the playing state with the but name as the cue point name		
			_media.playingState();			
			_media.getCuePoint(evt.currentTarget.name);			
		}		
		
		private function startWaitingTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,waitingLoop);
			intervalTimer.start();			
		}		
		
		private function waitingLoop(tEvent:TimerEvent):void{
			//when the video reaches the end cue point get the loop cue point
			if(_media.videoStream.time > _media.cuePoint.end){				
				intervalTimer.removeEventListener(TimerEvent.TIMER,waitingLoop);
				intervalTimer.stop();
				_media.getCuePoint("loop");
			}			
		}
		
	}//end Class
}//end Package