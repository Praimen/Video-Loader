package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
		
	public class LoadingState extends VideoState implements IVideoState
	{
		
		private var bandwidthChecker:BandwidthChecker;
		
		private var bandwidthVideoSize:String;
		private var intervalTimer:Timer = new Timer(1000);
		
		public function LoadingState()
		{	
						
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);
			//if not checked already
			checkBandwidth();
		}
		
		override public function buttonState():void{			
			trace("actiate button here");
		}
	
		protected function checkBandwidth():void{
			trace("got video");
			bandwidthChecker = new BandwidthChecker("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/images/arctic_test.bmp");					
		}
		
		private function setBandwidth(gEvent:GlobalEvent):void{	
			trace("bandwith complete")
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);
			bandwidthVideoSize = bandwidthChecker.bandwidth;
			startInitVideo();
		}
		
		override protected function startInitVideo():void{
			super.startInitVideo();		
			loadVideo.videoPlayPercent = 15;
			intervalTimer.addEventListener(TimerEvent.TIMER,checkVideo);
			intervalTimer.start();
			
		}		
		
		private function checkVideo(tEvent:TimerEvent):void{	
			trace("check video "+ loadVideo.currentPercentLoaded);
			if(loadVideo.currentPercentLoaded > loadVideo.videoPlayPercent){	
				intervalTimer.removeEventListener(TimerEvent.TIMER, checkVideo);
				intervalTimer = null;
				GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.VIDEO_PLAYING));
			}
		}
		
		//these override supply information to base class so it can acccessed by desendant 
		//classes
		
		/*override public function set video(value:Video):void{			
			super.video = loadVideo.video;			
		}
		
		override public function get video():Video{
			return super.video;
		}*/
		
		/*override public function set videoStream(value:NetStream):void{
			super.videoStream = super.loadVideo.stream;
		}*/
		
		
		
		
		
		
		
	}//end Class
}//end Package