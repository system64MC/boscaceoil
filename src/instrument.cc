#include <memory>
#include <string>

#include "si-voice.h"

namespace bosca {
	struct instrumentclass {
		instrumentclass() {
			clear();
		}

		void clear() {
			voice = std::make_shared<sion::Voice>();
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

		void changefilterto(int c, int r, int v) {
			if (voice != nullptr) {
				voice->updateVolumes = true;
				voice->velocity = v;
				voice->setFilterEnvelop(0, c, r);
			}
		}

		void changevolumeto(int v) {
			if (voice != nullptr) {
				voice->updateVolumes = true;
				voice->velocity = v;
			}
		}

		int cutoff;
		int resonance;
		std::shared_ptr<sion::Voice> voice;

		std::string category;
		std::string name;
		int palette;
		int type;
		int index;
		int volume;
	};
}
