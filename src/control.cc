#include <string>
#include <vector>
#include <fstream>
#include <sstream>

#include "arrangement.h"
#include "instrument.h"
#include "musicphrase.h"
#include "drumkit.h"
#include "list.h"
#include "voicelist.h"
#include "help.h"


namespace bosca
{
	template<typename T>
	std::string to_string(T t)
	{
		std::ostringstream ss;
		ss << t;
		return ss.str();
	}

	template<typename T>
	T to(const std::string& str)
	{
		std::istringstream ss(s);
		T t;
		ss >> t;
		return t;
	}

	struct control
	{
		enum Scale
		{
			SCALE_NORMAL = 0,
			SCALE_MAJOR = 1,
			SCALE_MINOR = 2,
			SCALE_BLUES = 3,
			SCALE_HARMONIC_MINOR = 4,
			SCALE_PENTATONIC_MAJOR = 5,
			SCALE_PENTATONIC_MINOR = 6,
			SCALE_PENTATONIC_BLUES = 7,
			SCALE_PENTATONIC_NEUTRAL = 8,
			SCALE_ROMANIAN_FOLK = 9,
			SCALE_SPANISH_GYPSY = 10,
			SCALE_ARABIC_MAGAM = 11,
			SCALE_CHINESE = 12,
			SCALE_HUNGARIAN = 13,
			CHORD_MAJOR = 14,
			CHORD_MINOR = 15,
			CHORD_5TH = 16,
			CHORD_DOM_7TH = 17,
			CHORD_MAJOR_7TH = 18,
			CHORD_MINOR_7TH = 19,
			CHORD_MINOR_MAJOR_7TH = 20,
			CHORD_SUS4 = 21,
			CHORD_SUS2 = 22
		};

		enum ListType
		{
			LIST_KEY = 0,
			LIST_SCALE = 1,
			LIST_INSTRUMENT = 2,
			LIST_CATEGORY = 3,
			LIST_SELECTINSTRUMENT = 4,
			LIST_BUFFERSIZE = 5,
			LIST_MOREEXPORTS = 6,
			LIST_EFFECTS = 7,
			LIST_EXPORTS = 8,
			LIST_MIDIINSTRUMENT = 9,
			LIST_MIDI_0_PIANO = 10,
			LIST_MIDI_1_BELLS = 11,
			LIST_MIDI_2_ORGAN = 12,
			LIST_MIDI_3_GUITAR = 13,
			LIST_MIDI_4_BASS = 14,
			LIST_MIDI_5_STRINGS = 15,
			LIST_MIDI_6_ENSEMBLE = 16,
			LIST_MIDI_7_BRASS = 17,
			LIST_MIDI_8_REED = 18,
			LIST_MIDI_9_PIPE = 19,
			LIST_MIDI_10_SYNTHLEAD = 20,
			LIST_MIDI_11_SYNTHPAD = 21,
			LIST_MIDI_12_SYNTHEFFECTS = 22,
			LIST_MIDI_13_WORLD = 23,
			LIST_MIDI_14_PERCUSSIVE = 24,
			LIST_MIDI_15_SOUNDEFFECTS = 25
		};

		enum Menutab
		{
			MENUTAB_FILE = 0,
			MENUTAB_ARRANGEMENTS = 1,
			MENUTAB_INSTRUMENTS = 2,
			MENUTAB_ADVANCED = 3,
			MENUTAB_CREDITS = 4,
			MENUTAB_HELP = 5,
			MENUTAB_GITHUB = 6
		};

		void init()
		{
			clicklist = false;
			clicksecondlist = false;
			midilistselection = -1;
			savescreencountdown = 0;

			// default filepath
			// defaultDirectory = File.desktopDirectory;

			test = false;
			teststring = "TEST = True";
			patternmanagerview = 0;
			dragaction = 0;
			trashbutton = 0;
			bpm = 120;

			for (i = 0; i < 144; i++) notename.push_back("");
			for (j = 0; j < 12; j++)
			{
				scale.push_back(1);
			}

			for (i = 0; i < 256; i++)
			{
				pianoroll.push_back(i);
				invertpianoroll.push_back(i);
			}
			scalesize = 12;

			for (j = 0; j < 11; j++)
			{
				notename[(j * 12) + 0] = "C";
				notename[(j * 12) + 1] = "C#";
				notename[(j * 12) + 2] = "D";
				notename[(j * 12) + 3] = "D#";
				notename[(j * 12) + 4] = "E";
				notename[(j * 12) + 5] = "F";
				notename[(j * 12) + 6] = "F#";
				notename[(j * 12) + 7] = "G";
				notename[(j * 12) + 8] = "G#";
				notename[(j * 12) + 9] = "A";
				notename[(j * 12) + 10] = "A#";
				notename[(j * 12) + 11] = "B";
			}

			for (i = 0; i < 23; i++)
			{
				scalename.push_back("");
			}
			scalename[SCALE_NORMAL] = "Scale: Normal";
			scalename[SCALE_MAJOR] = "Scale: Major";
			scalename[SCALE_MINOR] = "Scale: Minor";
			scalename[SCALE_BLUES] = "Scale: Blues";
			scalename[SCALE_HARMONIC_MINOR] = "Scale: Harmonic Minor";
			scalename[SCALE_PENTATONIC_MAJOR] = "Scale: Pentatonic Major";
			scalename[SCALE_PENTATONIC_MINOR] = "Scale: Pentatonic Minor";
			scalename[SCALE_PENTATONIC_BLUES] = "Scale: Pentatonic Blues";
			scalename[SCALE_PENTATONIC_NEUTRAL] = "Scale: Pentatonic Neutral";
			scalename[SCALE_ROMANIAN_FOLK] = "Scale: Romanian Folk";
			scalename[SCALE_SPANISH_GYPSY] = "Scale: Spanish Gypsy";
			scalename[SCALE_ARABIC_MAGAM] = "Scale: Arabic Magam";
			scalename[SCALE_CHINESE] = "Scale: Chinese";
			scalename[SCALE_HUNGARIAN] = "Scale: Hungarian";
			scalename[CHORD_MAJOR] = "Chord: Major";
			scalename[CHORD_MINOR] = "Chord: Minor";
			scalename[CHORD_5TH] = "Chord: 5th";
			scalename[CHORD_DOM_7TH] = "Chord: Dom 7th";
			scalename[CHORD_MAJOR_7TH] = "Chord: Major 7th";
			scalename[CHORD_MINOR_7TH] = "Chord: Minor 7th";
			scalename[CHORD_MINOR_MAJOR_7TH] = "Chord: Minor Major 7th";
			scalename[CHORD_SUS4] = "Chord: Sus4";
			scalename[CHORD_SUS2] = "Chord: sus2";

			looptime = 0;
			swingoff = 0;
			SetSwing(); //Swing functions submitted on gibhub via @increpare, cheers!

			// _presets = SiONPresetVoice();

			//Setup drumkits
			drumkit.push_back(Drumkit());
			drumkit.push_back(Drumkit());
			drumkit.push_back(Drumkit()); //Midi Drums
			createdrumkit(0);
			createdrumkit(1);
			createdrumkit(2);

			for (i = 0; i < 16; i++)
			{
				instrument.push_back(instrumentclass());
				if (i == 0)
				{
					instrument[i].voice = _presets["midi.piano1"];
				}
				else
				{
					voicelist.index = to<int>(Math.random() * voicelist.listsize);
					instrument[i].index = voicelist.index;
					instrument[i].voice = _presets[voicelist.voice[voicelist.index]];
					instrument[i].category = voicelist.category[voicelist.index];
					instrument[i].name = voicelist.name[voicelist.index];
					instrument[i].palette = voicelist.palette[voicelist.index];
				}
				instrument[i].updatefilter();
			}
			numinstrument = 1;
			instrumentmanagerview = 0;

			for (i = 0; i < 4096; i++)
			{
				musicbox.push_back(musicphraseclass());
			}
			numboxes = 1;

			arrange.loopstart = 0;
			arrange.loopend = 1;
			arrange.bar[0].channel[0] = 0;

			setscale(SCALE_NORMAL);
			key = 0;
			updatepianoroll();
			for (i = 0; i < numboxes; i++)
			{
				musicbox[i].start = scalesize * 3;
			}

			currentbox = 0;
			notelength = 1;
			currentinstrument = 0;

			boxcount = 16;
			barcount = 4;

			_driver = SiONDriver(buffersize);
			currentbuffersize = buffersize;
			_driver.setBeatCallbackInterval(1);
			_driver.setTimerInterruption(1, _onTimerInterruption);

			effecttype = 0;
			effectvalue = 0;
			effectname.push_back("DELAY");
			effectname.push_back("CHORUS");
			effectname.push_back("REVERB");
			effectname.push_back("DISTORTION");
			effectname.push_back("LOW BOOST");
			effectname.push_back("COMPRESSOR");
			effectname.push_back("HIGH PASS");

			_driver.addEventListener(SiONEvent.STREAM, onStream);

			_driver.bpm = bpm; //Default
			_driver.play(nullptr, false);

			startup = 1;
		}

		void notecut()
		{
			//This is broken, try to fix later
			//for each (SiMMLTrack trk in _driver.sequencer.tracks) trk.keyOff();
		}

		void updateeffects()
		{
			//So, I can't see to figure out WHY only one effect at a time seems to work.
			//If anyone else can, please, by all means update this code!

			//start by turning everything off:
			_driver.effector.clear(0);

			if (effectvalue > 5)
			{
				if (effecttype == 0)
				{
					_driver.effector.connect(0, SiEffectStereoDelay((300 * effectvalue) / 100, 0.1, false));
				}
				else if (effecttype == 1)
				{
					_driver.effector.connect(0, SiEffectStereoChorus(20, 0.2, 4, 10 + ((50 * effectvalue) / 100)));
				}
				else if (effecttype == 2)
				{
					_driver.effector.connect(0, SiEffectStereoReverb(0.7, 0.4 + ((0.5 * effectvalue) / 100), 0.8, 0.3));
				}
				else if (effecttype == 3)
				{
					_driver.effector.connect(0, SiEffectDistortion(-20 - ((80 * effectvalue) / 100), 18, 2400, 1));
				}
				else if (effecttype == 4)
				{
					_driver.effector.connect(0, SiFilterLowBoost(3000, 1, 4 + ((6 * effectvalue) / 100)));
				}
				else if (effecttype == 5)
				{
					_driver.effector.connect(0, SiEffectCompressor(0.7, 50, 20, 20, -6, 0.2 + ((0.6 * effectvalue) / 100)));
				}
				else if (effecttype == 6)
				{
					_driver.effector.connect(0, SiCtrlFilterHighPass(((1.0 * effectvalue) / 100), 0.9));
				}
			}
		}

		void _onTimerInterruption()
		{
			if (musicplaying)
			{
				if (looptime >= boxcount)
				{
					looptime -= boxcount;
					SetSwing();
					arrange.currentbar++;
					if (arrange.currentbar >= arrange.loopend)
					{
						arrange.currentbar = arrange.loopstart;
						if (nowexporting)
						{
							musicplaying = false;
							savewav();
						}
					}

					for (i = 0; i < numboxes; i++)
					{
						musicbox[i].isplayed = false;
					}
				}
				//Play everything in the current bar
				for (k = 0; k < 8; k++)
				{
					if (arrange.channelon[k])
					{
						i = arrange.bar[arrange.currentbar].channel[k];
						if (i > -1)
						{
							musicbox[i].isplayed = true;
							if (instrument[musicbox[i].instr].type == 0)
							{
								for (j = 0; j < musicbox[i].numnotes; j++)
								{
									if (musicbox[i].notes[j].width == looptime)
									{
										if (musicbox[i].notes[j].x > -1)
										{
											instrument[musicbox[i].instr].updatefilter();
											//If pattern uses recorded values, update them
											if (musicbox[i].recordfilter == 1)
											{
												instrument[musicbox[i].instr].changefilterto(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount], musicbox[i].volumegraph[looptime % boxcount]);
											}
											_driver.noteOn(musicbox[i].notes[j].x,
												instrument[musicbox[i].instr].voice,
												musicbox[i].notes[j].y);
										}
									}
								}
							}
							else
							{
								//Drumkits
								for (j = 0; j < musicbox[i].numnotes; j++)
								{
									if (musicbox[i].notes[j].width == looptime)
									{
										if (musicbox[i].notes[j].x > -1)
										{
											if (musicbox[i].notes[j].x < drumkit[instrument[musicbox[i].instr].type - 1].size)
											{
												//Change filter on first note
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type - 1].updatefilter(instrument[musicbox[i].instr].cutoff, instrument[musicbox[i].instr].resonance);
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type - 1].updatevolume(instrument[musicbox[i].instr].volume);
												//If pattern uses recorded values, update them
												if (musicbox[i].recordfilter == 1)
												{
													drumkit[instrument[musicbox[i].instr].type - 1]
														.updatefilter(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount]);
													drumkit[instrument[musicbox[i].instr].type - 1]
														.updatevolume(musicbox[i].volumegraph[looptime % boxcount]);
												}
												_driver.noteOn(
													drumkit[instrument[musicbox[i].instr].type - 1].voicenote[musicbox[i].notes[j].x],
													drumkit[instrument[musicbox[i].instr].type - 1].voicelist[musicbox[i].notes[j].x],
													musicbox[i].notes[j].y
												);
											}
										}
									}
								}
							}
						}
					}
				}

				looptime = looptime + 1;
				SetSwing();
			}
		}

		void SetSwing()
		{
			if (_driver == nullptr) return;

			//swing goes from -10 to 10
			//fswing goes from 0.2 - 1.8
			float fswing = 0.2 + (swing + 10) * (1.8 - 0.2) / 20.0;

			if (swing == 0)
			{
				if (swingoff == 1)
				{
					_driver.setTimerInterruption(1, _onTimerInterruption);
					swingoff = 0;
				}
			}
			else
			{
				swingoff = 1;
				if (looptime % 2 == 0)
				{
					_driver.setTimerInterruption(fswing, _onTimerInterruption);
				}
				else
				{
					_driver.setTimerInterruption(2 - fswing, _onTimerInterruption);
				}
			}
		}

		void loadscreensettings()
		{
			guiclass.firstrun = true;
			fullscreen = false;
			gfx->changescalemode(0);
			
			gfx->windowwidth = 768;
			gfx->windowheight = 560;
			gfx->changewindowsize(gfx->windowwidth, gfx->windowheight);
		}

		void loadfilesettings()
		{
		}

		void savescreensettings()
		{
		}

		void setbuffersize(int t)
		{
			if (t == 0) buffersize = 2048;
			if (t == 1) buffersize = 4096;
			if (t == 2) buffersize = 8192;
		}

		void adddrumkitnote(int t, std::string name, std::string voice, int note = 60)
		{
			if (t == 2 && note == 60) note = 16;
			drumkit[t].voicelist.push_back(_presets[voice]);
			drumkit[t].voicename.push_back(name);
			drumkit[t].voicenote.push_back(note);
			if (t == 2)
			{
				//Midi drumkit
				std::string voicenum = "";
				bool afterdot = false;
				for (int i = 0; i < voice.length(); i++)
				{
					if (afterdot)
					{
						voicenum = voicenum + voice[i];
					}
					if (i >= 8) afterdot = true;
				}
				drumkit[t].midivoice.push_back(to<int>(voicenum));
			}
			drumkit[t].size++;
		}

		/// Create Drumkit t at index
		void createdrumkit(int t)
		{
			switch (t)
			{
			case 0:
				//Simple
				drumkit[0].kitname = "Simple Drumkit";
				adddrumkitnote(0, "Bass Drum 1", "valsound.percus1", 30);
				adddrumkitnote(0, "Bass Drum 2", "valsound.percus13", 32);
				adddrumkitnote(0, "Bass Drum 3", "valsound.percus3", 30);
				adddrumkitnote(0, "Snare Drum", "valsound.percus30", 20);
				adddrumkitnote(0, "Snare Drum 2", "valsound.percus29", 48);
				adddrumkitnote(0, "Open Hi-Hat", "valsound.percus17", 60);
				adddrumkitnote(0, "Closed Hi-Hat", "valsound.percus23", 72);
				adddrumkitnote(0, "Crash Cymbal", "valsound.percus8", 48);
				break;
			case 1:
				//SiON Kit
				drumkit[1].kitname = "SiON Drumkit";
				adddrumkitnote(1, "Bass Drum 2", "valsound.percus1", 30);
				adddrumkitnote(1, "Bass Drum 3 o1f", "valsound.percus2");
				adddrumkitnote(1, "RUFINA BD o2c", "valsound.percus3", 30);
				adddrumkitnote(1, "B.D.(-vBend)", "valsound.percus4");
				adddrumkitnote(1, "BD808_2(-vBend)", "valsound.percus5");
				adddrumkitnote(1, "Cho cho 3 (o2e)", "valsound.percus6");
				adddrumkitnote(1, "Cow-Bell 1", "valsound.percus7");
				adddrumkitnote(1, "Crash Cymbal (noise)", "valsound.percus8", 48);
				adddrumkitnote(1, "Crash Noise", "valsound.percus9");
				adddrumkitnote(1, "Crash Noise Short", "valsound.percus10");
				adddrumkitnote(1, "ETHNIC Percus.0", "valsound.percus11");
				adddrumkitnote(1, "ETHNIC Percus.1", "valsound.percus12");
				adddrumkitnote(1, "Heavy BD.", "valsound.percus13", 32);
				adddrumkitnote(1, "Heavy BD2", "valsound.percus14");
				adddrumkitnote(1, "Heavy SD1", "valsound.percus15");
				adddrumkitnote(1, "Hi-Hat close 5_", "valsound.percus16");
				adddrumkitnote(1, "Hi-Hat close 4", "valsound.percus17");
				adddrumkitnote(1, "Hi-Hat close 5", "valsound.percus18");
				adddrumkitnote(1, "Hi-Hat Close 6 -808-", "valsound.percus19");
				adddrumkitnote(1, "Hi-hat #7 Metal o3-6", "valsound.percus20");
				adddrumkitnote(1, "Hi-Hat Close #8 o4", "valsound.percus21");
				adddrumkitnote(1, "Hi-hat Open o4e-g+", "valsound.percus22");
				adddrumkitnote(1, "Open-hat2 Metal o4c-", "valsound.percus23");
				adddrumkitnote(1, "Open-hat3 Metal", "valsound.percus24");
				adddrumkitnote(1, "Hi-Hat Open #4 o4f", "valsound.percus25");
				adddrumkitnote(1, "Metal ride o4c or o5c", "valsound.percus26");
				adddrumkitnote(1, "Rim Shot #1 o3c", "valsound.percus27");
				adddrumkitnote(1, "Snare Drum Light", "valsound.percus28");
				adddrumkitnote(1, "Snare Drum Lighter", "valsound.percus29");
				adddrumkitnote(1, "Snare Drum 808 o2-o3", "valsound.percus30", 20);
				adddrumkitnote(1, "Snare4 -808type- o2", "valsound.percus31");
				adddrumkitnote(1, "Snare5 o1-2(Franger)", "valsound.percus32");
				adddrumkitnote(1, "Tom (old)", "valsound.percus33");
				adddrumkitnote(1, "Synth tom 2 algo 3", "valsound.percus34");
				adddrumkitnote(1, "Synth (Noisy) Tom #3", "valsound.percus35");
				adddrumkitnote(1, "Synth Tom #3", "valsound.percus36");
				adddrumkitnote(1, "Synth -DX7- Tom #4", "valsound.percus37");
				adddrumkitnote(1, "Triangle 1 o5c", "valsound.percus38");
				break;
			case 2:
				//MIDI DRUMS
				drumkit[2].kitname = "Midi Drumkit";
				adddrumkitnote(2, "Seq Click H", "midi.drum24", 24);
				adddrumkitnote(2, "Brush Tap", "midi.drum25", 25);
				adddrumkitnote(2, "Brush Swirl", "midi.drum26", 26);
				adddrumkitnote(2, "Brush Slap", "midi.drum27", 27);
				adddrumkitnote(2, "Brush Tap Swirl", "midi.drum28", 28);
				adddrumkitnote(2, "Snare Roll", "midi.drum29");
				adddrumkitnote(2, "Castanet", "midi.drum32");
				adddrumkitnote(2, "Snare L", "midi.drum31");
				adddrumkitnote(2, "Sticks", "midi.drum32");
				adddrumkitnote(2, "Bass Drum L", "midi.drum33");
				adddrumkitnote(2, "Open Rim Shot", "midi.drum34");
				adddrumkitnote(2, "Bass Drum M", "midi.drum35");
				adddrumkitnote(2, "Bass Drum H", "midi.drum36");
				adddrumkitnote(2, "Closed Rim Shot", "midi.drum37");
				adddrumkitnote(2, "Snare M", "midi.drum38");
				adddrumkitnote(2, "Hand Clap", "midi.drum39");
				adddrumkitnote(2, "Snare H", "midi.drum42");
				adddrumkitnote(2, "Floor Tom L", "midi.drum41");
				adddrumkitnote(2, "Hi-Hat Closed", "midi.drum42");
				adddrumkitnote(2, "Floor Tom H", "midi.drum43");
				adddrumkitnote(2, "Hi-Hat Pedal", "midi.drum44");
				adddrumkitnote(2, "Low Tom", "midi.drum45");
				adddrumkitnote(2, "Hi-Hat Open", "midi.drum46");
				adddrumkitnote(2, "Mid Tom L", "midi.drum47");
				adddrumkitnote(2, "Mid Tom H", "midi.drum48");
				adddrumkitnote(2, "Crash Cymbal 1", "midi.drum49");
				adddrumkitnote(2, "High Tom", "midi.drum52");
				adddrumkitnote(2, "Ride Cymbal 1", "midi.drum51");
				adddrumkitnote(2, "Chinese Cymbal", "midi.drum52");
				adddrumkitnote(2, "Ride Cymbal Cup", "midi.drum53");
				adddrumkitnote(2, "Tambourine", "midi.drum54");
				adddrumkitnote(2, "Splash Cymbal", "midi.drum55");
				adddrumkitnote(2, "Cowbell", "midi.drum56");
				adddrumkitnote(2, "Crash Cymbal 2", "midi.drum57");
				adddrumkitnote(2, "Vibraslap", "midi.drum58");
				adddrumkitnote(2, "Ride Cymbal 2", "midi.drum59");
				adddrumkitnote(2, "Bongo H", "midi.drum62");
				adddrumkitnote(2, "Bongo L", "midi.drum61");
				adddrumkitnote(2, "Conga H Mute", "midi.drum62");
				adddrumkitnote(2, "Conga H Open", "midi.drum63");
				adddrumkitnote(2, "Conga L", "midi.drum64");
				adddrumkitnote(2, "Timbale H", "midi.drum65");
				adddrumkitnote(2, "Timbale L", "midi.drum66");
				adddrumkitnote(2, "Agogo H", "midi.drum67");
				adddrumkitnote(2, "Agogo L", "midi.drum68");
				adddrumkitnote(2, "Cabasa", "midi.drum69");
				adddrumkitnote(2, "Maracas", "midi.drum72");
				adddrumkitnote(2, "Samba Whistle H", "midi.drum71");
				adddrumkitnote(2, "Samba Whistle L", "midi.drum72");
				adddrumkitnote(2, "Guiro Short", "midi.drum73");
				adddrumkitnote(2, "Guiro Long", "midi.drum74");
				adddrumkitnote(2, "Claves", "midi.drum75");
				adddrumkitnote(2, "Wood Block H", "midi.drum76");
				adddrumkitnote(2, "Wood Block L", "midi.drum77");
				adddrumkitnote(2, "Cuica Mute", "midi.drum78");
				adddrumkitnote(2, "Cuica Open", "midi.drum79");
				adddrumkitnote(2, "Triangle Mute", "midi.drum80");
				adddrumkitnote(2, "Triangle Open", "midi.drum81");
				adddrumkitnote(2, "Shaker", "midi.drum82");
				adddrumkitnote(2, "Jingle Bells", "midi.drum83");
				adddrumkitnote(2, "Bell Tree", "midi.drum84");
				break;
			}
		}

		void changekey(int t)
		{
			int keyshift = t - key;
			for (i = 0; i < musicbox[currentbox].numnotes; i++)
			{
				musicbox[currentbox].notes[i].x += keyshift;
			}
			musicbox[currentbox].key = t;
			key = t;
			musicbox[currentbox].setnotespan();
			updatepianoroll();
		}

		void changescale(int t)
		{
			setscale(t);
			updatepianoroll();

			//Delete notes not in scale
			for (i = 0; i < musicbox[currentbox].numnotes; i++)
			{
				if (invertpianoroll[musicbox[currentbox].notes[i].x] == -1)
				{
					musicbox[currentbox].deletenote(i);
					i--;
				}
			}

			musicbox[currentbox].scale = t;
			if (musicbox[currentbox].bottomnote < 250)
			{
				musicbox[currentbox].start = invertpianoroll[musicbox[currentbox].bottomnote] - 2;
				if (musicbox[currentbox].start < 0) musicbox[currentbox].start = 0;
			}
			else
			{
				musicbox[currentbox].start = (scalesize * 4) - 2;
			}
			musicbox[currentbox].setnotespan();
		}

		void changemusicbox(int t)
		{
			currentbox = t;
			key = musicbox[t].key;
			setscale(musicbox[t].scale);
			updatepianoroll();

			if (instrument[musicbox[t].instr].type == 0)
			{
				if (musicbox[t].bottomnote < 250)
				{
					musicbox[t].start = invertpianoroll[musicbox[t].bottomnote] - 2;
					if (musicbox[t].start < 0) musicbox[t].start = 0;
				}
				else
				{
					musicbox[t].start = (scalesize * 4) - 2;
				}
			}
			else
			{
				musicbox[t].start = 0;
			}

			guiclass.changetab(currenttab);
		}

		void _setscale(int t1 = -1, int t2 = -1, int t3 = -1, int t4 = -1, int t5 = -1, int t6 = -1, int t7 = -1, int t8 = -1, int t9 = -1, int t10 = -1, int t11 = -1, int t12 = -1)
		{
			if (t1 == -1)
			{
				scalesize = 0;
			}
			else if (t2 == -1)
			{
				scale[0] = t1;
				scalesize = 1;
			}
			else if (t3 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scalesize = 2;
			}
			else if (t4 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scalesize = 3;
			}
			else if (t5 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scalesize = 4;
			}
			else if (t6 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scalesize = 5;
			}
			else if (t7 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scalesize = 6;
			}
			else if (t8 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scalesize = 7;
			}
			else if (t9 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scalesize = 8;
			}
			else if (t10 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scalesize = 9;
			}
			else if (t11 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scale[9] = t10;
				scalesize = 10;
			}
			else if (t12 == -1)
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scale[9] = t10;
				scale[10] = t11;
				scalesize = 11;
			}
			else
			{
				scale[0] = t1;
				scale[1] = t2;
				scale[2] = t3;
				scale[3] = t4;
				scale[4] = t5;
				scale[5] = t6;
				scale[6] = t7;
				scale[7] = t8;
				scale[8] = t9;
				scale[9] = t10;
				scale[10] = t11;
				scale[11] = t12;
				scalesize = 12;
			}
		}

		void setscale(int t)
		{
			currentscale = t;
			switch (t)
			{
			case SCALE_MAJOR:
				_setscale(2, 2, 1, 2, 2, 2, 1);
				break;
			case SCALE_MINOR:
				_setscale(2, 1, 2, 2, 2, 2, 1);
				break;
			case SCALE_BLUES:
				_setscale(3, 2, 1, 1, 3, 2);
				break;
			case SCALE_HARMONIC_MINOR:
				_setscale(2, 1, 2, 2, 1, 3, 1);
				break;
			case SCALE_PENTATONIC_MAJOR:
				_setscale(2, 3, 2, 2, 3);
				break;
			case SCALE_PENTATONIC_MINOR:
				_setscale(3, 2, 2, 3, 2);
				break;
			case SCALE_PENTATONIC_BLUES:
				_setscale(3, 2, 1, 1, 3, 2);
				break;
			case SCALE_PENTATONIC_NEUTRAL:
				_setscale(2, 3, 2, 3, 2);
				break;
			case SCALE_ROMANIAN_FOLK:
				_setscale(2, 1, 3, 1, 2, 1, 2);
				break;
			case SCALE_SPANISH_GYPSY:
				_setscale(2, 1, 3, 1, 2, 1, 2);
				break;
			case SCALE_ARABIC_MAGAM:
				_setscale(2, 2, 1, 1, 2, 2, 2);
				break;
			case SCALE_CHINESE:
				_setscale(4, 2, 1, 4, 1);
				break;
			case SCALE_HUNGARIAN:
				_setscale(2, 1, 3, 1, 1, 3, 1);
				break;
			case CHORD_MAJOR:
				_setscale(4, 3, 5);
				break;
			case CHORD_MINOR:
				_setscale(3, 4, 5);
				break;
			case CHORD_5TH:
				_setscale(7, 5);
				break;
			case CHORD_DOM_7TH:
				_setscale(4, 3, 3, 2);
				break;
			case CHORD_MAJOR_7TH:
				_setscale(4, 3, 4, 1);
				break;
			case CHORD_MINOR_7TH:
				_setscale(3, 4, 3, 2);
				break;
			case CHORD_MINOR_MAJOR_7TH:
				_setscale(3, 4, 4, 1);
				break;
			case CHORD_SUS4:
				_setscale(5, 2, 5);
				break;
			case CHORD_SUS2:
				_setscale(2, 5, 5);
				break;
			default:
			case SCALE_NORMAL:
				_setscale(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
				break;
			}
		}

		void updatepianoroll()
		{
			//Set piano roll based on currently loaded scale
			int scaleiter = -1;  int pianoroll_iter = 0;  int lastnote = 0;

			lastnote = key;
			pianoroll_size = 0;

			while (lastnote < 104)
			{
				pianoroll[pianoroll_iter] = lastnote;
				pianoroll_size++;
				pianoroll_iter++;
				scaleiter++;
				if (scaleiter >= scalesize) scaleiter -= scalesize;

				lastnote = pianoroll[pianoroll_iter - 1] + scale[scaleiter];
			}

			for (i = 0; i < 104; i++)
			{
				invertpianoroll[i] = -1;
				for (j = 0; j < pianoroll_size; j++)
				{
					if (pianoroll[j] == i)
					{
						invertpianoroll[i] = j;
					}
				}
			}
		}

		void addmusicbox()
		{
			musicbox[numboxes].clear();
			musicbox[numboxes].instr = currentinstrument;
			musicbox[numboxes].palette = instrument[currentinstrument].palette;
			musicbox[numboxes].hash += currentinstrument;
			numboxes++;
		}

		void copymusicbox(int a, int b)
		{
			musicbox[a].numnotes = musicbox[b].numnotes;

			for (j = 0; j < musicbox[a].numnotes; j++)
			{
				musicbox[a].notes[j].x = musicbox[b].notes[j].x;
				musicbox[a].notes[j].y = musicbox[b].notes[j].y;
				musicbox[a].notes[j].width = musicbox[b].notes[j].width;
				musicbox[a].notes[j].height = musicbox[b].notes[j].height;
			}

			for (j = 0; j < 16; j++)
			{
				musicbox[a].cutoffgraph[j] = musicbox[b].cutoffgraph[j];
				musicbox[a].resonancegraph[j] = musicbox[b].resonancegraph[j];
				musicbox[a].volumegraph[j] = musicbox[b].volumegraph[j];
			}

			musicbox[a].recordfilter = musicbox[b].recordfilter;
			musicbox[a].topnote = musicbox[b].topnote;
			musicbox[a].bottomnote = musicbox[b].bottomnote;
			musicbox[a].notespan = musicbox[b].notespan;

			musicbox[a].start = musicbox[b].start;
			musicbox[a].key = musicbox[b].key;
			musicbox[a].instr = musicbox[b].instr;
			musicbox[a].palette = musicbox[b].palette;
			musicbox[a].scale = musicbox[b].scale;
			musicbox[a].isplayed = musicbox[b].isplayed;
		}

		void deletemusicbox(int t)
		{
			if (currentbox == t) currentbox--;
			for (i = t; i < numboxes; i++)
			{
				copymusicbox(i, i + 1);
			}
			numboxes--;

			for (j = 0; j < 8; j++)
			{
				for (i = 0; i < arrange.lastbar; i++)
				{
					if (arrange.bar[i].channel[j] == t)
					{
						arrange.bar[i].channel[j] = -1;
					}
					else if (arrange.bar[i].channel[j] > t)
					{
						arrange.bar[i].channel[j]--;
					}
				}
			}
		}

		void seekposition(int t)
		{
			//Make this smoother someday maybe
			barposition = t;
		}

		void filllist(int t)
		{
			list.type = t;
			switch (t)
			{
			case LIST_KEY:
				for (i = 0; i < 12; i++)
				{
					list.item[i] = notename[i];
				}
				list.numitems = 12;
				break;
			case LIST_SCALE:
				for (i = 0; i < 23; i++)
				{
					list.item[i] = scalename[i];
				}
				list.numitems = 23;
				break;
			case LIST_CATEGORY:
				list.item[0] = "MIDI";
				list.item[1] = "DRUMKIT";
				list.item[2] = "CHIPTUNE";
				list.item[3] = "PIANO";
				list.item[4] = "BRASS";
				list.item[5] = "BASS";
				list.item[6] = "STRINGS";
				list.item[7] = "WIND";
				list.item[8] = "BELL";
				list.item[9] = "GUITAR";
				list.item[10] = "LEAD";
				list.item[11] = "SPECIAL";
				list.item[12] = "WORLD";
				list.numitems = 13;
				break;
			case LIST_INSTRUMENT:
				if (voicelist.sublistsize > 15)
				{
					//Need to split into several pages
					//Fix pagenum if it got broken somewhere
					if ((voicelist.pagenum * 15) > voicelist.sublistsize) voicelist.pagenum = 0;
					if (voicelist.sublistsize - (voicelist.pagenum * 15) > 15)
					{
						for (i = 0; i < 15; i++)
						{
							list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
						}
						list.item[15] = ">> Next Page";
						list.numitems = 16;
					}
					else
					{
						for (i = 0; i < voicelist.sublistsize - (voicelist.pagenum * 15); i++)
						{
							list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
						}
						list.item[voicelist.sublistsize - (voicelist.pagenum * 15)] = "<< First Page";
						list.numitems = voicelist.sublistsize - (voicelist.pagenum * 15) + 1;
					}
				}
				else
				{
					//Just a simple single page
					for (i = 0; i < voicelist.sublistsize; i++)
					{
						list.item[i] = voicelist.subname[i];
					}
					list.numitems = voicelist.sublistsize;
				}
				break;
			case LIST_MIDIINSTRUMENT:
				midilistselection = -1;
				list.item[0] = "> Piano";
				list.item[1] = "> Bells";
				list.item[2] = "> Organ";
				list.item[3] = "> Guitar";
				list.item[4] = "> Bass";
				list.item[5] = "> Strings";
				list.item[6] = "> Ensemble";
				list.item[7] = "> Brass";
				list.item[8] = "> Reed";
				list.item[9] = "> Pipe";
				list.item[10] = "> Lead";
				list.item[11] = "> Pads";
				list.item[12] = "> Synth";
				list.item[13] = "> World";
				list.item[14] = "> Drums";
				list.item[15] = "> Effects";
				list.numitems = 16;
				break;
			case LIST_SELECTINSTRUMENT:
				//For choosing from existing instruments
				for (i = 0; i < numinstrument; i++)
				{
					list.item[i] = to_string(i + 1) + " " + instrument[i].name;
				}
				list.numitems = numinstrument;
				break;
			case LIST_BUFFERSIZE:
				list.item[0] = "2048 (default, high performance)";
				list.item[1] = "4096 (try if you get cracking on wav exports)";
				list.item[2] = "8192 (slow, not recommended)";
				list.numitems = 3;
				break;
			case LIST_EFFECTS:
				for (i = 0; i < 7; i++)
				{
					list.item[i] = effectname[i];
				}
				list.numitems = 7;
				break;
			case LIST_MOREEXPORTS:
				list.item[0] = "EXPORT .xm (wip)";
				list.item[1] = "EXPORT .mml (wip)";
				list.numitems = 2;
				break;
			case LIST_EXPORTS:
				list.item[0] = "EXPORT .wav";
				list.item[1] = "EXPORT .mid";
				list.item[2] = "> More";
				list.numitems = 3;
				break;
			default:
				//Midi list
				list.type = LIST_MIDIINSTRUMENT;
				secondlist.type = t;
				for (i = 0; i < 8; i++)
				{
					secondlist.item[i] = voicelist.name[i + ((t - 10) * 8)];
				}
				secondlist.numitems = 8;
				break;
			}
		}

		void setinstrumenttoindex(int t)
		{
			voicelist.index = instrument[t].index;
			if (help::Left(voicelist.voice[voicelist.index], 7) == "drumkit")
			{
				instrument[t].type = to<int>(help::Right(voicelist.voice[voicelist.index]));
				instrument[t].updatefilter();
				drumkit[instrument[t].type - 1].updatefilter(instrument[t].cutoff, instrument[t].resonance);
			}
			else
			{
				instrument[t].type = 0;
				instrument[t].voice = _presets[voicelist.voice[voicelist.index]];
				instrument[t].updatefilter();
			}

			instrument[t].name = voicelist.name[voicelist.index];
			instrument[t].category = voicelist.category[voicelist.index];
			instrument[t].palette = voicelist.palette[voicelist.index];
		}

		void nextinstrument()
		{
			//Change to the next instrument in a category
			voicelist.index = voicelist.getnext(voicelist.getvoice(instrument[currentinstrument].name));
			changeinstrumentvoice(voicelist.name[voicelist.index]);
		}

		void previousinstrument()
		{
			//Change to the previous instrument in a category
			voicelist.index = voicelist.getprevious(voicelist.getvoice(instrument[currentinstrument].name));
			changeinstrumentvoice(voicelist.name[voicelist.index]);
		}

		void changeinstrumentvoice(std::string t)
		{
			instrument[currentinstrument].name = t;
			voicelist.index = voicelist.getvoice(t);
			instrument[currentinstrument].category = voicelist.category[voicelist.index];
			if (help::Left(voicelist.voice[voicelist.index], 7) == "drumkit")
			{
				instrument[currentinstrument].type = to<int>(help::Right(voicelist.voice[voicelist.index]));
				instrument[currentinstrument].updatefilter();
				drumkit[instrument[currentinstrument].type - 1].updatefilter(instrument[currentinstrument].cutoff, instrument[currentinstrument].resonance);

				if (currentbox > -1)
				{
					if (musicbox[currentbox].start > drumkit[instrument[currentinstrument].type - 1].size)
					{
						musicbox[currentbox].start = 0;
					}
				}
			}
			else
			{
				instrument[currentinstrument].type = 0;
				instrument[currentinstrument].voice = _presets[voicelist.voice[voicelist.index]];
				instrument[currentinstrument].updatefilter();
			}

			instrument[currentinstrument].palette = voicelist.palette[voicelist.index];
			instrument[currentinstrument].index = voicelist.index;

			for (i = 0; i < numboxes; i++)
			{
				if (musicbox[i].instr == currentinstrument)
				{
					musicbox[i].palette = instrument[currentinstrument].palette;
				}
			}
		}

		void makefilestring()
		{
			filestring = "";
			filestring += to_string(version) + ",";
			filestring += to_string(swing) + ",";
			filestring += to_string(effecttype) + ",";
			filestring += to_string(effectvalue) + ",";
			filestring += to_string(bpm) + ",";
			filestring += to_string(boxcount) + ",";
			filestring += to_string(barcount) + ",";
			//Instruments first!
			filestring += to_string(numinstrument) + ",";
			for (i = 0; i < numinstrument; i++)
			{
				filestring += to_string(instrument[i].index) + ",";
				filestring += to_string(instrument[i].type) + ",";
				filestring += to_string(instrument[i].palette) + ",";
				filestring += to_string(instrument[i].cutoff) + ",";
				filestring += to_string(instrument[i].resonance) + ",";
				filestring += to_string(instrument[i].volume) + ",";
			}
			//Next, musicboxes
			filestring += to_string(numboxes) + ",";
			for (i = 0; i < numboxes; i++)
			{
				filestring += to_string(musicbox[i].key) + ",";
				filestring += to_string(musicbox[i].scale) + ",";
				filestring += to_string(musicbox[i].instr) + ",";
				filestring += to_string(musicbox[i].palette) + ",";
				filestring += to_string(musicbox[i].numnotes) + ",";
				for (j = 0; j < musicbox[i].numnotes; j++)
				{
					filestring += to_string(musicbox[i].notes[j].x) + ",";
					filestring += to_string(musicbox[i].notes[j].y) + ",";
					filestring += to_string(musicbox[i].notes[j].width) + ",";
					filestring += to_string(musicbox[i].notes[j].height) + ",";
				}
				filestring += to_string(musicbox[i].recordfilter) + ",";
				if (musicbox[i].recordfilter == 1)
				{
					for (j = 0; j < 16; j++)
					{
						filestring += to_string(musicbox[i].volumegraph[j]) + ",";
						filestring += to_string(musicbox[i].cutoffgraph[j]) + ",";
						filestring += to_string(musicbox[i].resonancegraph[j]) + ",";
					}
				}
			}
			//Next, arrangements
			filestring += to_string(arrange.lastbar) + ",";
			filestring += to_string(arrange.loopstart) + ",";
			filestring += to_string(arrange.loopend) + ",";
			for (i = 0; i < arrange.lastbar; i++)
			{
				for (j = 0; j < 8; j++)
				{
					filestring += to_string(arrange.bar[i].channel[j]) + ",";
				}
			}
		}

		void newsong()
		{
			changetab(MENUTAB_FILE);
			bpm = 120;
			boxcount = 16;
			barcount = 4;
			doublesize = false;
			effectvalue = 0;
			effecttype = 0;
			updateeffects();
			_driver.bpm = bpm;
			arrange.clear();
			musicbox[0].clear();
			changekey(0);
			changescale(0);
			arrange.bar[0].channel[0] = 0;
			numboxes = 1;
			currentbox = 0;
			numinstrument = 1;
			instrumentmanagerview = 0;
			patternmanagerview = 0;
			// set instrument to grand piano
			instrument[0] = instrumentclass();
			instrument[0].voice = _presets["midi.piano1"];
			instrument[0].updatefilter();
			showmessage("NEW SONG CREATED");
		}

		int readfilestream()
		{
			fi++;
			return to<int>(filestream[fi - 1]);
		}

		void convertfilestring()
		{
			fi = 0;
			version = readfilestream();
			if (version == 3)
			{
				swing = readfilestream();
				effecttype = readfilestream();
				effectvalue = readfilestream();
				updateeffects();
				bpm = readfilestream();
				_driver.bpm = bpm;
				boxcount = readfilestream();
				doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i = 0; i < numinstrument; i++)
				{
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].volume = readfilestream();
					instrument[i].updatefilter();
					if (instrument[i].type > 0)
					{
						drumkit[instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						drumkit[instrument[i].type - 1].updatevolume(instrument[i].volume);
					}
				}
				//Next, musicboxes
				numboxes = readfilestream();
				for (i = 0; i < numboxes; i++)
				{
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j = 0; j < musicbox[i].numnotes; j++)
					{
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote();
					musicbox[i].findbottomnote();
					musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1)
					{
						for (j = 0; j < 16; j++)
						{
							musicbox[i].volumegraph[j] = readfilestream();
							musicbox[i].cutoffgraph[j] = readfilestream();
							musicbox[i].resonancegraph[j] = readfilestream();
						}
					}
				}
				//Next, arrangements
				arrange.lastbar = readfilestream();
				arrange.loopstart = readfilestream();
				arrange.loopend = readfilestream();
				for (i = 0; i < arrange.lastbar; i++)
				{
					for (j = 0; j < 8; j++)
					{
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
			}
			else
			{
				//opps, the file we're loading is out of date. Let's try to convert it
				assert(false && "not handled")
					version = 3;
			}
		}

		// File stuff
		void saveceol()
		{
			// todo(Gustav): add file browsing
			// "Save .ceol File"
			// "*.ceol"
			onsaveceol("song.ceol");

			fixmouseclicks = true;
		}

		void onsaveceol(const std::string& file)
		{
			makefilestring();

			std::ofstream stream;
			stream.open(file);
			stream << filestring;
			stream.close();

			fixmouseclicks = true;
			showmessage("SONG SAVED");
		}

		void loadceol()
		{
			// file.browseForOpen("Load .ceol File", FileFilter("Ceol", "*.ceol"));
			onloadceol("my-song.ceol");

			fixmouseclicks = true;
		}

		void onloadceol(const std::string& filepath)
		{
			std::ifstream stream;
			stream.open(filepath);

			std::stringstream buffer;
			buffer << stream.rdbuf();
			filestring = buffer.str();

			stream.close();

			loadfilestring(filestring);
			_driver.play(nullptr, false);

			fixmouseclicks = true;
			showmessage("SONG LOADED");

		}

		std::vector<std::string> filestream;
		void loadfilestring(std::string s)
		{
			auto ss = std::istringstream(s);

			std::string str;
			while (std::getline(ss, str, ' ')){
				filestream.emplace_back(str);
			}

			numinstrument = 1;
			numboxes = 0;
			arrange.clear();
			arrange.currentbar = 0;
			arrange.viewstart = 0;

			convertfilestring();

			changemusicbox(0);
			looptime = 0;
		}

		void showmessage(std::string t)
		{
			message = t;
			messagedelay = 90;
		}

		void pausemusic()
		{
			if (musicplaying)
			{
				musicplaying = !musicplaying;
				if (!musicplaying) notecut();
			}
		}

		void stopmusic()
		{
			if (musicplaying)
			{
				musicplaying = !musicplaying;
				looptime = 0;
				arrange.currentbar = arrange.loopstart;
				if (!musicplaying) notecut();
			}
		}

		void startmusic()
		{
			if (!musicplaying)
			{
				musicplaying = !musicplaying;
			}
		}

#if 0
		void onStream(SiONEvent e)
		{
			e.streamBuffer.position = 0;
			while (e.streamBuffer.bytesAvailable > 0)
			{
				int d = e.streamBuffer.readFloat() * 32767;
				if (nowexporting) _data.writeShort(d);
			}
		}

		void exportwav()
		{
			changetab(MENUTAB_ARRANGEMENTS);
			clicklist = true;
			arrange.loopstart = 0;
			arrange.loopend = arrange.lastbar;
			musicplaying = true;
			looptime = 0;
			arrange.currentbar = arrange.loopstart;
			SetSwing();

			//Clear the wav buffer
			_data = ByteArray();
			_data.endian = Endian.LITTLE_ENDIAN;

			followmode = true;
			nowexporting = true;
		}

		void savewav()
		{
			nowexporting = false;
			followmode = false;

			_wav = ByteArray();
			_wav.endian = Endian.LITTLE_ENDIAN;
			_wav.writeUTFBytes("RIFF");
			int len = _data.length;
			_wav.writeInt(len + 36);
			_wav.writeUTFBytes("WAVE");
			_wav.writeUTFBytes("fmt ");
			_wav.writeInt(16);
			_wav.writeShort(1);
			_wav.writeShort(2);
			_wav.writeInt(44100);
			_wav.writeInt(176400);
			_wav.writeShort(4);
			_wav.writeShort(16);
			_wav.writeUTFBytes("data");
			_wav.writeInt(len);
			_data.position = 0;
			_wav.writeBytes(_data);


			if (!filepath)
			{
				filepath = defaultDirectory;
			}
			file = filepath.resolvePath("*.wav");
			file.addEventListener(Event.SELECT, onsavewav);
			file.browseForSave("Export .wav File");

			fixmouseclicks = true;
		}

		void onsavewav(const std::string& file)
		{
			std::ofstream stream;
			stream.open(file);
			stream << _wav;
			stream.close();

			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS WAV");
		}
#endif

		void changetab(int newtab)
		{
			currenttab = newtab;
			guiclass.changetab(newtab);
		}

		void changetab_ifdifferent(int newtab)
		{
			if (currenttab != newtab)
			{
				currenttab = newtab;
				guiclass.changetab(newtab);
			}
		}


		// File file; FileStream stream;
		std::string filestring; int fi;

		int i; int j; int k;

		bool fullscreen;

		bool fullscreentoggleheld = false;

		bool press_up; bool press_down; bool press_left; bool press_right; bool press_space; bool press_enter;
		int keypriority = 0;
		bool keyheld = false;

		bool clicklist;
		bool clicksecondlist;
		bool copykeyheld = false;

		int keydelay; int keyboardpressed = 0;
		bool fixmouseclicks = false;

		int mx; int my;
		bool test; std::string teststring;

		// SiONDriver _driver;
		// SiONPresetVoice _presets;
		voicelistclass voicelist;

		std::vector<instrumentclass> instrument;
		int numinstrument;
		int instrumentmanagerview;

		std::vector<musicphraseclass> musicbox;
		int numboxes;
		int looptime;
		int currentbox;
		int currentnote;
		int currentinstrument;
		int boxsize; int boxcount;
		int barsize; int barcount;
		int notelength;
		bool doublesize;
		int arrangescrolldelay = 0;

		float barposition = 0;
		int drawnoteposition; int drawnotelength;

		int cursorx; int cursory;
		int arrangecurx; int arrangecury;
		int patterncury; int timelinecurx;
		int instrumentcury;
		int notey;

		std::vector<std::string> notename;
		std::vector<std::string> scalename;

		int currentscale = 0;
		std::vector<int> scale;
		int key;
		int scalesize;

		std::vector<int> pianoroll;
		std::vector<int> invertpianoroll;
		int pianoroll_size;

		Arrangement arrange;
		std::vector<Drumkit> drumkit;

		int currenttab;

		int dragaction; int dragx; int dragy; int dragpattern;
		int patternmanagerview;

		int trashbutton;

		listclass list;
		listclass secondlist;
		int midilistselection;

		bool musicplaying = true;
		bool nowexporting = false;
		bool followmode = false;
		int bpm;
		int version;
		int swing;
		int swingoff;

		int doubleclickcheck;

		// SharedObject programsettings;
		int buffersize; int currentbuffersize;

		// ByteArray _data;
		// ByteArray _wav;

		std::string message;
		int messagedelay = 0;
		int startup = 0; std::string invokefile = "nullptr";
		std::string ctrl;

		// Add filepath memory
		// File filepath = nullptr;
		// File defaultDirectory = nullptr;

		//Global effects
		int effecttype;
		int effectvalue;
		std::vector<std::string> effectname;

		std::string versionnumber;
		int savescreencountdown;
		int minresizecountdown;
		bool forceresize = false;
	};
}