// temporary: ignore the entire contents of this file when building for web
CONFIG::desktop {
namespace bosca {
	
	
	
	
	
	import flash.filesystem.*;
	import org.si.sion.midi.*;
	import org.si.sion.events.*;
	
	struct midicontrol {
		static int MIDIDRUM_35_Acoustic_Bass_Drum = 35;
		static int MIDIDRUM_36_Bass_Drum_1 = 36;
		static int MIDIDRUM_37_Side_Stick = 37;
		static int MIDIDRUM_38_Acoustic_Snare = 38;
		static int MIDIDRUM_39_Hand_Clap = 39;
		static int MIDIDRUM_40_Electric_Snare = 40;
		static int MIDIDRUM_41_Low_Floor_Tom = 41;
		static int MIDIDRUM_42_Closed_Hi_Hat = 42;
		static int MIDIDRUM_43_High_Floor_Tom = 43;
		static int MIDIDRUM_44_Pedal_Hi_Hat = 44;
		static int MIDIDRUM_45_Low_Tom = 45;
		static int MIDIDRUM_46_Open_Hi_Hat = 46;
		static int MIDIDRUM_47_Low_Mid_Tom = 47;
		static int MIDIDRUM_48_Hi_Mid_Tom = 48;
		static int MIDIDRUM_49_Crash_Cymbal_1 = 49;
		static int MIDIDRUM_50_High_Tom = 50;
		static int MIDIDRUM_51_Ride_Cymbal_1 = 51;
		static int MIDIDRUM_52_Chinese_Cymbal = 52;
		static int MIDIDRUM_53_Ride_Bell = 53;
		static int MIDIDRUM_54_Tambourine = 54;
		static int MIDIDRUM_55_Splash_Cymbal = 55;
		static int MIDIDRUM_56_Cowbell = 56;
		static int MIDIDRUM_57_Crash_Cymbal_2 = 57;
		static int MIDIDRUM_58_Vibraslap = 58;
		static int MIDIDRUM_59_Ride_Cymbal_2 = 59;
		static int MIDIDRUM_60_Hi_Bongo = 60;
		static int MIDIDRUM_61_Low_Bongo = 61;
		static int MIDIDRUM_62_Mute_Hi_Conga = 62;
		static int MIDIDRUM_63_Open_Hi_Conga = 63;
		static int MIDIDRUM_64_Low_Conga = 64;
		static int MIDIDRUM_65_High_Timbale = 65;
		static int MIDIDRUM_66_Low_Timbale = 66;
		static int MIDIDRUM_67_High_Agogo = 67;
		static int MIDIDRUM_68_Low_Agogo = 68;
		static int MIDIDRUM_69_Cabasa = 69;
		static int MIDIDRUM_70_Maracas = 70;
		static int MIDIDRUM_71_Short_Whistle = 71;
		static int MIDIDRUM_72_Long_Whistle = 72;
		static int MIDIDRUM_73_Short_Guiro = 73;
		static int MIDIDRUM_74_Long_Guiro = 74;
		static int MIDIDRUM_75_Claves = 75;
		static int MIDIDRUM_76_Hi_Wood_Block = 76;
		static int MIDIDRUM_77_Low_Wood_Block = 77;
		static int MIDIDRUM_78_Mute_Cuica = 78;
		static int MIDIDRUM_79_Open_Cuica = 79;
		static int MIDIDRUM_80_Mute_Triangle = 80;
		static int MIDIDRUM_81_Open_Triangle = 81;
		
		static void openfile() {
			control.stopmusic();	
			
			if (!control.filepath)
			{
				control.filepath = control.defaultDirectory;
			}
			file = control.filepath.resolvePath("");
			file.addEventListener(Event.SELECT, onloadmidi);
			file.browseForOpen("Load .mid File", [midiFilter]);
			
			control.fixmouseclicks = true;
		}
		
		static void savemidi() {
			control.stopmusic();
			
			if (!control.filepath)
			{
				control.filepath = control.defaultDirectory;
			}
			file = control.filepath.resolvePath("*.mid");
			file.addEventListener(Event.SELECT, onsavemidi);
			file.browseForSave("Save .mid File");
			
			control.fixmouseclicks = true;
		}
		
		private static void onsavemidi(Event e) {		
			file = e.currentTarget as File;
			
			if (!control.fileHasExtension(file, "mid")) {
				control.addExtensionToFile(file, "mid");
			}
			
			convertceoltomidi();
			
			tempbytes = new ByteArray();
			tempbytes = clone(midiexporter.midifile.output());
			
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(tempbytes, 0, tempbytes.length);
			stream.close();
			
			control.fixmouseclicks = true;
			control.showmessage("SONG EXPORTED AS MIDI");
			control.savefilesettings();
		}
		
		private static void onloadmidi(Event e) {	
			mididata = new ByteArray();
			file = e.currentTarget as File;
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(mididata);
			stream.close();
			
			tempbytes = new ByteArray;
			tempbytes = clone(mididata);
			midiexporter = new Midiexporter;
			midiexporter.midifile.input(tempbytes);
			
			smfData.loadBytes(mididata);
			
			SMFTrack track;
			SMFEvent event;
			
			clearnotes();
			resetinstruments();
			
			//trace(smfData.toString());
			
			for (int trackn = 0; trackn < smfData.numTracks; trackn++) {
				//trace("Reading track " + std::string(trackn) + ": " + std::string(smfData.tracks[trackn].sequence.length));
				for each(event in smfData.tracks[trackn].sequence) {
					//trace("msg: " + std::string(event.time) + ": " + event.toString());
					switch (event.type & 0xf0) {
						case SMFEvent.NOTE_ON:
							if(event.velocity == 0) {
								//This is *actually* a note off event in disguise
								changenotelength(event.time, event.note, event.channel);
							}else{
								addnote(event.time, event.note, event.channel);
								if (event.velocity > channelvolume[event.channel]) {
									channelvolume[event.channel] = event.velocity;
								}
							}
						break;
						case SMFEvent.NOTE_OFF:
							changenotelength(event.time, event.note, event.channel);
						break;
						case SMFEvent.PROGRAM_CHANGE:
							channelinstrument[event.channel] = event.value;
						break;
					}
				}
			} 
			
			//channelinstrument[9] = 142;
			channelinstrument[9] = control.voicelist.getvoice("Simple Drumkit");
			
			convertmiditoceol();
			
			control.arrange.currentbar = 0; control.arrange.viewstart = 0;
			control.changemusicbox(0);
			
			/*
			control._driver.setBeatCallbackInterval(1);
			control._driver.setTimerInterruption(1, null);
			control._driver.play(smfData, false);
			*/
			
			control.showmessage("MIDI IMPORTED");
			control.fixmouseclicks = true;
			control.savefilesettings();
		}
		
		static function clone(Object source):* { 
			ByteArray myBA = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
		
		static void resetinstruments() {
			if (channelinstrument.length == 0) {
				for (int i = 0; i < 16; i++) {
					channelinstrument.push(-1);
					channelvolume.push(0);
				}
			}else {
				for (i = 0; i < 16; i++) {
					channelinstrument[i] = -1;
					channelvolume[i] = 0;
				}
			}
		}
		
		static void clearnotes() {
			unmatchednotes = new std::vector<Rectangle>;
			midinotes = new std::vector<Rectangle>;
		}
		
		static void addnote(int time, int note, int instr) {
			unmatchednotes.push(new Rectangle(time, note, 0, instr));
			//trace("adding note: ", time, note, instr);
		}
		
		static void changenotelength(int time, int note, int instr) {
			//Find the first note of that pitch and instrument BEFORE given time.
			int timedist = -1;
			int currenttimedist = 0;
			int matchingnote = -1;
			for (int i = 0; i < unmatchednotes.length; i++) {
				if (unmatchednotes[i].y == note && unmatchednotes[i].height == instr) {
					currenttimedist = time - unmatchednotes[i].x;
					if (currenttimedist >= 0) {
						if (timedist == -1) {
							timedist = currenttimedist;
							matchingnote = i;
						}else {
							if (currenttimedist < timedist) {
								timedist = currenttimedist;
								matchingnote = i;
							}
						}
					}
				}
			}
			
			if (matchingnote != -1) {
				unmatchednotes[matchingnote].width = -1;
				midinotes.push(new Rectangle(unmatchednotes[matchingnote].x, 
																		 unmatchednotes[matchingnote].y, 
																		 time, 
																		 unmatchednotes[matchingnote].height));
				
				//Swap matching note with last note, and pop it off
				if (matchingnote != unmatchednotes.length - 1) {					
					int swp;
					
					swp = unmatchednotes[matchingnote].x;
					unmatchednotes[matchingnote].x = unmatchednotes[unmatchednotes.length - 1].x;
					unmatchednotes[unmatchednotes.length - 1].x = swp;
					
					swp = unmatchednotes[matchingnote].y;
					unmatchednotes[matchingnote].y = unmatchednotes[unmatchednotes.length - 1].y;
					unmatchednotes[unmatchednotes.length - 1].y = swp;
					
					swp = unmatchednotes[matchingnote].width;
					unmatchednotes[matchingnote].width = unmatchednotes[unmatchednotes.length - 1].width;
					unmatchednotes[unmatchednotes.length - 1].width = swp;
					
					swp = unmatchednotes[matchingnote].height;
					unmatchednotes[matchingnote].height = unmatchednotes[unmatchednotes.length - 1].height;
					unmatchednotes[unmatchednotes.length - 1].height = swp;
				}
			}
			
			if (unmatchednotes.length > 0) {
				if (unmatchednotes[unmatchednotes.length - 1].width == -1) {
					unmatchednotes.pop();
				}
			}
		}
		
		static int getsonglength() {
			return int(smfData.measures);
		}
		
		static int reversechannelinstrument(int t) {
			//Given instrument number t, return first channel using it.
			for (int i = 0; i < 16; i++) {
				if (channelinstrument[i] == t) return i;
			}
			return -1;
		}
		
		static int gettopbox(int currentpattern, int chan) {
			//return the first musicbox to either match instrument or be empty
			if (chan == 9) {
				//Drums, put it on the last row
				if(control.arrange.bar[currentpattern].channel[7] == -1) {
					return 7;
				}else {
					if (reversechannelinstrument(channelinstrument[control.musicbox[control.arrange.bar[currentpattern].channel[7]].instr]) == reversechannelinstrument(channelinstrument[chan])) {
						return 7;
					}	
				}
			}
			
			
			for (int i = 0; i < 8; i++) {
				if(control.arrange.bar[currentpattern].channel[i] == -1) {
					return i;
				}else {
					if (channelinstrument[chan] != -1) {
						if (reversechannelinstrument(channelinstrument[control.musicbox[control.arrange.bar[currentpattern].channel[i]].instr]) == reversechannelinstrument(channelinstrument[chan])) {
							return i;
						}	
					}					
				}
			}
			return -1;
		}
		
		static int getmusicbox(int currentpattern, int chan) {
			//Find (or create a new) music box at the position we're placing the note.
			int top = gettopbox(currentpattern, chan);
			
			if (top > -1) {
				if (control.arrange.bar[currentpattern].channel[top] == -1) {
					control.currentinstrument = chan;
					if (channelinstrument[chan] > -1) {
						control.voicelist.index = channelinstrument[chan];
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}else {
						control.voicelist.index = 0;
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}
					control.addmusicbox();
					control.arrange.addpattern(currentpattern, top, control.numboxes - 1);
					return control.numboxes - 1;
				}else {
					return control.arrange.bar[currentpattern].channel[top];
				}
			}
			
			return -1;
		}
		
		static void addnotetoceol(int currentpattern, int time, int pitch, int notelength, int chan) {
			//control.musicbox[currentpattern + (instr * numpatterns)].addnote(time, pitch, notelength);
			currentpattern = getmusicbox(currentpattern, chan);
			if(currentpattern>-1){
				control.musicbox[currentpattern].addnote(time, pitch, notelength);
			}
		}
		
		static void replaceontimeline(int _old, int _new) {
			for (int i = 0; i < numpatterns; i++) {
				for (int j = 0; j < 8; j++) {
					if (control.arrange.bar[i].channel[j] == _old) {
						control.arrange.bar[i].channel[j] = _new;
					}
				}
			}
		}
		
		static bool musicboxmatch(int a, int b) {
			if (control.musicbox[a].numnotes == control.musicbox[b].numnotes) {
				if (control.musicbox[a].instr == control.musicbox[b].instr) {
					for (int i = 0; i < control.musicbox[a].numnotes; i++) {
						if (control.musicbox[a].notes[i].x != control.musicbox[b].notes[i].x) {
							return false;
						}
					}
					return true;
				}
			}
			return false;
		}
		
		static void convertmiditoceol() {
			control.newsong();
			control.numboxes = 0;
			control.bpm = (smfData.bpm - (smfData.bpm % 5));
			if (control.bpm <= 10) control.bpm = 120;
			control._driver.bpm = control.bpm;
			control._driver.play(null, false);
			
			//for (int tst = 0; tst < 16; tst++) {
			//	trace("channel " + std::string(tst) + " uses instrument " + std::string(channelinstrument[tst]) + " at volume " + std::string(channelvolume[tst]));
			//}
			
			resolution = smfData.resolution;
			signature = smfData.signature_d;
			numnotes = smfData.signature_d * smfData.signature_n;
			if (signature == 0 || numnotes == 0) {
				signature = 4;
				numnotes = 16;
			}
			if (numnotes > 16) control.doublesize = true;
			
			int boxsize = resolution;
			numpatterns = getsonglength();
			control.numboxes = 0;
			control.arrange.bar[0].channel[0] = -1;
			
			control.numinstrument = 16;
			for (int j = 0; j < 16; j++) {
				control.currentinstrument = j;
				control.voicelist.index = 132; //Set to chiptune noise if not used
				control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					
				if (channelinstrument[j] > -1) {
					control.voicelist.index = channelinstrument[j];
					control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					
					control.instrument[control.currentinstrument].setvolume((channelvolume[j] * 256) / 128);
					control.instrument[control.currentinstrument].updatefilter();
					if (control.instrument[control.currentinstrument].type > 0) {
						control.drumkit[control.instrument[control.currentinstrument].type-1].updatevolume((channelvolume[j] * 256) / 128);
					}
				}
			}
			
			int i;
			int note;
			int notelength;
			int currentpattern;
			
			for (i = 0; i < midinotes.length; i++) {
				//Drums
				if (int(midinotes[i].height) == 9) {
					//x = time
					//y = note
					//w = length
					//h = instrument
					note = ((midinotes[i].x * numnotes) / boxsize);
					notelength = (((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1;
					currentpattern = int((midinotes[i].x	- (midinotes[i].x % boxsize)) / boxsize);
					
					int drumnote = 0;
					
					//0 "Bass Drum 1"
					//1 "Bass Drum 2"
					//2 "Bass Drum 3"
					//3 "Snare Drum"
					//4 "Snare Drum 2"
					//5 "Open Hi-Hat"
					//6 "Closed Hi-Hat"
					//7 "Crash Cymbal"
					switch(midinotes[i].y) {
						case MIDIDRUM_35_Acoustic_Bass_Drum: drumnote = 0; break;
						case MIDIDRUM_36_Bass_Drum_1: drumnote = 1; break;
						case MIDIDRUM_37_Side_Stick: drumnote = 3; break;
						case MIDIDRUM_38_Acoustic_Snare: drumnote = 3; break;
						case MIDIDRUM_39_Hand_Clap: drumnote = 1; break;
						case MIDIDRUM_40_Electric_Snare: drumnote = 4; break;
						case MIDIDRUM_41_Low_Floor_Tom: drumnote = 1; break;
						case MIDIDRUM_42_Closed_Hi_Hat: drumnote = 6; break;
						case MIDIDRUM_43_High_Floor_Tom: drumnote = 2; break;
						case MIDIDRUM_44_Pedal_Hi_Hat: drumnote = 5; break;
						case MIDIDRUM_45_Low_Tom: drumnote = 1; break;
						case MIDIDRUM_46_Open_Hi_Hat: drumnote = 5; break;
						case MIDIDRUM_47_Low_Mid_Tom: drumnote = 1; break;
						case MIDIDRUM_48_Hi_Mid_Tom: drumnote = 2; break;
						case MIDIDRUM_49_Crash_Cymbal_1: drumnote = 7; break;
						case MIDIDRUM_50_High_Tom: drumnote = 2; break;
						case MIDIDRUM_51_Ride_Cymbal_1: drumnote = 7; break;
						case MIDIDRUM_52_Chinese_Cymbal: drumnote = 7; break;
						case MIDIDRUM_53_Ride_Bell: drumnote = 5; break;
						case MIDIDRUM_54_Tambourine: drumnote = 5; break;
						case MIDIDRUM_55_Splash_Cymbal: drumnote = 7; break;
						case MIDIDRUM_56_Cowbell: drumnote = 7; break;
						case MIDIDRUM_57_Crash_Cymbal_2: drumnote = 7; break;
						case MIDIDRUM_58_Vibraslap: drumnote = 5; break;
						case MIDIDRUM_59_Ride_Cymbal_2: drumnote = 7; break;
						case MIDIDRUM_60_Hi_Bongo: drumnote = 4; break;
						case MIDIDRUM_61_Low_Bongo: drumnote = 3; break;
						case MIDIDRUM_62_Mute_Hi_Conga: drumnote = 4; break;
						case MIDIDRUM_63_Open_Hi_Conga: drumnote = 5; break;
						case MIDIDRUM_64_Low_Conga: drumnote = 2; break;
						case MIDIDRUM_65_High_Timbale: drumnote = 4; break;
						case MIDIDRUM_66_Low_Timbale: drumnote = 3; break;
						case MIDIDRUM_67_High_Agogo: drumnote = 4; break;
						case MIDIDRUM_68_Low_Agogo: drumnote = 3; break;
						case MIDIDRUM_69_Cabasa: drumnote = 5; break;
						case MIDIDRUM_70_Maracas: drumnote = 7; break;
						case MIDIDRUM_71_Short_Whistle: drumnote = 7; break;
						case MIDIDRUM_72_Long_Whistle: drumnote = 7; break;
						case MIDIDRUM_73_Short_Guiro: drumnote = 3; break;
						case MIDIDRUM_74_Long_Guiro: drumnote = 4; break;
						case MIDIDRUM_75_Claves: drumnote = 6; break;
						case MIDIDRUM_76_Hi_Wood_Block: drumnote = 4; break;
						case MIDIDRUM_77_Low_Wood_Block: drumnote = 3; break;
						case MIDIDRUM_78_Mute_Cuica: drumnote = 2; break;
						case MIDIDRUM_79_Open_Cuica: drumnote = 4; break;
						case MIDIDRUM_80_Mute_Triangle: drumnote = 5; break;
						case MIDIDRUM_81_Open_Triangle: drumnote = 7; break;
					}
					
					addnotetoceol(currentpattern, note - (numnotes * currentpattern), drumnote, notelength, midinotes[i].height);
				}else {
					//x = time
					//y = note
					//w = length
					//h = instrument
					note = ((midinotes[i].x * numnotes) / boxsize);
					notelength = (((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1;
					currentpattern = int((midinotes[i].x	- (midinotes[i].x % boxsize)) / boxsize);
					
					addnotetoceol(currentpattern, note - (numnotes * currentpattern), midinotes[i].y, notelength, midinotes[i].height);
				}
			}
			
			//Optimising stage: Check for duplicate patterns and remove unused ones.
			for (i = 0; i < control.numboxes; i++) {
				int currenthash = control.musicbox[i].hash;
				if (currenthash != -1) {
					for (j = i + 1; j < control.numboxes; j++) {
						if (control.musicbox[j].hash == currenthash) {
							//Probably a match! Let's compare and remove if so
							if (musicboxmatch(i, j)) {
								replaceontimeline(j, i);
								control.musicbox[j].hash = -1;
							}
						}
					}
				}
			}
			
			//Delete unused boxes
			i = control.numboxes;
			while (i >= 0) {
				if (i < control.numboxes) {
					if (control.musicbox[i].hash == -1) {
						control.deletemusicbox(i);
					}
				}
				i--;	
			}
			
			control.arrange.loopstart = 0;
			control.arrange.loopend = control.arrange.lastbar;	
			if (control.arrange.loopend <= control.arrange.loopstart) {
				control.arrange.loopend = control.arrange.loopstart + 1;
			}
		}
		
		static void convertceoltomidi() {
			//Export the song currently loaded as a midi.
			//midifile = new MidiFile();
			/*
			trace("num tracks:" + midifile.tracks);
			for (int sel = 0 ; sel < midifile.tracks ; sel++) {
				trace("track " + std::string(sel + 1) + ", data:" + std::string(midifile.track(sel).trackChannel) + ", channel:" + std::string(midifile.track(sel).trackChannel));
				for (int i = 0 ; i < midifile.track(sel).msgList.length ; i++) {
					if (midifile.track(sel).msgList[i] is ChannelItem) {
						trace(i, "command: " + std::string(midifile.track(sel).msgList[i]._command) + ", data1:" + std::string(midifile.track(sel).msgList[i]._data1));
					}
					uint index = i+1;
					uint time = midifile.track(sel).msgList[i].timeline;
					uint len = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].duration : null;
					uint channel = midifile.track(sel).msgList[i] is NoteItem?midifile.track(sel).msgList[i].channel+1 : midifile.track(sel).trackChannel+1;
					std::string type = MidiEnum.getMessageName(midifile.track(sel).msgList[i].kind);
					std::string param = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].pitchName : "else";
					uint value = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].velocity : null;
					trace("index:" + std::string(index) + ", time:" + std::string(time) + ", len:+" + std::string(len) + ", channel:" + std::string(channel) + ", event:" + std::string(type) + ", param:" + std::string(param) + ", value:" + std::string(value));
				}				
			}
			*/
			midiexporter = new Midiexporter;
			
			midiexporter.nexttrack();
			midiexporter.writetimesig();
			midiexporter.writetempo(control.bpm);
			
			midiexporter.nexttrack();
			
			//Write all the instruments to each channel.
			//In MIDI, channel 9 is special.
			for (int j = 0; j < control.numinstrument; j++) {
				midiexporter.writeinstrument(instrumentconverttomidi(control.instrument[j].index), j);
			}
			
			//Cover the entire song
			control.arrange.loopstart = 0;
			control.arrange.loopend = control.arrange.lastbar;	
			if (control.arrange.loopend <= control.arrange.loopstart) {
				control.arrange.loopend = control.arrange.loopstart + 1;
			}
			
			/*
			These are the same patch numbers as defined in the original version of GS. 
			Drum bank is accessed by setting cc#0 (Bank Select MSB) to 120 and cc#32 (Bank 
			Select LSB) to 0 and PC (Program Change) to select drum kit.	
			1 	Standard Kit 	The only kit specified by General MIDI Level 1
			 * */
			
			//Write notes
			for (j = 0; j < control.arrange.lastbar; j++) {
				for (int i = 0; i < 8; i++) {
					if (control.arrange.bar[j].channel[i] != -1) {
						int t = control.arrange.bar[j].channel[i];
						//Do normal instruments first
						if (control.instrument[control.musicbox[control.arrange.bar[j].channel[i]].instr].type == 0) {
							for (int k = 0; k < control.musicbox[t].numnotes; k++) {
								midiexporter.writenote(control.musicbox[t].instr, 
																			 control.musicbox[t].notes[k].x, 
																			 ((j * control.boxcount) + control.musicbox[t].notes[k].width) * 30, 
																			 control.musicbox[t].notes[k].y * 30, 255);
							}
						}
					}
				}
			}
			
			midiexporter.nexttrack();
			midiexporter.writeinstrument(0, 9);
			//Drumkits
			for (j = 0; j < control.arrange.lastbar; j++) {
				for (i = 0; i < 8; i++) {
					if (control.arrange.bar[j].channel[i] != -1) {
						t = control.arrange.bar[j].channel[i];
						int drumkit = control.musicbox[control.arrange.bar[j].channel[i]].instr;
						//Now do drum kits
						if (help::Left(control.voicelist.voice[control.instrument[drumkit].index], 7) == "drumkit") {
							for (k = 0; k < control.musicbox[t].numnotes; k++) {
								midiexporter.writenote(9, 
																			 convertdrumtonote(control.musicbox[t].notes[k].x, control.instrument[drumkit].index), 
																			 ((j * control.boxcount) + control.musicbox[t].notes[k].width) * 30, 
																			 control.musicbox[t].notes[k].y * 30, 255);
							}
						}
					}
				}
			}
			
			/*
			writeinstrument(1, 0);
			writenote(0, 60, 0, 120, 255);
			writenote(0, 63, 120, 120, 255);
			writenote(0, 67, 240, 120, 255);
			writenote(0, 72, 360, 120, 255);
			
			for (int j = 0; j < 4; j++) {
				writenote(0, 60 - 24, 0 + (120 * j), 30, 255);
				writenote(0, 63 - 24, 30 + (120 * j), 30, 255);
				writenote(0, 67 - 24, 60 + (120 * j), 30, 255);
				writenote(0, 72 - 24, 90 + (120 * j), 30, 255);
				writenote(0, 60 + 12, 0 + (120 * j), 30, 255);
				writenote(0, 63 + 12, 30 + (120 * j), 30, 255);
				writenote(0, 60 + 12, 60 + (120 * j), 30, 255);
				writenote(0, 67 + 12, 90 + (120 * j), 30, 255);
			}
			
			nexttrack();
			writeinstrument(20, 1);
			
			writenote(1, 48, 0, (120 * 2), 255);
			writenote(1, 55, 240, (120 * 2), 255);
			writenote(1, 48, 480, (120 * 2), 255);
			writenote(1, 55, 620, (120 * 2), 255);
			
			
			nexttrack();
			writeinstrument(40, 2);
			
			writenote(2, 36, 0, (120 * 8), 255);
			*/
			//currenttrack._msgList.push(new NoteItem(1, 67, 127, 120));
			
			//midifile._trackArray[0].list.push(new NoteItem(0, 67, 127, 120));
			//midifile.addTrack(new MidiTrack());
		}
		
		static int convertdrumtonote(int note, int drumkit) {
			//Takes a drum beat from control.createdrumkit()'s list and converts it
			//to a drum beat from the General Midi list (http://www.midi.org/techspecs/gm1sound.php)
			int i;
			std::string voicename = "";
			if (control.voicelist.name[drumkit] == "Simple Drumkit") {
				voicename = control.drumkit[0].voicename[note];
				
				if (voicename == "Bass Drum 1") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Bass Drum 2") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Bass Drum 3") return MIDIDRUM_66_Low_Timbale;
				if (voicename == "Snare Drum") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare Drum 2") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "Open Hi-Hat") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Closed Hi-Hat") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Crash Cymbal") return MIDIDRUM_49_Crash_Cymbal_1;
			}else if (control.voicelist.name[drumkit] == "SiON Drumkit") {
				voicename = control.drumkit[1].voicename[note];
				
				if (voicename == "Bass Drum 2") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Bass Drum 3 o1f") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "RUFINA BD o2c") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "B.D.(-vBend)") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "BD808_2(-vBend)") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Cho cho 3 (o2e)") return MIDIDRUM_72_Long_Whistle;
				if (voicename == "Cow-Bell 1") return MIDIDRUM_56_Cowbell;
				if (voicename == "Crash Cymbal (noise)") return MIDIDRUM_49_Crash_Cymbal_1;
				if (voicename == "Crash Noise") return MIDIDRUM_57_Crash_Cymbal_2;
				if (voicename == "Crash Noise Short") return MIDIDRUM_51_Ride_Cymbal_1;
				if (voicename == "ETHNIC Percus.0") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "ETHNIC Percus.1") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "Heavy BD.") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Heavy BD2") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Heavy SD1") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Hi-Hat close 5_") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat close 4") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat close 5") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat Close 6 -808-") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-hat #7 Metal o3-6") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat Close #8 o4") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-hat Open o4e-g+") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Open-hat2 Metal o4c-") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Open-hat3 Metal") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Hi-Hat Open #4 o4f") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Metal ride o4c or o5c") return MIDIDRUM_51_Ride_Cymbal_1;
				if (voicename == "Rim Shot #1 o3c") return MIDIDRUM_59_Ride_Cymbal_2;
				if (voicename == "Snare Drum Light") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare Drum Lighter") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare Drum 808 o2-o3") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare4 -808type- o2") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare5 o1-2(Franger)") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Tom (old)") return MIDIDRUM_45_Low_Tom;
				if (voicename == "Synth tom 2 algo 3") return MIDIDRUM_47_Low_Mid_Tom;
				if (voicename == "Synth (Noisy) Tom #3") return MIDIDRUM_48_Hi_Mid_Tom;
				if (voicename == "Synth Tom #3") return MIDIDRUM_50_High_Tom;
				if (voicename == "Synth -DX7- Tom #4") return MIDIDRUM_76_Hi_Wood_Block;
				if (voicename == "Triangle 1 o5c") return MIDIDRUM_81_Open_Triangle;
			}else if (control.voicelist.name[drumkit] == "Midi Drumkit") {
				//This one's easy: we already have the mapping saved.
				trace(note, control.drumkit[2].midivoice[note]);
				if (control.drumkit[2].midivoice[note] >= 35 && control.drumkit[2].midivoice[note] <= 81) {
					return control.drumkit[2].midivoice[note];
				}
				//There are a handful of notes in the SiON midi drumkit that aren't standard:
				//Map them to something similar in the standard set:
				voicename = control.drumkit[2].voicename[note];
				if (voicename == "Seq Click H") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Brush Tap") return MIDIDRUM_55_Splash_Cymbal;
				if (voicename == "Brush Swirl") return MIDIDRUM_59_Ride_Cymbal_2;
				if (voicename == "Brush Slap") return MIDIDRUM_49_Crash_Cymbal_1;
				if (voicename == "Brush Tap Swirl") return MIDIDRUM_49_Crash_Cymbal_1;
				if (voicename == "Snare Roll") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Castanet") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Snare L") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "Sticks") return MIDIDRUM_37_Side_Stick;
				if (voicename == "Bass Drum L") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Open Rim Shot") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Shaker") return MIDIDRUM_70_Maracas;
				if (voicename == "Jingle Bells") return MIDIDRUM_81_Open_Triangle;
				if (voicename == "Bell Tree") return MIDIDRUM_74_Long_Guiro;
			}
			
			//If in doubt just return sum bass \:D/
			return 35;
		}
		
		static int instrumentconverttomidi(int t) {
			//Converts Bosca Ceoil instrument to a similar Midi one.
			return control.voicelist.midimap[t];
		}
		
		CONFIG::desktop {
			static File file, FileStream stream;
		}
		
		static ByteArray mididata;
		static Number resolution;
		static Number signature;
		static int numnotes;
		static int numpatterns;
		
		static FileFilter midiFilter = new FileFilter("Standard MIDI File", "*.mid;*.midi;");
		
		static std::vector<Rectangle> unmatchednotes = new std::vector<Rectangle>;
		static std::vector<Rectangle> midinotes = new std::vector<Rectangle>;
		static std::vector<int> channelinstrument;
		static std::vector<int> channelvolume;
		static SMFData smfData = new SMFData();
		
		//Stuff for exporting
		static ByteArray tempbytes;
		static Midiexporter midiexporter;
	}
}
}