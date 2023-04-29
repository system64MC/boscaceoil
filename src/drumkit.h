#pragma once

#include <string>
#include <vector>

#include "si-voice.h"

namespace bosca
{
	struct Drumkit
	{
		Drumkit();

		void updatefilter(int cutoff, int resonance);
		void updatevolume(int volume);

		std::vector<sion::Voice> voicelist;
		std::vector<std::string> voicename;
		std::vector<int> voicenote;
		std::vector<int> midivoice;
		std::string kitname;
		int size;
	};
}
