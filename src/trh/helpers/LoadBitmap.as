package trh.helpers
{
	
	/**
	 * var imageLoad:LoadBitmap = new LoadBitmap("assets/images/period_color.png",156,190)	 
	 */	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	
	public class LoadBitmap
	{
		private var _bitdraw:BitmapData;
		private var _loadedBitmapData:Bitmap;
		private var _sprite:Sprite;
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
			
			var loaderContext:LoaderContext = new LoaderContext();			
			loaderContext.checkPolicyFile = true;
			
			loader = new Loader();		
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError, false, 0, true);
			
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, initBitmap );
			loader.load(new URLRequest(loadURL), loaderContext );
			
			
		}
		
		private function initBitmap(event:Event):void{			
			_bitdraw.draw(loader);
			
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, initBitmap );
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);	
			
		}
		
		protected function onLoadError(event:Event):void {
				
			imageLoadClean();
		}
		
		protected function imageLoadClean():void {			
			loader.close();
			loader.unload();
			loader = null;
			
		}
		
		///getter and setters
		
		public function get bitmap():Bitmap{	
			_loadedBitmapData = new Bitmap(_bitdraw);				
			return _loadedBitmapData;
		}
		
		public function get sprite():Sprite{	
			_loadedBitmapData = new Bitmap(_bitdraw);
			_sprite = new Sprite()
			_sprite.addChild(_loadedBitmapData);
			return _sprite;
		}	
		
		
		public function get bitmapData():BitmapData{			
			return _bitdraw;
		}
		
	}
}