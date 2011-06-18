package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	
	public class PlayState implements IVideoState
	{
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(500);
		
		public function PlayState(msObject:MediaStatePlayer)
		{	
			_media = msObject;
			
			//trace(super.videoStream);	
			
		}
		
		public function applyState():void{			
			_media.videoStream.pause();
			
			if(_media.videoStream.time > 19.00 ){
				_media.videoStream.seek(_media.cuePoint.start);				
			}else{
				_media.videoStream.seek(0);				
			}
			
			_media.videoStream.resume();
			
			startPlayingTimer();
		}		
		
		
		public function buttonState():void{			
			for each (var button:Sprite in _media.buttons){					
				if(button.name == _media.cuePoint.name){
					button.alpha = 1;					
				}				
			}
		}
		
		
		private function startPlayingTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,startPlaying);
			intervalTimer.start();
			
		}		
		
		private function startPlaying(tEvent:TimerEvent):void{
			trace("video stream Time: "+_media.videoStream.time+" |  playing cuePoints: "+_media.cuePoint.end);
			if(_media.videoStream.time > _media.cuePoint.end){
				trace("Exiting Playing State");
				
				intervalTimer.stop();
				intervalTimer.removeEventListener(TimerEvent.TIMER,startPlaying);				
			 	_media.setWaiting()		
				_media.getCuePoint("loop");	
			}			
		}
		
				
		
		
	}//end Class
}//end Package