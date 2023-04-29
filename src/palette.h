#pragma once

namespace bosca
{
	struct paletteclass
	{
		paletteclass();

		void setto(int r1, int g1, int b1);
		void transition(int r1, int g1, int b1, int speed = 5);
		void fixbounds();

		int r;
		int g;
		int b;
	};
}
