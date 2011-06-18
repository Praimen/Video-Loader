package
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
		
	public class ButtonState extends Sprite
	{
		
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(2000);;
		public function ButtonState(msObject:MediaStatePlayer)
		{
			_media = msObject;	
			 
			
		}
		
		private function checkButtonActivation(tEvent:TimerEvent):void{
			for (var i:Number = 0; i< _media.buttons.length; i++){
				trace("check Button Activation");
				var button:Sprite = _media.buttons[i];
				var buttonTime:Number = _media.video.cueArray[i].time;
				
				if(_media.video.currentPercentLoaded == 100){
					intervalTimer.stop();	
					intervalTimer.removeEventListener(TimerEvent.TIMER,checkButtonLoad);
				}else{
					 
						if (buttonTime < _media.video.timeLoaded){
							trace("activated button name: "+button.name);
							button.alpha = .25;	
							button.buttonMode = true;
						}else{
							button.alpha = .10;
							button.buttonMode = false;
						}
				}
			}
			
		}		
		
		public function checkButtonLoad():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,checkButtonActivation);
			intervalTimer.start();			
		}	
		
		
		
		
		
	}//end Class
}//end Package