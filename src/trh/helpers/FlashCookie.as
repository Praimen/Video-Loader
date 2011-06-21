package trh.helpers{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	public class FlashCookie {
		
		public var expirationTime:Number;// minutes
		private var so:SharedObject;
		private var now:Date;
		private var lastPlayed:Number;
		private var testing:Boolean = false;
		
		
		public function FlashCookie(expire:Number=20) {			
			now = new Date;			
			so = SharedObject.getLocal("flashCookie12345"); 
			expirationTime = expire;
			doesCookieExist();			
		}
		
		private function doesCookieExist():void {			
			if (so.data.lastPlayed){
				if(testing)trace("Getting Exisiting Value: "+so.data.lastPlayed);
				lastPlayed = so.data.lastPlayed;
			}else{
				
				saveValue();
			}
		}
		
		public function isExpired():Boolean{
			var timeLapse:Number = Math.abs(now.minutes - lastPlayed);
			if ( timeLapse >= expirationTime || isNaN(timeLapse)) {
				if(testing)trace("Now Minutes: "+ now.minutes+"  Last Played: "+lastPlayed);	
				saveValue();
				return true;
			}else{
				if(testing)trace("the time has not expired: "+	timeLapse);
				return false;				
			}
		}
		
		private function saveValue():void {
			try {	
				if(testing)trace("Saved Value: "+so.data.lastPlayed)
				so.data.lastPlayed = now.minutes;
				so.flush();				
			} catch (error:Error) {
				if(testing)trace("Could not write SharedObject to disk");
			}
		}		
		
	}//end Class
}//end Package
