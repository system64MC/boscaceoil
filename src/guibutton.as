namespace bosca {
	
 
	struct guibutton {
		function guibutton() {
			position = new Rectangle(0, 0, 0, 0);
			selected = false;
			active = false;
			visable = false;
			mouseover = false;
		}
		
		void init(int x, int y, int w, int h, std::string contents, std::string act = "", std::string sty = "normal") {
			position.setTo(x, y, w, h);
			text = contents;
			action = act;
			style = sty;
			
			selected = false;
			moveable = false;
			visable = true;
			active = true;
			onwindow = false;
			textoffset = 0;
			pressed = 0;
		}
		
		void press() {
			pressed = 6;
		}
		
		var Rectangle position;
		var std::string text;
		var std::string action;
		var std::string style;
		
		var bool visable;
		var bool mouseover;
		var bool selected;
		var bool active;
		var bool moveable;
		var bool onwindow;
		
		var int pressed;
		var int textoffset;
	}
}