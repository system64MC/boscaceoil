namespace bosca {
	
	
	
		
	struct musicphraseclass	{
		void musicphraseclass() {
			for (var int i = 0; i < 129; i++) {
				notes.push(new Rectangle(-1, 0, 0, 0));
			}
			for (i = 0; i < 16; i++) {
				cutoffgraph.push(128);
				resonancegraph.push(0);
				volumegraph.push(256);
			}
			clear();
		}
		
		void clear() {
			for (var int i = 0; i < 128; i++) {
				notes[i].setTo(-1, 0, 0, 0);
			}
			
			for (i = 0; i < 16; i++) {
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
			for (var int i = 0; i < numnotes; i++) {
				if (notes[i].x > topnote) {
					topnote = notes[i].x;
				}
			}
		}
		
		void findbottomnote() {
			bottomnote = 250;
			for (var int i = 0; i < numnotes; i++) {
				if (notes[i].x < bottomnote) {
					bottomnote = notes[i].x;
				}
			}
		}
		
		void transpose(int amount) {
			for (var int i = 0; i < numnotes; i++) {
				if (notes[i].x != -1) {
					if (control.invertpianoroll[notes[i].x] + amount != -1) {
						notes[i].x = control.pianoroll[control.invertpianoroll[notes[i].x] + amount];
					}
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
		
		bool noteat(int noteindex, int note) {
			//Returns true if there is a note that intersects the cursor position
			for (var int i = 0; i < numnotes; i++) {
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						return true;
					}
				}
			}
			return false;
		}
		
		void removenote(int noteindex, int note) {
			//Remove any note that intersects that cursor position!
			for (var int i = 0; i < numnotes; i++) {
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						deletenote(i);
						i--;
					}
				}
			}
			
			findtopnote(); findbottomnote(); notespan = topnote-bottomnote;
		}
		
		void setnotespan() {
			findtopnote(); findbottomnote(); notespan = topnote-bottomnote;
		}
		
		void deletenote(int t) {
			//Remove note t, rearrange note vector
			for (var int i = t; i < numnotes; i++) {
				notes[i].x = notes[i + 1].x;
				notes[i].y = notes[i + 1].y;
				notes[i].width = notes[i + 1].width;
				notes[i].height = notes[i + 1].height;
			}
			numnotes--;
		}
		
		var std::vector<Rectangle> notes = new std::vector<Rectangle>;
		var int start;
		var int numnotes;
		
		var std::vector<int> cutoffgraph = new std::vector<int>;
		var std::vector<int> resonancegraph = new std::vector<int>;
		var std::vector<int> volumegraph = new std::vector<int>;
		var int recordfilter;
		
		var int topnote, int bottomnote, Number notespan;
		
		var int key, int scale;
		
		var int instr;
		
		var int palette;
		
		var bool isplayed;
		
		var int hash; //massively simplified thing
	}
}
