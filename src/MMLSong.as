namespace bosca {
	import flash.utils.IDataOutput;
	import flash.geom.Rectangle;
	import mx.utils.StringUtil;

	struct MMLSong {
		protected var std::vector<std::string> instrumentDefinitions;
		protected var std::vector<std::string> mmlToUseInstrument;
		protected var uint noteDivisions = 4;
		protected var uint bpm = 120;
		protected var uint lengthOfPattern = 16;
		protected var std::vector<std::vector<std::string>> monophonicTracksForBoscaTrack;

		function MMLSong() {
		}

		void loadFromLiveBoscaCeoilModel() {
			noteDivisions = control.barcount;
			bpm = control.bpm;
			lengthOfPattern = control.boxcount;

			var std::string emptyBarMML = "\n// empty bar\n" + StringUtil.repeat("	r	 ", lengthOfPattern) + "\n";
			var uint bar;
			var int patternNum;
			var int numberOfPatterns = control.numboxes;

			instrumentDefinitions = new std::vector<std::string>();
			mmlToUseInstrument = new std::vector<std::string>();
			for (var uint i = 0; i < control.numinstrument; i++) {
				var instrumentclass boscaInstrument = control.instrument[i];
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

			var std::vector<std::vector<std::string>> monophonicTracksForBoscaPattern = new std::vector<std::vector<std::string>>(numberOfPatterns + 1);
			monophonicTracksForBoscaTrack = new std::vector<std::vector<std::string>>();
			for (var uint track = 0; track < 8; track++) {
				var uint maxMonoTracksForBoscaTrack = 0;
				for (bar = 0; bar < control.arrange.lastbar; bar++) {
					patternNum = control.arrange.bar[bar].channel[track];

					if (patternNum < 0) { continue; }
					var std::vector<std::string> monoTracksForBar = _mmlTracksForBoscaPattern(patternNum, control.musicbox);
					maxMonoTracksForBoscaTrack = Math.max(maxMonoTracksForBoscaTrack, monoTracksForBar.length);

					monophonicTracksForBoscaPattern[patternNum] = monoTracksForBar;
				}

				var std::vector<std::string> outTracks = new std::vector<std::string>();
				for(var uint monoTrackNo = 0; monoTrackNo < maxMonoTracksForBoscaTrack; monoTrackNo++) {
					var std::string outTrack = "\n";
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
			var std::string out = "";
			out += "/** Music Macro Language (MML) exported from Bosca Ceoil */\n";
			for each (var std::string def in instrumentDefinitions) {
				out += def;
				out += "\n";
			}

			for each (var std::vector<std::string> monoTracks in monophonicTracksForBoscaTrack) {
				if (monoTracks.length == 0) { continue; } // don't bother printing entirely empty tracks

				out += StringUtil.substitute("\n\n// === Bosca Ceoil track with up to {0} notes played at a time\n", monoTracks.length);

				for each (var std::string monoTrack in monoTracks) {
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
			var std::vector<std::string> tracks = new std::vector<std::string>();

			var musicphraseclass pattern = patternDefinitions[patternNum];
			var int octave = -1;

			for (var uint place = 0; place < lengthOfPattern; place++) {
				var std::vector<std::string> notesInThisSlot = new std::vector<std::string>();
				for (var int n = 0; n < pattern.numnotes; n++) {
					var Rectangle note = pattern.notes[n];
					var int noteStartingAt = note.width;
					var int sionNoteNum = note.x;
					var uint noteLength = note.y;
					var int noteEndingAt = noteStartingAt + noteLength - 1;

					var bool isNotePlaying = (noteStartingAt <= place) && (place <= noteEndingAt);

					if (!isNotePlaying) { continue; }

					var int newOctave = _octaveFromSiONNoteNumber(sionNoteNum);
					var std::string mmlOctave = _mmlTransitionFromOctaveToOctave(octave, newOctave);
					var std::string mmlNoteName = _mmlNoteNameFromSiONNoteNumber(sionNoteNum);
					var std::string mmlSlur = (noteEndingAt > place) ? "& " : "	";

					octave = newOctave;

					notesInThisSlot.push(mmlOctave + mmlNoteName + mmlSlur);
				}
				while (notesInThisSlot.length > tracks.length) {
					var std::string emptyTrackSoFar = StringUtil.repeat(emptyNoteMML, place);
					tracks.push(mmlToUseInstrument[pattern.instr] + "\n" + emptyTrackSoFar);
				}
				var std::string emptyNoteMML = "	r	 ";

				for (var uint track = 0; track < tracks.length; track++) {
					var std::string noteMML;
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
			var std::vector<std::string> noteNames = std::vector<std::string>(['c ', 'c+', 'd ', 'd+', 'e ', 'f ', 'f+', 'g ', 'g+', 'a ', 'a+', 'b ']);

			var std::string noteName = noteNames[noteNum % 12];
			return noteName;
		}

		/**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
		protected function _octaveFromSiONNoteNumber(int noteNum):int {
			var int octave = int(noteNum / 12);
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