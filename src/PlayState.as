package
{
	import flash.display.Sprite;
	import flash.net.NetStream;
	
	public class PlayState extends Sprite implements IVideoState
	{
		public function PlayState(msObject:MediaStatePlayer)
		{	
			
			trace("playing state");	
			//trace(super.videoStream);
			
		}
		
		public function applyState():void{			
			trace("waiting applied");
		}
		
	}//end Class
}//end Package