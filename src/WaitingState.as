package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	public class WaitingState implements IVideoState{	
		
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(3500);
		private var btnActiveAlpha:Number = 1;
		private var btnNotActiveAlpha:Number = .5;
		//private var videoSound:Sound = new Sound();
		
		public function WaitingState(msObject:MediaStatePlayer){			
			_media = msObject;						
		}
		
		public function applyState():void{
			trace("apply waiting state");
			_media.videoStream.pause();
			_media.videoHolder.visible = false;
			_media.loopHolder.visible = true;
			/*_media.videoStream.pause();	
			
			_media.videoStream.seek(_media.cuePoint.start);
			
			_media.videoStream.resume();
			startWaitingTimer();*/			
		}		
		
		public function buttonState():void{
			
			for each (var button:Sprite in  _media.btnState.activeBtnArray){
				//_media.book.statusTxt.text = String("w"+ button);
				button.alpha = btnActiveAlpha;
				button.useHandCursor = true;				
				
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
				
				//_media.getCuePoint("loop");
			}			
		}
		
	}//end Class
}//end Package