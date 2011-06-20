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
				lastPlayed = so.data.lastPlayed ;
			}else{
				saveValue();
			}
		}
		
		public function isExpired():Boolean{
			trace("Flash Cookie: "+Math.abs(now.minutes - lastPlayed));
			if ( Math.abs(now.minutes - lastPlayed) > expirationTime) {
				so.clear();									
				return true;
			}else{
				
				return false;				
			}
		}
		
		private function saveValue():void {			
			so.data.lastPlayed = now.minutes;			
			try {				
				so.flush();
				so.close();				
			} catch (error:Error) {
				trace("Could not write SharedObject to disk");
			}
		}		
		
	}//end Class
}//end Package
