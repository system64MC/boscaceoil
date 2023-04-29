#include "drumkit.h"

namespace bosca {
	Drumkit::Drumkit() {
		size = 0;
	}

	void Drumkit::updatefilter(int cutoff, int resonance) {
		for (int i = 0; i < size; i++) {
			if (voicelist[i].channelParam.cutoff != cutoff || voicelist[i].channelParam.resonance != resonance) {
				voicelist[i].setFilterEnvelop(0, cutoff, resonance);
			}
		}
	}

	void Drumkit::updatevolume(int volume) {
		for (int i = 0; i < size; i++) {
			if (voicelist[i].velocity != volume) {
				voicelist[i].updateVolumes = true;
				voicelist[i].velocity = volume;
			}
		}
	}
}
