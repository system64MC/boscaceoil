#pragma once

namespace sion
{
	struct Voice
	{
		struct ChannelParam
		{
			int cutoff;
			int resonance;
		};

		ChannelParam channelParam;
		int velocity;
		bool updateVolumes;

		void setFilterEnvelop(int, int cutoff, int resonance);
	};
}

