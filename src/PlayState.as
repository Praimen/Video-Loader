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
		//private var testTimer:Timer = new Timer(5000,1)
		
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
			buttonState()
			
		}		
		
		
		public function buttonState():void{			
			for each (var button:Sprite in _media.buttons){				
				button.mouseEnabled = false;
				button.buttonMode = false;
				button.alpha = .5;
				
			}
		}
		
				
		
		
	}//end Class
}//end Package