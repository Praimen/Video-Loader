package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.text.*;
	import flash.utils.*;
	
	import trh.helpers.*;
	
	
	[SWF(backgroundColor="#666666", frameRate="60", width="940", height="670")]
	public class MediaStatePlayer extends Sprite
	{	
		private var book:Book;
		private var button:ButtonState;		
		private var _btnArray:Array;		
		private var buttonArray:Array;
		private var _btnState:ButtonState;
		private var cuePointObject:Object = new Object();
		private var flashCookie:FlashCookie = new FlashCookie(15);//expiration in minutes MAX 59
		
		private var loading:IVideoState;
		private var _loadVideo:LoadVideo;
		public var path:String = "http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/";
		private var playing:IVideoState;
			
		private var _state:IVideoState;
		private var _startEndCue:Object;
		
		public var testing:Boolean = false;
		private var ui:UIGraphics;
		private var waiting:IVideoState;
		
		/**
		 *  This is the Main Constructor
		 * 
		 * 	
		 */
		public function MediaStatePlayer(){	
			
			loading = new LoadingState(this);
			waiting = new WaitingState(this);
			playing = new PlayState(this);
			_btnState = new ButtonState(this);
			ui = new UIGraphics();			
			_loadVideo = new LoadVideo(940,550);			
			init();			
		}
		
		/**
		 *  Initalizes the start of buttons and graphics and initial
		 * positioning of elements. 
		 * 
		 * <p>buttonArray contains an Array of Objects that have the following elements:
		 * <ul>
		 * <li>name: String value which should be made to correspond to the CuePoint name string output be the video MetaData</li>
		 * <li>posX: the initial x position of the element</li>
		 * <li>posY: the initial y position of the element</li>
		 * <li>path: the path of the graphic asset</li>
		 * <li>imgW: the width of the graphic asset</li>
		 * <li>imgH: the height of the graphic asset</li>
		 * </ul>
		 * these values are sent as a pramameter to the UIGraphics.addBtns() method to be returned as an array
		 * accessible by other states that have a reference to the MediaStatePlayer Object</p> 
		 * 
		 */
		
		private function init():void{	
			
			buttonArray = 	[	
								{name:"pedo1",posX:135, posY:90, image:path+"assets/pedo1.png",imgW:240,imgH:50},
								{name:"pedo2",posX:135, posY:140,image:path+"assets/pedo2.png",imgW:240,imgH:50},
								{name:"pedo3",posX:132, posY:200,image:path+"assets/pedo3.png",imgW:240,imgH:50},
								{name:"pedo4",posX:127, posY:260,image:path+"assets/pedo4.png",imgW:240,imgH:50},
								{name:"pedo5",posX:120, posY:330,image:path+"assets/pedo5.png",imgW:240,imgH:50},
								{name:"ortho1",posX:395, posY:90, image:path+"assets/ortho1.png",imgW:240,imgH:50},
								{name:"ortho2",posX:395, posY:140,image:path+"assets/ortho2.png",imgW:240,imgH:50},
								{name:"ortho3",posX:403, posY:200,image:path+"assets/ortho3.png",imgW:240,imgH:50},
								{name:"ortho4",posX:408, posY:260,image:path+"assets/ortho4.png",imgW:240,imgH:50},
								{name:"ortho5",posX:415, posY:330,image:path+"assets/ortho5.png",imgW:240,imgH:50}	
							];
			
			ui.addBtns(buttonArray);
			_btnArray = ui.uiButtonArray;
			
			//percentage number to start playing the video;
			_loadVideo.startPlayPercent = 1;
			
			//add visual elements order is important
			addChild(_loadVideo.video);		
			_loadVideo.video.y = 21;
			
			
			book = new Book();
			book.addChild(ui);			
			addChild(book);
			
			book.x = stage.width*.5 - book.width*.5;
			book.y = stage.height - (book.height - 104);
				
			//intial state is loading state   state = LoadingState.as
			_state = loading;
			state.applyState();
		}
		
		
		/**
		 *  Sets the string of the video to load
		 * 
		 * @param  optVideo this is the path of the FLV file that will be used
		 * 	
		 */
		public function setLoading(optVideo:String):void{			
			if(optVideo == "high"){			
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");
			}
			if(optVideo == "low"){				
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");	
			}			
		}
		
		/**
		 *  sets the application to the "playing" state  	
		 */
		
		public function playingState():void{				
			//state = PlayState.as
			_state = playing;		
		}
		
		/**
		 *  sets the application to the "waiting" state  	
		 */
		
		public function waitingState():void{			
			//state = WaitingState.as
			_state = waiting;
			getCuePoint("loop");		
		}
		
		
		/**
		 *  Determines the initial state and also constructs a <code>initCueSegment</code> Object 
		 * 	to set what portion of the video should initially play. 
		 * 
		 * <p>The <code>initCueSegment</code> Object is composed of:
		 * <ul>
		 * <li>name: the <b>name</b> String from the video MetaData</li>
		 * <li>start:  the <b>start time</b> from the named cuePoint String in the video MetaData</li>
		 * <li>end: the <b>start time</b> from the <b>NEXT</b> cuePoint in the array, which serves as the current segment <b>end point</b></li>
		 * </ul>
		 * </p>
		 * <p><b>NOTE:</b><em>setting an initial start value that exceeds the amount of video that has been loaded is not advised</em></p>  	
		 */		
		private function setInitCueStart():void{
			//the Shared Object will detect if the video has already played once before(roughly)	
			
			
			//the object contains the inital cue point segment			
			var initCueName:String = video.cueArray[1].name;
			var initCuePointStart:Number = video.cueArray[1].time;
			var initCuePointEnd:Number = video.cueArray[2].time;				
			
			var initCueSegment:Object = {name:initCueName,start:initCuePointStart,end:initCuePointEnd};
			cuePoint = initCueSegment;
			
			state.applyState();
			state.buttonState();
			addEventListener(Event.ENTER_FRAME, updateStatus);
		}
		
		public function getFlashCookie():void{
			if (flashCookie.isExpired()){				
				playingState();	
				setInitCueStart();
			}else{				
				waitingState();				
			}
		}		
		
		/**
		 * Accepts a String value that corresponds to a valid cuePoint name
		 * sets the <code>cuePoint</code> Object to the corresponding cuePoint segment.  
		 *  
		 * 
		 * @param cueName String value that corresponds to valid cuePoint name
		 * 
		 * <p>if the cueName value is <code>null</code> or does not correspond to a value in the video.cueArray,
		 * the video will enter the <code>WaitingState()</code> to being its looping cycles</p>
		 */
		public function getCuePoint(cueName:String):void{			
			var cueArray:Array = video.cueArray;			
			var cbLen:int = cueArray.length;	
			for(var i:int = 0; i < cbLen; i++){
				if(video.cueArray[i].name == cueName){					
					cuePointObject = {name:cueName, start:cueArray[i].time, end:cueArray[i+1].time};
				}else if (cueName == null){
					waitingState();
					break;
				}
			}
			//testing
			if(testing)trace("media cue array: "+ cuePointObject.name + " cuePointObject.start: " + cuePointObject.start+ " cuePointObject.end: "+ cuePointObject.end);
			
			cuePoint = cuePointObject;
			state.applyState();
			state.buttonState();				
		}
		
		/**
		 *  Updates the UI status loading text, once
		 * 	the video has fully loaded it will remove the handler  	
		 */		
		public function updateStatus(evt:Event):void{
			
			if(book.statusTxt != null){
				book.statusTxt.text = String(video.currentPercentLoaded+"%");
				if(video.currentPercentLoaded == 100){	
					
					removeEventListener(Event.ENTER_FRAME, updateStatus);
					book.statusTxt.text = "";
					book.cleanUp();
				}		
			}
		}
		
		
///////////////////////////////setters and getters//////////////////////
		
		public function get btnState():ButtonState{
			return _btnState;
		}		
		
		public function get buttons():Array{			
			return _btnArray;
		}		
		
		public function get video():LoadVideo{
			return _loadVideo; 
		}		
		
		public function get videoStream():NetStream{
			return _loadVideo.stream;
		}
		
		public function set cuePoint(value:Object):void{	
			//start and End cuePoint			
			_startEndCue = value;			
		}
		
		public function get cuePoint():Object{	
			//start and End cuePoint
			return _startEndCue	;		
		}		
		
		public function get state():IVideoState{			
			return _state;
		}			
		
	}//end Class
}//end Package