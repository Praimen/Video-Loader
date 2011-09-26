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
		private var startPlaying:Boolean
		
		private var _media:MediaStatePlayer;
		
		
		/**
		 *  This state handles all the loading state functions for the <code>MediaStatePlayer</code>:
		 * 
		 * <p>
		 * <ul>
		 * <li></li>
		 * </ul>
		 * </p>
		 * 
		 * <p>The <code>initCueSegment</code> Object is composed of:
		 * <ul>
		 * <li>name: the <b>name</b> String from the video MetaData</li>
		 * <li>start:  the <b>start time</b> from the named cuePoint String in the video MetaData</li>
		 * <li>end: the <b>start time</b> from the <b>NEXT</b> cuePoint in the array, which serves as the current segment <b>end point</b></li>
		 * </ul>
		 * </p>
		 * <p><b>NOTE:</b><em>setting an initial start value that exceeds the amount of video that has been loaded is not advised</em></p>  	
		 */		
		public function LoadingState(msObject:MediaStatePlayer){	
			_media = msObject;		
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);	
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.META_INFO, setStateInitPlaying);
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_PLAY, videoPause);
			startPlaying = false;			
		}		
		
		
		public function applyState():void{				
			checkBandwidth();
		}
	
		public function checkBandwidth():void{
			if(_media.testing)trace("got video");
			bandwidthChecker = new BandwidthChecker(_media.path+"/bandwith_test.bmp");					
					
		}		
		
		public function buttonState():void{			
			_media.btnState.checkButtonLoad();			
		}
		
		private function videoPause(gEvent:GlobalEvent):void{
			_media.videoStream.pause();	
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.VIDEO_PLAY, videoPause);
			
		}		
		
		private function setBandwidth(gEvent:GlobalEvent):void{	
			if(_media.testing)trace("bandwith complete");
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);
			_bandwidthVideoSize = bandwidthChecker.bandwidth;
			_media.setLoading(_bandwidthVideoSize);
			
			_bandwidthVideoSize = null;
			bandwidthChecker = null;
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
				///the resume here with intiate the MetaData event in the VideoStream Object 
						
					if(!startPlaying){
						//after percent load will either start playing from the inital state cue point or it will apply the wating state
						if(_media.state is WaitingState){
							_media.state.applyState();
						}else{
							_media.videoStream.resume();
						}				
						startPlaying = true;
					}		
			}
			
			if(_media.video.currentPercentLoaded > 99){	
				intervalTimer.stop();
				intervalTimer.removeEventListener(TimerEvent.TIMER, checkVideo);
			}
		}
		
		private function setStateInitPlaying(evt:Event):void{
			//once meta data event is triggered then the video is paused to gather the inital cue points
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.META_INFO, setStateInitPlaying);	
			buttonState();
			_media.getFlashCookie();			
		}
		

		///////////////////////////////setters and getters//////////////////////		
			
		
	}//end Class
}//end Package