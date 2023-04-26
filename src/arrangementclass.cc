#include "bar.h"


namespace bosca {
		
	struct Arrangement	{
		Arrangement() {
			for (int i = 0; i < 1000; i++) {
				bar.push_back(Bar{});
			}
			for (int i = 0; i < 100; i++) {
				copybuffer.push_back(Bar{});
			}
			copybuffersize = 0;
			
			for (int i = 0; i < 8; i++) {
				channelon.push_back(true);
			}
			clear();
		}
		
		void copy() {
			for (int i = loopstart; i < loopend; i++) {
				for (int j = 0; j < 8; j++) {
					copybuffer[i-loopstart].channel[j] = bar[i].channel[j];
				}
			}
			copybuffersize = loopend-loopstart;
		}
		
		void paste(int t) {
			for (int i = 0; i < copybuffersize; i++) {
				insertbar(t);
			}
			
			for (int i = t; i < t + copybuffersize; i++) {
				for (int j = 0; j < 8; j++) {
					bar[i].channel[j] = copybuffer[i - t].channel[j];
				}
			}
		}
		
		void clear() {
			loopstart = 0;
			loopend = 1;
			currentbar = 0;
			
			for (int i = 0; i < lastbar; i++) {
				for (int j = 0; j < 8; j++) {
					bar[i].channel[j] = -1;
				}
			}
			
			lastbar = 1;
		}
		
		void addpattern(int a, int b, int t) {
			bar[a].channel[b] = t;
			if (a + 1 > lastbar) lastbar = a + 1;
		}
		
		void removepattern(int a, int b) {
			bar[a].channel[b] = -1;
			int lbcheck = 0;
			for (int i = 0; i <= lastbar; i++) {
				for (int j = 0; j < 8; j++) {
					if (bar[i].channel[j] > -1) {
						lbcheck = i;
					}
				}
			}
			lastbar = lbcheck + 1;
		}
		
		void insertbar(int t) {
			for (int i = lastbar+1; i > t; i--) {
				for (int j = 0; j < 8; j++) {
					bar[i].channel[j] = bar[i - 1].channel[j];
				}
			}
			for (int j = 0; j < 8; j++) {
				bar[t].channel[j] = -1;
			}
			lastbar++;
		}
		
		void deletebar(int t) {
			for (int i = t; i < lastbar+1; i++) {
				for (int j = 0; j < 8; j++) {
					bar[i].channel[j] = bar[i + 1].channel[j];
				}
			}
			lastbar--;
		}
		
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
