namespace bosca {
	
	
	
	
		import ocean.midi.*;
	import ocean.midi.event.*;
	import ocean.midi.model.*;
	
	//Taking Midias library calls away from midicontrol
	struct Midiexporter {
		//MidiFile
		//MidiTrack
		//MetaItem
		//NoteItem
		//ChannelItem
		function Midiexporter() {
			midifile = new MidiFile;
		}
		
		void addnewtrack() {
			midifile.addTrack(new MidiTrack());
		}
		
		public	void nexttrack() {
			addnewtrack();
			currenttrack = midifile.track(midifile._trackArray.length - 1);
		}
		
		void writetimesig() {
			currenttrack._msgList.push(new MetaItem());
			int t = currenttrack._msgList.length - 1;
			currenttrack._msgList[t].type = 0x58; // Time Signature
			ByteArray myba = new ByteArray();
			myba.writeByte(0x04);
			myba.writeByte(0x02);
			myba.writeByte(0x18);
			myba.writeByte(0x08);
			currenttrack._msgList[t].text = myba;
		}
		
		void writetempo(int tempo) {
			currenttrack._msgList.push(new MetaItem());
			int t = currenttrack._msgList.length - 1;
			currenttrack._msgList[t].type = 0x51; // Set Tempo
			int tempoinmidiformat = 60000000 / tempo;
			
			int byte1 = (tempoinmidiformat >> 16) & 0xFF;
			int byte2 = (tempoinmidiformat >> 8) & 0xFF;
			int byte3 = tempoinmidiformat & 0xFF;
			
			ByteArray myba = new ByteArray();
			myba.writeByte(byte1);
			myba.writeByte(byte2);
			myba.writeByte(byte3);
			currenttrack._msgList[t].text = myba;
		}
		
		
		void writeinstrument(int instr, int channel) {
			currenttrack._msgList.push(new ChannelItem());
			int t = currenttrack._msgList.length - 1;
			currenttrack._msgList[t]._kind = 0xC0; // Program Change
			currenttrack._msgList[t]._command = 192 + channel;
			currenttrack._msgList[t]._data1 = instr;
		}
		
		void writenote(int channel, int pitch, int time, int length, int volume) {
			volume = volume / 2;
			if (volume > 127) volume = 127;
			
			currenttrack._msgList.push(new NoteItem(channel, pitch, volume, length, time)); 
		}
		
		MidiFile midifile;
		MidiTrack currenttrack;
	}
}