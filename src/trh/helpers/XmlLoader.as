package trh.helpers
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class XmlLoader extends Sprite
	{
	
		private var _xmlResult:XML;
		private var myLoader:URLLoader = new URLLoader();		
		
		public function XmlLoader(xmlfile:String){
			
			myLoader.addEventListener(Event.COMPLETE, processXML);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			myLoader.load(new URLRequest(xmlfile));						
		}
		
		/*====================== Process XML ==============================	
		processXML is called by the myLoader URL Request and
		will populate the myXML object 
		check to see if the object is null*/		
		
		private function processXML(e:Event):void {
			var myXML:XML = new XML(e.target.data);
			try{
				if(myXML != null){
					_xmlResult = myXML;
					GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.XML_LOADED));					
				}
			}catch(e:Error){
				trace("XML load Failed");
			}			
		}
		
		private function xmlLoadError(e:IOErrorEvent):void {			
			trace("there was an error requesting the XML file: "+ e.text)			
		}			
		
		//*********************************************************************
		public function get xmlFile():XML{			
			return _xmlResult;
		}		
		
	}//end Class
}//end Package