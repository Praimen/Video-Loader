package trh.helpers{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	public class FlashCookie {
		
		private var so:SharedObject;
		private var now:Date;
		private var lastPlayed:Number;
		public var expirationTime:Number;// minutes
		
		public function FlashCookie(expire:Number=20) {			
			now = new Date;			
			so = SharedObject.getLocal("flashCookie12345"); 
			expirationTime = expire;
			doesCookieExist();			
		}
		
		private function doesCookieExist():void {			
			if (so.data.lastPlayed){
				trace("Getting Exisiting Value: "+so.data.lastPlayed)
				lastPlayed = so.data.lastPlayed;
			}else{
				saveValue();
			}
		}
		
		public function isExpired():Boolean{
			var timeLapse:Number = Math.abs(now.minutes - lastPlayed);
			if ( timeLapse > expirationTime || isNaN(timeLapse)) {
				trace("Flash Cookie: "+ timeLapse);
				so.clear();	
				
				return true;
			}else{
				trace("the time has not expired: "+	timeLapse);
				return false;				
			}
		}
		
		private function saveValue():void {			
			so.data.lastPlayed = now.minutes;	
			
			try {	
				trace("Saved Value: "+so.data.lastPlayed)
				so.flush();
				so.close();
			} catch (error:Error) {
				trace("Could not write SharedObject to disk");
			}
		}		
		
	}//end Class
}//end Package
