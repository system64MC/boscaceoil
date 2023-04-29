#pragma once


#include <vector>

#include "rect.h"

namespace bosca
{
	struct musicphraseclass
	{
		musicphraseclass();

		void clear();

		void findtopnote();

		void findbottomnote();

		void transpose(int amount);

		void addnote(int noteindex, int note, int time);

		/// Returns true if there is a note that intersects the cursor position
		bool noteat(int noteindex, int note);

		/// Remove any note that intersects that cursor position!
		void removenote(int noteindex, int note);

		void setnotespan();

		/// Remove note t, rearrange note vector
		void deletenote(int t);

		std::vector<Rectangle> notes;
		int start;
		int numnotes;
		std::vector<int> cutoffgraph;
		std::vector<int> resonancegraph;
		std::vector<int> volumegraph;
		int recordfilter;
		int topnote; int bottomnote; float notespan;
		int key; int scale;
		int instr;
		int palette;
		bool isplayed;
		int hash; //massively simplified thing
	};
}
