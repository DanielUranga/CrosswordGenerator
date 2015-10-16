package com.daniel.crossword;

//using unifill.Codepoint;
using unifill.Unifill;

class StringUtil {

	var replaceMapEncode : Map<String, String>;
	var replaceMapDecode : Map<String, String>;
	var replaceables : Array<Array<String>>;

	public function new() {
		replaceables = [
			["a", "á"],
			["e", "é"],
			["i", "í"],
			["o", "ó"],
			["u", "ú", "ü"]
		];
		replaceMapEncode = [
			"á" => "0",
			"é" => "1",
			"í" => "2",
			"ó" => "3",
			"ú" => "4",
			"ñ" => "6",
			"ü" => "7"
		];
		replaceMapDecode = [
			"0" => "á",
			"1" => "é",
			"2" => "í",
			"3" => "ó",
			"4" => "ú",
			"6" => "ñ",
			"7" => "ü"
		];
	}

	function getCharOptions(str : String) : Array<String> {
		var c = str.charAt(0);
		for (r1 in replaceables) {
			for (r2 in r1) {
				if (r2==c) {
					var cp = r1.copy();
					cp.remove(c);
					return cp;
				}
			}
		}
		return [];
	}

	public function generateOptionals(str : String) : Array<String> {
		var optionals = [str];
		for (i in 0...str.uLength()) {
			var c = str.uCharAt(i);
			var opts = getCharOptions(c);
			var newOptions = [];
			for (currentW in optionals) {
				for (opt in opts) {
					var newOpt = "";
					for (j in 0...currentW.uLength()) {
						if (i!=j) {
							newOpt += currentW.uCharAt(j);
						} else {
							newOpt += opt;
						}
					}
					newOptions.push(newOpt);
				}
			}
			for (o in newOptions) {
				optionals.push(o);
			}
		}
		return optionals;
	}

	public function encode(str : String) : String {
		var ret = "";
		for (c in str.uIterator()) {
			var c = c.toString().toLowerCase();
			if (replaceMapEncode.exists(c)) {
				c = replaceMapEncode[c];
			}
			ret += c;
		}
		return ret;
	}

	public function decode(str : String) : String {
		var ret = "";
		for (c in str.uIterator()) {
			var c = c.toString().toLowerCase();
			if (replaceMapDecode.exists(c)) {
				c = replaceMapDecode[c];
			}
			ret += c;
		}
		return ret;
	}

}
