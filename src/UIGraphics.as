package
{
	
	import flash.display.Sprite;
	
	import trh.helpers.LoadBitmap;
	
	public class UIGraphics extends Sprite
	{
		
		private var _uiButtonArray:Array;
		//private var imageLoad:LoadBitmap;
		public function UIGraphics()
		{
			_uiButtonArray = new Array;
		}
		
		public function addButtons(buttons:Array):void{	
			
			for(var i:Number = 0; i<buttons.length;i++){
				var button:Sprite = buttons[i] as Sprite;
				button = buttonGraphic();
				button.name = buttons[i].name;
				button.x = buttons[i].posX;
				button.y = buttons[i].posY;	
				button.alpha = .10;
				
				//button.image = buttonImage
				_uiButtonArray.push(button);
				addChild(button);
			}		
		}
		
		
		private function buttonGraphic():Sprite{		
			var square:Sprite = new Sprite();			
			square.graphics.lineStyle(3,0x00ff00);
			square.graphics.beginFill(0x0000FF);
			square.graphics.drawRect(0,0,75,25);
			square.graphics.endFill();	
			return square;
		}
		
		
		/*private function buttonImage():LoadBitmap{
			//imageLoad = new LoadBitmap("image.jpg", 200, 100);	
			return;
		}*/
		///////////============setter and getter===================//////////
		
		public function get uiButtonArray():Array{
			return _uiButtonArray;
		}
		
	}//end Class
}//end Package