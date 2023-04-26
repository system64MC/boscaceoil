#pragma once


#include <vector>

namespace bosca
{
	struct Bar
	{
		Bar();

		void clear();

		// todo(Gustav): replace with a std::array or a c array
		std::vector<int> channel;
	};
}
