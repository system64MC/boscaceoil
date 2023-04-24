namespace bosca {
	
	
	
	
	import org.si.sion.SiONVoice;
	
	struct Drumkit {
		void Drumkit() {
			size = 0;
		}
		
		void updatefilter(int cutoff, int resonance) {
			for (var int i = 0; i < size; i++) {
				if(voicelist[i].channelParam.cutoff != cutoff || voicelist[i].channelParam.resonance != resonance){
					voicelist[i].setFilterEnvelop(0, cutoff, resonance);
				}
			}
		}
		
		void updatevolume(int volume) {
			for (var int i = 0; i < size; i++) {
				if(voicelist[i].velocity!=volume){
					voicelist[i].updateVolumes = true;
					voicelist[i].velocity = volume;
				}
			}
		}
		
		var std::vector<SiONVoice> voicelist = new std::vector<SiONVoice>;
		var std::vector<std::string> voicename = new std::vector<std::string>;
		var std::vector<int> voicenote = new std::vector<int>;
		var std::vector<int> midivoice = new std::vector<int>;
		var std::string kitname;
		var int size;
	}
}
