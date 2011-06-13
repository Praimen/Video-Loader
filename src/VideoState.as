package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Dictionary;

	public class VideoState extends Sprite implements IVideoState
	{
		private var _state:IVideoState;
		protected var videoButton:SimpleButton;
		private var _ns:NetStream;
		private var _video:Video;
		protected var loadVideo:LoadVideo;

		public function VideoState(){
			
			init();
		}
		
		public function addButtons(buttons:Array):void{			
			for(var i:Number = 0; i<buttons.length;i++){
				var button:SimpleButton = buttons[i] as SimpleButton;
				button = new SimpleButton(this.buttonGraphic());
				button.name = buttons[i];
				addChild(button);
				button.y = i * (button.height + 4); 
				trace(button.name);
			}
		}
		
		protected function startInitVideo():void{
			//add bandwidth video size to load video
			trace("start Video");
			loadVideo = new LoadVideo("http://www.drvollenweider.com/Portals/_default/Skins/siteSkin/videos/Cue_1.flv",800,400);
			video = loadVideo.video;
			this.videoStream = loadVideo.stream;
			addChild(video);
			
			
		}		
		
		private function init():void{
			buttonGraphic();
			createStatusText();
		}
		
		private function buttonGraphic():Sprite{
			var square:Sprite = new Sprite();
			//addChild(square);
			square.graphics.lineStyle(3,0x00ff00);
			square.graphics.beginFill(0x0000FF);
			square.graphics.drawRect(0,0,75,25);
			square.graphics.endFill();	
			return square;
		}
		
		
		private function createStatusText():void{
			
			
		}
		
		
		public function buttonState():void{			
			trace("actiate button here");
		}
		
				
		/**
		 * 
		 * @param value
		 * 
		 */		
		
		public function set state(value:IVideoState):void{			
			this._state = value;
		}
		
		public function get state():IVideoState{			
			return _state;
		}
		
		public function set video(value:Video):void{
			_video = value;			
		}
		
		public function get video():Video{
			
			return _video;
		}
		
		public function set videoStream(value:NetStream):void{
			_ns = value;
		}
		
		public function get videoStream():NetStream{			
			return _ns;
		}
		
		
		
		
	}//end Class
}//end Package