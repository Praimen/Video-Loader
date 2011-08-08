package trh.helpers 
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{	
		// event constants	
		public static const VIDEO_LOADED:String = "video loaded";
		public static const VIDEO_INIT_START:String = "video init loaded";
		public static const VIDEO_WAITING:String = "video waiting";
		public static const VIDEO_PLAYING:String = "video playing";
		public static const BANDWIDTH_COMPLETE:String = "bandwith complete";
		public static const META_INFO:String = "meta info";
		public static const FONT_LOADED:String = "font loaded";
		public static const VIDEO_PLAY:String = "video play";
		
		//public var params:Object;
	
		public function GlobalEvent(type:String, /*params:Object,*/ bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			//this.params = params;
		}
		
		///required override
		public override function clone():Event{
			return new GlobalEvent(type, /*params,*/ bubbles, cancelable);
		}
		
		public override function toString():String{
			return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");		
		}

		
	}
}
