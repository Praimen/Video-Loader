package trh.helpers {
	
	import flash.display.*;	
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.*;
	
	
	public class BandwidthChecker {
		
		public static const DEFAULT_BANDWIDTH:String = "low";
		public static const DEFAULT_BANDWIDTH_SPEED:Number = 50; // Setting connection threshold speed to 50KBps
		
		private var _bandwidthDetected:String;
		private var bandwidthSpeedDetected:Number;
		private var currentBytesDownloaded:int;
		private var intervalTimer:Timer = new Timer(5000);	
		private var time:Number = 5000;
		private var testFile:String;
		private var loader:Loader;
		private var request:URLRequest;
		
		
		public function BandwidthChecker(testImage:String) {
			testFile = testImage;
			loader = new Loader();
			addListeners();
			loadTestAsset();
				
		}
		
/////////////////////////////////////////////////////////////////////////////
//		PUBLIC METHODS
/////////////////////////////////////////////////////////////////////////////

		private function loadTestAsset():void {	
			
			request = new URLRequest(testFile);// + cacheBlocker()			
			loader.load(request);
			intervalTimer.addEventListener(TimerEvent.TIMER,avgDLSpeed);					
			intervalTimer.start();	
		}

/////////////////////////////////////////////////////////////////////////////
//		EVENT HANDLERS
/////////////////////////////////////////////////////////////////////////////

		protected function onLoadStart(event:Event):void {	
			trace("start Loading the test image");
			
					
		}
		
		
	
		
		protected function onLoadError(event:Event):void {
			_bandwidthDetected = DEFAULT_BANDWIDTH;
			bandwidthSpeedDetected = DEFAULT_BANDWIDTH_SPEED;
			DLComplete(event);
			trace("Error Loading SWF file");
		}
		
		private function avgDLSpeed(tEvent:TimerEvent):void{
			trace("get average download speed");
			//this function will run after the timer delay has expired
			//at that time the current bytes downloaded will be calculated against
			//the time to get the average downloaede bytes over that time
			
			bandwidthSpeedDetected = loader.contentLoaderInfo.bytesLoaded/time;
			
			_bandwidthDetected = (bandwidthSpeedDetected > DEFAULT_BANDWIDTH_SPEED) ? "high" : "low";	
			trace("/////////////////==///bandwidth: "+ bandwidthSpeedDetected+" = "+_bandwidthDetected+"////////////////////////////////////////////////////");
			GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.BANDWIDTH_COMPLETE));
			intervalTimer.stop();
			intervalTimer.removeEventListener(TimerEvent.TIMER,avgDLSpeed);
		}

		protected function DLComplete(event:Event):void {			
			/*loader.close();
			loader.unload();
			loader = null;*/
			trace("SWF file download completed");
			
			/*removeListeners();
			intervalTimer = null;*/
			
			/*request = null;
			testFile = null;*/
		}
		
		
/////////////////////////////////////////////////////////////////////////////
//		HELPERS
/////////////////////////////////////////////////////////////////////////////
		/*protected function cacheBlocker():String {
			if ((Capabilities.playerType == "External" || 
					 Capabilities.playerType == "StandAlone")) {
				return "";
			}
			else {
				var date:Date = new Date();
				var time:Number = date.getTime();
				return "?t=" + time.toString();
			}
		}*/
		
		protected function addListeners():void {
			
			
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoadStart);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, DLComplete);
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
		}
		
		protected function removeListeners():void {
			loader.contentLoaderInfo.removeEventListener(Event.OPEN, onLoadStart);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, DLComplete);
			
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
		}			
		
		///////////////////////////////setters and getters//////////////////////
		public function get bandwidth():String {
			return _bandwidthDetected;
		}
		
		public function get loopSWF():DisplayObject{			
			return loader.content;
		}
		
		
	}
}
