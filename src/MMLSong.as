namespace bosca {
	import flash.utils.IDataOutput;
	import flash.geom.Rectangle;
	import mx.utils.StringUtil;

	struct MMLSong {
		protected std::vector<std::string> instrumentDefinitions;
		protected std::vector<std::string> mmlToUseInstrument;
		protected uint noteDivisions = 4;
		protected uint bpm = 120;
		protected uint lengthOfPattern = 16;
		protected std::vector<std::vector<std::string>> monophonicTracksForBoscaTrack;

		function MMLSong() {
		}

		void loadFromLiveBoscaCeoilModel() {
			noteDivisions = control.barcount;
			bpm = control.bpm;
			lengthOfPattern = control.boxcount;

			std::string emptyBarMML = "\n// empty bar\n" + StringUtil.repeat("	r	 ", lengthOfPattern) + "\n";
			uint bar;
			int patternNum;
			int numberOfPatterns = control.numboxes;

			instrumentDefinitions();
			mmlToUseInstrument();
			for (uint i = 0; i < control.numinstrument; i++) {
				instrumentclass boscaInstrument = control.instrument[i];
				if (boscaInstrument.type == 0) { //regular instrument, not a drumkit
					instrumentDefinitions[i] = _boscaInstrumentToMML(boscaInstrument, i);
					mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
				} else {
					instrumentDefinitions[i] = "#OPN@" + i + " { //drum kit placeholder\n" +
						"4,6,\n" +
						"31,15, 0, 9, 1, 0, 0,15, 0, 0\n" +
						"31,20, 5,14, 5, 3, 0, 4, 0, 0\n" +
						"31,10, 9, 9, 1, 0, 0,10, 0, 0\n" +
						"31,22, 5,14, 5, 0, 1, 7, 0, 0};\n";
					mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
				}
			}

			std::vector<std::vector<std::string>> monophonicTracksForBoscaPattern = new std::vector<std::vector<std::string>>(numberOfPatterns + 1);
			monophonicTracksForBoscaTrack = new std::vector<std::vector<std::string>>();
			for (uint track = 0; track < 8; track++) {
				uint maxMonoTracksForBoscaTrack = 0;
				for (bar = 0; bar < control.arrange.lastbar; bar++) {
					patternNum = control.arrange.bar[bar].channel[track];

					if (patternNum < 0) { continue; }
					std::vector<std::string> monoTracksForBar = _mmlTracksForBoscaPattern(patternNum, control.musicbox);
					maxMonoTracksForBoscaTrack = Math.max(maxMonoTracksForBoscaTrack, monoTracksForBar.length);

					monophonicTracksForBoscaPattern[patternNum] = monoTracksForBar;
				}

				std::vector<std::string> outTracks();
				for(uint monoTrackNo = 0; monoTrackNo < maxMonoTracksForBoscaTrack; monoTrackNo++) {
					std::string outTrack = "\n";
					for (bar = 0; bar < control.arrange.lastbar; bar++) {
						patternNum = control.arrange.bar[bar].channel[track];
						if (patternNum < 0) {
							outTrack += emptyBarMML;
							continue;
						}

						monoTracksForBar = monophonicTracksForBoscaPattern[patternNum];
						if (monoTrackNo in monoTracksForBar) {
							outTrack += ("\n// pattern " + patternNum + "\n");
							outTrack += monoTracksForBar[monoTrackNo];
						} else {
							outTrack += emptyBarMML;
						}
					}
					outTracks.push(outTrack)
				}
				monophonicTracksForBoscaTrack[track] = outTracks;
			}
		}

		void writeToStream(IDataOutput stream) {
			std::string out = "";
			out += "/** Music Macro Language (MML) exported from Bosca Ceoil */\n";
			for each (std::string def in instrumentDefinitions) {
				out += def;
				out += "\n";
			}

			for each (std::vector<std::string> monoTracks in monophonicTracksForBoscaTrack) {
				if (monoTracks.length == 0) { continue; } // don't bother printing entirely empty tracks

				out += StringUtil.substitute("\n\n// === Bosca Ceoil track with up to {0} notes played at a time\n", monoTracks.length);

				for each (std::string monoTrack in monoTracks) {
					out += "\n// ---- track\n"

					// XXX: I thought note length would be something like (lengthOfPattern / noteDivisions) but I clearly misunderstand
					out += StringUtil.substitute("\nt{0} l{1} // timing (tempo and note length)\n", bpm, 16);

					out += monoTrack;
					out += ";\n"
				}
			}
			stream.writeMultiByte(out, "utf-8");
		}

		protected function _mmlTracksForBoscaPattern(int patternNum, std::vector<musicphraseclass> patternDefinitions):std::vector<std::string> {
			std::vector<std::string> tracks();

			musicphraseclass pattern = patternDefinitions[patternNum];
			int octave = -1;

			for (uint place = 0; place < lengthOfPattern; place++) {
				std::vector<std::string> notesInThisSlot();
				for (int n = 0; n < pattern.numnotes; n++) {
					Rectangle note = pattern.notes[n];
					int noteStartingAt = note.width;
					int sionNoteNum = note.x;
					uint noteLength = note.y;
					int noteEndingAt = noteStartingAt + noteLength - 1;

					bool isNotePlaying = (noteStartingAt <= place) && (place <= noteEndingAt);

					if (!isNotePlaying) { continue; }

					int newOctave = _octaveFromSiONNoteNumber(sionNoteNum);
					std::string mmlOctave = _mmlTransitionFromOctaveToOctave(octave, newOctave);
					std::string mmlNoteName = _mmlNoteNameFromSiONNoteNumber(sionNoteNum);
					std::string mmlSlur = (noteEndingAt > place) ? "& " : "	";

					octave = newOctave;

					notesInThisSlot.push(mmlOctave + mmlNoteName + mmlSlur);
				}
				while (notesInThisSlot.length > tracks.length) {
					std::string emptyTrackSoFar = StringUtil.repeat(emptyNoteMML, place);
					tracks.push(mmlToUseInstrument[pattern.instr] + "\n" + emptyTrackSoFar);
				}
				std::string emptyNoteMML = "	r	 ";

				for (uint track = 0; track < tracks.length; track++) {
					std::string noteMML;
					if (track in notesInThisSlot) {
						noteMML = notesInThisSlot[track];
					} else {
						noteMML = emptyNoteMML;
					}
					tracks[track] += noteMML;
				}
			}

			return tracks;
		}

		/**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
		protected function _mmlNoteNameFromSiONNoteNumber(int noteNum):std::string {
			std::vector<std::string> noteNames = std::vector<std::string>(['c ', 'c+', 'd ', 'd+', 'e ', 'f ', 'f+', 'g ', 'g+', 'a ', 'a+', 'b ']);

			std::string noteName = noteNames[noteNum % 12];
			return noteName;
		}

		/**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
		protected function _octaveFromSiONNoteNumber(int noteNum):int {
			int octave = int(noteNum / 12);
			return octave;
		}

		protected function _mmlTransitionFromOctaveToOctave(int oldOctave, int newOctave):std::string {
			if (oldOctave == newOctave) {
				return "	";
			}
			if ((oldOctave + 1) == newOctave) {
				return "< ";
			}
			if ((oldOctave - 1) == newOctave) {
				return "> ";
			}
			return "o" + newOctave;
		}

		protected function _boscaInstrumentToMML(instrumentclass instrument, int channel):std::string {
			return StringUtil.substitute("// instrument \"{0}\"\n{1}\n", instrument.name, instrument.voice.getMML(channel));
		}

		protected function _boscaInstrumentToMMLUse(instrumentclass instrument, int channel):std::string {
			return StringUtil.substitute("%6@{0} v{1} @f{2},{3}", channel, int(instrument.volume / 16), instrument.cutoff, instrument.resonance);
		}

	}
}