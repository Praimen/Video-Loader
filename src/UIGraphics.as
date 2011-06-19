package
{
	
	import flash.display.*;
	
	import trh.helpers.LoadBitmap;
	
	public class UIGraphics extends MovieClip 	{
		
			
		private var _uiButtonArray:Array;
		private var imageLoad:LoadBitmap;
		public function UIGraphics()
		{
			_uiButtonArray = new Array;
		}
		
		public function addBtns(buttons:Array):void{	
			
			for(var i:Number = 0; i<buttons.length;i++){
				var button:Sprite = new Sprite;				
				button.addChild(buttonImage(buttons[i].image,240,50));
				button.name = buttons[i].name;
				button.x = buttons[i].posX;
				button.y = buttons[i].posY;	
				button.alpha = .10;				
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
		
		
		private function buttonImage(imgStr:String,imgW:Number,imgH:Number):Sprite{
			imageLoad = new LoadBitmap(imgStr,imgW, imgH);			
			var img:Bitmap = imageLoad.bitmap;
			var image:Sprite = new Sprite;
			image.addChild(img);
			return image;
		}
		///////////============setter and getter===================//////////
		
		public function get uiButtonArray():Array{
			return _uiButtonArray;
		}
		
	}//end Class
}//end Package