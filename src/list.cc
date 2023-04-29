#include "list.h"

namespace bosca {
	
	listclass::listclass() {
		for (int i = 0; i < 30; i++) {
			item.push_back("");
		}
		clear();
	}

	void listclass::clear() {
		numitems = 0;
		active = false;
		x = 0; y = 0;
		selection = -1;
	}

	void listclass::init(int xp, int yp) {
		x = xp; y = yp; active = true;
		getwidth();
#ifdef GFX
		h = numitems * gfx.linesize;
#endif
	}

	void listclass::close() {
		active = false;
	}

	void listclass::getwidth() {
		w = 0;
		for (int i = 0; i < numitems; i++) {
#ifdef GFX
			const auto temp = gfx.len(item[i]);
			if (w < temp) w = temp;
#endif
		}
		w += 10;
	}
}
