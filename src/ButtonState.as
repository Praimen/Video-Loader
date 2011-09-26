 package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	
	public class ButtonState extends Sprite	{
		
		private var _media:MediaStatePlayer;
		private var intervalTimer:Timer
		private var checkButtonArray:Array;
		private var _activated:Array;
		private var btnActiveAlpha:Number = .5;
		private var btnNotActiveAlpha:Number = .1;
		
		
		
		/**
		 *  This is the ButtonState Constructor
		 * 
		 * 	@param msObject the reference to the main MediaStatePlayer Object
		 */	
		
		public function ButtonState(msObject:MediaStatePlayer){
			_media = msObject;		
			intervalTimer = new Timer(200);
			//checkButtonArray = [];
			intervalTimer.addEventListener(TimerEvent.TIMER,checkButtonActivation);
		}
		
		
		/**
		 *  checks each button to determine if it has been activated or not based on the loading time
		 *  of the <code>MediaStatePlayer.video.timeLoaded</code>. 
		 * 
		 * <p>The function will loop through all the MediaStatePlayer.buttons and will change the buttons
		 * initial parameters to a set of "active" parameters if the button time is less than the current timeLoaded
		 * and the button name matches the current iterative loop qualifier</p>
		 * <p> Once a button is qualifies as active it is removed from the intial array and pushed to a 
		 * new array that will be used by the states<p> 
		 * 
		 * 	@param msObject the reference to the main MediaStatePlayer Object
		 */
		
		
			
		private function checkButtonActivation(tEvent:TimerEvent):void{	
			
			var mediaLen:int = _media.video.cueArray.length;
			
			for (var i:int = 0; i < checkButtonArray.length; i++){			
				var button:Sprite = checkButtonArray[i];
				
					for (var j:int = 0; j< mediaLen; j++){	
						var mediaArray:Object = _media.video.cueArray[j];	
						var buttonName:String = String(mediaArray.name);
						var buttonTime:Number = Number(mediaArray.time);	
							if(buttonName == button.name){
							
								if ((buttonTime < int(_media.video.timeLoaded)) && (button.name == buttonName)){
									button.alpha = btnActiveAlpha;	
									button.buttonMode = true;
									
									if(_media.testing)trace("Button name: "+ button.name+" | | "+"Button Time: "+buttonTime+" | | "+"Video Time: "+_media.video.timeLoaded);
									_activated.push(button);
									checkButtonArray.splice(i, 1);
									
									
								}else{
									button.alpha = btnNotActiveAlpha;
									button.buttonMode = false;
									button.useHandCursor = false;
									
								}
								
							}
							
					}//j for end
						
			}//i for end
			
			
			
			if(!checkButtonArray.length){
				intervalTimer.stop();
				trace("checkbutton array: "+ checkButtonArray.length);
				trace("activeBtnArray array: "+ this.activeBtnArray.length);
				trace("media Cue array: "+ _media.video.cueArray.length);
				
				intervalTimer.removeEventListener(TimerEvent.TIMER,checkButtonActivation);
				intervalTimer = null;
				//checkButtonArray = null;		
			}
			
		}		
		
		/**
		 *  initiated from the <code>MediaStatePlayer.setInitCueStart()</code> 
		 * 
		 * <p>loads the buttons array from the MediaStatePlayer and start the 
		 * timer for the <code>checkButtonActivation</code></p>	
		 * 	
		 */	
		public function checkButtonLoad():void{
			
			checkButtonArray = _media.buttons;
			trace("checkButtonArray: "+ _media.buttons);
			_activated = [];			
			intervalTimer.start();			
		}
		
		
		
		/**
		 *  @return an array of all the activated buttons 
		 * 	
		 */	
		public function get activeBtnArray():Array{
			return _activated;			
		}
		
		
		
		
		
	}//end Class
}//end Package