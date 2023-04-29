#include <vector>
#include <string>

namespace bosca {
	struct listclass {
		listclass() {
			for (int i = 0; i < 30; i++) {
				item.push_back("");
			}
			clear();
		}

		void clear() {
			numitems = 0;
			active = false;
			x = 0; y = 0;
			selection = -1;
		}

		void init(int xp, int yp) {
			x = xp; y = yp; active = true;
			getwidth();
#ifdef GFX
			h = numitems * gfx.linesize;
#endif
		}

		void close() {
			active = false;
		}

		void getwidth() {
			w = 0;
			int temp;
			for (int i = 0; i < numitems; i++) {
#ifdef GFX
				temp = gfx.len(item[i]);
#endif
				if (w < temp) w = temp;
			}
			w += 10;
		}

		std::vector<std::string> item;
		int numitems;
		bool active;
		int x; int y; int w; int h;
		int type;
		int selection;
	};
}
