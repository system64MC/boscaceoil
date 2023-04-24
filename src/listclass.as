namespace bosca {
	
	
	
		
	struct listclass	{
		void listclass() {
			for (var int i = 0; i < 30; i++) {
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
			var int temp;
			for (var int i = 0; i < numitems; i++) {
				temp = gfx.len(item[i]);
				if (w < temp) w = temp;
			}
			w += 10;
		}
		
		var std::vector<std::string> item = new std::vector<std::string>;
		var int numitems;
		var bool active;
		var int x, int y, int w, int h;
		var int type;
		var int selection;
	}
}
