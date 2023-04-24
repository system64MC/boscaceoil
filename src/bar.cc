#include <vector>

namespace bosca
{
	struct Bar
	{
		Bar()
		{
			for (int i = 0; i < 8; i++)
			{
				channel.push_back(-1);
			}
			clear();
		}

		void clear()
		{
			for (int i = 0; i < 8; i++)
			{
				channel[i] = -1;
			}
		}

		// todo(Gustav): replace with a std::array or a c array
		std::vector<int> channel;
	};
}
