package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.*;

	public class LoadVideo extends Sprite
	{
		
		private var _vid:Video;
		private var nc:NetConnection;
		private var _ns:NetStream;
	
		private var customClient:Object = new Object();
		private var _cuePoints:Array = new Array();
		private var _currentVideoTime:Number;
		private var _loadedPercent:uint;
		private var _startPlayPercent:uint;
		private var videoStatus:String;
		private var videoURL:String;
		
			
		public function LoadVideo(videoString:String, width:Number,height:Number)
		{
			videoURL = videoString;
			_vid = new Video(width, height);
			addChild(_vid);
			nc = new NetConnection();
			nc.connect(null);			
			_ns = new NetStream(nc);	
			
			addEvents();
			
		}
		
		private function addEvents():void{	
			
			customClient.onCuePoint = cuePointHandler;
			customClient.onMetaData = metaDataHandler;
			
			_ns.client = customClient;
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			playVideo();
		}
		
		private function playVideo():void{
			_vid.smoothing = true;				
			_vid.attachNetStream(_ns);
			//_vid.x = stage.stageWidth - (_vid.width/1.5);//custom positioning of video				
			_ns.play(videoURL);	
			
		}		
		
		
		private function cuePointHandler(infoObject:Object):void {
		/*	for (var propName:String in infoObject) {
				trace("CuePoint: "+propName + " = " + infoObject[propName]);
			}
			
			CuePoint: type = navigation
			CuePoint: time = 8.917
			CuePoint: name = select
			
			CuePoint: type = navigation
			CuePoint: time = 19.75
			CuePoint: name = loop
			
			*/
		}
		
		private function metaDataHandler(infoObject:Object):void {
			for (var propName:String in infoObject) {
				if(propName == "cuePoints"){
					//trace("MetaData: "+ propName + " = " + infoObject[propName].name);
					for(var i:Number = 0; i < infoObject.cuePoints.length; i++){
						var oCue:Object = infoObject.cuePoints[i];
						trace("\t\t" + i + ": " + oCue.name + ", " + oCue.type+ ", " + oCue.time);
						_cuePoints[oCue.name] = oCue.time;
					}
				}
			}
			
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {			
			videoStatus = event.info.code;
			trace(videoStatus);
			
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
	
		private function onEnterFrame(e:Event):void{			
			_loadedPercent = (_ns.bytesLoaded/_ns.bytesTotal) * 100;			
			_currentVideoTime = _ns.time;
			
			if(currentPercentLoaded == 100){
				
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		
		///////////////////////////////setters and getters//////////////////////		
		
		public function get stream():NetStream{			
			return _ns;
		}
		
		public function get video():Video{			
			return _vid;
		}
		
		
		public function get currentTime():Number{			
			return _currentVideoTime;
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
		
		public function get cueArray():Array{
			return _cuePoints;
		}
		
		
	}//end Class
}//end Package