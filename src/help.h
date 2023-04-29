#pragma once

#include <string>

namespace bosca::help
{
	struct Glow
	{
		int glow = 0;
		int slowsine = 0;
		int glowdir = 0;

		void init();
		void updateglow();
	};
	bool inbox(int xc, int yc, int x1, int y1, int x2, int y2);
	bool inboxw(int xc, int yc, int x1, int y1, int x2, int y2);
	
	int Instr(const std::string& s, const std::string& c, int start = 1);
	std::string Mid(const std::string& s, int start = 0, int length = 1);
	std::string Left(const std::string& s, int length = 1);
	std::string Right(const std::string& s, int length = 1);
}
