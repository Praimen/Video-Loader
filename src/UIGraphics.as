package
{
	
	import flash.display.Sprite;
	
	public class UIGraphics extends Sprite
	{
		
		private var uiButtonArray:Array;
		
		public function UIGraphics()
		{
			uiButtonArray = new Array;
		}
		
		public function addButtons(buttons:Array):Array{	
			
			for(var i:Number = 0; i<buttons.length;i++){
				var button:Sprite = buttons[i] as Sprite;
				button = buttonGraphic();
				button.name = buttons[i];
				uiButtonArray.push(button);
				addChild(button);
				button.y = i * (button.height + 4); 
				
			}
			
			return uiButtonArray;
			
		}
		
		
		private function buttonGraphic():Sprite{
			var square:Sprite = new Sprite();
			
			square.graphics.lineStyle(3,0x00ff00);
			square.graphics.beginFill(0x0000FF);
			square.graphics.drawRect(0,0,75,25);
			square.graphics.endFill();	
			return square;
		}
		
		
	}//end Class
}//end Package