#include "guibutton.h"


namespace bosca {
	
 
	guibutton::guibutton()
		: position(0, 0, 0, 0)
	{
		selected = false;
		active = false;
		visable = false;
		mouseover = false;
	}

	void guibutton::init(int x, int y, int w, int h, std::string contents, std::string act, std::string sty)
	{
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

	void guibutton::press()
	{
		pressed = 6;
	}
}