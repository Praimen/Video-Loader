package trh.helpers {
		import flash.display.*;
		import flash.events.MouseEvent;
		import flash.net.*;
		import flash.net.URLRequest;
		import flash.net.URLRequestMethod;


	public class ButtonLink {
		
		private var _link:String;
		private var _linkTarget:String;
		private var _currentButton:*;
		private var request:URLRequest;
		private var linkTarget:String;
		
		
		public function ButtonLink(currentbutton:*, link:String, linktarget:String){		
			_link = link;
			_linkTarget = linktarget;
			_currentButton = currentbutton;
			_currentButton.buttonMode = true
			_currentButton.useHandCursor = true;
			_currentButton.addEventListener(MouseEvent.CLICK, getLink)
			_currentButton.addEventListener(MouseEvent.ROLL_OVER, buttonOn);
			_currentButton.addEventListener(MouseEvent.ROLL_OUT, buttonOff);
			
		}
		
		private function getLink(event:MouseEvent):void{			
			 request = new URLRequest(this._link);
			 request.method = URLRequestMethod.GET;			
			 navigateToURL(request, _linkTarget);			
		}
		
		private function buttonOn(event:MouseEvent):void{			
			_currentButton.alpha = 1;			
		}
		
		private function buttonOff(event:MouseEvent):void{			
			_currentButton.alpha = 1;			
		}	
		
	}	
	
}