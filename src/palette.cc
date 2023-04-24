namespace bosca {
	
	
	
		
	struct paletteclass {
		paletteclass() {
			r = 0; g = 0; b = 0;
		}

		void setto(int r1, int g1, int b1) {
			r = r1; g = g1; b = b1;
			fixbounds();
		}

		void transition(int r1, int g1, int b1, int speed = 5) {
			if (r < r1) { r += speed;	if (r > r1) r = r1; }
			if (g < g1) { g += speed;	if (g > g1) g = g1; }
			if (b < b1) { b += speed;	if (b > b1) b = b1; }

			if (r > r1) { r -= speed;	if (r < r1) r = r1; }
			if (g > g1) { g -= speed;	if (g < g1) g = g1; }
			if (b > b1) { b -= speed;	if (b < b1) b = b1; }

			fixbounds();
		}

		void fixbounds() {
			if (r <= 0) r = 0;		if (g <= 0) g = 0;		if (b <= 0) b = 0;
			if (r > 255) r = 255;	if (g > 255) g = 255;	if (b > 255) b = 255;
		}

		int r;
		int g;
		int b;
	};
}
