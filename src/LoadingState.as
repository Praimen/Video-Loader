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
		private var intervalTimer:Timer = new Timer(500);
		private var _media:MediaStatePlayer;
		
		public function LoadingState(msObject:MediaStatePlayer){	
			_media = msObject;		
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);	
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.META_INFO, setStateInitPlaying);
		}
		
		
		public function applyState():void{			
			checkBandwidth();
		}
	
		public function checkBandwidth():void{
			if(_media.testing)trace("got video");
			bandwidthChecker = new BandwidthChecker(_media.path+"/bandwith_test.bmp");					
			buttonState();		
		}		
		
		public function buttonState():void{			
			
		}
		
		private function setBandwidth(gEvent:GlobalEvent):void{	
			if(_media.testing)trace("bandwith complete");
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
			_media.updateStatus(new Event(Event.INIT));
			//trace("check video "+ _media.video.currentPercentLoaded);			
			if(_media.video.currentPercentLoaded >= _media.video.startPlayPercent){				
				intervalTimer.stop();
				intervalTimer.removeEventListener(TimerEvent.TIMER, checkVideo);
				///the resume here with intiate the MetaData event in the VideoStream Object 
				_media.videoStream.resume();			
			}
		}
		
		private function setStateInitPlaying(evt:Event):void{
			//once meta data event is triggered then the video is paused to gather the inital cue points
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.META_INFO, setStateInitPlaying);
			_media.videoStream.pause();			
			_media.setInitCueStart();			
		}
		
		
		

		///////////////////////////////setters and getters//////////////////////		
		
		
	
		
	}//end Class
}//end Package