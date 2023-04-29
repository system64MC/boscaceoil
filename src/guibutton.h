#pragma once


#include <string>

#include "rect.h"


namespace bosca
{
	struct guibutton
	{
		guibutton();

		void init(int x, int y, int w, int h, std::string contents, std::string act = "", std::string sty = "normal");
		void press();

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