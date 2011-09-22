package trh.helpers{
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Timer;
	
	public class FlashCookie {
		
		public var expirationTime:Number;// minutes
		private var so:SharedObject;		
		private var lastMinute:Number;
		private var testing:Boolean = true;
		private var intervalTimer:Timer = new Timer(6000);
		
		
		public function FlashCookie(expire:Number=20) {			
						
			so = SharedObject.getLocal("flashCookie12345"); 
			expirationTime = expire;
			intervalTimer.addEventListener(TimerEvent.TIMER,doesCookieExist);
			intervalTimer.start();			
		}
		
		private function doesCookieExist(tEvt:TimerEvent):void {			
			if (so.data.lastMinute){
				if(testing)trace("Getting Exisiting Value: "+so.data.lastMinute);				
				lastMinute++;
			}else{				
				saveValue();
			}
		}
		
		public function isExpired():Boolean{
			
			/*timeLapseDay == 0 && timeLapseHour == 0 && */
			if (lastMinute > expirationTime) {
				if(testing)trace("Now Day: true");	
				saveValue();
				return true;
			}else{
				if(testing)trace("Now Day: false");				
				return false;				
			}
		}
		
		private function saveValue():void {
			try {	
				lastMinute = 0;	
				so.data.lastMinute = lastMinute;							
				so.flush();		
				if(testing)trace("Saved Value: "+so.data.lastMinute)
			} catch (error:Error) {
				if(testing)trace("Could not write SharedObject to disk");
			}
		}		
		
	}//end Class
}//end Package
