package trh.helpers
{	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class URLVars extends Sprite	{
		
		private var _flashVars:Object = new Object();
		
		private var myLoader:URLLoader = new URLLoader();	
		
		public function URLVars(){
					
		}		
		
		public function loaderComplete(evt:Event):void{				
			_flashVars = LoaderInfo(evt.target).parameters;	
			
			GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.FLASHVARS_LOADED));
		}
		
		public function get flashVars():Object{			
			return _flashVars;
		}		
		
	}// end Class
}//end Package