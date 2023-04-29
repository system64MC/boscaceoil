#include "instrument.h"

namespace bosca
{
	
	instrumentclass::instrumentclass() {
		clear();
	}

	void instrumentclass::clear() {
		voice = std::make_shared<sion::Voice>();
		category = "MIDI";
		name = "Grand Piano"; type = 0; index = 0;
		cutoff = 128; resonance = 0;
		palette = 0;
		volume = 256;
	}

	void instrumentclass::setfilter(int c, int r) {
		cutoff = c; resonance = r;
	}

	void instrumentclass::setvolume(int v) {
		volume = v;
	}

	void instrumentclass::updatefilter() {
		if (voice != nullptr) {
			if (voice->velocity != volume) {
				voice->updateVolumes = true;
				voice->velocity = volume;
			}
			if (voice->channelParam.cutoff != cutoff || voice->channelParam.resonance != resonance) {
				voice->setFilterEnvelop(0, cutoff, resonance);
			}
		}
	}

	void instrumentclass::changefilterto(int c, int r, int v) {
		if (voice != nullptr) {
			voice->updateVolumes = true;
			voice->velocity = v;
			voice->setFilterEnvelop(0, c, r);
		}
	}

	void instrumentclass::changevolumeto(int v) {
		if (voice != nullptr) {
			voice->updateVolumes = true;
			voice->velocity = v;
		}
	}
}
