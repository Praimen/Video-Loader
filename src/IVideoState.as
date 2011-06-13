package
{
	import flash.display.Sprite;

	public interface IVideoState
	{
		function buttonState():void;
		function set state(value:IVideoState):void;
		function get state():IVideoState;
		
	}
}