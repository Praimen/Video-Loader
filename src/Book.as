package
{
	import flash.display.*;
		
	import trh.helpers.*;
	
	
	public class Book extends Sprite
	{
		private var contactBtn:Sprite = new Sprite();
		private var pedoBtn:Sprite = new Sprite();
		private var bracesBtn:Sprite = new Sprite();
		private var whatBtn:Sprite = new Sprite();
		private var loadButtonImage:LoadBitmap;
		private var loadBook:LoadBitmap;
		
		
		public function Book()
		{
				
			
			loadBook = new LoadBitmap("assets/book.png",783,468);
			
			loadButtonImage = new LoadBitmap("assets/contact.png", 52, 103);
			contactBtn.addChild(loadButtonImage.sprite);
			contactBtn.x = 20;
			contactBtn.y = 285;
			new ButtonLink(contactBtn,"http://www.thesuperdentists.com/ContactUs/tabid/398/Default.aspx", "_self")
			
			loadButtonImage = new LoadBitmap("assets/pedo_dent.png", 52, 103);
			pedoBtn.addChild(loadButtonImage.sprite);
			pedoBtn.x = 60;
			pedoBtn.y = 140;
			new ButtonLink(pedoBtn,"http://www.thesuperdentists.com/Default.aspx?alias=www.thesuperdentists.com/pediatric", "_self");
			
			loadButtonImage = new LoadBitmap("assets/braces.png", 52, 103);
			bracesBtn.addChild(loadButtonImage.sprite);
			bracesBtn.x = 650;
			bracesBtn.y = 140;
			new ButtonLink(bracesBtn,"http://www.thesuperdentists.com/Default.aspx?alias=www.thesuperdentists.com/ortho", "_self");
			
			
			loadButtonImage = new LoadBitmap("assets/whats_new.png", 52, 103);
			whatBtn.addChild(loadButtonImage.sprite);			
			whatBtn.x = 680;
			whatBtn.y = 270;
			new ButtonLink(whatBtn,"http://www.thesuperdentists.com/FunStuff/WhatsNew/tabid/355/Default.aspx", "_self");
			
			
			addChild(loadBook.sprite);
			
			addChild(contactBtn);
			addChild(whatBtn);
			addChild(bracesBtn);
			addChild(pedoBtn);
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}//end Class
}//end Package