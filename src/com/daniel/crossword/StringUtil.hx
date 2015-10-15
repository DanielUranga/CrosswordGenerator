package com.daniel.crossword;

using unifill.Unifill;

class StringUtil {

	public static function encode(str : String) : String {

		var ret = "";

		for (c in str.uIterator()) {
			ret += switch (c.toString()) {
				case "á": "a";
				case "é": "e";
				case "í": "i";
				case "ó": "o";
				case "ú": "u";
				case "ñ": "5";
				default: c.toString().toLowerCase();
			}
		}

		ret = ret.split("\r").join("");

		return ret;
	}

	public static function decode(str : String) : String {

		var ret = "";

		for (c in str.uIterator()) {
			ret += switch (c.toString()) {
				case "a": "á";
				case "e": "é";
				case "i": "í";
				case "o": "ó";
				case "u": "ú";
				case "5": "ñ";
				default: c.toString().toLowerCase();
			}
		}

		ret = ret.split("\r").join("");

		return ret;
	}

}
