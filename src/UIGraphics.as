package
{	
	import flash.display.*;
	
	
	
	import trh.helpers.LoadBitmap;
	
	public class UIGraphics extends MovieClip{		
		private var _media:MediaStatePlayer;	
		public var _uiButtonArray:Array;		
		public function UIGraphics(msObject:MediaStatePlayer){
			_uiButtonArray = [];
			_media = msObject;
		}
		
		public function addBtns(buttons:Array):void{	
				
			for(var i:int = 0; i<buttons.length;i++){
				var button:Sprite = new Sprite;
				var imageLoad:LoadBitmap = new LoadBitmap(buttons[i].image, buttons[i].imgW, buttons[i].imgH)
				button.addChild(imageLoad.sprite);
				button.name = buttons[i].name;
				button.x = buttons[i].posX;
				button.y = buttons[i].posY;	
				button.alpha = .10;				
				_uiButtonArray.push(button);
				addChild(button);				
			}
			uiButtonArray();
		}
		
		
		private function buttonImage(imgStr:String,imgW:Number,imgH:Number):Sprite{
			var imageLoad:LoadBitmap = new LoadBitmap(imgStr,imgW, imgH);			
			var img:Sprite = imageLoad.sprite;			
			
			return img;
		}
		
		///////////============setter and getter===================//////////
		
		public function uiButtonArray():void{			
			_media.buttons = _uiButtonArray;
			
		}
		
	}//end Class
}//end Package