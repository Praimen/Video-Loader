package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import trh.helpers.BandwidthChecker;
	import trh.helpers.GlobalDispatcher;
	import trh.helpers.GlobalEvent;
	
		
	public class LoadingState implements IVideoState
	{		
		private var bandwidthChecker:BandwidthChecker;		
		private var _bandwidthVideoSize:String;
		private var intervalTimer:Timer = new Timer(1000);
		private var _media:MediaStatePlayer;
		
		public function LoadingState(msObject:MediaStatePlayer)
		{	
			_media = msObject;		
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);	
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.META_INFO, setStateInitPlaying);
		}
		
		
		public function applyState():void{			
			checkBandwidth();
		}
	
		public function checkBandwidth():void{
			trace("got video");
			bandwidthChecker = new BandwidthChecker("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/images/arctic_test.bmp");					
			buttonState()		
		}		
		
		public function buttonState():void{			
			for each (var button:Sprite in _media.buttons){				
				button.mouseEnabled = false;
				button.buttonMode = false;
				button.alpha = .5;
				
			}
		}
		
		private function setBandwidth(gEvent:GlobalEvent):void{	
			trace("bandwith complete")
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);
			_bandwidthVideoSize = bandwidthChecker.bandwidth;
			_media.setLoading(_bandwidthVideoSize);
			startLoadTimer();			
		}
		
		private function startLoadTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,checkVideo);
			intervalTimer.start();			
		}	
		
		
		private function checkVideo(tEvent:TimerEvent):void{	
			trace("check video "+ _media.video.currentPercentLoaded);
			if(_media.video.currentPercentLoaded > _media.video.startPlayPercent){	
				intervalTimer.removeEventListener(TimerEvent.TIMER, checkVideo);
				//used to start video to get the MetaData initiated
				_media.videoStream.resume();			
			}
		}
		private function setStateInitPlaying(evt:Event):void{
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.META_INFO, setStateInitPlaying);
			_media.videoStream.pause();
			
			setInitCueStart();			
		}
		
		private function setInitCueStart():void{
			var initCueSegment:Object = new Object();
			//the object contains the inital cue point segment
			var initCueName:String = _media.video.cueArray[1].name;
			var initCuePointStart:Number = _media.video.cueArray[1].time;
			var initCuePointEnd:Number = _media.video.cueArray[2].time;
			initCueSegment = {name:initCueName,start:initCuePointStart,end:initCuePointEnd};
			
			_media.cuePoint = initCueSegment;
			
			_media.setPlaying();
		}
		

		///////////////////////////////setters and getters//////////////////////		
		
		
	
		
	}//end Class
}//end Package