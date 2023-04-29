#pragma once

#include <vector>
#include <string>

namespace bosca
{
	struct voicelistclass
	{
		voicelistclass();
		
		void init();
		
		void fixlengths();
		
		void create(std::string cat, std::string t1, std::string t2, int pal, int midimapping = -1);
		
		/// Make sublist based on category
		void makesublist(std::string cat);
		
		void add(std::string t1, std::string t2, int pal);
		
		/// Return the index of the first member of this category
		int getfirst(std::string cat);
		
		/// Return the index of the last member of this category
		int getlast(std::string cat);
		
		/// Get the voice by name, return index
		int getvoice(std::string n);
		
		/// Given current instrument, get the next instrument in this category
		int getnext(int current);
		
		/// Given current instrument, get the previous instrument in this category
		int getprevious(int current);
		
		std::vector<std::string> category;
		std::vector<std::string> name;
		std::vector<std::string> voice;
		std::vector<int> palette;
		std::vector<int> midimap;
		
		std::vector<std::string> subname;
		std::vector<std::string> subvoice;
		std::vector<int> subpalette;
		int sublistsize;
		
		int listsize;
		int index;
		int pagenum;
	};
}
