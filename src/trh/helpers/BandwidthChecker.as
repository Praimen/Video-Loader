package trh.helpers {
	
	import flash.display.Loader;
	import flash.display.Sprite;
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
		private var intervalTimer:Timer;
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
			
			request = new URLRequest(testFile + cacheBlocker());			
			loader.load(request);
			
		
		}

/////////////////////////////////////////////////////////////////////////////
//		EVENT HANDLERS
/////////////////////////////////////////////////////////////////////////////

		private function onLoadStart(event:Event):void {	
			trace("start Loading the test image");
			intervalTimer = new Timer(time, 1);
			intervalTimer.addEventListener(TimerEvent.TIMER,avgDLSpeed);
			intervalTimer.start();					
		}
		
		
	
		
		private function onLoadError(event:Event):void {
			_bandwidthDetected = DEFAULT_BANDWIDTH;
			bandwidthSpeedDetected = DEFAULT_BANDWIDTH_SPEED;
			DLComplete(event);
		}
		
		private function avgDLSpeed(tEvent:TimerEvent):void{			
			//this function will run after the timer delay has expired
			//at that time the current bytes downloaded will be calculated against
			//the time to get the average downloaede bytes over that time
			
			bandwidthSpeedDetected = loader.contentLoaderInfo.bytesLoaded/time;
			
			_bandwidthDetected = (bandwidthSpeedDetected > DEFAULT_BANDWIDTH_SPEED) ? "high" : "low";	
			trace("/////////////////==///bandwidth: "+ bandwidthSpeedDetected+" = "+_bandwidthDetected+"////////////////////////////////////////////////////");
			GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.BANDWIDTH_COMPLETE));
			loader.close();
			loader.unload();
			removeListeners();
		}

		private function DLComplete(event:Event):void {
			intervalTimer.stop();
			intervalTimer.removeEventListener(TimerEvent.TIMER,avgDLSpeed);
			removeListeners();
			intervalTimer = null;
			loader = null;
			request = null;
			testFile = null;
		}
		
		
/////////////////////////////////////////////////////////////////////////////
//		HELPERS
/////////////////////////////////////////////////////////////////////////////
		private function cacheBlocker():String {
			if ((Capabilities.playerType == "External" || 
					 Capabilities.playerType == "StandAlone")) {
				return "";
			}
			else {
				var date:Date = new Date();
				var time:Number = date.getTime();
				return "?t=" + time.toString();
			}
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoadStart);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, DLComplete);
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
		}
		
		private function removeListeners():void {
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
		
		
	}
}
