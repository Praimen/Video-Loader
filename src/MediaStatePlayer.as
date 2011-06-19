package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import trh.helpers.LoadVideo;
	
	[SWF(backgroundColor="#666666", frameRate="60", width="940", height="670")]
	public class MediaStatePlayer extends Sprite
	{	
		private var button:ButtonState;
		private var ui:UIGraphics;
		private var _btnArray:Array;
		private var _startEndCue:Object;
		private var buttonArray:Array;
		private var _btnState:ButtonState;
		
		private var loading:IVideoState;		
		private var playing:IVideoState;		
		private var waiting:IVideoState;
		
		private var _loadVideo:LoadVideo;	
		private var _state:IVideoState;
		/**
		 * Loads the initial available states and listeners 
		 * 
		 */
		public function MediaStatePlayer(){				
			loading = new LoadingState(this);
			waiting = new WaitingState(this);
			playing = new PlayState(this);
			_btnState = new ButtonState(this);
			ui = new UIGraphics();			
			_loadVideo = new LoadVideo(800,450);						
			init();		
		}			
		
		private function init():void{			
			//add buttons to array, 
			//name should correspond to the cue point name
			//posX, posY are the positions of the buttons relative to the stage
			//image: link to image asset
			//imgW and imgH are the width and height of the image asset
			buttonArray = 	[	
								{name:"pedo1",posX:200, posY:50,image:"assets/see_pediatric.png",imgW:240,imgH:50},
								{name:"pedo2",posX:200, posY:100,image:"assets/see_pediatric.png",imgW:240,imgH:50},
								{name:"pedo3",posX:200, posY:150,image:"assets/see_pediatric.png",imgW:240,imgH:50},
								{name:"pedo4",posX:100, posY:200,image:"assets/see_pediatric.png",imgW:240,imgH:50},
								{name:"pedo5",posX:100, posY:250,image:"assets/see_pediatric.png",imgW:240,imgH:50}								
							];
			
			ui.addBtns(buttonArray);
			_btnArray = ui.uiButtonArray;				
						
			
			//percentage number to start playing the video;
			_loadVideo.startPlayPercent = 5;
			
			//add visual elements order is important
			addChild(_loadVideo.video);	
			addChild(ui);
				
			//intial state is loading state   state = LoadingState.as
			_state = loading;
			state.applyState();
			
		}
		
		public function setLoading(optVideo:String):void{			
			if(optVideo == "high"){			
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_600.flv");
			}
			if(optVideo == "low"){				
				_loadVideo.addVideo("http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/final_400.flv");	
			}
			
			
		}
				
		
		public function playingState():void{				
			//state = PlayState.as
			_state = playing;			
			
		}
		
		public function waitingState():void{			
			//state = WaitingState.as
			_state = waiting;
			getCuePoint("loop");	
			
		}
		
		
		public function getCuePoint(cueName:String):void{			
			var cueArray:Array = video.cueArray;			
			var cuePointObject:Object = new Object();
			trace("triggered cue name: "+cueName);
			for(var i:Number = 0; i < cueArray.length; i++){
				if(video.cueArray[i].name == cueName){					
					cuePointObject = {name:cueName, start:cueArray[i].time, end:cueArray[i+1].time};
				}
			}
			trace("media cue array: "+ cuePointObject.name + " cuePointObject.start: " + cuePointObject.start+ " cuePointObject.end: "+ cuePointObject.end)
			cuePoint = cuePointObject;
			state.applyState();
			state.buttonState();				
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