#include "help.h"

namespace bosca::help
{
	void Glow::init()
	{
		glow = 0;
		glowdir = 0;
		slowsine = 0;
	}
	
	/*
	Number RGB(Number red, Number green, Number blue)
	{
		return (blue | (green << 8) | (red << 16))
	}
	
	void removeObject(Object obj, Array arr)
	{
		std::string i;
		for (i in arr)
		{
			if (arr[i] == obj)
			{
				arr.splice(i, 1)
				break;
			}
		}
	}
	*/
	
	void Glow::updateglow()
	{
		slowsine += 2;
		if (slowsine >= 64) slowsine = 0;
		
		if (glowdir == 0)
		{
			glow += 2;
			if (glow >= 63) glowdir = 1;
		}
		else
		{
			glow -= 2;
			if (glow < 1) glowdir = 0;
		}
	}
	
	bool inbox(int xc, int yc, int x1, int y1, int x2, int y2)
	{
		if (xc >= x1 && xc <= x2)
		{
			if (yc >= y1 && yc <= y2)
			{
				return true;
			}
		}
		return false;
	}
	
	bool inboxw(int xc, int yc, int x1, int y1, int x2, int y2)
	{
		if (xc >= x1 && xc <= x1 + x2)
		{
			if (yc >= y1 && yc <= y1 + y2)
			{
				return true;
			}
		}
		return false;
	}
	
	int Instr(const std::string& s, const std::string& c, int start)
	{
		return (s.find(c, start - 1) + 1);
	}
	
	std::string Mid(const std::string& s, int start, int length)
	{
		return s.substr(start, length);
	}
	
	std::string Left(const std::string& s, int length)
	{
		return s.substr(0, length);
	}
	
	std::string Right(const std::string& s, int length)
	{
		return s.substr(s.length() - length, length);
	}
}
