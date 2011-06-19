package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
		
	public class ButtonState extends Sprite
	{
		
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer = new Timer(2000);
		private var checkButtonArray:Array = new Array();
		private var _activated:Array;
		
		public function ButtonState(msObject:MediaStatePlayer)
		{
			_media = msObject;		
			_activated = new Array();
			
		}
		
		private function checkButtonActivation(tEvent:TimerEvent):void{
			for (var i:Number = 0; i< checkButtonArray.length; i++){			
				var button:Sprite = checkButtonArray[i];
				var buttonTime:Number = _media.video.cueArray[i].time;
				
					if (buttonTime < _media.video.timeLoaded){
						button.alpha = .25;	
						button.buttonMode = true;
						_activated.push(button);
						checkButtonArray.splice(i, 1)					
					}else{
						button.alpha = .10;
						button.buttonMode = false;
						button.useHandCursor = false;
					}				
			}
			if(checkButtonArray.length == 0){
				intervalTimer.stop();
				intervalTimer.removeEventListener(TimerEvent.TIMER,checkButtonActivation);
				checkButtonArray = null;		
			}
		}		
		
		public function checkButtonLoad():void{	
			checkButtonArray = _media.buttons;
			intervalTimer.addEventListener(TimerEvent.TIMER,checkButtonActivation);
			intervalTimer.start();			
		}	
		
		
		public function get activeBtnArray():Array{
			return _activated;			
		}
		
		
		
		
		
	}//end Class
}//end Package