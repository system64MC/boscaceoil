#include <vector>

namespace bosca
{
	struct Rectangle
	{
		int x; int y; int width; int height;
		Rectangle(int, int, int, int);
		void setTo(int, int, int, int);
	};

	struct musicphraseclass {
		musicphraseclass() {
			for (int i = 0; i < 129; i++) {
				notes.push_back(Rectangle(-1, 0, 0, 0));
			}
			for (int i = 0; i < 16; i++) {
				cutoffgraph.push_back(128);
				resonancegraph.push_back(0);
				volumegraph.push_back(256);
			}
			clear();
		}

		void clear() {
			for (int i = 0; i < 128; i++) {
				notes[i].setTo(-1, 0, 0, 0);
			}

			for (int i = 0; i < 16; i++) {
				cutoffgraph[i] = 128;
				resonancegraph[i] = 0;
				volumegraph[i] = 256;
			}
			start = 48; //start at c4
			numnotes = 0;
			instr = 0;
			scale = 0; key = 0;

			palette = 0;
			isplayed = false;

			recordfilter = 0;
			topnote = -1; bottomnote = 250;

			hash = 0;
		}

		void findtopnote() {
			topnote = -1;
			for (int i = 0; i < numnotes; i++) {
				if (notes[i].x > topnote) {
					topnote = notes[i].x;
				}
			}
		}

		void findbottomnote() {
			bottomnote = 250;
			for (int i = 0; i < numnotes; i++) {
				if (notes[i].x < bottomnote) {
					bottomnote = notes[i].x;
				}
			}
		}

		void transpose(int amount) {
			for (int i = 0; i < numnotes; i++) {
				if (notes[i].x != -1) {
#ifdef CONTROL
					if (control::invertpianoroll[notes[i].x] + amount != -1) {
						notes[i].x = control::pianoroll[control::invertpianoroll[notes[i].x] + amount];
					}
#endif
				}
				if (notes[i].x < 0) notes[i].x = 0;
				if (notes[i].x > 104) notes[i].x = 104;
			}
		}

		void addnote(int noteindex, int note, int time) {
			if (numnotes < 128) {
				notes[numnotes].setTo(note, time, noteindex, 0);
				numnotes++;
			}

			if (note > topnote) topnote = note;
			if (note < bottomnote) bottomnote = note;
			notespan = topnote - bottomnote;

			hash = (hash + (note * time)) % 2147483647;
		}

		/// Returns true if there is a note that intersects the cursor position
		bool noteat(int noteindex, int note) {
			for (int i = 0; i < numnotes; i++) {
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						return true;
					}
				}
			}
			return false;
		}

		/// Remove any note that intersects that cursor position!
		void removenote(int noteindex, int note) {
			for (int i = 0; i < numnotes; i++) {
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						deletenote(i);
						i--;
					}
				}
			}

			findtopnote(); findbottomnote(); notespan = topnote - bottomnote;
		}

		void setnotespan() {
			findtopnote(); findbottomnote(); notespan = topnote - bottomnote;
		}

		/// Remove note t, rearrange note vector
		void deletenote(int t) {
			for (int i = t; i < numnotes; i++) {
				notes[i].x = notes[i + 1].x;
				notes[i].y = notes[i + 1].y;
				notes[i].width = notes[i + 1].width;
				notes[i].height = notes[i + 1].height;
			}
			numnotes--;
		}

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
