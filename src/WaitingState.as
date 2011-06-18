package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class WaitingState implements IVideoState
	{
		
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(500);
		public function WaitingState(msObject:MediaStatePlayer)
		{
			
			_media = msObject;
			
						
		}
		
		public function applyState():void{
			
			_media.videoStream.pause();
			
			_media.videoStream.seek(_media.cuePoint.start);	
			
			_media.videoStream.resume();
			startWaitingTimer();
			
			
		}		
		
		public function buttonState():void{			
			for (var i:Number = 0; i< _media.buttons.length; i++){
				var button:Sprite = _media.buttons[i];			
				if(button.buttonMode){
					trace("waiting button name: "+button.name);
					button.alpha = 1;
					button.addEventListener(MouseEvent.CLICK, runCuePoint);
				}
			}
		}
		
		private function runCuePoint(evt:Event):void{
			_media.setPlaying();
			_media.getCuePoint(evt.target.name);
			
		}
		
		
		private function startWaitingTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,waitingLoop);
			intervalTimer.start();
			
		}		
		
		private function waitingLoop(tEvent:TimerEvent):void{		
			if(_media.videoStream.time > _media.cuePoint.end){
				trace("Exiting Waiting State");
				intervalTimer.removeEventListener(TimerEvent.TIMER,waitingLoop);
				intervalTimer.stop();
				_media.getCuePoint("loop");
			}			
		}
		
	}//end Class
}//end Package