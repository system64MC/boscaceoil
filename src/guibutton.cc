#include <string>

#include "rect.h"


namespace bosca {
	
 
	struct guibutton {
		guibutton()
			: position(0, 0, 0, 0)
		{
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

		Rectangle position;
		std::string text;
		std::string action;
		std::string style;

		bool visable;
		bool mouseover;
		bool selected;
		bool active;
		bool moveable;
		bool onwindow;

		int pressed;
		int textoffset;
	};
}