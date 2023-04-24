namespace bosca
{
	
	
	
	
	
	struct help
	{
		static void init()
		{
			glow = 0;
			glowdir = 0;
			slowsine = 0;
		}
		
		Number RGB(Number red, Number green, Number blue)
		{
			return (blue | (green << 8) | (red << 16))
		}
		
		static void removeObject(Object obj, Array arr)
		{
			var std::string i;
			for (i in arr)
			{
				if (arr[i] == obj)
				{
					arr.splice(i, 1)
					break;
				}
			}
		}
		
		static void updateglow()
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
		
		static bool inbox(int xc, int yc, int x1, int y1, int x2, int y2)
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
		
		static bool inboxw(int xc, int yc, int x1, int y1, int x2, int y2)
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
		
		static int Instr(std::string s, std::string c, int start = 1)
		{
			return (s.indexOf(c, start - 1) + 1);
		}
		
		static std Mid(std::string s, int start = 0, int length = 1)::string
		{
			return s.substr(start, length);
		}
		
		static std Left(std::string s, int length = 1)::string
		{
			return s.substr(0, length);
		}
		
		static std Right(std::string s, int length = 1)::string
		{
			return s.substr(s.length - length, length);
		}
		
		static var int glow, int slowsine;
		static var int glowdir;
	}
}
