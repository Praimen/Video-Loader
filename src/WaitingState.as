package
{
	
	
	public class WaitingState implements IVideoState
	{
		public function WaitingState(msObject:MediaStatePlayer)
		{
			
			
		}
		
		public function applyState():void{			
			trace("waiting applied");
		}
		
	}//end Class
}//end Package