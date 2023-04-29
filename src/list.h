#pragma once

#include <vector>
#include <string>

namespace bosca
{
	struct listclass
	{
		listclass();

		void clear();
		void init(int xp, int yp);
		void close();
		void getwidth();

		std::vector<std::string> item;
		int numitems;
		bool active;
		int x; int y; int w; int h;
		int type;
		int selection;
	};
}
