#pragma once

#include <memory>
#include <string>

#include "si-voice.h"

namespace bosca
{
	struct instrumentclass
	{
		instrumentclass();

		void clear();
		void setfilter(int c, int r);
		void setvolume(int v);
		void updatefilter();
		void changefilterto(int c, int r, int v);
		void changevolumeto(int v);

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
