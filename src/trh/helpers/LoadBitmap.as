package trh.helpers
{
	
	/**
	 * var imageLoad:LoadBitmap = new LoadBitmap("assets/images/period_color.png",156,190)	 
	 */	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	
	public class LoadBitmap
	{
		private var _bitdraw:BitmapData;
		private var _loadedBitmapData:Bitmap;
		private var loader:Loader;
		private var regEvent:Boolean;
		//==decouple===/private var myTimer:PanelTimer;
		
		//this adds the parameter listenForEvents and will dispatch an event based on pixel data being present
		//this help syncronize loading of components and graphics
		public function LoadBitmap(loadURL:String, pixelW:Number, pixelH:Number, listenForEvents:Boolean=false){
			//==decouple===/myTimer = new PanelTimer(1000,2);
			initLoadBitmap(loadURL,pixelW,pixelH);
			this.regEvent = listenForEvents;
		
		}
		
		private function initLoadBitmap(loadURL:String, pixelW:Number, pixelH:Number):void{
			
			_bitdraw = new BitmapData(pixelW,pixelH, true, 0x00000000);
			loader = new Loader();			
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, initBitmap );	
			loader.load(new URLRequest(loadURL));	
			
		}
		
		private function initBitmap(event:Event):void{			
			_bitdraw.draw(loader);			
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, initBitmap );
			loader = null
			
		}	
		
		
		private function bitmapAdded(e:Event):void{	
			/*//==decouple=====///myTimer.data.panel = e.target.parent;
			myTimer.addEventListener(TimerEvent.TIMER,getImagePixel);
			myTimer.start();*/																
		}
		
		private function getImagePixel(e:TimerEvent):void{	
		/*	var panelParent:* = e.target.data.panel;
			var isPixel:uint = bitmapData.getPixel32(panelParent.width/2, panelParent.height/2);			
			if (isPixel > 0){
				myTimer.stop();
				//==decouple===/panelParent.dispatchEvent(new PanelEvent(PanelEvent.PANEL_RENDERED));					
			}*/
			//add counter and error handling if images does not load			
		}
		
		///getter and setters
		
		public function get bitmap():Bitmap{	
			_loadedBitmapData = new Bitmap(_bitdraw);
			
			if(regEvent){
				_loadedBitmapData.addEventListener(Event.ADDED, bitmapAdded);
			}
			
			return _loadedBitmapData;
		}
		
		
		
		public function get bitmapData():BitmapData{	
			
			return _bitdraw;
		}
		
	}
}