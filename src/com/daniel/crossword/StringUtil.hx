package com.daniel.crossword;

using unifill.Unifill;

class StringUtil {

	public static function encode(str : String) : String {
		var ret = "";
		for (i in 0...str.uLength()) {
			var c = str.uCharAt(i);
			ret += switch (c) {
				case "á": "0";
				case "é": "1";
				case "í": "2";
				case "ó": "3";
				case "ú": "4";
				case "ñ": "5";
				default: c;
			}
		}
		return ret;
	}

	public static function decode(str : String) : String {
		var ret = "";
		for (i in 0...str.uLength()) {
			var c = str.uCharAt(i);
			ret += switch (c) {
				case "0": "á";
				case "1": "é";
				case "2": "í";
				case "3": "ó";
				case "4": "ú";
				case "5": "ñ";
				default: c;
			}
		}
		return ret;
	}

}
