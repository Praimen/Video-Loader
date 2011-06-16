package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class WaitingState implements IVideoState
	{
		
		private var _media:MediaStatePlayer;
		
		public function WaitingState(msObject:MediaStatePlayer)
		{
			
			_media = msObject;
			
			//trace(super.videoStream);			
		}
		
		public function applyState():void{	
			_media.videoStream.pause();
			_media.videoStream.seek(_media.cuePoint.start);	
			_media.videoStream.resume();
			buttonState();
			
		}
		
		
		public function buttonState():void{			
			for each (var button:Sprite in _media.buttons){
				button.mouseEnabled = true;	
				button.buttonMode = true;
				button.alpha = 1;
				button.addEventListener(MouseEvent.CLICK, runCuePoint);
			}
		}
		
		private function runCuePoint(evt:Event):void{
			_media.getCuePoint(evt.target.name);
			_media.setPlaying();
		}
		
		
		
	}//end Class
}//end Package