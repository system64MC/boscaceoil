#pragma once

#include "bar.h"


namespace bosca
{		
	struct Arrangement
	{
		Arrangement();
		
		void copy();
		void paste(int t);
		void clear();
		
		void addpattern(int a, int b, int t);
		void removepattern(int a, int b);
		void insertbar(int t);
		void deletebar(int t);
		
		std::vector<Bar> copybuffer;
		int copybuffersize;
		std::vector<Bar> bar;
		std::vector<bool> channelon;
		int loopstart;
		int loopend;
		int currentbar;
		int lastbar;
		int viewstart;
	};
}
