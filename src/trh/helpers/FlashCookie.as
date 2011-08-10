package trh.helpers{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	public class FlashCookie {
		
		public var expirationTime:Number;// minutes
		private var so:SharedObject;
		private var now:Date;
		private var lastDay:Number;
		private var lastHour:Number;
		private var lastMinute:Number;
		private var testing:Boolean = true;
		
		
		public function FlashCookie(expire:Number=20) {			
			now = new Date();			
			so = SharedObject.getLocal("flashCookie12345"); 
			expirationTime = expire;
			doesCookieExist();
			if(testing)trace("Today's Day "+ now.date );
		}
		
		private function doesCookieExist():void {			
			if (so.data.lastDay){
				if(testing)trace("Getting Exisiting Value: "+so.data.lastDay);
				lastDay = Number(so.data.lastDay);
				lastHour = Number(so.data.lastHour);
				lastMinute = Number(so.data.lastMinute);
			}else{
				
				saveValue();
			}
		}
		
		public function isExpired():Boolean{
			var timeLapseDay:Number = now.date - lastDay;
			var timeLapseHour:Number = now.hours - lastHour;
			var timeLapseMinutes:Number = now.minutes - lastMinute;
			/*timeLapseDay == 0 && timeLapseHour == 0 && */
			if ((timeLapseDay >= 0) && (timeLapseHour >= 0) && (timeLapseMinutes >= expirationTime)|| timeLapseMinutes == 0) {
				if(testing)trace("Now Day: "+ timeLapseDay +"  Last Hour: "+timeLapseHour+"  Last Minute: "+ timeLapseMinutes);	
				saveValue();
				return true;
			}else{
				if(testing)trace("Now Day: "+ timeLapseDay +"  Last Hour: "+timeLapseHour+"  Last Minute: "+ timeLapseMinutes);
				return false;				
			}
		}
		
		private function saveValue():void {
			try {	
				
					
				lastDay = so.data.lastDay = now.date
				lastHour = so.data.lastHour = now.hours;
				lastMinute = so.data.lastMinute = now.minutes;				
				so.flush();		
				if(testing)trace("Saved Value: "+so.data.lastMinute)
			} catch (error:Error) {
				if(testing)trace("Could not write SharedObject to disk");
			}
		}		
		
	}//end Class
}//end Package
