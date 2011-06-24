package
{
	import flash.display.*;	
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;	
	
	public class PlayState implements IVideoState
	{
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(500);
		private var btnActiveAlpha:Number = 1;
		private var btnNotActiveAlpha:Number = .5;
		
		public function PlayState(msObject:MediaStatePlayer){	
			_media = msObject;			
				
		}
		
		public function applyState():void{			
			_media.videoStream.pause();
			
				if(_media.btnState.activeBtnArray.length > 0){//if there is an active button use the Cue point
					_media.videoStream.seek(_media.cuePoint.start);					
				}else{
					_media.videoStream.seek(0);				
				}			
			_media.videoStream.resume();
			
			startPlayingTimer();
		}		
		
		
		public function buttonState():void{			
			for each (var button:Sprite in  _media.btnState.activeBtnArray){					
				if(button.name == _media.cuePoint.name){
					button.alpha = btnActiveAlpha;					
				}else{
					button.alpha = btnNotActiveAlpha;					
					
				}			
			}			
		}
		
		private function buttonStateUpdate(tEvent:TimerEvent):void{
			for each (var button:Sprite in  _media.btnState.activeBtnArray){
				//buggy event being added fix later	
				//may involve a loader listener	
				
				button.addEventListener(MouseEvent.CLICK, runCuePoint);
			}
		}
		
		private function buttonOn(evt:MouseEvent):void{			
			evt.currentTarget.alpha = btnActiveAlpha;			
		}
		
		private function buttonOff(evt:MouseEvent):void{			
			evt.currentTarget.alpha = btnNotActiveAlpha;			
		}	
		
		public function runCuePoint(evt:Event):void{
			//sets the playing state with the but name as the cue point name					
			_media.getCuePoint(evt.currentTarget.name);			
		}		
		
		
		private function startPlayingTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,startPlaying);
			intervalTimer.addEventListener(TimerEvent.TIMER,buttonStateUpdate);
			intervalTimer.start();
			
		}		
		
		private function startPlaying(tEvent:TimerEvent):void{
			//trace("video stream Time: "+_media.videoStream.time+" |  playing cuePoints: "+_media.cuePoint.end);
			if(_media.videoStream.time > _media.cuePoint.end){							
				intervalTimer.stop();
				intervalTimer.removeEventListener(TimerEvent.TIMER,startPlaying);
				intervalTimer.removeEventListener(TimerEvent.TIMER,buttonStateUpdate);
			 	_media.waitingState()	;				
			}			
		}		
		
	}//end Class
}//end Package