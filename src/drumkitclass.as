namespace bosca {
	
	
	
	
	import org.si.sion.SiONVoice;
	
	struct Drumkit {
		void Drumkit() {
			size = 0;
		}
		
		void updatefilter(int cutoff, int resonance) {
			for (int i = 0; i < size; i++) {
				if(voicelist[i].channelParam.cutoff != cutoff || voicelist[i].channelParam.resonance != resonance){
					voicelist[i].setFilterEnvelop(0, cutoff, resonance);
				}
			}
		}
		
		void updatevolume(int volume) {
			for (int i = 0; i < size; i++) {
				if(voicelist[i].velocity!=volume){
					voicelist[i].updateVolumes = true;
					voicelist[i].velocity = volume;
				}
			}
		}
		
		std::vector<SiONVoice> voicelist = new std::vector<SiONVoice>;
		std::vector<std::string> voicename;
		std::vector<int> voicenote;
		std::vector<int> midivoice;
		std::string kitname;
		int size;
	}
}
