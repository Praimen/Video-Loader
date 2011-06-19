package trh.helpers
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.*;
	import flash.utils.Timer;

	public class LoadVideo extends Sprite
	{
		
		private var _vid:Video;
		private var nc:NetConnection;
		private var _ns:NetStream;
	
		private var customClient:Object = new Object();
		private var _cuePoints:Array;
		private var _currentVideoTime:Number;
		private var _loadedPercent:uint;
		private var _startPlayPercent:uint;
		private var _loadedTimePercentage:Number;
		private var videoStatus:String;
		private var videoURL:String;
		private var _duration:Number;
		private var intervalTimer:Timer = new Timer(500);
			
		public function LoadVideo(width:Number,height:Number)
		{
			_vid = new Video(width, height);
			addChild(_vid);
			nc = new NetConnection();
			nc.connect(null);			
			_ns = new NetStream(nc);	
			
			addEvents();
			
		}
		
		public function addVideo(videoString:String):void{
			videoURL = videoString;
			playVideo();
		}
		
		private function addEvents():void{	
			
			customClient.onCuePoint = cuePointHandler;
			customClient.onMetaData = metaDataHandler;
			
			_ns.client = customClient;
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			intervalTimer.addEventListener(TimerEvent.TIMER,percentLoaded);
			intervalTimer.start();
			
		}
		
		private function playVideo():void{			
			_vid.smoothing = true;				
			_vid.attachNetStream(_ns);
			//_vid.x = stage.stageWidth - (_vid.width/1.5);//custom positioning of video				
			_ns.play(videoURL);	
			
		}	
		
		private function cuePointHandler(infoObject:Object):void {
			/*for (var propName:String in infoObject) {
				trace("CuePoint: "+propName + " = " + infoObject[propName]);
			}
						
			CuePoint: type = navigation
			CuePoint: time = 8.917
			CuePoint: name = select			
			*/	
			
		}
		
		private function metaDataHandler(infoObject:Object):void {
			_cuePoints = new Array();
			for (var propName:String in infoObject) {				
				if(propName == "cuePoints"){					
					for(var i:Number = 0; i < infoObject.cuePoints.length; i++){
						var oCue:Object = infoObject.cuePoints[i];
						trace("\t\t" + i + ": " + oCue.name + ", " + oCue.type+ ", " + oCue.time);								
						_cuePoints[i] = oCue;
					}
				}
			}
			cueArray = _cuePoints;
			duration = infoObject.duration;
			GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.META_INFO));
			
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {			
			videoStatus = event.info.code;
						
			switch (videoStatus) {				
				case "NetStream.Play.Start":
					//starts the video as the first inital play through and pauses the video for buffering
					trace("starting");
					_ns.pause();					
				break;
				
				case "NetStream.Buffer.Empty":
					//when Empty is triggered a array value is stored at that byte count	
				break;
			}//end Switch			
			
		}
		
		
	
		private function percentLoaded(tEvent:TimerEvent):void{			
			_loadedPercent = (_ns.bytesLoaded/_ns.bytesTotal) * 100;	
			
			_loadedTimePercentage = duration * (_loadedPercent/100);			
			if(_loadedPercent == 100){	
				intervalTimer.stop();
				intervalTimer.removeEventListener(TimerEvent.TIMER,percentLoaded);
				
			}
		}
		
		
		///////////////////////////////setters and getters//////////////////////		
		
		public function get stream():NetStream{			
			return _ns;
		}
		
		public function get video():Video{			
			return _vid;
		}	
		
		public function set duration(value:Number):void{
			_duration = value;
		}
		
		public function get duration():Number{
			return _duration;
		}
		
		public function get timeLoaded():Number{
			///timeLoaded will return the time of the video based on the percentage of the loaded bytes	
			return _loadedTimePercentage
		}
		
		
		public function get currentPercentLoaded():Number{			
			return _loadedPercent;
		}
		
		public function set startPlayPercent(value:Number):void{			
			_startPlayPercent = value;
		}
		
		public function get startPlayPercent():Number{			
			return _startPlayPercent;
		}
		
		public function set cueArray(value:Array):void{			
			_cuePoints = value;
		}
		
		public function get cueArray():Array{			
			return _cuePoints;
		}
		
		
	}//end Class
}//end Package