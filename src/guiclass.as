package {
	import flash.desktop.InteractiveIcon;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
	import flash.utils.*;
  import flash.net.*;
	import bigroom.input.KeyPoll;
	
	public class guiclass {
		public function guiclass() {}
		
		public static function init():void {
			for (var i:int = 0; i < 250; i++) {
				button.push(new guibutton());
			}
			
			numbuttons = 0;
			maxbuttons = 250;
		}
		
		public static function addlogo(x:int, y:int):void {
			addbutton(x, y, 0, 0, "BOSCA CEOIL", "", "logo");
		}
		
		public static function addtextlabel(x:int, y:int, text:String, col:int = 2):void {
			addbutton(x, y, col, 0, text, "", "textlabel");
		}
		
		public static function addrighttextlabel(x:int, y:int, text:String, col:int = 2):void {
			addbutton(x, y, col, 0, text, "", "righttextlabel");
		}
		
		public static function addrect(x:int, y:int, w:int, h:int, col:int = 1):void {
			addbutton(x, y, w, h, "", "", "fillrect", col);
		}
		
		public static function addleftarrow(x:int, y:int, action:String):void {
			addbutton(x, y, 16, 16, "", action, "leftarrow");
		}
		
		public static function addrightarrow(x:int, y:int, action:String):void {
			addbutton(x, y, 16, 16, "", action, "rightarrow");
		}
		
		public static function adddownarrow(x:int, y:int, action:String):void {
			addbutton(x, y, 16, 16, "", action, "downarrow");
		}
		
		public static function addvariable(x:int, y:int, variable:String, col:int = 0):void {
			addbutton(x, y, col, 0, "", variable, "variable");
		}
		
		public static function addcontrol(x:int, y:int, type:String):void {
			//For complex multipart things
			if (type == "changepatternlength") {
				addrect(x, y, 160, gfx.linesize);
				addrighttextlabel(x + 60, y, "PATTERN", 0);
				
				addleftarrow(x + 70, y , "barcountdown");
				addvariable(x + 85, y, "barcount");
				addrightarrow(x + 100, y, "barcountup");
				
				addleftarrow(x + 115, y, "boxcountdown");
				addvariable(x + 125, y, "boxcount");
				addrightarrow(x + 145, y, "boxcountup");
			}else if (type == "changebpm") {
				addrect(x, y, 160, gfx.linesize);
				addrighttextlabel(x + 60, y, "BPM", 0);
				
				addleftarrow(x + 85, y, "bpmdown");
				addvariable(x + 100, y, "bpm");
				addrightarrow(x + 130, y, "bpmup");
			}else if (type == "changesoundbuffer") {
				addrect(x, y, 160, gfx.linesize);
				addrighttextlabel(x + 80, y, "SOUND BUFFER ", 0);
				
				adddownarrow(x + 105, y, "bufferlist");
				addvariable(x + 120, y, "buffersize");
				addvariable(x + 4, y + gfx.linesize + 5, "buffersizealert");
			}else if (type == "swingcontrol") {
				addrect(x, y, 160, gfx.linesize);
				addrighttextlabel(x + 60, y, "SWING", 0);
				
				addleftarrow(x + 85, y, "swingdown");
				addvariable(x + 100, y, "swing");
				addrightarrow(x + 130, y, "swingup");
			}
		}
		
		public static function addbutton(x:int, y:int, w:int, h:int, contents:String, act:String = "", sty:String = "normal", toffset:int = 0):void {
			if (button.length == 0) init();
			
			var i:int, z:int;
			if(numbuttons == 0) {
				//If there are no active buttons, Z=0;
				z = 0; 
			}else {
				i = 0; z = -1;
				while (i < numbuttons) {
					if (!button[i].active) {
						z = i; i = numbuttons;
					}
					i++;
				}
				if (z == -1) {
					z = numbuttons;
				}
			}
			//trace("addbutton(", x, y, w, h, contents, act, sty, ")", numbuttons);
			button[z].init(x, y, w, h, contents, act, sty);
			button[z].textoffset = toffset;
			numbuttons++;
		}
		
		public static function clear():void {
			for (var i:int = 0; i < numbuttons; i++) {
				button[i].active = false;
			}
			numbuttons = 0;
		}
		
		public static function buttonexists(t:String):Boolean {
			//Return true if there is an active button with action t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function checkinput(key:KeyPoll):void {
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active && button[i].visable) {
					if (help.inboxw(control.mx, control.my, button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height)) {
						button[i].mouseover = true;
					}else {
						button[i].mouseover = false;
					}
					
					if (button[i].action != "" && !control.list.active) {
						if (key.click) {
							if (button[i].mouseover) {
								dobuttonaction(i);
								key.click = false;
								//button[i].selected = true;
							}
						}
					}
				}
			}
			
			cleanup();
		}
		
		public static function cleanup():void {
			var i:int = 0;
			i = numbuttons - 1; while (i >= 0 && !button[i].active) { numbuttons--; i--; }
		}
		
		public static function drawbuttons():void {
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active && button[i].visable) {
					if (button[i].style == "normal") {
						gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, 12);
						
						if (button[i].mouseover) {
							gfx.fillrect(button[i].position.x - 2, button[i].position.y - 2, button[i].position.width, button[i].position.height, 20);
						}else {
							gfx.fillrect(button[i].position.x - 2, button[i].position.y - 2, button[i].position.width, button[i].position.height, 1);
						}
						
						tx = button[i].position.x + 7 + button[i].textoffset;
						ty = button[i].position.y - 1;
						gfx.print(tx, ty, button[i].text, 0, false, true);
					}else if (button[i].style == "textlabel") {
						gfx.print(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, false, true);
					}else if (button[i].style == "righttextlabel") {
						gfx.rprint(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, true);
					}else if (button[i].style == "fillrect") {
						gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, button[i].textoffset);
					}else if (button[i].style == "leftarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 3);
					}else if (button[i].style == "rightarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 2);
					}else if (button[i].style == "uparrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 1);
					}else if (button[i].style == "downarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 0);
					}else if (button[i].style == "variable") {
						if(button[i].action == "barcount"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.barcount), button[i].position.width, false, true);
						}else if(button[i].action == "boxcount"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.boxcount), button[i].position.width, false, true);
						}else if(button[i].action == "bpm"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.bpm), button[i].position.width, false, true);
						}else if(button[i].action == "buffersize"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.buffersize), button[i].position.width, false, true);
						}else if (button[i].action == "buffersizealert") {
							if (control.buffersize != control.currentbuffersize) {
								if (help.slowsine >= 32) {
									gfx.print(button[i].position.x, button[i].position.y, "REQUIRES RESTART", 0);
								}else {
									gfx.print(button[i].position.x, button[i].position.y, "REQUIRES RESTART", 15);
								}
							}
						}else if (button[i].action == "swing") {
							if(control.swing==-10){
								gfx.print(button[i].position.x, button[i].position.y, String(control.swing), 0, false, true);
							}else if (control.swing < 0 || control.swing == 10 ) {
								gfx.print(button[i].position.x + 5, button[i].position.y, String(control.swing), 0, false, true);
							}else{
								gfx.print(button[i].position.x + 10, button[i].position.y, String(control.swing), 0, false, true);
							}
						}
					}else if (button[i].style == "logo") {
						tx = button[i].position.x;
						ty = button[i].position.y;
						gfx.bigprint(tx, ty, "BOSCA CEOIL", 0, 0, 0, false, 3);
						if(control.currentbox!=-1){
						  timage = control.musicbox[control.currentbox].palette;
							if (timage > 6) timage = 6;
						}else {
							timage = 6;
						}
						if (control.looptime % control.barcount==1) {
							gfx.drawimage(timage, tx - 2 + (Math.random() * 4), ty - 4 + (Math.random() * 4));
						}else{
							gfx.drawimage(timage, tx, ty + 2);
						}
					}
				}
			}
		}
		
		public static function deleteall(t:String = ""):void {
			if (t == "") {
				for (var i:int = 0; i < numbuttons; i++) button[i].active = false;
				numbuttons = 0;
			}else{
				//Deselect any buttons with style t
				for (i = 0; i < numbuttons; i++) {
					if (button[i].active) {
						if (button[i].style == t) {
							button[i].active = false;
						}
					}
				}
			}
		}
		
		public static function selectbutton(t:String):void {
			//select any buttons with action t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						dobuttonaction(i);
						button[i].selected = true;
					}
				}
			}
		}
		
		public static function deselect(t:String):void {
			//Deselect any buttons with action t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						button[i].selected = false;
					}
				}
			}
		}
		
		public static function deselectall(t:String):void {
			//Deselect any buttons with style t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].style == t) {
						button[i].selected = false;
					}
				}
			}
		}
		
		public static function findbuttonbyaction(t:String):int {
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						return i;
					}
				}
			}
			return 0;
		}
		
		public static function changetab(t:int):void {
			//Delete all buttons when tabs change, and create new ones
			deleteall();
			
		  switch(t) {
				case control.MENUTAB_FILE:
					addlogo(12, (gfx.linesize * 3) - 3);
					addtextlabel(165, (gfx.linesize * 5) + 4, control.versionnumber);
					
					addtextlabel(10, (gfx.linesize * 6)+5, "Created by Terry Cavanagh");
					addtextlabel(10, (gfx.linesize * 7)+5, "http://www.distractionware.com");
					
					addbutton(10, (gfx.linesize * 9), 75, 10, "CREDITS", "creditstab", "normal", 7);
					
					CONFIG::desktop {
						addbutton(220, gfx.linesize * 2, 75, 10, "NEW SONG", "newsong");
						addbutton(305, gfx.linesize * 2, 75, 10, "EXPORT", "exportlist", "normal", 10);
						//addbutton(305, gfx.linesize * 3, 75, 10, "EXPORT .xm", "exportxm");
						addbutton(220, (gfx.linesize * 4) + 5, 75, 10, "LOAD .ceol", "loadceol");
						addbutton(305, (gfx.linesize * 4) + 5, 75, 10, "SAVE .ceol", "saveceol");
					}
					
					addcontrol(220, (gfx.linesize * 7) - 1, "changepatternlength");
					addcontrol(220, (gfx.linesize * 9) - 1, "changebpm");
				break;
			  case control.MENUTAB_CREDITS:
				  addtextlabel(10, (gfx.linesize * 2), "SiON softsynth library by Kei Mesuda", 0);
					addrighttextlabel(384 - 10, (gfx.linesize * 2), "Online version by Chris Kim", 0);
				  addtextlabel(10, (gfx.linesize * 3), "sites.google.com/site/sioncenter/");
					addrighttextlabel(384 - 10, (gfx.linesize * 3), "dy-dx.com/");
					
					addtextlabel(10, (gfx.linesize * 5), "Swing function by Stephen Lavelle",0);
					addrighttextlabel(384-10, (gfx.linesize * 5), "XM Exporter by Rob Hunter",0);
					addtextlabel(10, (gfx.linesize * 6), "increpare.com/");
					addrighttextlabel(384 - 10, (gfx.linesize * 6), "about.me/rjhunter/");
					
					addtextlabel(10, (gfx.linesize * 8), "Linux port by Damien L",0);
					addtextlabel(10, (gfx.linesize * 9), "uncovergame.com/");
					addrighttextlabel(384-10, (gfx.linesize * 8), "Open Source under FreeBSD licence",0);
					
					addbutton(302, (gfx.linesize * 9)+4, 75, 10, "BACK", "filetab", "normal", 16);
				break;
			  case control.MENUTAB_ADVANCED:
				  addcontrol(20, (gfx.linesize * 3) + 2, "changesoundbuffer");
					addcontrol(20, (gfx.linesize * 6) + 2, "swingcontrol");
				break;
			}
		}
		
		public static function dobuttonaction(i:int):void {
			currentbutton = button[i].action;
			//trace("doing action... TEXT:" + button[i].text + ", ACTION:" + button[i].action + ", STYLE:" + button[i].style);
			
			if (currentbutton == "newsong") {
				control.newsong();
			}else if (currentbutton == "exportlist") {
				control.filllist(control.LIST_EXPORTS);
				control.list.init(gfx.screenwidth - 100, (gfx.linesize * 3) - 1);
			}else if (currentbutton == "loadceol") {
				control.loadceol();
			}else if (currentbutton == "saveceol") {
				control.saveceol();
			}else if (currentbutton == "filetab") {
				control.changetab(control.MENUTAB_FILE);
			}else if (currentbutton == "arrangementstab") {
				control.changetab(control.MENUTAB_ARRANGEMENTS);
			}else if (currentbutton == "instrumentstab") {
				control.changetab(control.MENUTAB_INSTRUMENTS);
			}else if (currentbutton == "advancedtab") {
				control.changetab(control.MENUTAB_ADVANCED);
			}else if (currentbutton == "creditstab") {
				control.changetab(control.MENUTAB_CREDITS);
			}else if (currentbutton == "barcountdown") {
				control.barcount--;
				if (control.barcount < 1) control.barcount = 1;
			}else if (currentbutton == "barcountup") {
				control.barcount++;
				if (control.barcount > 32) control.barcount = 32;
			}else if (currentbutton == "boxcountdown") {
				control.boxcount--;
				if (control.boxcount < 1) control.boxcount = 1;
				control.doublesize = control.boxcount > 16;
			}else if (currentbutton == "boxcountup") {
				control.boxcount++;
				if (control.boxcount > 32) control.boxcount = 32;
				control.doublesize = control.boxcount > 16;
			}else if (currentbutton == "bpmdown") {
				control.bpm -= 5;
				if (control.bpm < 10) control.bpm = 10;
				control._driver.bpm = control.bpm;
			}else if (currentbutton == "bpmup") {
				control.bpm += 5;
				if (control.bpm > 220) control.bpm = 220;
				control._driver.bpm = control.bpm;
			}else if (currentbutton == "bufferlist") {
				control.filllist(control.LIST_BUFFERSIZE);
				control.list.init(105, (gfx.linesize * 4) - 3);
			}else if (currentbutton == "swingup") {
				control.swing ++;
				if (control.swing > 10) control.swing = 10;
			}else if (currentbutton == "swingdown") {
				control.swing --;
				if (control.swing < -10) control.swing = -10;
			}
		}
		
		public static var button:Vector.<guibutton> = new Vector.<guibutton>;
		public static var numbuttons:int;
		public static var maxbuttons:int;
		
		public static var tx:int, ty:int, timage:int;
		public static var currentbutton:String;
	}
}