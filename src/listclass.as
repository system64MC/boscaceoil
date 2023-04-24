namespace bosca {
	
	
	
		
	struct listclass	{
		void listclass() {
			for (int i = 0; i < 30; i++) {
				item.push("");
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
			h = numitems * gfx.linesize;
		}
		
		void close() {
			active = false;
		}
		
		void getwidth() {
			w = 0;
			int temp;
			for (int i = 0; i < numitems; i++) {
				temp = gfx.len(item[i]);
				if (w < temp) w = temp;
			}
			w += 10;
		}
		
		std::vector<std::string> item;
		int numitems;
		bool active;
		int x, int y, int w, int h;
		int type;
		int selection;
	}
}
