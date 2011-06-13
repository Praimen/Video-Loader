package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
		
	public class LoadingState implements IVideoState
	{
		
		private var bandwidthChecker:BandwidthChecker;
		
		private var bandwidthVideoSize:String;
		private var intervalTimer:Timer = new Timer(1000);
		private var _media:MediaStatePlayer;
		
		public function LoadingState(msObject:MediaStatePlayer)
		{	
			_media = msObject;		
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);					
		}
		
		public function applyState():void{			
			checkBandwidth();
		}
	
		protected function checkBandwidth():void{
			trace("got video");
			bandwidthChecker = new BandwidthChecker("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/images/arctic_test.bmp");					
		}
		
		private function setBandwidth(gEvent:GlobalEvent):void{	
			trace("bandwith complete")
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);
			bandwidthVideoSize = bandwidthChecker.bandwidth;
			startLoadTimer();
		}
		
		private function startLoadTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,checkVideo);
			intervalTimer.start();
			
		}		
		
		private function checkVideo(tEvent:TimerEvent):void{	
			trace("check video "+ _media.video.currentPercentLoaded);
			if(_media.video.currentPercentLoaded > _media.video.videoPlayPercent){	
				intervalTimer.removeEventListener(TimerEvent.TIMER, checkVideo);
				intervalTimer = null;
				_media.setPlaying();
			}
		}
		
		
	
		
		
		
		
		
		
		
		
		
	}//end Class
}//end Package