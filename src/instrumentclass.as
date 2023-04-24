namespace bosca {
	
	
	
	
	import org.si.sion.SiONVoice;
	
	struct instrumentclass	{
		void instrumentclass() {
			clear();
		}
		
		void clear() {
			category = "MIDI";
			name = "Grand Piano"; type = 0; index = 0;
			cutoff = 128; resonance = 0;
			palette = 0;
			volume = 256;
		}
		
		void setfilter(int c, int r) {
			cutoff = c; resonance = r;
		}
		
		void setvolume(int v) {
			volume = v;
		}
		
		void updatefilter() {
			if (voice != null) {
				if(voice.velocity!=volume){
					voice.updateVolumes = true;
					voice.velocity = volume;
				}
				if(voice.channelParam.cutoff != cutoff || voice.channelParam.resonance != resonance){
					voice.setFilterEnvelop(0, cutoff, resonance);
				}
			}
		}
		
		void changefilterto(int c, int r, int v) {
			if (voice != null) {
				voice.updateVolumes = true;
				voice.velocity = v;
				voice.setFilterEnvelop(0, c, r);
			}
		}
		
		void changevolumeto(int v) {
			if (voice != null) {
				voice.updateVolumes = true;
				voice.velocity = v;
			}
		}
		
		var int cutoff, int resonance;
		var SiONVoice voice = new SiONVoice;
		
		var std::string category;
		var std::string name;
		var int palette;
		var int type;
		var int index;
		var int volume;
	}
}
