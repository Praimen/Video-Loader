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
		private var testing:Boolean = false;
		
		
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
				
			}else{
				so.data.lastDay = now.date
				so.data.lastHour = now.hours;
				so.data.lastMinute = now.minutes;
				saveValue();
			}
		}
		
		public function isExpired():Boolean{
			var timeLapseDay:Number = Math.abs(now.date - Number(so.data.lastDay));
			var timeLapseHour:Number =  Math.abs(now.hours - Number(so.data.lastHour));
			var timeLapseMinutes:Number =  Math.abs(now.minutes - Number(so.data.lastMinute));
		
			if ((timeLapseDay >= 0) && (timeLapseHour >= 0) && (timeLapseMinutes >= expirationTime)|| timeLapseMinutes == 0) {
				if(testing){
					trace("Now Day: "+ now.date +"  Now Hour: "+now.hours+"  Now Minute: "+ now.minutes);
					trace("Last Day: "+ so.data.lastDay +"  Last Hour: "+so.data.lastHour+"  Last Minute: "+ so.data.lastMinute)
					trace("Lapse Day: "+ timeLapseDay +"  Lapse Hour: "+timeLapseHour+"  Lapse Minute: "+ timeLapseMinutes);
				}
				
				so.data.lastDay = now.date
				so.data.lastHour = now.hours;
				so.data.lastMinute = now.minutes;
				saveValue();
				return true;
			}else{
				if(testing){
					trace("Now Day: "+ now.date +"  Now Hour: "+now.hours+"  Now Minute: "+ now.minutes);
					trace("Last Day: "+ so.data.lastDay +"  Last Hour: "+so.data.lastHour+"  Last Minute: "+ so.data.lastMinute)
					trace("Lapse Day: "+ timeLapseDay +"  Lapse Hour: "+timeLapseHour+"  Lapse Minute: "+ timeLapseMinutes);
				}
				return false;				
			}
		}
		
		private function saveValue():void {
			try {								
				so.flush();		
				if(testing)trace("Saved Value: "+so.data.lastMinute)
			} catch (error:Error) {
				if(testing)trace("Could not write SharedObject to disk");
			}
		}		
		
	}//end Class
}//end Package
