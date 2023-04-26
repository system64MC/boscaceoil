#include "bar.h"

namespace bosca
{
	Bar::Bar()
	{
		for (int i = 0; i < 8; i++)
		{
			channel.push_back(-1);
		}
		clear();
	}

	void Bar::clear()
	{
		for (int i = 0; i < 8; i++)
		{
			channel[i] = -1;
		}
	}
}
