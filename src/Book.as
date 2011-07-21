package
{
	import flash.display.*;
	import flash.text.*;
	
	import trh.helpers.*;	
	
	public class Book extends Sprite{
		
		private var contactBtn:Sprite = new Sprite();
		private var pedoBtn:Sprite = new Sprite();
		private var bracesBtn:Sprite = new Sprite();
		private var whatBtn:Sprite = new Sprite();
		private var embFonts:EmbedFonts;
		private var loadButtonImage:LoadBitmap;
		private var loadBook:LoadBitmap;
		public var statusTxt:TextField;
		private var buttonLink:ButtonLink;
		private var path:String = "http://www.thesuperdentists.com/Portals/_default/Skins/portalSkin/";
		
		/**
		 *  This is the Book Constructor
		 * 
		 * <p>loads the main book graphic asset <code>book.png</code> for the application and 
		 * contains the direct URL link buttons to other areas of the site. </p>
		 * 	
		 */
		public function Book(){
				
			init()
			
		}
		
		private function init():void{
			
			loadBook = new LoadBitmap(path+"assets/book.png",783,468);
			
			loadButtonImage = new LoadBitmap(path+"assets/contact.png", 52, 103);
			contactBtn.addChild(loadButtonImage.sprite);
			contactBtn.x = 30;
			contactBtn.y = 295;
			new ButtonLink(contactBtn,"http://www.thesuperdentists.com/ContactUs/tabid/398/Default.aspx", "_self");
			
			loadButtonImage = new LoadBitmap(path+"assets/pedo_dent.png", 52, 103);
			pedoBtn.addChild(loadButtonImage.sprite);
			pedoBtn.x = 60;
			pedoBtn.y = 115;
			new ButtonLink(pedoBtn,"http://www.thesuperdentists.com/Default.aspx?alias=www.thesuperdentists.com/pediatric", "_self");
			
			loadButtonImage = new LoadBitmap(path+"assets/braces.png", 52, 103);
			bracesBtn.addChild(loadButtonImage.sprite);
			bracesBtn.x = 680;
			bracesBtn.y = 120;
			new ButtonLink(bracesBtn,"http://www.thesuperdentists.com/Default.aspx?alias=www.thesuperdentists.com/ortho", "_self");
			
			
			loadButtonImage = new LoadBitmap(path+"assets/whats_new.png", 52, 103);
			whatBtn.addChild(loadButtonImage.sprite);			
			whatBtn.x = 700;
			whatBtn.y = 290;
			new ButtonLink(whatBtn,"http://www.thesuperdentists.com/FunStuff/WhatsNew/tabid/355/Default.aspx", "_self");
			
			
			addChild(loadBook.sprite);
			
			addChild(contactBtn);
			addChild(whatBtn);
			addChild(bracesBtn);
			addChild(pedoBtn);
			
			statusMsgField();
		}
		
		/**
		 *  creates the loading status text field for the video player	
		 */
		private function statusMsgField():void	{
			embFonts = new EmbedFonts(20);			
			statusTxt = new TextField;
			statusTxt.defaultTextFormat = embFonts.format;				
			statusTxt.autoSize = TextFieldAutoSize.CENTER;			
			statusTxt.textColor = 0x864328;
			statusTxt.text = "Loading.."; 
			statusTxt.embedFonts = true;			
			statusTxt.x = (this.width/2) - 15;
			statusTxt.y = this.height - (statusTxt.height-5);
			statusTxt.width = 50;
			statusTxt.height = 50;
			addChild(statusTxt);		
		}
		
		public function cleanUp():void{
			removeChild(statusTxt);
			statusTxt = null;
			embFonts = null;
		}
		
		
	}//end Class
}//end Package