#pragma once

namespace bosca
{
	struct Rectangle
	{
		int x; int y; int width; int height;
		Rectangle(int, int, int, int);
		void setTo(int, int, int, int);
	};
}
